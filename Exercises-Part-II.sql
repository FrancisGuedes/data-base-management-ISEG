Q1.
/*
Para cada Cliente (CompanyName), listar os diferentes Endereços identificando o Tipo de
Endereço
*/

select cst.customerid, companyname, addresstype, addressline1, city, postalcode
from customer cst
join customer_address csta
on cst.customerid = csta.customerid
join address a
on csta.addressid = a.addressid

Q2.
/*
Para cada Produto listar o seu nº e a sua designação, bem como a designação e descrição do
respetivo modelo
*/

select productnumber, p.name, pmpd.PRODUCTDESCRIPTIONID, DESCRIPTION
from product p
join product_model pm
on p.productmodelid = pm.productmodelid
join PRODUCT_MODEL_PRODUCT_DESCRIPTION pmpd
on pmpd.productmodelid = pm.productmodelid
join PRODUCT_DESCRIPTION pd
on pmpd.productdescriptionid = pd.productdescriptionid

Q3.
/*
Listar todas as identificações e designações de Categorias de Produto, juntamente com as
identificações e designações das Categorias de Nível Superior, ordenadas por identificação de
Categoria de Nível Superior
*/

select filho.productcategoryid, filho.name, pai.parentproductcategoryid, pai.name
from product_category filho
join product_category pai
on filho.parentproductcategoryid = pai.productcategoryid
order by filho.parentproductcategoryid desc

Q4.
/*
Listar os números das encomendas sem linhas associadas
*/

select *
from customer cst
left join SALES_ORDER_HEADER sh
on cst.customerid = sh.customerid
where sh.salesorderid IS NULL

Q5.
/*
Para o Produto com ProductNumber = ‘BK-M82B-48’ selecione os restantes Produtos da mesma
Categoria
*/

select productnumber
from product
where productcategoryid = (
    select productcategoryid 
    from product
    where productnumber = 'BK-M82B-48'
    )

Q6.
/*
Listar o ProductID, o ProductNumber e o Name dos Produtos sem encomendas associadas.
*/

select ProductID, ProductNumber, name
from product cst
where not exists (
    select *
    from sales_order_detail sh
    where cst.productid = sh.productid
)

Q7.
/*
Listar o CustomerID e CompanyName dos Clientes (Customers) que têm instalações na mesma
cidade que o Cliente com CustomerName= Authentic Sales and Service
*/

select cst.customerid, cst.CompanyName
from Customer cst
inner join customer_address ca on cst.customerid = ca.customerid
inner join address a on a.addressid = ca.addressid
where a.city = (
    select a.city
    from customer cst
    join customer_address ca
    on cst.customerID = ca.customerID
    join address a
    on ca.addressID = a.addressID
    where cst.companyname = 'Authentic Sales and Service'
)

Q8.
/*
Liste o código das categorias, o código dos produtos e o somatório de vendas por código de
categoria, código de produto
*/
select p.productcategoryid, p.productid, sum(linetotal)
from product p
join sales_order_detail sd
on p.productid = sd.productid
group by p.productcategoryid, p.productid

Q9.
/*
Liste o código das modelo, o código dos produtos e o somatório de vendas por: código de
modelo, código de produto, (código de modelo, código de produto) e total geral, ordenados
por código de modelo, código de produto
*/

select p.productmodelid, p.productid, sum(linetotal)
from product p
join sales_order_detail sd
on p.productid = sd.productid
group by cube (p.productmodelid, p.productid) 
order by p.productmodelid, p.productid

Q10.
/*
Para cada modelo de produto liste o ranking das vendas de cada produto ordenado por ordem
descendente de vendas.
*/

select p.productmodelid, p.productid, sum(linetotal), 
rank () over (partition by productmodelid  order by sum(linetotal) desc ) as rank
from product p
join sales_order_detail sd
on p.productid = sd.productid
group by p.productmodelid, p.productid

Q11.
/*
Para cada nome de Categoria de Produtos liste o máximo do preço de venda dos produtos que a
compõem.
*/

select pc.name, max(unitprice)
from product_category pc
join product p
on pc.productcategoryid = p.productcategoryid
join sales_order_detail sd
on p.productid = sd.productid
group by pc.name

Q12.
/*
Liste o(s) produto(s) com o máximo preço unitário de venda (listprice), bem como esse preço.
*/

select name, max(listprice)
from product 
group by name
having max(listprice) = (
    select max(listprice)
    from product
)

------------------------------

select name, listprice
from product
where listprice = (
    select max(listprice)
    from product
)

Q13.
/*
Identifique o ProductNumber do produto com a máxima média de preço unitário de venda
(unitprice), bem como essa média.
*/

select productnumber, avg(unitprice)
from product p
join sales_order_detail sd
on p.productid = sd.productid
group by p.productnumber
having avg(unitprice) = (
    select max(avg(unitprice))
    from sales_order_detail sd
    group by productid
)

Q14.
/*
Liste o cliente (CustomerID, companyName) que colocou uma encomenda com o valor máximo
entre todas as encomendas. Liste também o salesorderid e o valor dessa encomenda.
*/

select c.customerid, c.companyname, sh.salesorderid, sh.totaldue 
from customer c
join sales_order_header sh
on c.customerid = sh.customerid
where totaldue = (
    select max(totaldue)
    from sales_order_header
)

---------------------------------------

select sh.salesorderid, sh.totaldue, c.customerid, c.companyname
from customer c, sales_order_header sh, 
(select max(totaldue) max from sales_order_header ) tmax
where sh.totaldue = tmax.max and c.customerid = sh.customerid 

Q15.
/*
Crie uma tabela CustomerWOrders com os atributos CustomerID, CompanyName dos clientes
sem nenhuma encomenda associada
*/
         
create table CustomerWOrders
as select customerid, CompanyName
from customer cst
left join SALES_ORDER_HEADER sh
on cst.customerid = sh.customerid
where sh.salesorderid IS NULL

Q16.
/*Crie as seguintes tabelas
a. PG (idPG, nome)
b. EdicaoPG (idPG, edicao, dataInicio (YYYY-MM-DD), dataFim)
Pretende-se que caso a PG seja anulada, também o sejam as suas edições
Altere a tabela EdicaoPG adicionando um atributo MediaDaPG e uma constraint data
Fim>dataInicio
*/
               
a.
create table PG
(
    idPG integer primary key,
    nome varchar2 (30) not null
)

create table EdicaoPG
(
    idPG references PG(idPG) on delete cascade,
    edicao varchar2(30) primary key,
    dataInicio date,
    dataFim date
)
-- não está completo               
b.             
alter table EdicaoPG add  MediaDaPG number (4,2);

alter table EdicaoPG add constraint datas check (dataFim>dataInicio);     
               
Q19.
/*
Crie as seguintes tabelas:
Cliente (idcliente, nome)
Fatura (idfatura, idcliente, total)
LinhaFatura (idfatura, idproduto, quantidade)
Pretende-se que caso o cliente seja apagado, também o sejam as suas faturas e respetivas linhas.

Insira duas linhas em cada uma das tabelas e depois apague um cliente com faturas e veja o que
acontece.
*/
               
create table Cliente
(
    idcliente integer primary key,
    nome char (20)
)

insert into Cliente values (1, 'Antonio')
insert into Cliente values (2, 'Joao')

create table Fatura
(
    idfatura integer primary key,
    idcliente references cliente(idcliente) on delete cascade,
    nomefatura varchar2 (30)
)

insert into Fatura values (1, 1, 'lalala')
insert into Fatura values (2, 2, 'lelele')

create table LinhaFatura 
(
    idfatura references fatura(idfatura) on delete cascade,
    idproduto integer primary key,
    quantidade integer
)

insert into LinhaFatura values (1, 1, 5)
insert into LinhaFatura values (2, 2, 10)

delete from Cliente where nome = 'Joao'
