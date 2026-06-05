"""
Datos de prueba para el Sistema de Ventas.
Ejecutar con: python manage.py shell < docs/seed_data.py
"""

import os, django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings')
django.setup()

from django.contrib.auth.models import User, Group
from api.clientes.models     import Cliente
from api.proveedores.models  import Proveedor
from api.sucursales.models   import Sucursal
from api.productos.models    import Producto
from api.pedidos.models      import Pedido
from api.detalle_pedidos.models import DetallePedido
from api.facturas.models     import Factura
from api.pagos.models        import Pago
from datetime import date, timedelta
from decimal  import Decimal

print("Cargando datos de prueba...")

# Grupos
for nombre in ['Administrador', 'Vendedor', 'Bodega']:
    Group.objects.get_or_create(name=nombre)

# Superusuario
if not User.objects.filter(username='admin').exists():
    User.objects.create_superuser('admin', 'admin@ventas.com', 'Admin1234!')
    print("Usuario creado: admin / Admin1234!")

admin = User.objects.get(username='admin')

# Sucursales
s1, _ = Sucursal.objects.get_or_create(codigo='SUC-BOG', defaults={
    'nombre': 'Sucursal Bogotá', 'direccion': 'Cra 7 # 32-16',
    'ciudad': 'Bogotá', 'es_principal': True, 'creado_por': admin
})
s2, _ = Sucursal.objects.get_or_create(codigo='SUC-MED', defaults={
    'nombre': 'Sucursal Medellín', 'direccion': 'Calle 50 # 45-30',
    'ciudad': 'Medellín', 'creado_por': admin
})

# Proveedores
p1, _ = Proveedor.objects.get_or_create(nit='900111222-1', defaults={
    'nombre': 'Distribuidora Tecno SAS', 'contacto': 'Carlos Ríos',
    'email': 'ventas@tecno.com', 'ciudad': 'Bogotá', 'creado_por': admin
})
p2, _ = Proveedor.objects.get_or_create(nit='800333444-2', defaults={
    'nombre': 'Importaciones del Valle', 'contacto': 'Ana Gómez',
    'email': 'info@impvalle.com', 'ciudad': 'Cali', 'creado_por': admin
})

# Productos
pr1, _ = Producto.objects.get_or_create(codigo='PROD-001', defaults={
    'nombre': 'Laptop Dell Inspiron 15', 'precio': Decimal('2800000'),
    'stock': 20, 'stock_minimo': 3, 'proveedor': p1, 'creado_por': admin
})
pr2, _ = Producto.objects.get_or_create(codigo='PROD-002', defaults={
    'nombre': 'Mouse Inalámbrico Logitech', 'precio': Decimal('85000'),
    'stock': 50, 'stock_minimo': 10, 'proveedor': p1, 'creado_por': admin
})
pr3, _ = Producto.objects.get_or_create(codigo='PROD-003', defaults={
    'nombre': 'Teclado Mecánico RGB', 'precio': Decimal('320000'),
    'stock': 15, 'stock_minimo': 5, 'proveedor': p2, 'creado_por': admin
})

# Clientes
c1, _ = Cliente.objects.get_or_create(numero_documento='1020304050', defaults={
    'tipo_documento': 'CC', 'nombre': 'María', 'apellido': 'López',
    'email': 'maria.lopez@email.com', 'ciudad': 'Bogotá', 'creado_por': admin
})
c2, _ = Cliente.objects.get_or_create(numero_documento='1031456789', defaults={
    'tipo_documento': 'CC', 'nombre': 'Juan Carlos', 'apellido': 'Pérez',
    'email': 'jcperez@email.com', 'ciudad': 'Medellín', 'creado_por': admin
})

# Pedido
ped, created = Pedido.objects.get_or_create(numero_pedido='PED-2024-001', defaults={
    'fecha_pedido': date.today(),
    'fecha_entrega': date.today() + timedelta(days=7),
    'estado': 'APROBADO',
    'cliente': c1, 'sucursal': s1, 'creado_por': admin
})

if created:
    DetallePedido.objects.create(
        pedido=ped, producto=pr1, cantidad=1,
        precio_unitario=Decimal('2800000'), descuento=Decimal('5'),
        creado_por=admin
    )
    DetallePedido.objects.create(
        pedido=ped, producto=pr2, cantidad=2,
        precio_unitario=Decimal('85000'), descuento=Decimal('0'),
        creado_por=admin
    )

# Factura
fac, _ = Factura.objects.get_or_create(numero_factura='FAC-2024-001', defaults={
    'fecha_emision': date.today(),
    'fecha_vencimiento': date.today() + timedelta(days=30),
    'estado': 'PENDIENTE', 'pedido': ped,
    'subtotal': ped.total, 'iva': Decimal('19'),
    'total': ped.total * Decimal('1.19'), 'creado_por': admin
})

# Pago
if not Pago.objects.filter(numero_pago='PAG-2024-001').exists():
    Pago.objects.create(
        numero_pago='PAG-2024-001', fecha_pago=date.today(),
        monto=fac.total, metodo_pago='TRANSFERENCIA',
        estado='APROBADO', referencia='TRF-987654321',
        factura=fac, creado_por=admin
    )

print("Datos cargados correctamente.")
print("Usuario: admin | Contraseña: Admin1234!")
print("Swagger: http://127.0.0.1:8000/api/docs/")
