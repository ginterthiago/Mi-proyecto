-- =====================================================
-- Datos mock: Sistema Bancario
-- Ejecutar después de 01_schema.sql
-- =====================================================

-- Sucursales
INSERT INTO sucursales (nombre, direccion, ciudad, telefono) VALUES
('Sucursal Central', 'Av. San Martín 100', 'Bolívar', '2314-400100'),
('Sucursal Norte',   'Calle Belgrano 250', 'Olavarría', '2284-500200'),
('Sucursal Sur',     'Av. Mitre 780',      'Azul', '2281-600300');

-- Clientes (UUID fijos para relacionarlos con la BD documental)
INSERT INTO clientes (cliente_id, nombre, apellido, dni, email, telefono, direccion, fecha_nacimiento) VALUES
('123e4567-e89b-12d3-a456-426614174000', 'Lucía',   'Fernández', '30123456', 'lucia.fernandez@mail.com', '2314-111111', 'Calle Alsina 45',    '1992-03-15'),
('123e4567-e89b-12d3-a456-426614174001', 'Martín',  'Gómez',     '28987654', 'martin.gomez@mail.com',    '2314-222222', 'Av. Brown 320',     '1988-07-22'),
('123e4567-e89b-12d3-a456-426614174002', 'Sofía',   'Ramírez',   '35456789', 'sofia.ramirez@mail.com',   '2284-333333', 'Calle Moreno 12',   '1997-11-02'),
('123e4567-e89b-12d3-a456-426614174003', 'Joaquín', 'Pérez',     '25111222', 'joaquin.perez@mail.com',   '2281-444444', 'Calle Rivadavia 9', '1980-01-30');

-- Empleados
INSERT INTO empleados (nombre, apellido, cargo, email, salario, fecha_contratacion, sucursal_id) VALUES
('Carolina', 'Díaz',   'Gerente',              'carolina.diaz@banco.com', 950000.00, '2015-04-01', 1),
('Pablo',    'Suárez', 'Cajero',               'pablo.suarez@banco.com',  520000.00, '2019-08-12', 1),
('Valeria',  'Torres', 'Oficial de préstamos', 'valeria.torres@banco.com',680000.00, '2018-02-20', 2),
('Diego',    'Luna',   'Cajero',               'diego.luna@banco.com',    510000.00, '2021-05-03', 3);

-- Tipos de cuenta
INSERT INTO tipos_de_cuenta (nombre, descripcion, tasa_interes, costo_mantenimiento) VALUES
('Caja de ahorro',   'Cuenta para ahorrar con interés bajo', 2.50, 500.00),
('Cuenta corriente', 'Cuenta para operaciones frecuentes',   0.00, 1500.00),
('Cuenta sueldo',    'Cuenta para cobro de haberes',         0.00, 0.00);

-- Tipos de tarjeta
INSERT INTO tipos_de_tarjeta (nombre, descripcion, limite_maximo) VALUES
('Débito',  'Descuenta directamente del saldo de la cuenta', NULL),
('Crédito', 'Compras en cuotas con límite mensual',          800000.00),
('Prepaga', 'Tarjeta recargable',                            100000.00);

-- Cuentas
INSERT INTO cuentas (numero_cuenta, saldo, fecha_apertura, estado, cliente_id, tipo_cuenta_id, sucursal_id) VALUES
('0010000000000000000001', 150000.00, '2020-01-10', 'activa',    '123e4567-e89b-12d3-a456-426614174000', 1, 1),
('0010000000000000000002',  85000.50, '2021-03-05', 'activa',    '123e4567-e89b-12d3-a456-426614174001', 3, 1),
('0010000000000000000003', 320000.00, '2019-09-18', 'activa',    '123e4567-e89b-12d3-a456-426614174002', 2, 2),
('0010000000000000000004',  12000.00, '2022-06-25', 'activa',    '123e4567-e89b-12d3-a456-426614174003', 1, 3),
('0010000000000000000005',  45000.00, '2023-02-14', 'bloqueada', '123e4567-e89b-12d3-a456-426614174000', 3, 1);

-- Transacciones
INSERT INTO transacciones (tipo, monto, fecha, descripcion, cuenta_origen_id, cuenta_destino_id, empleado_id) VALUES
('deposito',      50000.00, '2025-05-02 10:15:00', 'Depósito en ventanilla', 1, NULL, 2),
('retiro',        10000.00, '2025-05-03 14:30:00', 'Retiro en cajero',       2, NULL, NULL),
('transferencia', 25000.00, '2025-05-05 09:45:00', 'Pago de alquiler',       3, 1,    NULL),
('deposito',      80000.00, '2025-05-06 11:00:00', 'Acreditación de sueldo', 2, NULL, NULL),
('retiro',         5000.00, '2025-05-07 16:20:00', 'Retiro en ventanilla',   4, NULL, 4),
('transferencia',  7500.00, '2025-05-08 18:05:00', 'Devolución de dinero',   1, 4,    NULL);

-- Préstamos
INSERT INTO prestamos (monto, tasa_interes, plazo_meses, fecha_inicio, estado, cliente_id, empleado_id) VALUES
(500000.00, 45.00, 24, '2024-08-01', 'aprobado',  '123e4567-e89b-12d3-a456-426614174002', 3),
(200000.00, 40.00, 12, '2025-01-15', 'pendiente', '123e4567-e89b-12d3-a456-426614174000', 3),
(100000.00, 38.00,  6, '2023-03-10', 'pagado',    '123e4567-e89b-12d3-a456-426614174001', 1);

-- Tarjetas
INSERT INTO tarjetas (numero_tarjeta, fecha_emision, fecha_vencimiento, estado, cuenta_id, tipo_tarjeta_id) VALUES
('4111111111111111', '2022-01-10', '2027-01-10', 'activa',    1, 1),
('5500000000000004', '2023-04-15', '2028-04-15', 'activa',    3, 2),
('4222222222222222', '2021-03-05', '2026-03-05', 'vencida',   2, 1),
('4333333333333333', '2023-02-14', '2028-02-14', 'bloqueada', 5, 3);
