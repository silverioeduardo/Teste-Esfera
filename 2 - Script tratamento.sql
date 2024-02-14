BULK INSERT DESPESA FROM 'C:\Users\Usuario\PythonSQL\EsferaTeste1\gdvDespesasExcel.csv'
WITH 
      ( FIRSTROW=2 -- Define a partir de qual linha que o sql irá importar
      , FIELDTERMINATOR = ';' -- separador das colunas
      , ROWTERMINATOR = '\n') -- separador das linhas, /n representa a quebra de linha (a linha acaba quando pula a linha)


BULK INSERT Receita FROM 'C:\Users\Usuario\PythonSQL\EsferaTeste1\gdvReceitasExcel.csv'
WITH 
      ( FIRSTROW=2
      , FIELDTERMINATOR = ';'
      , ROWTERMINATOR = '\n')

-- Incluíndo a coluna VLR_LIQUIDADO e passando as informações da coluna Liquidado p/ VLR_LIQUIDADO substituindo '.' por '', " " por '', e ',' por '.'
GO
ALTER TABLE DESPESA ADD VLR_LIQUIDADO FLOAT
GO
UPDATE DESPESA SET VLR_LIQUIDADO = CAST(REPLACE(REPLACE(REPLACE(liquidado, '.', ''), ' ', ''), ',', '.') AS FLOAT)

GO
ALTER TABLE RECEITA ADD VLR_ARRECADADO FLOAT
GO
UPDATE RECEITA SET VLR_ARRECADADO = CAST(REPLACE(REPLACE(REPLACE(Arrecadado, '.', ''), ' ', ''), ',', '.') AS FLOAT)

GO
alter table receita drop column arrecadado

GO
alter table despesa drop column liquidado

GO
sp_rename 'DESPESA.VLR_LIQUIDADO', 'Liquidado', 'COLUMN'
GO
sp_rename 'RECEITA.VLR_ARRECADADO', 'Arrecadado', 'COLUMN'

-- Extrai os selects abaixo, removi os "tabs" e substitui as vírgulas por ponto para conseguir importar o arquivo com o campo de valor com tipo de dado float.

SELECT FONTE_DE_RECURSOS, ';', TIPO_DESPESA, ';', LIQUIDADO FROM DESPESA
SELECT FONTE_DE_RECURSOS, ';', TIPO_receita, ';', arrecadado FROM RECEITA