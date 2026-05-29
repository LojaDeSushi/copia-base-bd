create user 'admin'@'localhost' identified by 'senhaAdmin';
create user 'atendente'@'localhost' identified by 'senhaAtendente';
create user 'cliente'@'localhost' identified by 'senhaCliente';

grant all privileges on banco1.* to 'admin'@'localhost';

grant select, insert, update on banco1.pedido to 'atendente'@'localhost';
grant select, insert, update on banco1.itempedido to 'atendente'@'localhost';
grant select, insert, update, delete on banco1.itemcarrinho to 'atendente'@'localhost';
grant select, insert, update on banco1.carrinho to 'atendente'@'localhost';
grant select, insert, update on banco1.pagamento to 'atendente'@'localhost';
grant select on banco1.produto to 'atendente'@'localhost';
grant select on banco1.cliente to 'atendente'@'localhost';
grant select on banco1.clienteweb to 'atendente'@'localhost';
grant select on banco1.conta to 'atendente'@'localhost';


grant select, insert, update, delete on banco1.itemcarrinho to 'cliente'@'localhost';
grant select, insert, update on banco1.pedido to 'cliente'@'localhost';
grant select, insert on banco1.itempedido to 'cliente'@'localhost';
grant select, insert on banco1.pagamento to 'cliente'@'localhost';
grant select on banco1.carrinho to 'cliente'@'localhost';
grant select on banco1.conta to 'cliente'@'localhost';
grant select on banco1.clienteweb to 'cliente'@'localhost';
grant select on banco1.produto to 'cliente'@'localhost';

flush privileges;
