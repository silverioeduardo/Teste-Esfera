# Teste Análise de Dados - Esfera
Esse teste é para o time de engenharia de dados do Esfera

Irei descrever detalhadamente o que foi feito e como utilizar, mas caso tenha dúvidas, pode acessar a página: Passo a Passo - Teste Engenheira de Dados.docx


### 1) Criação do banco de dados e das tabelas
Realizei a criação do banco de dados e das tabelas Despesa e Receita através do código abaixo:

```
create database Esfera
go
use Esfera
create table Despesa (
    Fonte_de_Recursos varchar (300),
    Tipo_Despesa varchar (300),
    Liquidado varchar (50)
);
create table Receita (
    Fonte_de_Recursos varchar (300),
    Tipo_Receita varchar (300),
    Arrecadado varchar (50)
)
```

### 2) Tratamento dos dados
Realizei os tratamentos dos dados da seguine forma:
  - Remoção das aspas;
  - Remoção de espaços duplicados;
  - Remoção da coluna "TOTAL";
  - Alterei os separadores de coluna de vírgula para ponto e vírgula;
  - Corrigi o layout do arquivo, pois a separação de colunas estava por vírgula, porém existia textos utilizando vírgula, o que causava quebra do arquivo;
  - Importei o arquivo no SQL com a coluna valor sendo uma string, precisei tratar a string e convertê-la para float, comado utilizado:
      ```
      ALTER TABLE DESPESA ADD VLR_LIQUIDADO FLOAT
      GO
      UPDATE DESPESA SET VLR_LIQUIDADO = CAST(REPLACE(REPLACE(REPLACE(liquidado, '.', ''), ' ', ''), ',', '.') AS FLOAT)
      ```
    Obs: Incluí a coluna VLR_LIQUIDADO e passei as informações da coluna Liquidado para VLR_LIQUIDADO substituindo '.' por '', " " por '', e ',' por '.'

Realizei a mesma operação para RECEITA.

Dropei (Excluí) a coluna arrecadado e liquidado e depois alterei o nome das colunas “DESPESA.VLR_LIQUIDADO”, para LIQUIDADO e “RECEITA.VLR_ARRECADADO” para ARRECADADO.

Segue o comado abaixo:
  ```
  alter table despesa drop column liquidado
sp_rename 'DESPESA.VLR_LIQUIDADO', 'Liquidado', 'COLUMN'
  ```

- Extrai os selects abaixo, removi os "tabs" e substitui as vírgulas por ponto para conseguir importar o arquivo com o campo de valor com tipo de dado float:
  ```
  SELECT FONTE_DE_RECURSOS, ';', TIPO_DESPESA, ';', LIQUIDADO FROM DESPESA
  SELECT FONTE_DE_RECURSOS, ';', TIPO_receita, ';', arrecadado FROM RECEITA
  ```
- Alterei o tipo de dado da coluna liquidado e arrecadado de varchar para float, comado abaixo:
  ```
  DROP TABLE DESPESA
  DROP TABLE RECEITA

  create table Despesa (
	Fonte_de_Recursos varchar (300),
	Tipo_Despesa varchar (300),
	Liquidado float);

  create table Receita (
	Fonte_de_Recursos varchar (300),
	Tipo_Receita varchar (300),
	Arrecadado float)
  ```
- importei novamente o arquivo no SQL:

  Scrip de Importação:
  ```
  BULK INSERT DESPESA FROM 'C:\Users\Usuario\PythonSQL\EsferaTeste1\gdvDespesasExcel.csv'
  WITH 
      ( FIRSTROW=2 -- Define a partir de qual linha que o sql irá importar
      , FIELDTERMINATOR = ';' -- separador das colunas
      , ROWTERMINATOR = '\n') -- separador das linhas, /n representa a quebra de linha (a linha acaba quando pula a linha)
  ```
### 3) Criação da Procedure
Criei uma PROC para rodar no Python e executa a operação de importação, segue o comado:
  ```
CREATE OR ALTER PROC SP_ESFERATESTE1
AS
BULK INSERT DESPESA FROM 'C:/Users/Usuario/PythonSQL/EsferaTeste1/gdvDespesasExcel.csv'
WITH 
      ( FIRSTROW=2
      , FIELDTERMINATOR = ';'
      , ROWTERMINATOR = '\n')


BULK INSERT Receita FROM 'C:/Users/Usuario/PythonSQL/EsferaTeste1/gdvReceitasExcel.csv'
WITH 
      ( FIRSTROW=2
      , FIELDTERMINATOR = ';'
      , ROWTERMINATOR = '\n')
  ```

### 4) Entregáveis: Tabela Final
Segue os comados abaixo para acessar as informações solicitadas:

  ```
  -- Soma da Receita e Despesa agrupados pela fonte de recursos.
SELECT R.FONTE_DE_RECURSOS, SUM(ARRECADADO) AS RECEITA, SUM(LIQUIDADO) AS DESPESA FROM RECEITA AS R
INNER JOIN DESPESA AS D ON R.FONTE_DE_RECURSOS = D.FONTE_DE_RECURSOS 
GROUP BY R.FONTE_DE_RECURSOS

-- Soma da despesa agrupada pelo tipo da despesa da maior para a menor
SELECT TIPO_DESPESA, SUM(LIQUIDADO) AS DESPESA FROM DESPESA
GROUP BY TIPO_DESPESA
ORDER BY DESPESA DESC

-- 10 maiores fontes de receita
SELECT TOP 10 FONTE_DE_RECURSOS, SUM(ARRECADADO) AS RECEITA FROM RECEITA
GROUP BY FONTE_DE_RECURSOS
ORDER BY RECEITA DESC

-- 10 maiores fontes de despesa
SELECT TOP 10 FONTE_DE_RECURSOS, SUM(LIQUIDADO) AS DESPESA FROM DESPESA
GROUP BY FONTE_DE_RECURSOS
ORDER BY DESPESA DESC
```

### 5) Script Python
Obs: Antes de rodar o comado, necessário excluir as tabelas e criar novamente através do comado abaixo:
  ```
  DROP TABLE DESPESA
DROP TABLE RECEITA
	create table Despesa (
	Fonte_de_Recursos varchar (300),
	Tipo_Despesa varchar (300),
	Liquidado float);

create table Receita (
	Fonte_de_Recursos varchar (300),
	Tipo_Receita varchar (300),
	Arrecadado float)
  ```
O script abaixo conecta o Python com SQL através da biblioteca PYODBC
  ```
  import pyodbc

dados_conexao = (
    "Driver={SQL Server};"
    "Server=DESKTOP-RCO0BTU;"
    "Database=Esfera;"
)

conexao = pyodbc.connect(dados_conexao)
print("Conexão Bem Sucedida")

cursor = conexao.cursor()

comado = """
exec SP_ESFERATESTE1
"""

cursor.execute(comado)
cursor.commit()
  ```

### END


