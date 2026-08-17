CREATE DATABASE alquilerVehiculosLVBD;
GO

USE alquilerVehiculosLVBD;
GO

CREATE TABLE cliente
(
    id_cliente INT PRIMARY KEY,
    cedula_ruc VARCHAR(20) NOT NULL,
    nombres VARCHAR(150) NOT NULL,
    apellidos VARCHAR(150) NOT NULL,
    correo VARCHAR(200) NOT NULL,
    direccion VARCHAR(250),
    tipo VARCHAR(100),
    celular VARCHAR(15) NOT NULL
);

CREATE TABLE empleado
(
    id_empleado INT PRIMARY KEY,
    nombres VARCHAR(150) NOT NULL,
    apellidos VARCHAR(150) NOT NULL,
    correo VARCHAR(200) NOT NULL,
    cargo VARCHAR(100),
    celular VARCHAR(15)
);

CREATE TABLE categoriaVehiculo
(
    id_categoria INT PRIMARY KEY,
    nombre_tipo VARCHAR(150) NOT NULL,
    tarifa_hora DECIMAL(10,2),
    tarifa_dia DECIMAL(10,2)
);

CREATE TABLE vehiculo
(
    id_vehiculo INT PRIMARY KEY,
    id_categoria INT,
    placa VARCHAR(20),
    marca VARCHAR(100),
    modelo VARCHAR(200),
    estado VARCHAR(100),
    CONSTRAINT fk_vehiculo_categoria FOREIGN KEY (id_categoria) REFERENCES categoriaVehiculo(id_categoria)
);

CREATE TABLE contrato
(
    id_contrato INT PRIMARY KEY,
    id_cliente INT,
    id_empleado INT,
    fecha_inicio DATETIME,
    fecha_fin DATETIME,
    estado VARCHAR(100),
    CONSTRAINT fk_contrato_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_contrato_empleado FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado)
);

CREATE TABLE detalle_Contrato
(
    id_detalle INT PRIMARY KEY,
    id_contrato INT,
    id_vehiculo INT,
    dias_prestado INT,
    monto_prorrateado DECIMAL(10,2),
    CONSTRAINT fk_dContrato_contrato FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato),
    CONSTRAINT fk_dContrato_vehiculo FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo)
);

CREATE TABLE reserva
(
    id_reserva INT PRIMARY KEY,
    id_cliente INT,
    id_vehiculo INT,
    fecha_reserva DATETIME,
    estado VARCHAR(100),
    total DECIMAL(10,2),
    CONSTRAINT fk_reserva_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
    CONSTRAINT fk_reserva_vehiculo FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo)
);

CREATE TABLE pagos
(
    id_pago INT PRIMARY KEY,
    id_contrato INT,
    id_reserva INT,
    monto DECIMAL(10,2),
    metodo_pago VARCHAR(100),
    fecha_pago DATETIME,
    CONSTRAINT fk_pago_contrato FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato),
    CONSTRAINT fk_pago_reserva FOREIGN KEY (id_reserva) REFERENCES reserva(id_reserva)
);

CREATE TABLE factura
(
    id_factura INT PRIMARY KEY,
    id_contrato INT,
    fecha_emision DATETIME,
    descuento DECIMAL(10,2),
    subtotal DECIMAL(10,2),
    impuesto DECIMAL(10,2),
    total DECIMAL(10,2),
    CONSTRAINT fk_factura_contrato FOREIGN KEY (id_contrato) REFERENCES contrato(id_contrato)
);

CREATE TABLE mantenimiento
(
    id_mantenimiento INT PRIMARY KEY,
    id_vehiculo INT,
    fecha_inicio DATETIME,
    fecha_fin DATETIME,
    descripcion VARCHAR(250) NOT NULL,
    costo DECIMAL(10,2) NOT NULL,
    responsable VARCHAR(120) NOT NULL,
    CONSTRAINT fk_mantenimiento_vehiculo FOREIGN KEY (id_vehiculo) REFERENCES vehiculo(id_vehiculo)
);
GO

INSERT INTO cliente
    (id_cliente, cedula_ruc, nombres, apellidos, correo, direccion, tipo, celular)
VALUES
    (1, '0957378680', 'Luis Isaac', 'Veas Vera', 'isaacveasvera@gmail.com', 'Guayaquil', 'Natural', '0984618951'),
    (2, '1234567890', 'Valeska Rosmeri', 'Veas Vera', 'valeska@gmail.com', 'Guayaquil', 'Natural', '0998887777'),
    (3, '0990384845', 'Bettsy', 'Paredes Vargas', 'bettsyparedez@gmail.com', 'Sergio Toral', 'Empresa', '0990384845');

INSERT INTO empleado
    (id_empleado, nombres, apellidos, correo, cargo, celular)
VALUES
    (1, 'Ana', 'Lopez', 'ana@rent.com', 'Asesor', '0991112222'),
    (2, 'Carlos', 'Ruiz', 'carlos@rent.com', 'Gerente', '0983334444');

INSERT INTO categoriaVehiculo
    (id_categoria, nombre_tipo, tarifa_hora, tarifa_dia)
VALUES
    (1, 'Sedán', 10.00, 50.00),
    (2, 'Transporte', 15.00, 80.00),
    (3, 'Lujo', 25.00, 100.00),
    (4, 'Maquinaria Pesada', 20.00, 140.00);

INSERT INTO vehiculo
    (id_vehiculo, id_categoria, placa, marca, modelo, estado)
VALUES
    (1, 3, 'LYN-1417', 'Mercedes-Benz', 'AMG35', 'Alquilado'),
    (2, 1, 'GQU-0987', 'Toyota', 'Yaris', 'Alquilado'),
    (3, 1, 'PCH-1122', 'Kia', 'Rio', 'Disponible'),
    (4, 4, 'CAT-8680', 'Caterpillar', '320 GC', 'Disponible');

INSERT INTO contrato
    (id_contrato, id_cliente, id_empleado, fecha_inicio, fecha_fin, estado)
VALUES
    (1, 1, 1, '2026-08-17', '2026-08-20', 'Activo'),
    (2, 2, 2, '2026-08-21', '2026-08-22', 'Finalizado');

INSERT INTO reserva
    (id_reserva, id_cliente, id_vehiculo, fecha_reserva, estado, total)
VALUES
    (1, 1, 1, '2026-08-10', 'Confirmada', 450.00),
    (2, 2, 3, '2026-08-15', 'Confirmada', 70.00);

INSERT INTO detalle_Contrato
    (id_detalle, id_contrato, id_vehiculo, dias_prestado, monto_prorrateado)
VALUES
    (1, 1, 1, 3, 300.00),
    (2, 1, 2, 3, 150.00),
    (3, 2, 3, 1, 70.00);

INSERT INTO pagos
    (id_pago, id_contrato, id_reserva, monto, metodo_pago, fecha_pago)
VALUES
    (1, 1, 1, 450.00, 'Tarjeta', '2026-08-17'),
    (2, 2, 2, 70.00, 'Efectivo', '2026-08-22');

INSERT INTO factura
    (id_factura, id_contrato, fecha_emision, descuento, subtotal, impuesto, total)
VALUES
    (1, 1, '2026-08-17', 0.00, 401.78, 48.22, 450.00),
    (2, 2, '2026-08-22', 0.00, 62.50, 7.50, 70.00);

INSERT INTO mantenimiento
    (id_mantenimiento, id_vehiculo, fecha_inicio, fecha_fin, descripcion, costo, responsable)
VALUES
    (1, 1, '2026-07-01', '2026-07-02', 'Cambio de aceite', 80.00, 'Taller Autolav'),
    (2, 3, '2026-05-10', '2026-05-15', 'Frenos', 120.00, 'Mecánica Sur');
GO

SELECT *
FROM cliente;
SELECT *
FROM factura;