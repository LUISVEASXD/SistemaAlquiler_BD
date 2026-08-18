use alquilervehiculoslvbd;
go

create procedure sp_registrarcontrato_transaccion
    @id_contrato int,
    @id_cliente int,
    @id_empleado int,
    @fecha_inicio datetime,
    @fecha_fin datetime,
    @id_vehiculo int,
    @dias_prestado int,
    @monto_prorrateado decimal(10,2)
as
begin
    begin try
        begin transaction; 

        declare @estado_actual varchar(100);
        select @estado_actual = estado
    from vehiculo
    where id_vehiculo = @id_vehiculo;

        if @estado_actual = 'mantenimiento' or @estado_actual = 'Mantenimiento'
        begin
            throw 50001, 'error: el vehiculo se encuentra en mantenimiento y no puede ser alquilado.', 1;
        end

        insert into contrato
        (id_contrato, id_cliente, id_empleado, fecha_inicio, fecha_fin, estado)
    values
        (@id_contrato, @id_cliente, @id_empleado, @fecha_inicio, @fecha_fin, 'activo');

        declare @nuevo_id_detalle int = (select isnull(max(id_detalle), 0) + 1
    from detalle_contrato);
        
        insert into detalle_contrato
        (id_detalle, id_contrato, id_vehiculo, dias_prestado, monto_prorrateado)
    values
        (@nuevo_id_detalle, @id_contrato, @id_vehiculo, @dias_prestado, @monto_prorrateado);

        update vehiculo set estado = 'alquilado' where id_vehiculo = @id_vehiculo;

        commit transaction; 
        print 'transaccion exitosa: contrato y detalle registrados.';
    end
    try
    begin catch
    if @@trancount > 0
            rollback transaction;

    print 'transaccion fallida (rollback ejecutado): ' + error_message();
    end catch
end;
go

create procedure sp_consultardisponibilidad
    @nombre_categoria varchar(150)
as
begin
    select
        v.placa, v.marca, v.modelo, v.estado, cv.tarifa_dia
    from vehiculo v
        join categoriavehiculo cv on v.id_categoria = cv.id_categoria
    where cv.nombre_tipo = @nombre_categoria and (v.estado = 'Disponible' or v.estado = 'disponible');
end;
go

create procedure sp_historialcliente
    @cedula_ruc varchar(20)
as
begin
    select
        c.id_contrato, c.fecha_inicio, c.estado, v.marca, v.modelo, f.total as total_facturado
    from contrato c
        join cliente cl on c.id_cliente = cl.id_cliente
        join detalle_contrato dc on c.id_contrato = dc.id_contrato
        join vehiculo v on dc.id_vehiculo = v.id_vehiculo
        left join factura f on c.id_contrato = f.id_contrato
    where cl.cedula_ruc = @cedula_ruc;
end;
go

create procedure sp_reportegerencial_facturacion
    @fechainicio datetime,
    @fechafin datetime,
    @filtrocategoria varchar(150) = null
as
begin
    set nocount on;

    with
        datosfacturacion
        as
        (
            select
                cv.id_categoria,
                cv.nombre_tipo as categoria,
                f.id_contrato,
                f.subtotal,
                f.descuento,
                f.total as ingreso_neto,
                v.placa,
                v.marca + ' ' + v.modelo as vehiculo,
                dc.monto_prorrateado
            from factura f
                join contrato c on f.id_contrato = c.id_contrato
                join detalle_contrato dc on c.id_contrato = dc.id_contrato
                join vehiculo v on dc.id_vehiculo = v.id_vehiculo
                join categoriavehiculo cv on v.id_categoria = cv.id_categoria
            where f.fecha_emision >= @fechainicio and f.fecha_emision <= @fechafin
                and (@filtrocategoria is null or cv.nombre_tipo = @filtrocategoria)
        ),

        resumenporcategoria
        as
        (
            select
                categoria,
                sum(subtotal) as ingreso_bruto,
                sum(descuento) as total_descuentos,
                sum(ingreso_neto) as ingreso_neto_categoria,
                count(distinct id_contrato) as total_contratos,
                round(sum(ingreso_neto) / nullif(count(distinct id_contrato), 0), 2) as ticket_promedio
            from datosfacturacion
            group by categoria
        ),

        totalgeneral
        as
        (
            select sum(ingreso_neto_categoria) as grantotal
            from resumenporcategoria
        ),

        mejorvehiculo
        as
        (
            select top 1
                vehiculo,
                placa,
                sum(monto_prorrateado) as total_generado_vehiculo
            from datosfacturacion
            group by vehiculo, placa
            order by sum(monto_prorrateado) desc
        )

    select
        rc.categoria,
        round(rc.ingreso_bruto, 2) as ingreso_bruto,
        round(rc.total_descuentos, 2) as total_descuentos,
        round(rc.ingreso_neto_categoria, 2) as ingreso_neto,
        rc.ticket_promedio,
        round((rc.ingreso_neto_categoria / nullif(tg.grantotal, 0)) * 100, 2) as porcentaje_participacion_pct,
        (select vehiculo + ' (' + placa + ') con $' + cast(total_generado_vehiculo as varchar)
        from mejorvehiculo) as vehiculo_mayor_ingreso_global
    from resumenporcategoria rc
    cross join totalgeneral tg
    order by rc.ingreso_neto_categoria desc;

end;
go

exec sp_reportegerencial_facturacion '2026-08-01', '2026-08-31';
exec sp_reportegerencial_facturacion '2026-08-01', '2026-08-31', 'Sedán';

exec sp_registrarcontrato_transaccion 3, 1, 1, '2026-09-01', '2026-09-05', 2, 4, 200.00;
exec sp_registrarcontrato_transaccion 4, 2, 2, '2026-09-01', '2026-09-05', 3, 4, 200.00;
exec sp_consultardisponibilidad 'Sedán';
exec sp_historialcliente '0957378680';