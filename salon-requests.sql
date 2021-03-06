-- ---------------------------------------------- Запросы к базе -----------------------------------------
-- Список приемов за период
SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS `Клиент`,
	cs.name AS `Вид процедуры`,
	s.name AS `Процедура`,
	s.price AS `Цена`,
	DATE_FORMAT(v.visit_time, '%d %m %Y') AS `Дата приема`,
	TIME_FORMAT(v.visit_time, '%H %i') AS `Время`
FROM visits v
	JOIN clients c 
		ON v.client_id = c.id 
	JOIN servises s 
		ON v.servise_id = s.id
	JOIN category_servises cs 
		ON s.category_servise_id = cs.id 
WHERE v.visit_time BETWEEN STR_TO_DATE('2020-08-01', '%Y-%m-%d') AND STR_TO_DATE('2020-08-31', '%Y-%m-%d')
ORDER BY v.visit_time;



-- Данные о конкретном приеме
SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS `Клиент`,
	cs.name AS `Вид процедуры`,
	s.name AS `Процедура`,
	s.price AS `Цена процедуры`,
	v.payment AS `Оплата с учетом скидок`,
	m.path_file AS `Фото`,
	IF(v.completed = 1, 'Да', 'Нет') AS `Услуга оказана`,
	DATE_FORMAT(v.visit_time, '%d %m %Y') AS `Дата приема`,
	TIME_FORMAT(v.visit_time, '%H %i') AS `Время`
FROM visits v
	LEFT JOIN clients c 
		ON v.client_id = c.id 
	LEFT JOIN servises s 
		ON v.servise_id = s.id
	LEFT JOIN category_servises cs 
		ON s.category_servise_id = cs.id
	LEFT JOIN media m
		ON m.visit_id = v.id
WHERE v.id = 10;



-- Посещения отдельного клиента
SELECT 
	CONCAT(c.first_name, ' ', c.last_name) AS `Клиент`,
	cs.name AS `Вид процедуры`,
	s.name AS `Процедура`,
	v.payment AS `Оплата с учетом скидок`,
	DATE_FORMAT(v.visit_time, '%d %m %Y') AS `Дата приема`,
	TIME_FORMAT(v.visit_time, '%H %i') AS `Время`,	
	IF(v.completed = 1, 'Да', 'Нет') AS `Услуга оказана`
FROM visits v 
	JOIN clients c 
		ON c.id = v.client_id
	JOIN servises s 
		ON v.servise_id = s.id
	JOIN category_servises cs 
		ON s.category_servise_id = cs.id
WHERE c.id = 37
ORDER BY v.visit_time DESC;



-- Расход материалов на процедуры
SELECT 
	CONCAT(cs.name, ' / ', s.name) AS `Услуга`,
	sh.name AS `Расходник`,
	CONCAT(c.volume, ' ', sh.unit) AS `Количество`
FROM consumption c 
	JOIN servises s 
		ON c.servise_id = s.id 
	JOIN category_servises cs 
		ON s.category_servise_id = cs.id 
	JOIN storehouse sh 
		ON c.consumable_id = sh.id
ORDER BY s.id;



-- Расход материалов на оказанные услуг за период
SELECT 
	sh.name AS `Расходник`,
	CONCAT(SUM(c.volume), ' ', sh.unit) AS `Количество`
FROM visits v 
	LEFT JOIN servises s 
		ON v.servise_id = s.id 
	LEFT JOIN consumption c 
		ON c.servise_id = s.id
	LEFT JOIN storehouse sh
		ON c.consumable_id = sh.id 
WHERE v.visit_time BETWEEN STR_TO_DATE('2020-08-01', '%Y-%m-%d') AND STR_TO_DATE('2020-08-31', '%Y-%m-%d')
GROUP BY sh.id;



-- доход за период
SELECT SUM(v.payment)
FROM visits v 
WHERE v.visit_time BETWEEN STR_TO_DATE('2020-10-01', '%Y-%m-%d') AND STR_TO_DATE('2020-10-31', '%Y-%m-%d');


-- -------------------------------------- Представления ----------------------------------------------------
-- представление расписание приемов за месяц
CREATE OR REPLACE VIEW schedule AS SELECT
	CONCAT(c.first_name, ' ', c.last_name) AS `Клиент`,
	cs.name AS `Вид процедуры`,
	s.name AS `Процедура`,
	s.price AS `Цена`,
	DATE_FORMAT(v.visit_time, '%d %m %Y') AS `Дата приема`,
	TIME_FORMAT(v.visit_time, '%H %i') AS `Время`,
	IF(v.completed = 1, 'Да', 'Нет') AS `Услуга оказана`
FROM visits v
	JOIN clients c 
		ON v.client_id = c.id 
	JOIN servises s 
		ON v.servise_id = s.id
	JOIN category_servises cs 
		ON s.category_servise_id = cs.id 
WHERE v.visit_time BETWEEN STR_TO_DATE('2021-04-15', '%Y-%m-%d') AND STR_TO_DATE('2021-05-15', '%Y-%m-%d')
ORDER BY v.visit_time;

SELECT * FROM schedule;

-- выборка конкретной процедуры из представления
SELECT * 
FROM schedule
WHERE `Процедура` = 'Феруловый NBL';




-- Представление расходов материалов за период
-- определяется из расчета расхода материалов на процедуру (таблица consumption)
CREATE OR REPLACE VIEW profit AS SELECT DISTINCT
	sh.name AS `Расходник`,
	CONCAT(SUM(c.volume) OVER (PARTITION BY sh.id), ' ', sh.unit) AS `Количество`,
	sh.actual_price AS `Стоимость (ед.)`,
	SUM(c.volume) OVER (PARTITION BY sh.id) * sh.actual_price AS `Расход (руб.)`
FROM  storehouse sh
	LEFT JOIN consumption c 
		ON c.consumable_id = sh.id 
	LEFT JOIN  servises s
		ON c.servise_id = s.id
	LEFT JOIN visits v
		ON v.servise_id = s.id 
WHERE v.visit_time BETWEEN STR_TO_DATE('2020-08-01', '%Y-%m-%d') AND STR_TO_DATE('2020-08-31', '%Y-%m-%d');

SELECT * FROM profit;

-- расход для конкретного материала из представления
SELECT * FROM profit WHERE `Расходник` = 'Гель для жирной кожи Гельтек';

-- расход всего 
-- таблица расхода материалов сгенерирована, поэтому такой расход :)
SELECT SUM(`Расход (руб.)`) FROM profit;





