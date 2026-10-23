-- =====================================================
-- Sistema de Reclamos Municipales - Base RELACIONAL
-- Motor: PostgreSQL 14+
-- Responsabilidad: datos estructurados, integridad,
-- relaciones, estados, asignaciones y estadisticas.
-- =====================================================

DROP TABLE IF EXISTS historial_estado, intervencion, asignacion, reclamo,
    equipo_empleado, equipo, empleado, categoria, ciudadano CASCADE;

CREATE TABLE ciudadano (
    id              SERIAL PRIMARY KEY,
    dni             VARCHAR(15)  NOT NULL UNIQUE,
    nombre          VARCHAR(80)  NOT NULL,
    apellido        VARCHAR(80)  NOT NULL,
    email           VARCHAR(120) NOT NULL UNIQUE,
    telefono        VARCHAR(30),
    password_hash   VARCHAR(255) NOT NULL,
    fecha_registro  TIMESTAMP    NOT NULL DEFAULT NOW()
);

CREATE TABLE empleado (
    id        SERIAL PRIMARY KEY,
    legajo    VARCHAR(20)  NOT NULL UNIQUE,
    nombre    VARCHAR(80)  NOT NULL,
    apellido  VARCHAR(80)  NOT NULL,
    email     VARCHAR(120) NOT NULL UNIQUE,
    cargo     VARCHAR(60),
    activo    BOOLEAN      NOT NULL DEFAULT TRUE
);

CREATE TABLE equipo (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(80) NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    zona        VARCHAR(80)
);

-- Relacion N:M entre empleados y equipos
CREATE TABLE equipo_empleado (
    equipo_id   INT NOT NULL REFERENCES equipo(id)   ON DELETE CASCADE,
    empleado_id INT NOT NULL REFERENCES empleado(id) ON DELETE CASCADE,
    PRIMARY KEY (equipo_id, empleado_id)
);

CREATE TABLE categoria (
    id          SERIAL PRIMARY KEY,
    nombre      VARCHAR(60) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
);

CREATE TABLE reclamo (
    id                SERIAL PRIMARY KEY,
    ciudadano_id      INT NOT NULL REFERENCES ciudadano(id),
    categoria_id      INT NOT NULL REFERENCES categoria(id),
    canal             VARCHAR(15) NOT NULL DEFAULT 'web'
                      CHECK (canal IN ('web','telefono','email','presencial')),
    descripcion       TEXT NOT NULL,
    direccion         VARCHAR(200) NOT NULL,
    latitud           NUMERIC(9,6),
    longitud          NUMERIC(9,6),
    estado            VARCHAR(15) NOT NULL DEFAULT 'pendiente'
                      CHECK (estado IN ('pendiente','en_proceso','resuelto')),
    fecha_creacion    TIMESTAMP NOT NULL DEFAULT NOW(),
    fecha_resolucion  TIMESTAMP,
    duplicado_de      INT REFERENCES reclamo(id),   -- para marcar reclamos duplicados
    detalle_mongo_id  CHAR(24),                     -- ObjectId del documento en MongoDB
    CHECK (fecha_resolucion IS NULL OR fecha_resolucion >= fecha_creacion)
);

-- Historial de asignaciones a equipos
CREATE TABLE asignacion (
    id               SERIAL PRIMARY KEY,
    reclamo_id       INT NOT NULL REFERENCES reclamo(id) ON DELETE CASCADE,
    equipo_id        INT NOT NULL REFERENCES equipo(id),
    asignado_por     INT NOT NULL REFERENCES empleado(id),
    fecha_asignacion TIMESTAMP NOT NULL DEFAULT NOW(),
    vigente          BOOLEAN NOT NULL DEFAULT TRUE
);

-- Un reclamo puede tener N intervenciones
CREATE TABLE intervencion (
    id               SERIAL PRIMARY KEY,
    reclamo_id       INT NOT NULL REFERENCES reclamo(id) ON DELETE CASCADE,
    empleado_id      INT NOT NULL REFERENCES empleado(id),
    equipo_id        INT REFERENCES equipo(id),
    fecha_inicio     TIMESTAMP NOT NULL DEFAULT NOW(),
    fecha_fin        TIMESTAMP,
    detalle_mongo_id CHAR(24),                      -- tareas, observaciones, fotos en MongoDB
    CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

-- Auditoria de cambios de estado (base del historial completo)
CREATE TABLE historial_estado (
    id              SERIAL PRIMARY KEY,
    reclamo_id      INT NOT NULL REFERENCES reclamo(id) ON DELETE CASCADE,
    estado_anterior VARCHAR(15),
    estado_nuevo    VARCHAR(15) NOT NULL,
    empleado_id     INT REFERENCES empleado(id),
    fecha           TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Indices para consultas frecuentes
CREATE INDEX idx_reclamo_ciudadano ON reclamo(ciudadano_id);
CREATE INDEX idx_reclamo_categoria ON reclamo(categoria_id);
CREATE INDEX idx_reclamo_estado    ON reclamo(estado);
CREATE INDEX idx_interv_reclamo    ON intervencion(reclamo_id);
CREATE INDEX idx_interv_empleado   ON intervencion(empleado_id);
CREATE INDEX idx_asig_reclamo      ON asignacion(reclamo_id);

-- Trigger de alta: registra el estado inicial
CREATE OR REPLACE FUNCTION fn_log_estado_insert() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO historial_estado(reclamo_id, estado_anterior, estado_nuevo)
    VALUES (NEW.id, NULL, NEW.estado);
    RETURN NEW;
END; $$ LANGUAGE plpgsql;

-- Trigger de cambio de estado: registra historial y fecha de resolucion
CREATE OR REPLACE FUNCTION fn_log_estado_update() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.estado IS DISTINCT FROM OLD.estado THEN
        INSERT INTO historial_estado(reclamo_id, estado_anterior, estado_nuevo)
        VALUES (NEW.id, OLD.estado, NEW.estado);
        IF NEW.estado = 'resuelto' THEN
            NEW.fecha_resolucion := NOW();
        END IF;
    END IF;
    RETURN NEW;
END; $$ LANGUAGE plpgsql;

CREATE TRIGGER trg_reclamo_estado_ins AFTER INSERT ON reclamo
    FOR EACH ROW EXECUTE FUNCTION fn_log_estado_insert();
CREATE TRIGGER trg_reclamo_estado_upd BEFORE UPDATE ON reclamo
    FOR EACH ROW EXECUTE FUNCTION fn_log_estado_update();

-- Datos iniciales
INSERT INTO categoria(nombre, descripcion) VALUES
 ('bache','Baches y roturas en calzada'),
 ('luminaria','Luminarias danadas o apagadas'),
 ('perdida_agua','Perdidas de agua en via publica'),
 ('arbol_caido','Arboles caidos o en riesgo'),
 ('basura','Acumulacion de residuos');
