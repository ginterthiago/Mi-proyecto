-- =====================================================
-- Base de datos relacional: Sistema Bancario (PostgreSQL)
-- =====================================================
DROP DATABASE IF EXISTS banco;
CREATE DATABASE banco;
\c banco

-- ---------- Tablas independientes ----------
CREATE TABLE sucursales (
    sucursal_id  SERIAL PRIMARY KEY,
    nombre       VARCHAR(100) NOT NULL,
    direccion    VARCHAR(150) NOT NULL,
    ciudad       VARCHAR(80)  NOT NULL,
    telefono     VARCHAR(20)
);

CREATE TABLE clientes (
    cliente_id       UUID PRIMARY KEY,
    nombre           VARCHAR(80)  NOT NULL,
    apellido         VARCHAR(80)  NOT NULL,
    dni              VARCHAR(15)  NOT NULL UNIQUE,
    email            VARCHAR(100) NOT NULL UNIQUE,
    telefono         VARCHAR(20),
    direccion        VARCHAR(150),
    fecha_nacimiento DATE         NOT NULL,
    fecha_registro   DATE         NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE tipos_de_cuenta (
    tipo_cuenta_id      SERIAL PRIMARY KEY,
    nombre              VARCHAR(50) NOT NULL UNIQUE,
    descripcion         VARCHAR(150),
    tasa_interes        DECIMAL(5,2) NOT NULL DEFAULT 0,
    costo_mantenimiento DECIMAL(10,2) NOT NULL DEFAULT 0
);

CREATE TABLE tipos_de_tarjeta (
    tipo_tarjeta_id SERIAL PRIMARY KEY,
    nombre          VARCHAR(50) NOT NULL UNIQUE,   -- Débito, Crédito, etc.
    descripcion     VARCHAR(150),
    limite_maximo   DECIMAL(12,2)
);

-- ---------- Tablas dependientes ----------
CREATE TABLE empleados (
    empleado_id        SERIAL PRIMARY KEY,
    nombre             VARCHAR(80)  NOT NULL,
    apellido           VARCHAR(80)  NOT NULL,
    cargo              VARCHAR(60)  NOT NULL,
    email              VARCHAR(100) NOT NULL UNIQUE,
    salario            DECIMAL(10,2) NOT NULL CHECK (salario > 0),
    fecha_contratacion DATE NOT NULL,
    sucursal_id        INT NOT NULL,
    FOREIGN KEY (sucursal_id) REFERENCES sucursales(sucursal_id)
);

CREATE TABLE cuentas (
    cuenta_id      SERIAL PRIMARY KEY,
    numero_cuenta  VARCHAR(22) NOT NULL UNIQUE,
    saldo          DECIMAL(14,2) NOT NULL DEFAULT 0 CHECK (saldo >= 0),
    fecha_apertura DATE NOT NULL DEFAULT CURRENT_DATE,
    estado         VARCHAR(15) NOT NULL DEFAULT 'activa'
                   CHECK (estado IN ('activa', 'inactiva', 'bloqueada')),
    cliente_id     UUID NOT NULL,
    tipo_cuenta_id INT  NOT NULL,
    sucursal_id    INT  NOT NULL,
    FOREIGN KEY (cliente_id)     REFERENCES clientes(cliente_id),
    FOREIGN KEY (tipo_cuenta_id) REFERENCES tipos_de_cuenta(tipo_cuenta_id),
    FOREIGN KEY (sucursal_id)    REFERENCES sucursales(sucursal_id)
);

CREATE TABLE transacciones (
    transaccion_id    SERIAL PRIMARY KEY,
    tipo              VARCHAR(20) NOT NULL
                      CHECK (tipo IN ('deposito', 'retiro', 'transferencia')),
    monto             DECIMAL(14,2) NOT NULL CHECK (monto > 0),
    fecha             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    descripcion       VARCHAR(150),
    cuenta_origen_id  INT NOT NULL,
    cuenta_destino_id INT,           -- solo para transferencias
    empleado_id       INT,           -- si se hizo en ventanilla
    FOREIGN KEY (cuenta_origen_id)  REFERENCES cuentas(cuenta_id),
    FOREIGN KEY (cuenta_destino_id) REFERENCES cuentas(cuenta_id),
    FOREIGN KEY (empleado_id)       REFERENCES empleados(empleado_id),
    -- solo las transferencias tienen cuenta destino
    CHECK ((tipo = 'transferencia' AND cuenta_destino_id IS NOT NULL)
        OR (tipo <> 'transferencia' AND cuenta_destino_id IS NULL))
);

CREATE TABLE prestamos (
    prestamo_id  SERIAL PRIMARY KEY,
    monto        DECIMAL(14,2) NOT NULL CHECK (monto > 0),
    tasa_interes DECIMAL(5,2)  NOT NULL,
    plazo_meses  INT NOT NULL CHECK (plazo_meses > 0),
    fecha_inicio DATE NOT NULL,
    estado       VARCHAR(15) NOT NULL DEFAULT 'pendiente'
                 CHECK (estado IN ('pendiente', 'aprobado', 'pagado', 'rechazado')),
    cliente_id   UUID NOT NULL,
    empleado_id  INT  NOT NULL,      -- empleado que lo gestionó
    FOREIGN KEY (cliente_id)  REFERENCES clientes(cliente_id),
    FOREIGN KEY (empleado_id) REFERENCES empleados(empleado_id)
);

CREATE TABLE tarjetas (
    tarjeta_id        SERIAL PRIMARY KEY,
    numero_tarjeta    VARCHAR(16) NOT NULL UNIQUE,
    fecha_emision     DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    estado            VARCHAR(15) NOT NULL DEFAULT 'activa'
                      CHECK (estado IN ('activa', 'bloqueada', 'vencida')),
    cuenta_id         INT NOT NULL,
    tipo_tarjeta_id   INT NOT NULL,
    FOREIGN KEY (cuenta_id)       REFERENCES cuentas(cuenta_id),
    FOREIGN KEY (tipo_tarjeta_id) REFERENCES tipos_de_tarjeta(tipo_tarjeta_id),
    CHECK (fecha_vencimiento > fecha_emision)
);
