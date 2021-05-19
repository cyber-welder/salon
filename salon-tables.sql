USE salon;

DROP TABLE IF EXISTS clients;
CREATE TABLE clients (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(255) COMMENT 'Имя',
	last_name VARCHAR(255) COMMENT 'Фамилия',
	telephone VARCHAR(11) NOT NULL COMMENT 'Телефон',
	email VARCHAR(255) COMMENT 'Email',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT = 'Клиенты';


DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	client_id BIGINT UNSIGNED COMMENT 'ID клиента',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT profiles_client_id_fk FOREIGN KEY (client_id)  REFERENCES clients(id)
) COMMENT = 'Анкеты клиентов';


DROP TABLE IF EXISTS servises;
CREATE TABLE servises (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL COMMENT 'Название услуги',
	price DECIMAL (11,2) COMMENT 'Цена услуги',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	UNIQUE unique_name(name(10))
) COMMENT = 'Услуги';


DROP TABLE IF EXISTS storehouse;
CREATE TABLE storehouse (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL COMMENT 'Наименование расходника',
	category ENUM('cosmetic', 'consumable') NOT NULL COMMENT 'Категория расходника',	
	unit VARCHAR(20) NOT NULL COMMENT 'Единица измерения',
	actual_price DECIMAL (11,2) COMMENT 'Актуальная цена за единицу расходника',
	quantity FLOAT NOT NULL DEFAULT 0 COMMENT 'Общее количество',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	UNIQUE unique_name(name(10))
) COMMENT = 'Склад';


DROP TABLE IF EXISTS consumption;
CREATE TABLE consumption (
	id SERIAL PRIMARY KEY,
	servise_id BIGINT UNSIGNED NOT NULL COMMENT 'Услуга',
	consumable_id BIGINT UNSIGNED NOT NULL COMMENT 'Расходник',
	unit VARCHAR(20) NOT NULL COMMENT 'Единица измерения',
	volume_units FLOAT DEFAULT 0 NOT NULL COMMENT 'Расходуемое количество',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT consumption_servise_id_fk FOREIGN KEY (servise_id)  REFERENCES servises(id),
 	CONSTRAINT consumption_consumable_id_fk FOREIGN KEY (consumable_id)  REFERENCES storehouse(id)
) COMMENT = 'Расход материалов';


DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
	id SERIAL PRIMARY KEY,
	client_id BIGINT UNSIGNED COMMENT 'Клиент',
	consumable_id BIGINT UNSIGNED NOT NULL COMMENT 'ID расходника',
	unit VARCHAR(20) NOT NULL COMMENT 'Единица измерения',
	unit_volume FLOAT UNSIGNED DEFAULT 0 NOT NULL COMMENT 'Проданное количество',
	unit_price FLOAT DEFAULT 0 NOT NULL COMMENT 'Цена за единицу',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT sales_client_id_fk FOREIGN KEY (client_id)  REFERENCES clients(id),
	CONSTRAINT sales_consumable_id_fk FOREIGN KEY (consumable_id)  REFERENCES storehouse(id)
) COMMENT = 'Продажи';


DROP TABLE IF EXISTS purchases;
CREATE TABLE purchases (
	id SERIAL PRIMARY KEY,
	consumable_id BIGINT UNSIGNED NOT NULL COMMENT 'ID расходника',
	unit VARCHAR(20) NOT NULL COMMENT 'Единица измерения',
	unit_volume FLOAT DEFAULT 0 NOT NULL COMMENT 'Закупаемое количество',
	unit_price FLOAT DEFAULT 0 NOT NULL COMMENT 'Цена за единицу',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT purchases_consumable_id_fk FOREIGN KEY (consumable_id)  REFERENCES storehouse(id)
) COMMENT = 'Закупки';


DROP TABLE IF EXISTS visits;
CREATE TABLE visits (
	id SERIAL PRIMARY KEY,
	client_id BIGINT UNSIGNED COMMENT 'Клиент',
	servise_id BIGINT UNSIGNED NOT NULL COMMENT 'Услуга',
	completed BOOLEAN NOT NULL COMMENT 'Услуга оказана',
	visit_time DATETIME NOT NULL COMMENT 'Время приема',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT visits_client_id_fk FOREIGN KEY (client_id)  REFERENCES clients(id),
	CONSTRAINT visits_servise_id_fk FOREIGN KEY (servise_id)  REFERENCES servises(id)
) COMMENT = 'Посещения';


DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id SERIAL PRIMARY KEY,
	client_id BIGINT UNSIGNED NOT NULL COMMENT 'Клиент',
	visit_id BIGINT UNSIGNED COMMENT 'Визит',
	type_file ENUM('photo', 'video') NOT NULL COMMENT 'Тип файла',
	path_file VARCHAR(255) NOT NULL COMMENT 'Путь к файлу',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	UNIQUE unique_name(path_file),
	CONSTRAINT media_client_id_fk FOREIGN KEY (client_id)  REFERENCES clients(id),
	CONSTRAINT media_visit_id_fk FOREIGN KEY (visit_id)  REFERENCES visits(id)
) COMMENT = 'Медиафайлы';


DROP TABLE IF EXISTS promotions;
CREATE TABLE promotions (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Название скидки',
	servise_id BIGINT UNSIGNED COMMENT 'Услуга',
	discount FLOAT DEFAULT 1.0 COMMENT 'Скидка',
	from_date DATETIME NOT NULL COMMENT 'Дата начала скидки',
	to_date DATETIME NOT NULL COMMENT 'Дата окончания скидки',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	UNIQUE unique_name(name(10)),
	CONSTRAINT promotions_servise_id_fk FOREIGN KEY (servise_id)  REFERENCES servises(id)
) COMMENT = 'Акции скидок';


DROP TABLE IF EXISTS expenses;
CREATE TABLE expenses (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL COMMENT 'Наименование расхода',
	unit VARCHAR(20) NOT NULL COMMENT 'Единица измерения',
	price DECIMAL (11,2) NOT NULL COMMENT 'Стоимость',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	UNIQUE unique_name(name(10))
) COMMENT = 'Расходы на бизнес';

