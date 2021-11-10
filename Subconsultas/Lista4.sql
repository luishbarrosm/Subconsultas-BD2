#1
SELECT pr.CodProduto, pr.Descricao, pr.ValorUnitario FROM produto pr WHERE pr.CodProduto IN (SELECT ip.CodProduto FROM itempedido ip WHERE ip.Quantidade > 9) ORDER BY pr.CodProduto; 

#2
SELECT * from cliente WHERE CodCliente in (SELECT CodCliente from pedido WHERE DataPedido BETWEEN ('2014-09-25') and ('2015-10-05'));

#3
SELECT c.CodCliente, c.Nome AS NomeCliente, c.endereco, c.cidade, c.cep, c.Uf, COALESCE(temp.TotalPedidoCliente, 0) AS TotalPedidoCliente FROM cliente c LEFT JOIN (SELECT p.CodCliente, COUNT(p.CodPedido) AS TotalPedidoCliente FROM pedido p GROUP BY p.CodCliente) temp ON c.CodCliente = temp.CodCliente; 
 
#4
SELECT pedido.CodPedido, PrazoEntrega, DataPedido, CodCliente, CodVendedor, COALESCE(temp.produtos, 0) AS produtos FROM pedido LEFT JOIN (SELECT SUM(Quantidade) AS produtos, CodPedido FROM itempedido GROUP BY CodPedido) temp ON pedido.CodPedido = temp.CodPedido ORDER BY produtos DESC; 

#5
SELECT * FROM Produto WHERE CodProduto NOT IN( SELECT CodProduto FROM itempedido)  ORDER BY Descricao ASC; 

#6
SELECT codProduto, descricao, valorUnitario, total from produto inner join (select codProduto, sum(quantidade) as total from itempedido order by codProduto) temp on produto.codProduto=temp.codProduto order by total desc; 
 
#7
SELECT CodCliente, Nome, Endereco, Cidade, Cep, Ie FROM cliente WHERE CodCliente IN  (SELECT pedido.CodCliente FROM pedido WHERE CodPedido IN (SELECT CodPedido FROM itempedido WHERE itempedido.CodProduto IN  (SELECT produto.CodProduto FROM produto WHERE ValorUnitario < 10.00))) 

#8
SELECT * FROM vendedor WHERE CodVendedor IN( SELECT CodVendedor FROM pedido WHERE CodPedido IN(SELECT CodPedido FROM itempedido WHERE CodProduto IN (SELECT CodProduto FROM produto WHERE Descricao LIKE "IPHONE 6 PLUS%")));

#9
Select produto.codProduto, descricao, valorUnitario, total from produto inner join (select codProduto, count(codPedido) as total from itempedido group by codPedido) temp on produto.codProduto = temp.codProduto; 

#10
SELECT P.CodPedido,P.PrazoEntrega,P.DataPedido,P.CodCliente,P.CodVendedor,round( coalence(T.Total,0),2) FROM pedido P inner join (SELECT CodPedido,SUM(ValorUnitario * Quantidade) AS Total FROM itempedido INNER JOIN produto ON produto.CodProduto = itempedido.CodProduto GROUP BY CodPedido) T INNER JOIN pedido P ON T.CodPedido = P.CodPedido ORDER BY Total desc; 
 
#11
Select vendedor.nome, total from vendedor inner join (select codvendedor, count(codPedido) as total from pedido group by codVendedor) temp on vendedor.codvendedor = temp.codvendedor order by total desc; 

#12


#13
SELECT produto.codProduto, Descricao, valorunitario, total from produto inner join (select codProduto, sum(quantidade) AS total from itempedido where codPedido in (select codPedido from pedido where year(datapedido) = 2015) group by codProduto) temp on temp.codProduto = produto.codProduto order by total desc; 

#14
SELECT produto.codProduto, Descricao, valorunitario, total from produto inner join (select codProduto, sum(quantidade) AS total from itempedido where codPedido in (select codPedido from pedido where year(datapedido) = 2015) group by codProduto) temp on temp.codProduto = produto.codProduto order by total desc; 
 
#15
Select nome, round(coalence(total,0),2) as total_vendido from vendedor left join (select codvendedor, sum(quantidade*valorunitario) as total from pedido inner join itempedido on pedido.codPedido = itempedido.codPedido inner join produto on produto.codProduto=itempedido.codProduto group by codVendedor) temp on temp.codVendedor = vendedor.codVendedor order by total desc; 