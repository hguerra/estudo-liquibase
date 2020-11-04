# Referências

### Teorico sobre o liquibase
https://www.youtube.com/watch?v=U9nVo9MS12o&feature=emb_title
https://www.youtube.com/watch?v=22TeQ8XWOlU


### Introducao ao liquibase em portugues
https://medium.com/responsive-br/versionando-o-banco-de-dados-com-liquibase-bfbf0b81d02f
https://medium.com/responsive-br/aprofundando-um-pouco-mais-no-liquibase-a61d509344f8
https://fernandogodoy.wordpress.com/2019/02/21/conhecendo-o-liquibase/


### Configurando liquibase postgres
https://www.liquibase.org/blog/using-liquibase-azure-postgres


### Introducao ao liquibas em ingles
https://medium.com/podiihq/getting-started-with-liquibase-8965897092aa
https://www.smaato.com/blog/how-to-execute-database-migrations-with-liquibase/
https://stackoverflow.com/questions/11131978/how-to-tag-a-changeset-in-liquibase-to-rollback
https://www.baeldung.com/liquibase-refactor-schema-of-java-app
https://www.baeldung.com/liquibase-rollback
https://stackoverflow.com/questions/34054638/can-liquibase-ignore-checksums-for-a-single-changeset


### Liquibase SQL
https://www.liquibase.org/blog/plain-sql
https://docs.liquibase.com/concepts/basic/sql-format.html
https://www.turtle-techies.com/how-to-write-xml-changesets-in-liquibase/


### Configurar Liquibase em um projeto existente
https://docs.liquibase.com/workflows/liquibase-community/existing-project.html


### Pre condicoes para executar uma migracao
https://docs.liquibase.com/concepts/advanced/preconditions.html
https://mohitgoyal.co/2019/03/26/check-database-state-and-conditionally-apply-changes-in-the-liquibase/
https://www.liquibase.org/blog/dealing-with-changing-changesets


### Comandos comuns
https://docs.liquibase.com/tools-integrations/cli/home.html
https://docs.liquibase.com/commands/community/home.html
https://xenovation.com/blog/development/java/java-professional-developer/managing-databases-with-liquibase


### Configurar projeto com Maven
https://docs.liquibase.com/tools-integrations/maven/workflows/creating-liquibase-projects-with-maven-postgresql.html



# Testes Práticos

### H2
```sh
export PATH=$PATH:/home/heitor/dev/liquibase/liquibase
liquibase --version
cd xml ou sql
liquibase update
```


### Gerar migration de um banco de dados
```sh
liquibase --changeLogFile=dbchangelog.xml generateChangeLog
```


### PostgreSQL
```sh
export PATH=$PATH:/home/heitor/dev/liquibase/liquibase
liquibase --version
```


### Status das migracoes. Quantas migracoes ainda nao foram aplicadas.
```sh
liquibase status
```


### Executar migracoes
```sh
liquibase update
```


### Criar SQL das migracoes sem executar
```sh
liquibase updateSQL > script.sql
```


### Criar uma tabela no postgres e gerar a diferenca com liquibase
```sql
CREATE TABLE fruits(
   id SERIAL PRIMARY KEY,
   name VARCHAR NOT NULL
)
```

```sh
liquibase --changeLogFile=changelog/000.changelog.xml generateChangeLog
./mvnw liquibase:generateChangeLog -Dliquibase.outputChangeLogFile=000.changelog.xml
```


### Adicionar uma precondition para nao executar o changelog
```xml
<preConditions onFail="MARK_RAN">
  <not>
    <tableExists tableName="fruits"/>
  </not>
</preConditions>
```


Ou marcar todos os changelogs como executados
```sh
liquibase changeLogSync
```


### Exportar dados do liquibase
```sh
liquibase --changeLogFile=data/dados.sql --diffTypes="data" generateChangeLog
```


### Gerar script de rollback em sql
```sh
liquibase rollbackCountSQL 2
liquibase rollbackToDateSQL 2020-11-01
liquibase rollbackSQL version_002
```

```sh
./mvnw liquibase:rollback -Dliquibase.rollbackCount=2
./mvnw liquibase:rollback -Dliquibase.rollbackDate=Jun 03, 2017
./mvnw liquibase:rollback -Dliquibase.rollbackTag=version_002
```


### Gerar uma tag para a ultima migration executada
```sh
liquibase tag version_003
```


### Verificar diff entre dois bancos (referenceUrl)
```sh
liquibase diff
liquibase --outputFile=mydiff.txt diff
```

```sh
./mvnw liquibase:diff
./mvnw liquibase:diff -Dliquibase.outputFile=mydiff.txt
```


### Gerar XML da diferenca
```sh
liquibase --changeLogFile=hmg.xml diffChangeLog
```


### Criar documentacao do banco de dados
```sh
liquibase dbdoc doc/dbdoc
```


### Liquibase Spatial http://lonnyj.github.io/liquibase-spatial/index.html
Fazer download do jar e colocar em liquibase/lib

```sh
liquibase status
liquibase updateSQL
liquibase update
```


# Templates
https://xenovation.com/blog/development/java/java-professional-developer/managing-databases-with-liquibase
https://gist.github.com/wilmoore/812253/45413ee9e97b5d5cfd8174efd08df7b7da788957


# Gerenciando Privilegios no PostgreSQL

https://tableplus.com/blog/2018/04/postgresql-how-to-grant-access-to-users.html
https://medium.com/coding-blocks/creating-user-database-and-adding-access-on-postgresql-8bfcd2f4a91e
https://www.postgresqltutorial.com/postgresql-roles/

```sh
sudo -u postgres psql
postgres=# create database mydb;
postgres=# create user myuser with encrypted password 'mypass';
postgres=# grant all privileges on database mydb to myuser;
```


```sql
CREATE DATABASE yourdbname;
CREATE USER youruser WITH ENCRYPTED PASSWORD 'yourpass';
GRANT ALL PRIVILEGES ON DATABASE yourdbname TO youruser;
```


# Restricted PostgreSQL permissions for web app
https://stackoverflow.com/questions/41537825/restricted-postgresql-permissions-for-web-app;

```sql
/* create the database */
\c postgres postgres
CREATE DATABASE test_database WITH OWNER app_admin;
\c test_database postgres

/* drop public schema; other, less invasive option is to
   REVOKE ALL ON SCHEMA public FROM PUBLIC */
DROP SCHEMA public;
/* create an application schema */
CREATE SCHEMA app AUTHORIZATION app_admin;
/* further operations won't need superuser access */
\c test_database app_admin
/* allow app_user to access, but not create objects in the schema */
GRANT USAGE ON SCHEMA app TO app_user;

/* PUBLIC should not be allowed to execute functions created by app_admin */
ALTER DEFAULT PRIVILEGES FOR ROLE app_admin
   REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;

/* assuming that app_user should be allowed to do anything
   with data in all tables in that schema, allow access for all
   objects that app_admin will create there */
ALTER DEFAULT PRIVILEGES FOR ROLE app_admin IN SCHEMA app
   GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_user;
ALTER DEFAULT PRIVILEGES FOR ROLE app_admin IN SCHEMA app
   GRANT SELECT, USAGE ON SEQUENCES TO app_user;
ALTER DEFAULT PRIVILEGES FOR ROLE app_admin IN SCHEMA app
   GRANT EXECUTE ON FUNCTIONS TO app_user;
```
