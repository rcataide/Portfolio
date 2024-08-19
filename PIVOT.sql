-- Funcao utilizada para transformar linhas em colunas, ou seja, realizar um crosstab diretamente no resultado do select
select * from (
   select nm_usuario_exec
   from ordem_servico o
   where o.dt_ordem_servico between
   to_date('02/06/2014 00:00:00', 'dd/mm/yyyy hh24:mi:ss') and
   to_date('02/06/2014 23:59:59', 'dd/mm/yyyy hh24:mi:ss')
)
pivot 
(
   count(nm_usuario_exec)
   for nm_usuario_exec in ('user1'as Danilo,'user2' as Cristiano,'user3'as Raquel,'user4'as Guilherme)
)
