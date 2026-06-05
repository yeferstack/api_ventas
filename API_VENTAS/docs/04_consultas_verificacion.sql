SET search_path TO ventas_schema, public;

-- 1. Cuántos registros hay en cada tabla
SELECT 'clientes'        AS tabla, COUNT(*) AS total FROM clientes
UNION ALL
SELECT 'proveedores',    COUNT(*) FROM proveedores
UNION ALL
SELECT 'sucursales',     COUNT(*) FROM sucursales
UNION ALL
SELECT 'productos',      COUNT(*) FROM productos
UNION ALL
SELECT 'pedidos',        COUNT(*) FROM pedidos
UNION ALL
SELECT 'detalle_pedidos',COUNT(*) FROM detalle_pedidos
UNION ALL
SELECT 'facturas',       COUNT(*) FROM facturas
UNION ALL
SELECT 'pagos',          COUNT(*) FROM pagos
ORDER BY tabla;

-- 2. Ver pedidos con nombre del cliente y sucursal
SELECT
    p.numero_pedido,
    p.fecha_pedido,
    p.estado,
    c.nombre || ' ' || c.apellido AS cliente,
    s.nombre AS sucursal,
    p.total
FROM pedidos p
JOIN clientes   c ON c.id = p.cliente_id
JOIN sucursales s ON s.id = p.sucursal_id
ORDER BY p.fecha_pedido DESC;

-- 3. Ver detalle de un pedido específico
SELECT
    ped.numero_pedido,
    prod.nombre AS producto,
    dp.cantidad,
    dp.precio_unitario,
    dp.descuento AS descuento_pct,
    dp.subtotal
FROM detalle_pedidos dp
JOIN pedidos  ped  ON ped.id  = dp.pedido_id
JOIN productos prod ON prod.id = dp.producto_id
WHERE ped.numero_pedido = 'PED-2024-001';

-- 4. Ver facturas con su estado de pago
SELECT
    f.numero_factura,
    f.fecha_emision,
    f.estado,
    f.total,
    COALESCE(SUM(pg.monto), 0) AS total_pagado,
    f.total - COALESCE(SUM(pg.monto), 0) AS saldo
FROM facturas f
LEFT JOIN pagos pg ON pg.factura_id = f.id AND pg.estado = 'APROBADO'
GROUP BY f.id, f.numero_factura, f.fecha_emision, f.estado, f.total
ORDER BY f.fecha_emision DESC;

-- 5. Productos con stock bajo
SELECT
    p.codigo,
    p.nombre,
    p.stock,
    p.stock_minimo,
    pr.nombre AS proveedor
FROM productos p
JOIN proveedores pr ON pr.id = p.proveedor_id
WHERE p.stock <= p.stock_minimo
ORDER BY p.stock ASC;

-- 6. Ventas totales por sucursal
SELECT
    s.nombre AS sucursal,
    COUNT(p.id) AS total_pedidos,
    SUM(p.total) AS ventas_totales
FROM pedidos p
JOIN sucursales s ON s.id = p.sucursal_id
WHERE p.estado != 'CANCELADO'
GROUP BY s.nombre
ORDER BY ventas_totales DESC;
