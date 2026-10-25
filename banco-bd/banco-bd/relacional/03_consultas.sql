-- =====================================================
-- Consultas de ejemplo
-- =====================================================

-- 1) Datos de un cliente por su UUID
SELECT nombre, apellido, email
FROM clientes
WHERE cliente_id = '123e4567-e89b-12d3-a456-426614174000';

-- 2) Cuentas de cada cliente con su tipo y sucursal
SELECT c.nombre, c.apellido, cu.numero_cuenta, t.nombre AS tipo_cuenta,
       s.nombre AS sucursal, cu.saldo
FROM cuentas cu
JOIN clientes c        ON c.cliente_id = cu.cliente_id
JOIN tipos_de_cuenta t ON t.tipo_cuenta_id = cu.tipo_cuenta_id
JOIN sucursales s      ON s.sucursal_id = cu.sucursal_id;

-- 3) Transacciones de una cuenta
SELECT transaccion_id, tipo, monto, fecha, descripcion
FROM transacciones
WHERE cuenta_origen_id = 1
ORDER BY fecha DESC;

-- 4) Préstamos aprobados con el empleado que los gestionó
SELECT p.prestamo_id, c.nombre, c.apellido, p.monto, e.nombre AS empleado
FROM prestamos p
JOIN clientes c  ON c.cliente_id = p.cliente_id
JOIN empleados e ON e.empleado_id = p.empleado_id
WHERE p.estado = 'aprobado';

-- 5) Cantidad de empleados por sucursal
SELECT s.nombre, COUNT(e.empleado_id) AS cantidad_empleados
FROM sucursales s
LEFT JOIN empleados e ON e.sucursal_id = s.sucursal_id
GROUP BY s.nombre;
