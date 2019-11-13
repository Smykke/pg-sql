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
