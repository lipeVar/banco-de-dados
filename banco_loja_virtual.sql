-- Passo 1: Criar e selecionar o banco de dados
CREATE DATABASE IF NOT EXISTS loja_aula;
USE loja_aula;

-- Passo 2: Criar a tabela de categorias
CREATE TABLE categorias (
	id_categoria INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(100) NOT NULL
);

-- Passo 3: Criar a tabela de produtos
CREATE TABLE produtos (
	id_produto INT PRIMARY KEY AUTO_INCREMENT,
	nome VARCHAR(150) NOT NULL,
	preço DECIMAL(10,2) NOT NULL,
	id_categoria INT,
 FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- Passo 4: Criar a tabela de clientes
CREATE TABLE clientes (
 id_cliente INT PRIMARY KEY AUTO_INCREMENT,
 nome VARCHAR(100) NOT NULL,
 cidade VARCHAR(80)
);

-- Passo 5: Criar a tabela de pedidos
CREATE TABLE pedidos (
 id_pedido INT PRIMARY KEY AUTO_INCREMENT,
 id_cliente INT,
 data_pedido DATE NOT NULL,
 valor_total DECIMAL(10,2),
 FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Passo 6: Criar a tabela de itens do pedido
CREATE TABLE itens_pedido (
 id_item INT PRIMARY KEY AUTO_INCREMENT,
 id_pedido INT NOT NULL,
 id_produto INT NOT NULL,
 quantidade INT NOT NULL,
 preço_unit DECIMAL(10,2) NOT NULL,
 FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
 FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

-- Passo 7: Inserir dados de teste
INSERT INTO categorias (nome) VALUES
 ('Eletronicos'), ('Livros'), ('Roupas'), ('Informatica');
 
INSERT INTO produtos (nome, preço, id_categoria) VALUES
 ('Smartphone Samsung', 1500.00, 1),
 ('Fone de Ouvido', 250.00, 1),
 ('Notebook Dell', 4200.00, 4),
 ('Teclado Mecanico', 380.00, 4),
 ('Clean Code (livro)', 120.00, 2),
 ('Camiseta Polo', 89.90, 3),
 ('Produto Órfão', 50.00, NULL); -- sem categoria
 
INSERT INTO clientes (nome, cidade) VALUES
 ('Ana Silva', 'Porto Alegre'),
 ('Bruno Costa', 'Sao Paulo'),
 ('Carla Dias', 'Curitiba'),
 ('Daniel Lopes', 'Porto Alegre');
 
 INSERT INTO pedidos (id_cliente, data_pedido, valor_total) VALUES
 (1, '2024-01-10', 1750.00),
 (1, '2024-02-15', 380.00),
 (2, '2024-01-20', 4200.00),
 (3, '2024-03-05', 209.90);
 -- Daniel (id=4) não tem pedidos
 
 INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preço_unit) VALUES
 (1, 1, 1, 1500.00),
 (1, 2, 1, 250.00),
 (2, 4, 1, 380.00),
 (3, 3, 1, 4200.00),
 (4, 6, 1, 89.90),
 (4, 5, 1, 120.00);
 
 show tables;

-- Conecta produtos + categorias
SELECT P.NOME AS PRODUTO, C.NOME AS CATEGORIA
FROM PRODUTOS P
INNER JOIN CATEGORIAS C
ON P.ID_CATEGORIA = C.ID_CATEGORIA;

-- pega só clientes que realmente tem pedidos - organiza do mais recente -> mais antigo
SELECT C.NOME AS CLIENTE,
	P.DATA_PEDIDO,
	P.VALOR_TOTAL
FROM PEDIDOS P
INNER JOIN CLIENTES C
ON P.ID_CLIENTE = C.ID_CLIENTE
ORDER BY P.DATA_PEDIDO DESC;

-- conta quantos pedidos tem cada criente e ordena mostrando todos, mesmo os que n tem pedido
SELECT C.NOME AS CLIENTES,
	COUNT(P.ID_PEDIDO) AS NUMERO_PEDIDOS
FROM CLIENTEs C
LEFT JOIN PEDIDOS P
ON C.ID_CLIENTE = P.ID_CLIENTE
GROUP BY C.ID_CLIENTE, C.NOME;

-- junta tabela pedido, cliente e produto em uma tabela, msoma a qunatidade com preço_unit e mostra o total 
-- ordena a tebela pelo id do pedido(id_pedido) 
SELECT
	P.ID_PEDIDO AS NUMERO_PEDIDO,
	C.NOME AS CLIENTE,
	PR.NOME AS PRODUTO,
	IP.QUANTIDADE,
	IP.PREÇO_UNIT,
	(IP.QUANTIDADE * IP.PREÇO_UNIT) AS SUBTOTAL
FROM ITENS_PEDIDO IP
INNER JOIN PEDIDOS P
ON IP.ID_PEDIDO = P.ID_PEDIDO
INNER JOIN CLIENTES C
ON P.ID_CLIENTE = C.ID_CLIENTE
INNER JOIN PRODUTOS PR
ON IP.ID_PRODUTO = PR.ID_PRODUTO
ORDER BY P.ID_PEDIDO;

-- seleciona os prdutos e filtra apenas os que n foram vendidos e não tem valor em itens_pedido
SELECT PR.NOME
FROM PRODUTOS PR
LEFT JOIN ITENS_PEDIDO IP
ON PR.ID_PRODUTO = IP.ID_PRODUTO
WHERE IP.ID_PRODUTO IS NULL;

-- pega os produtos e junta em categorias e depois filtra para aparecer apenas as categorias com + ou = a 2 itens
SELECT C.NOME AS CATEGORIA,
COUNT(P.ID_PRODUTO) AS QUANTIDADE_PRODUTOS
FROM CATEGORIAS C
INNER JOIN PRODUTOS P
ON C.ID_CATEGORIA = P.ID_CATEGORIA
GROUP BY C.ID_CATEGORIA, C.NOME
HAVING COUNT(P.ID_PRODUTO) >= 2;

-- pega o nome e o preço dos produtos e mostra apenas os produtos mais caros que fone de ouvido where = if/else
SELECT NOME, PREÇO
FROM PRODUTOS
WHERE PREÇO > (
	SELECT PREÇO
	FROM PRODUTOS
	WHERE NOME = 'Fone de Ouvido'
);

-- pega todos os clientes que tem pelo menos 1 pedido
SELECT NOME
FROM CLIENTES
WHERE ID_CLIENTE IN (
	SELECT ID_CLIENTE
	FROM PEDIDOS
);

-- descobre a categoria, soma a media da categoria, compara preço do produto com a media e mostra só o produto que for maior que a media
SELECT
	P.NOME AS PRODUTO,
	P.PREÇO,
	C.NOME AS CATEGORIA,
(
SELECT AVG(P2.PREÇO)
FROM PRODUTOS P2
WHERE P2.ID_CATEGORIA = P.ID_CATEGORIA
) AS MEDIA_CATEGORIA
FROM PRODUTOS P
INNER JOIN CATEGORIAS C
ON P.ID_CATEGORIA = C.ID_CATEGORIA
WHERE P.PREÇO > (
	SELECT AVG(P3.PREÇO)
	FROM PRODUTOS P3
	WHERE P3.ID_CATEGORIA = P.ID_CATEGORIA
);
