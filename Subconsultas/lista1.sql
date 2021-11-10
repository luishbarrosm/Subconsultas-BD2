use compubras;

#1
select Nome, Endereco, Cidade, Uf, Cep 
from cliente where CodCliente in 
(select CodCliente from pedido where year(DataPedido) = 2015) 
order by Nome asc; 

#2
select Descricao, ValorUnitario 
from produto where CodProduto in 
(select CodProduto from (select CodPedido, CodProduto, SUM(Quantidade) as total from itempedido 
group by CodPedido, CodProduto) temp 
where total >= 5 and total <= 7)  
order by  ValorUnitario desc; 

#3
select count(CodCliente) as total 
from pedido where CodCliente in
(select CodCliente from cliente where Uf = 'RS' or Uf = 'SC'); 

#4
select CodProduto, Descricao, ValorUnitario from produto where CodProduto in
(select CodProduto from itempedido where CodPedido in (select CodPedido from pedido 
where PrazoEntrega  between '2014-12-01' and '2015-01-31')) 
order by ValorUnitario desc; 
#5
select c.CodCliente,c.Nome,c.Endereco ,c.Cidade ,c.Cep ,c.uf ,c.Ie 
from cliente c inner join pedido p on p.codcliente = c.codcliente 
where p.codpedido in
(select ip.codpedido as total from itempedido ip 
group by ip.codpedido having sum(ip.quantidade) > 60 ); 

#6
select c.CodCliente, c.Nome, t2.codpedido 
from cliente c inner join 
(select p.CodCliente, p.CodPedido as codpedido from pedido p inner join 
(select v.CodVendedor as codvendedor from vendedor v
where v.FaixaComissao = "A") as t on p.CodVendedor = t.codvendedor) as t2 
on c.CodCliente = t2.codcliente order by c.CodCliente; 

#7
select c.Nome, c.Endereco, c.Cidade,c.Uf, c.Cep, t.codpedido, t.prazoentrega  from cliente c
inner join (select codcliente, codpedido, prazoentrega from pedido p
where CodVendedor not in (select codvendedor from vendedor where salariofixo <= 1500)) 
t on c.CodCliente= t.codCliente; 

#8
select nome, cidade, uf 
from cliente where codCliente in
(select codCliente from pedido where YEAR(dataPedido) = 2015) 
order by nome; 

#9
select t2.codpedido, t2.quantidade from 
(select itempedido.CodPedido as codpedido, sum(itempedido.Quantidade) 
as quantidade from itempedido 
group by itempedido.CodPedido) as t2
where t2.quantidade > any(select avg(temp.quantidade) 
from (select sum(itempedido.Quantidade) as quantidade from itempedido
group by itempedido.CodPedido) as temp); 
 
#10
select c.nome as NomeCliente, v.nome as NomeVendedor,c.uf from 
(select p.codcliente,p.codvendedor,p.datapedido,p.codpedido from 
(select p.codcliente,max(p.datapedido) as Primeiro from 
pedido p group by p.codcliente ) t 
inner join pedido p 
on p.CodCliente = t.codcliente
where primeiro = p.datapedido ) t2
inner join cliente c
on t2.codcliente = c.codcliente
inner join vendedor v
on v.codvendedor = t2.codvendedor
where c.uf = 'RS'
order by  c.nome;

#11
select Descricao , ValorUnitario 
from produto where ValorUnitario > all
(select ValorUnitario from produto where Descricao like 'L%') 
order by Descricao ; 

#12
select codproduto, descricao as nome, valorunitario  
from produto  where codproduto in 
(select codproduto from  (Select codPedido, Codproduto, sum(quantidade) as total 
from itempedido group by codPedido, codProduto) t
where total > 9); 

#13
select CodVendedor, nome from vendedor where CodVendedor not in (
select CodVendedor from pedido where PrazoEntrega 
between '2015-08-01' and '2015-08-31');

#14
select CodCliente, Nome from cliente where CodCliente in 
(select CodCliente from pedido where DataPedido between '2014-04-01' and '2014-04-30') 
group by CodCliente 
order by Nome; 

