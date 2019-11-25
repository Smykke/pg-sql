# pg-sql

## Instalar PostgreSQL
https://www.postgresql.org/download/

### psql
Para usar comandos de PostgreSQL no terminal, é necessário adicionar o `psql` no Path.

`C:\Program Files\PostgreSQL\12\lib`
e
`C:\Program Files\PostgreSQL\12\bin`

## Executar pelo terminal
`psql -U <user> -d <database> -c "<query>"`

ou

`psql -U <user> -d <database> -c "<query>" > output.txt`

Exemplo:
`psql -U postgres -d localsqltest -c "select compara('select * from picpaydb;', 'select * from picpaydb2;');"`

### Adicionar função/procedure pelo terminal
> https://pubs.vmware.com/datadirector/index.jsp?topic=%2Fcom.vmware.datadirector.vpostgres.doc%2Fpg_supp_Getting_Started.5.6.html

`psql -U <user> -d <database> -f <caminho para o arquivo>`

Exemplo:
`psql -U postgres -d localsqltest -f .\Documents\pg\verifySQLQuery.sql`


# Usar o PostgreSQL no Docker
Testes feitos com a versão *(PostgreSQL) 10.10 (Ubuntu 10.10-0ubuntu0.18.04.1)* instalada no container do boca.

```
-- O usuário `postgres` tem nível de acesso de administrador do banco de dados
docker exec -it myboca su - postgres
-- https://stackoverflow.com/questions/30641512/create-database-from-command-line
createuser testuser
createdb picpaydb
psql
postgres=# alter user testuser with encrypted password 'codenation';
> ALTER ROLE
postgres=# grant all privileges on database picpaydb to testuser;
-- Conecta com o banco de dados
postgres=# \c picpaydb
-- Lista os bancos criados
postgres=# \l
-- Cria uma tabela no banco
-- https://www.guru99.com/create-drop-table-postgresql.html
postgres=# create table picpay_challenge(
              id uuid NOT NULL, name character varying, username character varying, constraint picpay_challenge_pkey PRIMARY KEY(id)
            );
> CREATE TABLE
-- Lista as tabelas criadas
postgres=# \d
-- Insere um dado de teste
INSERT INTO picpay_challenge VALUES ('000003c9-1169-4c65-895a-20c17ed6c31b', 'Marcela Vieira', 'marcela.vieira');
SELECT * FROM picpay_challenge
```

## Executar comandos
Para salvar um arquivo `.sql` com o código de uma função, usar o usuário `root`:
```
docker exec -it myboca /bin/bash
touch verifysqlquery.sql
vi verifysqlquery.sql
```
Comandos de edição do Vim:
```
-- [ESC] + :i + [ENTER]
-- <escrever o código>
-- [ESC] + :x + [ENTER]
```
Para testar a função, logar no container com o usuário `postgres`:
```
-- Checar onde o usuário está. Geralmente, no diretório /var/bin
pwd
psql -U postgres -d picpaydb -f .\..\..\verifySQLQuery.sql
psql -U postgres -d picpaydb -c "select verifysqlquery('select * from picpay_challenge;', 'select id, name, username from picpay_challenge;');"
```
