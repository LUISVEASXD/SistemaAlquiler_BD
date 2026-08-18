
use alquilervehiculoslvbd;
go

create view vw_vehiculos_disponibles
as
    select
        v.placa,
        v.marca,
        v.modelo,
        c.nombre_tipo as categoria,
        c.tarifa_dia,
        c.tarifa_hora
    from vehiculo v
        join categoriavehiculo c on v.id_categoria = c.id_categoria
    where v.estado = 'disponible';
go

create view vw_contratos_activos
as
    select
        co.fecha_inicio,
        co.fecha_fin,
        cl.nombres as cliente,
        em.nombres as empleado
    from contrato co
        join cliente cl on co.id_cliente = cl.id_cliente
        join empleado em on co.id_empleado = em.id_empleado
    where co.estado = 'activo';
go

create view vw_historial_mantenimiento
as
    select
        man.fecha_inicio,
        man.fecha_fin,
        man.descripcion,
        dm.costo_reparacion as costo,
        man.responsable,
        ve.placa,
        ve.marca,
        ve.modelo,
        cav.nombre_tipo as categoria
    from mantenimiento man
        join detalle_mantenimiento dm on man.id_mantenimiento = dm.id_mantenimiento
        join vehiculo ve on dm.id_vehiculo = ve.id_vehiculo
        join categoriavehiculo cav on ve.id_categoria = cav.id_categoria;
go

create view vw_resumen_pagos
as
    select
        p.monto,
        p.metodo_pago,
        p.fecha_pago,
        cl.nombres as cliente,
        cl.tipo,
        cl.correo,
        co.fecha_inicio,
        co.fecha_fin,
        co.estado,
        em.nombres as empleado,
        dco.monto_prorrateado
    from pagos p
        join contrato co on p.id_contrato = co.id_contrato
        join cliente cl on co.id_cliente = cl.id_cliente
        join empleado em on co.id_empleado = em.id_empleado
        join detalle_contrato dco on co.id_contrato = dco.id_contrato;
go
select *
from vw_resumen_pagos