SET search_path TO ventas_schema, public;

-- Tabla 1: clientes
CREATE TABLE IF NOT EXISTS clientes (
    id               BIGSERIAL    PRIMARY KEY,
    tipo_documento   VARCHAR(5)   NOT NULL,
    numero_documento VARCHAR(20)  NOT NULL UNIQUE,
    nombre           VARCHAR(150) NOT NULL,
    apellido         VARCHAR(150),
    email            VARCHAR(254) NOT NULL UNIQUE,
    telefono         VARCHAR(20),
    ciudad           VARCHAR(100),
    activo           BOOLEAN      DEFAULT TRUE,
    fecha_creacion   TIMESTAMP    DEFAULT NOW()
);

-- Tabla 2: proveedores
CREATE TABLE IF NOT EXISTS proveedores (
    id         BIGSERIAL    PRIMARY KEY,
    nit        VARCHAR(20)  NOT NULL UNIQUE,
    nombre     VARCHAR(200) NOT NULL,
    contacto   VARCHAR(150),
    email      VARCHAR(254),
    telefono   VARCHAR(20),
    ciudad     VARCHAR(100),
    sitio_web  VARCHAR(200),
    activo     BOOLEAN      DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT NOW()
);

-- Tabla 3: sucursales
CREATE TABLE IF NOT EXISTS sucursales (
    id           BIGSERIAL    PRIMARY KEY,
    codigo       VARCHAR(20)  NOT NULL UNIQUE,
    nombre       VARCHAR(200) NOT NULL,
    direccion    TEXT         NOT NULL,
    ciudad       VARCHAR(100) NOT NULL,
    telefono     VARCHAR(20),
    email        VARCHAR(254),
    es_principal BOOLEAN      DEFAULT FALSE,
    activo       BOOLEAN      DEFAULT TRUE,
    fecha_creacion TIMESTAMP  DEFAULT NOW()
);

-- Tabla 4: productos (referencia a proveedores)
CREATE TABLE IF NOT EXISTS productos (
    id            BIGSERIAL      PRIMARY KEY,
    codigo        VARCHAR(50)    NOT NULL UNIQUE,
    nombre        VARCHAR(200)   NOT NULL,
    descripcion   TEXT,
    precio        NUMERIC(12,2)  NOT NULL,
    stock         INTEGER        DEFAULT 0,
    stock_minimo  INTEGER        DEFAULT 5,
    unidad_medida VARCHAR(5)     DEFAULT 'UND',
    proveedor_id  BIGINT         NOT NULL REFERENCES proveedores(id),
    activo        BOOLEAN        DEFAULT TRUE,
    fecha_creacion TIMESTAMP     DEFAULT NOW()
);

-- Tabla 5: pedidos (referencia a clientes y sucursales)
CREATE TABLE IF NOT EXISTS pedidos (
    id            BIGSERIAL     PRIMARY KEY,
    numero_pedido VARCHAR(20)   NOT NULL UNIQUE,
    fecha_pedido  DATE          NOT NULL,
    fecha_entrega DATE,
    estado        VARCHAR(15)   DEFAULT 'PENDIENTE',
    cliente_id    BIGINT        NOT NULL REFERENCES clientes(id),
    sucursal_id   BIGINT        NOT NULL REFERENCES sucursales(id),
    observaciones TEXT,
    total         NUMERIC(14,2) DEFAULT 0,
    activo        BOOLEAN       DEFAULT TRUE,
    fecha_creacion TIMESTAMP    DEFAULT NOW()
);

-- Tabla 6: detalle_pedidos (referencia a pedidos y productos)
CREATE TABLE IF NOT EXISTS detalle_pedidos (
    id              BIGSERIAL     PRIMARY KEY,
    pedido_id       BIGINT        NOT NULL REFERENCES pedidos(id),
    producto_id     BIGINT        NOT NULL REFERENCES productos(id),
    cantidad        INTEGER       NOT NULL,
    precio_unitario NUMERIC(12,2) NOT NULL,
    descuento       NUMERIC(5,2)  DEFAULT 0,
    subtotal        NUMERIC(14,2) DEFAULT 0,
    activo          BOOLEAN       DEFAULT TRUE,
    fecha_creacion  TIMESTAMP     DEFAULT NOW(),
    UNIQUE(pedido_id, producto_id)
);

-- Tabla 7: facturas (referencia a pedidos)
CREATE TABLE IF NOT EXISTS facturas (
    id                BIGSERIAL     PRIMARY KEY,
    numero_factura    VARCHAR(20)   NOT NULL UNIQUE,
    fecha_emision     DATE          NOT NULL,
    fecha_vencimiento DATE          NOT NULL,
    estado            VARCHAR(10)   DEFAULT 'PENDIENTE',
    pedido_id         BIGINT        NOT NULL UNIQUE REFERENCES pedidos(id),
    subtotal          NUMERIC(14,2) NOT NULL,
    iva               NUMERIC(5,2)  DEFAULT 19,
    total             NUMERIC(14,2) NOT NULL,
    activo            BOOLEAN       DEFAULT TRUE,
    fecha_creacion    TIMESTAMP     DEFAULT NOW()
);

-- Tabla 8: pagos (referencia a facturas)
CREATE TABLE IF NOT EXISTS pagos (
    id           BIGSERIAL     PRIMARY KEY,
    numero_pago  VARCHAR(20)   NOT NULL UNIQUE,
    fecha_pago   DATE          NOT NULL,
    monto        NUMERIC(14,2) NOT NULL,
    metodo_pago  VARCHAR(15)   NOT NULL,
    estado       VARCHAR(12)   DEFAULT 'PENDIENTE',
    referencia   VARCHAR(100),
    factura_id   BIGINT        NOT NULL REFERENCES facturas(id),
    activo       BOOLEAN       DEFAULT TRUE,
    fecha_creacion TIMESTAMP   DEFAULT NOW()
);
