--1 Criar uma tabela para guardar todas as alteração 
-- de salário sofridas por um funcionário. Em seguida
-- crie triggers para guardar nesta tabela informações
-- sobre essas alteraçõe (id, cpf, salario anterior, data e hora)

CREATE TABLE LOG_ALTERACAO_SAL
(
	LOG_ID INT IDENTITY(1,1) PRIMARY KEY,
	CPF CHAR(11),
	SALARIO_ANTERIOR DECIMAL(10, 2),
	DATA_HORA DATETIME DEFAULT GETDATE()
);
GO

CREATE OR ALTER TRIGGER TRG_AFTER_UPDATE_SAL
ON FUNCIONARIO
AFTER UPDATE
AS
BEGIN
	-- VERIFICA SE O COMANDO ENVOLVEU A COLUNA SALARIO
	IF UPDATE(SALARIO)
	BEGIN
		
	END
END