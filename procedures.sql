----------------------------Método de pag mais usado-----------------------------
delimiter //
CREATE PROCEDURE MetodoMais()
BEGIN
    SELECT metodo_pag, COUNT(metodo_pag) as total
    FROM pagamento
    GROUP BY metodo_pag
    ORDER BY total DESC
    LIMIT 1;
END //

----------------------------Valor medio de vendas por ano---------------------
delimiter //
create procedure MediaPedidosAno()
begin
    select year(dia_pedido), avg(total_pedido) as media
    from pedido
    group by year(dia_pedido)
    order by media desc;
end //

-----------------------------ano e mes de maior num de vendas-------------------
delimiter //
create procedure MaiorVendasM_A()
begin
    select year(dia_pedido), month(dia_pedido), count(id_pedido) as total
    from pedido
    group by year(dia_pedido), month(dia_pedido)
    order by total desc
    limit 1;
end //

-----------------------cliente com compras todo mes-------------------------
delimiter //
create procedure ClienteAnual(in ano year)
begin
    select id_conta, count(distinct month(dia_pedido)) as meses
    from pedido
    where year(dia_pedido) = ano
    group by id_conta
    having meses = 12;
end //

--------------------produtos mais vendidos-------------------
delimiter //
create procedure ProdutoMais()
begin
    select nome_produto, sum(itempedido.quanti_item) as total
    from produto
    join itempedido
    on produto.id_produto = itempedido.id_produto
    group by nome_produto
    order by total desc;
end //
delimiter ;
