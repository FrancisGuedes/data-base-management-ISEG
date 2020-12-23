Pós Graduação em Digital Technologies For Management
        1ª Edição - Ano Letivo 2020/2021
        UC de Database Management

Projecto Final

Imagine um website de avaliação de filmes, ondem os críticos inserem as suas classificações. O
website ainda não contém muitos dados, mas já permite efetuar algumas consultas interessantes. O
esquema é o seguinte:

Filme ( fID, titulo, ano, realizador )
Cada filme é identificado por um número fID, um título, ano de produção e realizador.

Critico ( cID, nome )
Cada crítico é identificado por um número cID e pelo seu nome.

Classificacao ( cID, fID, estrelas, dataClassificacao )
Cada classificação é caraterizada pelo nº do crítico, nº do filme, nº de estrelas atribuídas (1-5) e data
da classificação.

Perguntas:
1. Listar os títulos de todos os filmes dirigidos por Steven Spielberg.
select * from filme
where realizador = 'Steven Spielberg'

2. Listar todos os anos em que foi produzido um filme que recebeu uma classificação de 4 ou 5, e
ordene-os por ordem crescente.
select distinct ano
from filme f, classificacao c
where f.fid = c.fid and estrelas between 4 and 5
order by ano asc

3. Listar os títulos de todos os filmes que não têm nenhuma classificação.
select distinct titulo
from filme 
where fid not in (
    select fid from classificacao
    )

4. Alguns críticos não inseriram a data correspondente à sua classificação. Listar os nomes de todos
os críticos que têm classificações em que a correspondente data é NULL.
select distinct nome 
from critico c, classificacao cl
where dataclassificacao is null

5. Escrever uma query que apresenta as classificações no seguinte formato: nome do crítico, título
do filme, nº de estrelas e data da classificação. Ordene o resultado por esta ordem: nome do
crítico, título do filme, nº de estrelas.
select distinct cr.nome nomedocritico, titulo titulodofilme, estrelas nºestrelas, dataclassificacao datadaclassificação
from critico cr, classificacao cl, filme f
where cr.cid = cl.cid and cl.fid = f.fid
order by nomedocritico, titulodofilme, nºestrelas

6. Em todos os casos em que o mesmo crítico classificou o mesmo filme duas vezes, sendo a 2ª
classificação superior à 1ª, listar o nome do crítico e o título do filme.
select distinct cr.nome, f.titulo, cla.estrelas
from critico cr
join classificacao cl on cr.cid = cl.cid
join classificacao cla on cl.cid = cla.cid
join filme f on cl.fid = f.fid 
where cl.dataclassificacao < cla.dataclassificacao and cl.estrelas < cla.estrelas and cl.fid = cla.fid

7. Para cada filme com pelo menos uma classificação, pesquisar a classificação máxima que lhe foi
atribuída. Listar o título do filme e a classificação máxima, ordenando por título do filme.
select titulo, max(estrelas) as classificaçãomáxima
from filme f
join classificacao cla on f.fid = cla.fid
group by titulo
order by titulo

8. Listar os títulos dos filmes e as médias das classificações por ordem decrescente destas últimas.
Listar por ordem alfabética os filmes com as mesmas médias.
select titulo, cast(avg(estrelas) as decimal(10,1)) as médiaclassificação
from filme f
join classificacao cl on f.fid = cl.fid
group by titulo
order by titulo, médiaclassificação desc
-- coloquei a média com uma casa decimal
                                             
9. Listar os nomes de todos os críticos que contribuíram com 3 ou mais classificações.
select distinct nome
from critico cr
join classificacao cl on cr.cid = cl.cid
group by nome
having count (*) >= 3

10. Adicione à base de dados o crítico Diogo Silva, com um cID=209.
insert into critico values (209, 'Diogo Silva')

11. Para cada filme, listar o seu título e a diferença entre a classificação mais alta e mais baixa que
lhe foram atribuídas. Ordenar por ordem descendente da diferença de classificações e depois
pelo título do filme.
select titulo, (max(estrelas)-min(estrelas)) as diferençaclassificações
from filme f, classificacao cl
where f.fid = cl.fid
group by titulo
order by diferençaclassificações desc, titulo

12. Listar a diferença entre as médias das classificações dos filmes produzidos antes de 1980 e no
ano de 1980 e seguintes. Deve ser calculada a média da classificação para cada filme e depois
calculada a média das médias para os filmes anteriores a 1980 e os produzidos nos anos de 1980
e seguintes.

13. Para todos os realizadores de mais de um filme, listar o seu nome e os títulos dos filmes que
realizaram, ordenados por nome do realizador, título do filme.
select f.realizador, f.titulo
from filme f
join filme fl on f.realizador = fl.realizador 
group by f.titulo, f.realizador
having count (f.titulo) > 1
order by f.realizador, f.titulo

14. Listar o(s) título(s) do(s)filme(s) com a maior média de classificações, bem como essa média.

15. Para cada par filme, crítico (título do filme e nome do crítico) liste o nº de classificações (um
filme pode ser avaliado mais do que uma vez por um crítico, em datas diferentes). Listar também
o nº de classificações por filme e por crítico, bem como o nº total de classificações.

16. Apresente o ranking dos filmes por ordem descendente de média de classificação.

17. Para cada realizador, apresente o ranking dos seus filmes por ordem descendente de média de
classificação.
