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

