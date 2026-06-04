SET search_path TO ventas_schema, public;

-- Sucursales
INSERT INTO sucursales (codigo, nombre, direccion, ciudad, telefono, email, es_principal)
VALUES
    ('SUC-BOG', 'Sucursal Bogotá',       'Cra 7 # 32-16',       'Bogotá',      '6017001122', 'bogota@ventas.com',    TRUE),
    ('SUC-MED', 'Sucursal Medellín',     'Calle 50 # 45-30',    'Medellín',    '6044452233', 'medellin@ventas.com',  FALSE),
    ('SUC-CAL', 'Sucursal Cali',         'Av 6N # 23-45',       'Cali',        '6023456789', 'cali@ventas.com',      FALSE),
    ('SUC-BAR', 'Sucursal Barranquilla', 'Cra 43 # 84-110',     'Barranquilla','6053217890', 'barranquilla@ventas.com', FALSE)
ON CONFLICT DO NOTHING;

-- Proveedores
INSERT INTO proveedores (nit, nombre, contacto, email, telefono, ciudad)
VALUES
    ('900111222-1', 'Distribuidora Tecno SAS',      'Carlos Ríos',    'ventas@tecno.com',   '3151112233', 'Bogotá'),
    ('800333444-2', 'Importaciones del Valle LTDA', 'Ana Gómez',      'info@impvalle.com',  '3204445566', 'Cali'),
    ('900777888-3', 'Electrónicos del Norte SAS',   'Pedro Martínez', 'pedidos@elnorte.com','3107778899', 'Medellín'),
    ('700555666-4', 'Suministros Industriales SA',  'Laura Herrera',  'compras@sumin.co',   '6014443355', 'Bogotá')
ON CONFLICT DO NOTHING;

-- Clientes
INSERT INTO clientes (tipo_documento, numero_documento, nombre, apellido, email, telefono, ciudad)
VALUES
    ('CC',  '1020304050',  'María',       'López',     'maria.lopez@email.com',   '3112223344', 'Bogotá'),
    ('CC',  '1031456789',  'Juan Carlos', 'Pérez',     'jcperez@email.com',       '3223334455', 'Medellín'),
    ('NIT', '900555666-3', 'TechCorp Colombia', '',    'compras@techcorp.co',     '6017778899', 'Bogotá'),
    ('CC',  '52789012',    'Sandra',      'Morales',   'sandra.morales@gmail.com','3134445566', 'Cali'),
    ('NIT', '800987654-1', 'Inversiones ABC', '',      'gerencia@inversionesabc.co','6044561234','Medellín'),
    ('CC',  '79345678',    'Roberto',     'Castro',    'roberto.castro@hotmail.com','3005556677','Barranquilla')
ON CONFLICT DO NOTHING;

-- Productos
INSERT INTO productos (codigo, nombre, descripcion, precio, stock, stock_minimo, proveedor_id)
VALUES
    ('PROD-001', 'Laptop Dell Inspiron 15',    'Procesador i5, 8GB RAM, 512GB SSD', 2800000, 20, 3, (SELECT id FROM proveedores WHERE nit='900111222-1')),
    ('PROD-002', 'Mouse Inalámbrico Logitech', 'Receptor USB, 1000 DPI',               85000, 50,10, (SELECT id FROM proveedores WHERE nit='900111222-1')),
    ('PROD-003', 'Teclado Mecánico RGB',       'Switch Blue, retroiluminación RGB',   320000, 15, 5, (SELECT id FROM proveedores WHERE nit='800333444-2')),
    ('PROD-004', 'Monitor Samsung 24"',        'Panel IPS, 75Hz, HDMI',              950000, 10, 2, (SELECT id FROM proveedores WHERE nit='900777888-3')),
    ('PROD-005', 'Disco SSD Kingston 1TB',     'SATA III, 550MB/s',                  380000, 30, 5, (SELECT id FROM proveedores WHERE nit='800333444-2')),
    ('PROD-006', 'Cable HDMI 2.0 3m',          'Resolución 4K',                       28000,100,20, (SELECT id FROM proveedores WHERE nit='700555666-4')),
    ('PROD-007', 'UPS CDP 1000VA',             'Regulador de voltaje, 6 tomas',      420000,  8, 2, (SELECT id FROM proveedores WHERE nit='700555666-4')),
    ('PROD-008', 'Audífonos Sony WH-1000XM5',  'Cancelación de ruido, Bluetooth',    890000, 12, 3, (SELECT id FROM proveedores WHERE nit='900777888-3'))
ON CONFLICT DO NOTHING;

-- Pedidos
INSERT INTO pedidos (numero_pedido, fecha_pedido, fecha_entrega, estado, cliente_id, sucursal_id, total)
VALUES
    ('PED-2024-001','2024-01-10','2024-01-17','ENTREGADO', (SELECT id FROM clientes WHERE numero_documento='1020304050'),  (SELECT id FROM sucursales WHERE codigo='SUC-BOG'), 0),
    ('PED-2024-002','2024-01-15','2024-01-22','ENTREGADO', (SELECT id FROM clientes WHERE numero_documento='1031456789'),  (SELECT id FROM sucursales WHERE codigo='SUC-MED'), 0),
    ('PED-2024-003','2024-02-01','2024-02-08','ENTREGADO', (SELECT id FROM clientes WHERE numero_documento='900555666-3'), (SELECT id FROM sucursales WHERE codigo='SUC-BOG'), 0),
    ('PED-2024-004','2024-02-14','2024-02-21','ENVIADO',   (SELECT id FROM clientes WHERE numero_documento='52789012'),    (SELECT id FROM sucursales WHERE codigo='SUC-CAL'), 0),
    ('PED-2024-005','2024-03-05','2024-03-12','APROBADO',  (SELECT id FROM clientes WHERE numero_documento='800987654-1'), (SELECT id FROM sucursales WHERE codigo='SUC-MED'), 0),
    ('PED-2024-006','2024-04-02','2024-04-09','PENDIENTE', (SELECT id FROM clientes WHERE numero_documento='79345678'),    (SELECT id FROM sucursales WHERE codigo='SUC-BAR'), 0)
ON CONFLICT DO NOTHING;

-- Detalle pedidos
INSERT INTO detalle_pedidos (pedido_id, producto_id, cantidad, precio_unitario, descuento, subtotal)
VALUES
    ((SELECT id FROM pedidos WHERE numero_pedido='PED-2024-001'), (SELECT id FROM productos WHERE codigo='PROD-001'), 1, 2800000, 5,  2800000*1*(1-5/100.0)),
    ((SELECT id FROM pedidos WHERE numero_pedido='PED-2024-001'), (SELECT id FROM productos WHERE codigo='PROD-002'), 2,   85000, 0,    85000*2),
    ((SELECT id FROM pedidos WHERE numero_pedido='PED-2024-002'), (SELECT id FROM productos WHERE codigo='PROD-003'), 1,  320000, 0,   320000),
    ((SELECT id FROM pedidos WHERE numero_pedido='PED-2024-002'), (SELECT id FROM productos WHERE codigo='PROD-004'), 1,  950000, 3,  950000*(1-3/100.0)),
    ((SELECT id FROM pedidos WHERE numero_pedido='PED-2024-003'), (SELECT id FROM productos WHERE codigo='PROD-001'), 2, 2800000,10, 2800000*2*(1-10/100.0)),
    ((SELECT id FROM pedidos WHERE numero_pedido='PED-2024-003'), (SELECT id FROM productos WHERE codigo='PROD-005'), 3,  380000, 5,  380000*3*(1-5/100.0)),
    ((SELECT id FROM pedidos WHERE numero_pedido='PED-2024-004'), (SELECT id FROM productos WHERE codigo='PROD-008'), 2,  890000, 0,  890000*2),
    ((SELECT id FROM pedidos WHERE numero_pedido='PED-2024-005'), (SELECT id FROM productos WHERE codigo='PROD-007'), 2,  420000, 0,  420000*2),
    ((SELECT id FROM pedidos WHERE numero_pedido='PED-2024-006'), (SELECT id FROM productos WHERE codigo='PROD-006'),10,   28000, 0,   28000*10)
ON CONFLICT DO NOTHING;

-- Actualizar totales de pedidos
UPDATE pedidos p
SET total = (
    SELECT COALESCE(SUM(subtotal), 0)
    FROM detalle_pedidos
    WHERE pedido_id = p.id
);

-- Facturas
INSERT INTO facturas (numero_factura, fecha_emision, fecha_vencimiento, estado, pedido_id, subtotal, iva, total)
SELECT
    'FAC-2024-00' || p.id,
    p.fecha_pedido,
    p.fecha_pedido + INTERVAL '30 days',
    CASE WHEN p.estado = 'ENTREGADO' THEN 'PAGADA' ELSE 'PENDIENTE' END,
    p.id,
    p.total,
    19,
    p.total * 1.19
FROM pedidos p
ON CONFLICT DO NOTHING;

-- Pagos (solo para las facturas pagadas)
INSERT INTO pagos (numero_pago, fecha_pago, monto, metodo_pago, estado, referencia, factura_id)
SELECT
    'PAG-2024-00' || f.id,
    f.fecha_emision + INTERVAL '2 days',
    f.total,
    'TRANSFERENCIA',
    'APROBADO',
    'TRF-10000' || f.id,
    f.id
FROM facturas f
WHERE f.estado = 'PAGADA'
ON CONFLICT DO NOTHING;
