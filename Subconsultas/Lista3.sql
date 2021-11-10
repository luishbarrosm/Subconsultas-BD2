USE compubras;

#1
select nome,
	   endereco,
       cidade,
       cep
from cliente
where codcliente IN( 
select codcliente
from pedido
where datediff(prazoentrega, datapedido) between '16' and '20'
)
and uf = 'SC'
group by codcliente;


#2
select nome,
	   endereco,
       cidade,
       cep
from cliente
where codcliente IN( 
select codcliente
from pedido
where codvendedor in(
select codvendedor
from vendedor 
where nome like 'A%' 
)
and year(datapedido) = '2015'
)
and uf = 'RS'
group by codcliente;

 
#3
select nome,
       salariofixo,
       faixacomissao
from vendedor 
where salariofixo >= '1800'
and codvendedor in(
select codvendedor
from pedido
where year(datapedido) = '2014' 
and month(datapedido) = '12'
and codcliente in(
select codcliente
from cliente
where UF = 'SC' or uf = 'RS'
)
);


#4
SELECT ved.nome AS Vendedor,
temp.total
FROM vendedor ved
inner join(
select ped.codvendedor,
count(ped.codvendedor) as total
from pedido ped
where year(ped.datapedido) = '2015'
GROUP BY ped.codvendedor
) temp
on ved.codvendedor = temp.codvendedor
ORDER BY total desc;

#5
SELECT
v.nome,
round(coalesce(SUM(((temp.quantidade * temp.valorunitario)*0.10)) , 0), 2) AS total
FROM vendedor v
LEFT JOIN (SELECT p.codpedido,
p.codvendedor,
ip.codproduto,
ip.quantidade,
prod.valorunitario
FROM pedido p
INNER JOIN itempedido ip
ON p.codpedido = ip.codpedido
INNER JOIN produto prod
ON ip.codproduto = prod.codproduto) temp
ON temp.codvendedor = v.codvendedor
group by v.nome
order by total;

#6
SELECT
c.nome,
round(coalesce(SUM((temp.quantidade * temp.valorunitario)) , 0), 2) AS total
FROM cliente c
left JOIN (SELECT
		   p.codpedido,
		   p.codcliente,
		   p.datapedido,
	       ip.codproduto,
           ip.quantidade,
           prod.valorunitario
           FROM pedido p
           inner JOIN itempedido ip
           ON p.codpedido = ip.codpedido
           inner JOIN produto prod
           ON ip.codproduto = prod.codproduto
           AND Year(p.datapedido) = '2015') temp
ON temp.codcliente = c.codcliente
WHERE ( c.uf = 'RS' or c.uf = 'SC' )
group by c.nome
order by c.codcliente, total desc, c.nome;

#7
SELECT
v.nome,
round(coalesce(SUM((temp.quantidade * temp.valorunitario)) , 0), 2) AS total
FROM vendedor v
LEFT JOIN (SELECT p.codpedido,
p.codvendedor,
ip.codproduto,
ip.quantidade,
prod.valorunitario
FROM pedido p
INNER JOIN itempedido ip
ON p.codpedido = ip.codpedido
INNER JOIN produto prod
ON ip.codproduto = prod.codproduto
AND Year(p.datapedido) = '2014') temp
ON temp.codvendedor = v.codvendedor
group by v.nome
order by total;
 
#8
SELECT p.codproduto,
p.descricao,
coalesce (SUM(temp.quantidade) , 0) AS total
FROM produto p
inner JOIN ( SELECT
ip.codproduto,
ip.quantidade
FROM itempedido ip
inner JOIN pedido pe
ON ip.codproduto = pe.codpedido
where pe.datapedido between '2014-08-12' and '2014-10-27' ) temp
ON temp.codproduto = p.codproduto
group by p.codproduto
order by total desc;

#9
select pr.codProduto,
	pr.descricao, 
    sum(tab.quantidade) as total 
    from produto pr
    inner join ( 
    select ip.CodProduto, ip.quantidade from itemPedido ip
			 inner join (select p.codPedido from pedido p
						 where p.dataPedido between '2014-08-12' and '2014-10-27') tab2
             on tab2.CodPedido = ip.CodPedido
             ) tab
on pr.codProduto = tab.codProduto
group by pr.codProduto
ORDER BY total DESC;
                                                        

#10
SELECT  temp_geral.nome, temp_geral.total_2014, temp_geral.total_2015, 
(temp_geral.total_2015-temp_geral.total_2014) AS Saldo
FROM
(select c.nome, 
round(coalesce(temp_2014.total_2014,0),2) AS total_2014, 
round(coalesce(temp_2015.total_2015,0),2)  AS total_2015
from cliente c
left join
(SELECT p.codcliente,
       SUM(temp.total) AS total_2014
        FROM pedido p
        INNER JOIN 
        ( select ip.codpedido,
                 SUM(quantidade*valorunitario) AS Total
			from itempedido ip
            INNER JOIN produto Pr
            ON pr.codproduto = ip.codproduto 
            GROUP BY ip.codpedido ) temp
            ON p.codpedido = temp.codpedido 
            WHERE year(p.datapedido) = 2014
            GROUP BY p.codcliente) temp_2014 
            ON c.codcliente = temp_2014.codcliente
            left join
            (SELECT p.codcliente,
        SUM(temp.total) AS total_2015
        FROM pedido p
        INNER JOIN 
        ( select ip.codpedido,
                 SUM(quantidade*valorunitario) AS Total
			from itempedido ip
            INNER JOIN produto Pr
            ON pr.codproduto = ip.codproduto 
            GROUP BY ip.codpedido ) temp
            ON p.codpedido = temp.codpedido 
            WHERE year(p.datapedido) = 2015
            GROUP BY p.codcliente) temp_2015
            ON c.codcliente = temp_2015.codcliente) temp_geral
            ORDER BY saldo DESC;
 

