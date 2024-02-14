create database Esfera
go
use Esfera

create table Despesa (
	--id int identity(1,1) primary key,
	Fonte_de_Recursos varchar (300),
	Tipo_Despesa varchar (300),
	Liquidado float);

create table Receita (
	--id int identity (1,1) primary key,
	Fonte_de_Recursos varchar (300),
	Tipo_Receita varchar (300),
	Arrecadado float)

--DROP TABLE DESPESA
--DROP TABLE RECEITA



	

