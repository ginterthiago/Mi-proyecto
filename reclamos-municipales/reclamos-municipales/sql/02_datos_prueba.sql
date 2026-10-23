-- Los detalle_mongo_id coinciden con los _id de mongo/ejemplos.js
INSERT INTO ciudadano(dni,nombre,apellido,email,telefono,password_hash) VALUES
 ('30111222','Ana','Gomez','ana@mail.com','2314-555111','hash1'),
 ('28999888','Luis','Perez','luis@mail.com','2314-555222','hash2');

INSERT INTO empleado(legajo,nombre,apellido,email,cargo) VALUES
 ('E001','Marta','Diaz','marta@muni.gob','Coordinadora'),
 ('E002','Jorge','Sosa','jorge@muni.gob','Operario'),
 ('E003','Lucia','Rios','lucia@muni.gob','Operaria');

INSERT INTO equipo(nombre,descripcion,zona) VALUES
 ('Cuadrilla Agua','Obras sanitarias','Centro'),
 ('Cuadrilla Alumbrado','Alumbrado publico','Norte');

INSERT INTO equipo_empleado VALUES (1,2),(2,3);

INSERT INTO reclamo(ciudadano_id,categoria_id,canal,descripcion,direccion,latitud,longitud,detalle_mongo_id)
VALUES (1,3,'web','Perdida de agua en la vereda','Av. San Martin 450',-36.2300,-61.1100,'650000000000000000000001'),
       (2,2,'telefono','Luminaria apagada hace 1 semana','Belgrano 120',-36.2290,-61.1120,'650000000000000000000002'),
       (1,1,'presencial','Bache profundo en la calzada','Sarmiento 800',-36.2310,-61.1090,'650000000000000000000003');

INSERT INTO asignacion(reclamo_id,equipo_id,asignado_por) VALUES (1,1,1);
UPDATE reclamo SET estado='en_proceso' WHERE id=1;
INSERT INTO intervencion(reclamo_id,empleado_id,equipo_id,detalle_mongo_id)
VALUES (1,2,1,'650000000000000000000011');

-- Reclamo 3 resuelto (para que las estadisticas de tiempos tengan datos)
UPDATE reclamo SET estado='en_proceso' WHERE id=3;
UPDATE reclamo SET estado='resuelto'   WHERE id=3;
