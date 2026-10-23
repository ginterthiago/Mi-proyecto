-- Cantidad de reclamos por categoria
SELECT c.nombre, COUNT(*) AS total
FROM reclamo r JOIN categoria c ON c.id = r.categoria_id
GROUP BY c.nombre ORDER BY total DESC;

-- Cantidad de reclamos por estado
SELECT estado, COUNT(*) FROM reclamo GROUP BY estado;

-- Intervenciones por empleado
SELECT e.legajo, e.nombre, e.apellido, COUNT(i.id) AS intervenciones
FROM empleado e LEFT JOIN intervencion i ON i.empleado_id = e.id
GROUP BY e.id ORDER BY intervenciones DESC;

-- Reclamos asignados por equipo (asignacion vigente)
SELECT q.nombre, COUNT(*) AS reclamos_asignados
FROM asignacion a JOIN equipo q ON q.id = a.equipo_id
WHERE a.vigente GROUP BY q.nombre;

-- Tiempo promedio de resolucion por categoria (en horas)
SELECT c.nombre,
       ROUND(AVG(EXTRACT(EPOCH FROM (r.fecha_resolucion - r.fecha_creacion))/3600)::numeric, 1) AS horas_promedio
FROM reclamo r JOIN categoria c ON c.id = r.categoria_id
WHERE r.estado = 'resuelto'
GROUP BY c.nombre;

-- Historial de estados de un reclamo
SELECT * FROM historial_estado WHERE reclamo_id = 1 ORDER BY fecha;
