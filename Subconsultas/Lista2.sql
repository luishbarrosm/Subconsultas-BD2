#1
select cliente.CodCliente, cliente.Nome, temp2.codpedido from cliente inner join 


(select pedido.CodCliente, pedido.CodPedido as codpedido from pedido inner join 

(select vendedor.CodVendedor as codvendedor from vendedor where vendedor.FaixaComissao = "A") as temp 

on pedido.CodVendedor = temp.codvendedor) as temp2 


on cliente.CodCliente = temp2.codcliente order by cliente.CodCliente;

#2
use compubras;

SELECT cliente.Nome, cliente.Endereco, cliente.Cidade, cliente.uf,cliente.Cep, temp.codpedido, temp.prazoentrega from cliente inner join 

(select codcliente, codpedido, prazoentrega from pedido where CodVendedor not in 

(select codvendedor from vendedor where salariofixo >= 1500)) temp on cliente.CodCliente= temp.codCliente; 


#3
SELECT cliente.nome, cliente.cidade, cliente.uf FROM Cliente WHERE CodCliente IN 
(SELECT Codcliente FROM pedido where year(Datapedido)=2015)
ORDER BY nome;

#4
use compubras;

 select temp2.codpedido, temp2.quantidade from (select itempedido.CodPedido as codpedido, sum(itempedido.Quantidade) as quantidade from 
 itempedido group by itempedido.CodPedido) as temp2 where temp2.quantidade >
 any(select avg(temp.quantidade) from (select sum(itempedido.Quantidade) as quantidade from itempedido group by itempedido.CodPedido) as temp); 


#5 ANULADA

#6
select p.codpedido as pedido, c.Nome as NomeCliente, c.uf as EstadoCliente, v.nome as NomeVendedor, max(p.DataPedido) as DataPedido from pedido p 
inner join vendedor v on v.CodVendedor = p.CodVendedor inner join 
cliente c on p.CodCliente = c.CodCliente where c.Codcliente in 
(select c.codcliente from cliente c where c.uf like "SC") 
group by p.CodCliente order by p.codpedido; 

#7
SELECT produto.descricao, produto.valorunitario FROM produto WHERE valorunitario > ALL(SELECT valorunitario FROM produto WHERE descricao like 'L%') ORDER BY descricao; 

#8
select p.codproduto, p.descricao as nome, p.valorunitario valor_unitario from produto p where p.codproduto in (select codproduto from  (Select codPedido, Codproduto, sum(quantidade) as total from itempedido group by codPedido, codProduto) temp where total>9); 

#9
SELECT CodCliente, Nome FROM cliente WHERE CodCliente IN (SELECT CodCliente FROM pedido WHERE MONTH(DataPedido)= 4 AND YEAR(DataPedido) = 2015) GROUP BY CodCliente ORDER BY Nome; 

#10
SELECT CodCliente, Nome FROM cliente WHERE CodCliente IN (SELECT CodCliente FROM pedido WHERE MONTH(DataPedido)= 4 AND YEAR(DataPedido) = 2014) GROUP BY CodCliente ORDER BY Nome; 