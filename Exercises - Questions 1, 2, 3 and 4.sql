-- 1) a) Selecione o título e o autor de todos os livros.
SELECT title, author FROM books;

-- 1) b) Selecione os livros escritos por Henry Davis.
SELECT * FROM books WHERE author ILIKE 'henry Davis';

-- 1) c) Selecione o título, autor e ano dos livros publicados antes de 1900.
SELECT 
	title Titulo, 
	author Autor, 
	release_year Ano de lançamento 
FROM books
WHERE release_year < 1900;

-- 1) d) Selecione todos os livros cujo título comece com a letra "O".
SELECT * FROM books WHERE title ILIKE 'o%';

-- 1) e) Selecione o título e o autor dos livros cujo ano seja posterior a 1950.
SELECT 
	title Titulo, 
	author Autor,
FROM books 
WHERE release_year > 1950;

-- 1) f) Selecione o número total de livros na tabela.
SELECT COUNT(*) FROM books;

-- 1) g) Selecione o autor com o maior número de livros publicados.
SELECT author Autor, COUNT(*)
FROM books
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 1) h) Selecione os livros ordenados por ano em ordem ascendente.
SELECT * FROM books ORDER BY release_year;

-- 1) i) Selecione o título do livro mais antigo.
SELECT 
	title Titulo, 
	release_year Ano de lançamento
FROM books
ORDER BY release_year 
LIMIT 1;

-- 1) j) Selecione o título do livro mais recente.
SELECT 
	title Titulo, 
	release_year Ano de lançamento
FROM books
ORDER BY release_year DESC
LIMIT 1;

-- 1) k) Selecione o título e o autor dos três últimos livros na tabela.
SELECT 
	id, 
	title Titulo, 
	author Autor
FROM books
ORDER BY id DESC
LIMIT 3;

-- 2) a)Selecione a quantidade total de produtos em estoque.
SELECT SUM(quantity_in_stock) FROM products;

-- 2) b) Selecione o preço médio dos produtos.
SELECT ROUND(AVG(price::numeric), 2) FROM products;

-- 2) c) Selecione o produto mais caro da tabela.
SELECT * FROM products ORDER BY price DESC LIMIT 1;

-- d) Selecione o produto mais barato da tabela.
SELECT * FROM products ORDER BY price LIMIT 1;

-- 2) e) Selecione o valor do total do estoque (preço * estoque) para cada produto.
SELECT 
	product Produto, 
	price * quantity_in_stock Valor total do estoque
FROM products;

-- 2) f) Selecione a quantidade de produtos que possuem estoque menor que 20.
SELECT COUNT(*)
FROM products
WHERE quantity_in_stock < 20;

-- 2) g) Selecione o produto com o maior retorno após a venda de todas as unidades em estoque.
SELECT 
	product Produto, 
	price * quantity_in_stock Retorno das vendas
FROM products
ORDER BY 2 DESC
LIMIT 1;

-- 3) a) Selecione o nome e cargo de cada funcionário, juntamente com o departamento em que trabalham.
SELECT 
	e.name Funcionário, 
	e.role Cargo, 
	d.name Departamento
FROM employees e
INNER JOIN departments d
ON e.department_id = d.id;

-- 3) b) Selecione o nome, o cargo e o salário dos funcionários do departamento de vendas.
SELECT 
	e.id, 
	e.name Funcionário, 
	e.role Cargo, 
	e.salary Salário
FROM employees e
INNER JOIN departments d
ON e.department_id = d.id
WHERE d.name ILIKE 'Vendas';

-- 3) c) Selecione o nome, o cargo e o salário dos funcionários cujo salário seja maior que 3500 e que trabalham no departamento de vendas.
SELECT 
	e.name Funcionário, 
	e.role Cargo, 
	e.salary Salário
FROM employees e
INNER JOIN departments d
ON e.department_id = d.id
WHERE e.salary::numeric > 3500 AND d.name ILIKE 'vendas';

-- 3) d) Selecione o nome, o cargo, o salário e o nome do projeto associado a cada funcionário.
SELECT 
	e.name Funcionário, 
	e.role Cargo, 
	e.salary Salário
	STRING_AGG(p.name, ', ') projetos
FROM employees e
INNER JOIN departments d
ON e.department_id = d.id
INNER JOIN projects p
ON p.department_id = d.id
GROUP BY e.id;

-- 3) e) Liste o total gasto pela empresa no pagamento dos funcionários.
SELECT SUM(salary) FROM employees;

-- 3) f) Liste o total de salário pago para os funcionários de cada departamento.
SELECT 
	d.name departamento, 
	SUM(e.salary)
FROM employees e
INNER JOIN departments d
ON e.department_id = d.id
GROUP BY d.id;

-- 3) g) Liste o maior salário de cada departamento.
SELECT 
	d.name departamento, 
	MAX(e.salary)
FROM employees e
INNER JOIN departments d
ON e.department_id = d.id
GROUP BY d.id;

-- 4) a) Listar todos os alimentos e as suas respectivas categorias.
SELECT 
	f.name Nome,
	c.name Categoria
FROM foods f
INNER JOIN categories c
ON f.category_id = c.id;

-- 4) b) Encontre o total de calorias para cada categoria de alimento.
SELECT 
	c.name Categoria,
	SUM(ni.calories)
FROM nutritional_information ni
INNER JOIN foods f
ON ni.food_id = f.id
INNER JOIN categories c
ON f.category_id = c.id
GROUP BY c.id;

-- 4) c) Listar as dietas que incluem alimentos com mais de 500 calorias.
SELECT 
	d.name Dieta,
	STRING_AGG(f.name, ', ') Alimento
FROM diets d
INNER JOIN diets_foods df
ON df.diet_id = d.id
INNER JOIN foods f
ON df.food_id = f.id
INNER JOIN nutritional_information ni
ON ni.food_id = f.id
WHERE ni.calories > 500
GROUP BY d.id;

-- 4) d) Calcular a média de proteínas por categoria de alimento.
SELECT 
	c.name Categoria,
	ROUND(AVG(ni.proteins),  2)
FROM nutritional_information ni
INNER JOIN foods f
ON ni.food_id = f.id
INNER JOIN categories c
ON f.category_id = c.id
GROUP BY c.id;

-- 4) e) Identificar os alimentos que têm um teor de gordura superior à média de gordura de todos os alimentos.
SELECT 
	f.name Alimentos,
	ni.fats
FROM nutritional_information ni
INNER JOIN foods f
ON ni.food_id = f.id
WHERE ni.fats > (SELECT AVG(fats) FROM nutritional_information);

-- 4) f) Listar as três categorias de alimentos com o maior número de itens.
SELECT c.name, COUNT(f.id)
FROM foods f
INNER JOIN categories c
ON f.category_id = c.id
GROUP BY c.id
ORDER BY 2 DESC
LIMIT 3;

-- 4) g) Encontrar a dieta que tem o menor teor total de carboidratos.
SELECT 
	d.name Dieta,
	SUM(ni.carbohydrates) "Total de Carboidratos"
FROM diets d
INNER JOIN diets_foods df
ON df.diet_id = d.id
INNER JOIN foods f
ON df.food_id = f.id
INNER JOIN nutritional_information ni
ON ni.food_id = f.id
GROUP BY d.id
ORDER BY 2
LIMIT 1;

-- 4) h) Listar todos os alimentos que não estão incluídos em nenhuma dieta.
SELECT * FROM foods WHERE id NOT IN (SELECT food_id FROM diets_foods);

-- 4) i) Determinar a proporção de proteínas, carboidratos e gorduras (em porcentagem de calorias fornecidas) de cada alimento.
SELECT 
    f.name,
    ROUND((ni.proteins * 4 / (ni.proteins * 4 + ni.carbohydrates * 4 + ni.fats * 9)) * 100, 2) "% de proteina",
    ROUND((ni.carbohydrates * 4 / (ni.proteins * 4 + ni.carbohydrates * 4 + ni.fats * 9)) * 100, 2) "% de carboidratos",
    ROUND((ni.fats * 9 / (ni.proteins * 4 + ni.carbohydrates * 4 + ni.fats * 9)) * 100, 2) "% de gordura"
FROM foods f
INNER JOIN nutritional_information ni 
ON f.id = ni.food_id;