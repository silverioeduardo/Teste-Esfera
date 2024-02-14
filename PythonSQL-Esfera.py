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
