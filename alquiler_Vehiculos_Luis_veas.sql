create table cliente
(
    id_cliente int primary key,
    nombres varchar(150) not null,
    apellidos varchar(150) not null,
    correo varchar(200) not null,
    direccion varchar(250),
    tipo varchar(100),
    celular varchar(10) not null
);
create table empleado
(
    id_empleado int primary key,
    nombres varchar(150) not null,
    apellidos varchar(150) not null,
    correo varchar(200) not null,
    cargo varchar(100),
    celular varchar(10)
);
create table contrato
(
    id_contrato int primary key,
    id_cliente int,
    id_empleado int,
    fecha_inicio datetime ,
    fecha_fin datetime ,
    estado varchar(100),
    constraint fk_contrato_cliente foreign key (id_cliente) references cliente (id_cliente),
    constraint fk_contrato_empleado foreign key(id_empleado) references empleado(id_empleado)
);
create table categoriaVehiculo
(
    id_categoria int primary key,
    nombre_tipo varchar(150) not null,
    tarifa_hora decimal(10,2),
    tarifa_dia decimal(10,2)
);
create table vehiculo
(
    id_vehiculo int primary key,
    id_categoria int,
    placa varchar(150),
    marca varchar(100),
    modelo varchar(200),
    estado varchar(100),
    constraint fk_vehiculo_categoria foreign key (id_categoria) references categoriaVehiculo(id_categoria)
);
create table reserva
(
    id_reserva int primary key,
    id_cliente int,
    id_vehiculo int,
    fecha_reserva datetime,
    monto_anticipado decimal(10,2),
    estado varchar(100),
    constraint fk_reserva_cliente foreign key(id_cliente) references cliente(id_cliente),
    constraint fk_reserva_vehiculo foreign key(id_vehiculo) references vehiculo(id_vehiculo)
);
create table pagos
(
    id_pago int primary key,
    id_contrato int,
    id_reserva int,
    monto decimal(10,2),
    metodo_pago varchar(100),
    fecha_pago datetime,
    constraint fk_pago_contrato foreign key(id_contrato) references contrato(id_contrato),
    constraint fk_pago_reserva foreign key(id_reserva) references reserva(id_reserva)
);
create table detalle_Contrato
(
    id_detalle int primary key,
    id_contrato int,
    id_vehiculo int,
    dias_prestado int,
    monto_prorrateado decimal(10,2),
    constraint fk_dContrato_contrato foreign key(id_contrato) references contrato(id_contrato),
    constraint fk_dContrato_vehiculo foreign key(id_vehiculo) references vehiculo(id_vehiculo)
);
create table mantenimiento
(
    id_mantenimiento int primary key,
    id_vehiculo int,
    fecha_inicio datetime,
    fecha_fin datetime,
    descripcion varchar(250) not null,
    costo decimal(10,2) not null,
    responsable varchar(120) not null,
    constraint fk_mantenimiento_vehiculo foreign key(id_vehiculo) references vehiculo(id_vehiculo)
)
go
insert into cliente
    (id_cliente,nombres,apellidos, correo, direccion, tipo, celular)
values
    (1, 'Luis Isaac', 'Veas Vera', 'isaacveasvera@gmail.com', 'Tia 25 y la ch', 'natural', '0984618951'),
    (2, 'Bettsy', 'Paredes Vargas', 'bettsyparedez@gmail.com', 'Sergio toral', 'Empresa', '0990384845'),
    (3, 'Valeska Rosmeri', 'Veas Vera', 'valeskaveasvera@gmail.com', 'Tia 25 y la ch', 'natural', '0999999999');
insert into categoriaVehiculo
    (id_categoria, nombre_tipo, tarifa_hora,tarifa_dia)
values
    (1, 'liviano', 5.00, 45.00),
    (2, 'transporte', 10.00, 80.00),
    (3, 'carga', 15.00, 125.00),
    (4, 'Maquinaria pesada', 20.00, 140.00);
insert into empleado
    (id_empleado, nombres,apellidos, correo, cargo,celular)
values
    (1, 'Dylan', 'Leon Choez', 'dylan@gmail.com', 'agente de ventas', '091234568'),
    (2, 'Ronny', 'Zajia', 'zajia@gmail.com', 'agente de ventas', '098888882');
insert into vehiculo
    (id_vehiculo, id_categoria, placa, marca, modelo, estado)
values
    (1, 1, 'LIV-8680', 'BMW', 'BMW Z4', 'disponible'),
    (2, 1, 'LYN-0000', 'MERCEDEZ', 'AMG-A35', 'No disponible'),
    (3, 1, 'NYL-1111', 'KIA', 'RIO', 'disponbile'),
    (4, 2, 'LVV-1417', 'chevrolet', 'FTR 1624', 'disponible'),
    (6, 4, 'CAT-8680', 'Caterpillar', '320 GC', 'disponible');