/* 1:
SELECT sub.CodPedido, sub.PrazoEntrega, sub.Nome 
FROM ( 
	SELECT 
    p.*, 
    v.Nome, v.SalarioFixo, v.FaixaComissao 
    FROM pedido p LEFT JOIN vendedor v 
    ON p.CodVendedor = v.CodVendedor 
) sub;
*/

/* 2:
SELECT sub.CodPedido, sub.DataPedido, sub.Nome 
FROM ( 
	SELECT 
    p.*, 
    c.Nome, c.Endereco, c.Cidade, c.Cep, c.Uf, c.Ie 
    FROM pedido p LEFT JOIN cliente c 
    ON p.CodCliente = c.CodCliente 
) sub 
ORDER BY sub.DataPedido;
*/

/* 3:
SELECT sub.Uf, count(sub.CodPedido) AS TotalPedidosEstado 
FROM ( 
	SELECT 
    p.*, 
    c.Nome AS Nome_Cliente, c.Endereco, c.Cidade, c.Cep, c.Uf, c.Ie, 
	v.Nome AS Nome_Vendedor, v.SalarioFixo, v.FaixaComissao 
    FROM pedido p LEFT JOIN cliente c 
    ON p.CodCliente = c.CodCliente 
    LEFT JOIN vendedor v 
    ON p.CodVendedor = v.CodVendedor 
) sub 
GROUP BY sub.Uf 
ORDER BY TotalPedidosEstado DESC;
*/

/* 4:
SELECT sub.Nome_Vendedor, count(sub.CodPedido) AS Quantidade 
FROM ( 
	SELECT 
    p.*, 
    c.Nome AS Nome_Cliente, c.Endereco, c.Cidade, c.Cep, c.Uf, c.Ie, 
	v.Nome AS Nome_Vendedor, v.SalarioFixo, v.FaixaComissao 
    FROM pedido p LEFT JOIN cliente c 
    ON p.CodCliente = c.CodCliente 
    LEFT JOIN vendedor v 
    ON p.CodVendedor = v.CodVendedor 
) sub 
GROUP BY sub.Nome_Vendedor 
ORDER BY Quantidade DESC;
*/

/* 5:
SELECT sub.Nome_Cliente, count(sub.CodPedido) AS Ranking 
FROM ( 
	SELECT 
    p.*, 
    c.Nome AS Nome_Cliente, c.Endereco, c.Cidade, c.Cep, c.Uf, c.Ie, 
	v.Nome AS Nome_Vendedor, v.SalarioFixo, v.FaixaComissao 
    FROM pedido p LEFT JOIN cliente c 
    ON p.CodCliente = c.CodCliente 
    LEFT JOIN vendedor v 
    ON p.CodVendedor = v.CodVendedor 
) sub 
GROUP BY sub.CodCliente 
ORDER BY Ranking DESC;
*/

/* 6:
SELECT  sub.CodPedido, round(coalesce(sum(sub.Quantidade * sub.ValorUnitario), 0), 2) AS Total 
FROM ( 
   SELECT 
    p.*, 
    ip.CodItemPedido, ip.CodProduto, ip.Quantidade, 
    pr.Descricao, pr.ValorUnitario 
    FROM pedido p LEFT JOIN itempedido ip 
    ON p.CodPedido = ip.CodPedido 
    INNER JOIN produto pr 
    ON ip.CodProduto = pr.CodProduto 
) sub 
GROUP BY sub.CodPedido;
*/

/* 7:
SELECT v.CodVendedor, v.Nome, round(coalesce(v.SalarioFixo + sum((sub.Quantidade * sub.ValorUnitario) / 100 * 20), 0), 2) AS salario 
FROM vendedor v 
LEFT JOIN ( 
    SELECT 
    p.*, 
    ip.CodItemPedido, ip.CodProduto, ip.Quantidade, 
    pr.Descricao, pr.ValorUnitario 
    FROM pedido p LEFT JOIN itempedido ip 
    ON p.CodPedido = ip.CodPedido 
    INNER JOIN produto pr 
    ON ip.CodProduto = pr.CodProduto 
) sub 
ON v.CodVendedor = sub.CodVendedor 
WHERE v.FaixaComissao LIKE "A" AND month(sub.DataPedido)=4 AND year(sub.DataPedido)=2016 
GROUP BY v.CodVendedor 
ORDER BY v.CodVendedor;
*/

/* 8:
SELECT c.CodCliente, c.Nome, round(coalesce(sum(sub.ValorUnitario * sub.Quantidade), 0), 2) AS ValorGasto 
FROM cliente c 
INNER JOIN ( 
   SELECT 
    p.*, 
    ip.CodItemPedido, ip.CodProduto, ip.Quantidade, 
    pr.Descricao, pr.ValorUnitario 
    FROM pedido p LEFT JOIN itempedido ip 
    ON p.CodPedido = ip.CodPedido 
    INNER JOIN produto pr 
    ON ip.CodProduto = pr.CodProduto 
) sub 
WHERE c.CodCliente = sub.CodCliente AND year(sub.DataPedido)=2016 
GROUP BY c.CodCliente 
ORDER BY valorGasto DESC;
*/

/* 9:
SELECT sub.CodProduto, sub.Descricao, coalesce(sum(sub.Quantidade), 0) AS Total 
FROM ( 
	SELECT 
    p.*, 
    ip.CodItemPedido, ip.CodProduto, ip.Quantidade, 
    pr.Descricao, pr.ValorUnitario 
    FROM pedido p LEFT JOIN itempedido ip 
    ON p.CodPedido = ip.CodPedido 
    INNER JOIN produto pr 
    ON ip.CodProduto = pr.CodProduto 
) sub 
WHERE year(sub.DataPedido)=2015 
GROUP BY sub.CodProduto;
*/

/* 10:
SELECT v.CodVendedor, v.Nome, count(sub.Quantidade) AS Total 
FROM vendedor v 
INNER JOIN ( 
   SELECT 
    p.*, 
    ip.CodItemPedido, ip.CodProduto, ip.Quantidade, 
    pr.Descricao, pr.ValorUnitario 
    FROM pedido p LEFT JOIN itempedido ip 
    ON p.CodPedido = ip.CodPedido 
    INNER JOIN produto pr 
    ON ip.CodProduto = pr.CodProduto 
) sub 
ON v.CodVendedor  = sub.CodVendedor 
WHERE LEFT(sub.Descricao, 3) LIKE "PS4" 
GROUP BY v.CodVendedor 
ORDER BY v.CodVendedor;
*/

/* 11:
SELECT sub.CodPedido, sub.CodProduto, round(coalesce((sub.Quantidade * sub.ValorUnitario), 0), 2) AS total 
FROM (
	SELECT 
	p.*, 
    ip.CodItemPedido, ip.CodProduto, ip.Quantidade, 
    pr.Descricao, pr.ValorUnitario 
	FROM pedido p LEFT JOIN itempedido ip 
	ON p.CodPedido = ip.CodPedido 
	INNER JOIN produto pr 
	ON ip.CodProduto = pr.CodProduto 
) sub 
GROUP BY sub.CodPedido, sub.CodProduto 
ORDER BY sub.CodPedido, sub.CodProduto;
*/

/* 12:
SELECT year(sub.DataPedido) AS Ano, c.CodCliente, c.Nome, round(coalesce(sum(sub.Quantidade * sub.ValorUnitario), 0), 2) AS ValorTotal 
FROM cliente c 
INNER JOIN ( 
	SELECT 
	p.*, 
    ip.CodItemPedido, ip.CodProduto, ip.Quantidade, 
    pr.Descricao, pr.ValorUnitario 
	FROM pedido p LEFT JOIN itempedido ip 
	ON p.CodPedido = ip.CodPedido 
	INNER JOIN produto pr 
	ON ip.CodProduto = pr.CodProduto 
) sub 
ON c.CodCliente = sub.CodCliente 
GROUP BY year(sub.DataPedido), c.CodCliente 
ORDER BY year(sub.DataPedido), sub.CodCliente;
*/

/* 13:
SELECT year(sub.DataPedido) AS Ano, v.CodVendedor, v.Nome, round(coalesce(sum(sub.Quantidade * sub.ValorUnitario), 0), 2) AS ValorTotal 
FROM vendedor v 
INNER JOIN ( 
	SELECT 
	p.*, 
    ip.CodItemPedido, ip.CodProduto, ip.Quantidade, 
    pr.Descricao, pr.ValorUnitario 
	FROM pedido p INNER JOIN itempedido ip 
	ON p.CodPedido = ip.CodPedido 
	INNER JOIN produto pr 
	ON ip.CodProduto = pr.CodProduto 
) sub 
ON v.CodVendedor = sub.CodVendedor 
GROUP BY year(sub.DataPedido), v.Nome 
ORDER BY year(sub.DataPedido), sub.CodVendedor;
*/