USE salon;

DROP TABLE IF EXISTS clients;
CREATE TABLE clients (
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(255) COMMENT '���',
	last_name VARCHAR(255) COMMENT '�������',
	telephone VARCHAR(11) NOT NULL COMMENT '�������',
	email VARCHAR(255) COMMENT 'Email',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) COMMENT = '�������';


DROP TABLE IF EXISTS profiles;
CREATE TABLE profiles (
	client_id BIGINT UNSIGNED COMMENT 'ID �������',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT profiles_client_id_fk FOREIGN KEY (client_id)  REFERENCES clients(id)
) COMMENT = '������ ��������';


DROP TABLE IF EXISTS servises;
CREATE TABLE servises (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL COMMENT '�������� ������',
	price DECIMAL (11,2) COMMENT '���� ������',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	UNIQUE unique_name(name(10))
) COMMENT = '������';


DROP TABLE IF EXISTS storehouse;
CREATE TABLE storehouse (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL COMMENT '������������ ����������',
	category ENUM('cosmetic', 'consumable') NOT NULL COMMENT '��������� ����������',	
	unit VARCHAR(20) NOT NULL COMMENT '������� ���������',
	actual_price DECIMAL (11,2) COMMENT '���������� ���� �� ������� ����������',
	quantity FLOAT NOT NULL DEFAULT 0 COMMENT '����� ����������',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	UNIQUE unique_name(name(10))
) COMMENT = '�����';


DROP TABLE IF EXISTS consumption;
CREATE TABLE consumption (
	id SERIAL PRIMARY KEY,
	servise_id BIGINT UNSIGNED NOT NULL COMMENT '������',
	consumable_id BIGINT UNSIGNED NOT NULL COMMENT '���������',
	unit VARCHAR(20) NOT NULL COMMENT '������� ���������',
	volume_units FLOAT DEFAULT 0 NOT NULL COMMENT '����������� ����������',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT consumption_servise_id_fk FOREIGN KEY (servise_id)  REFERENCES servises(id),
 	CONSTRAINT consumption_consumable_id_fk FOREIGN KEY (consumable_id)  REFERENCES storehouse(id)
) COMMENT = '������ ����������';


DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
	id SERIAL PRIMARY KEY,
	client_id BIGINT UNSIGNED COMMENT '������',
	consumable_id BIGINT UNSIGNED NOT NULL COMMENT 'ID ����������',
	unit VARCHAR(20) NOT NULL COMMENT '������� ���������',
	unit_volume FLOAT UNSIGNED DEFAULT 0 NOT NULL COMMENT '��������� ����������',
	unit_price FLOAT DEFAULT 0 NOT NULL COMMENT '���� �� �������',
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT sales_client_id_fk FOREIGN KEY (client_id)  REFERENCES clients(id),
	CONSTRAINT sales_consumable_id_fk FOREIGN KEY (consumable_id)  REFERENCES storehouse(id)
) COMMENT = '�������';


DROP TABLE IF EXISTS purchases;
CREATE TABLE purchases (
	id SERIAL PRIMARY KEY,
	consumable_id BIGINT UNSIGNED NOT NULL COMMENT 'ID ����������',
	unit VARCHAR(20) NOT NULL COMMENT '������� ���������',
	unit_volume FLOAT DEFAULT 0 NOT NULL COMMENT '���������� ����������',
	unit_price FLOAT DEFAULT 0 NOT NULL COMMENT '���� �� �������',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT purchases_consumable_id_fk FOREIGN KEY (consumable_id)  REFERENCES storehouse(id)
) COMMENT = '�������';


DROP TABLE IF EXISTS visits;
CREATE TABLE visits (
	id SERIAL PRIMARY KEY,
	client_id BIGINT UNSIGNED COMMENT '������',
	servise_id BIGINT UNSIGNED NOT NULL COMMENT '������',
	completed BOOLEAN NOT NULL COMMENT '������ �������',
	visit_time DATETIME NOT NULL COMMENT '����� ������',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT visits_client_id_fk FOREIGN KEY (client_id)  REFERENCES clients(id),
	CONSTRAINT visits_servise_id_fk FOREIGN KEY (servise_id)  REFERENCES servises(id)
) COMMENT = '���������';


DROP TABLE IF EXISTS media;
CREATE TABLE media (
	id SERIAL PRIMARY KEY,
	client_id BIGINT UNSIGNED NOT NULL COMMENT '������',
	visit_id BIGINT UNSIGNED COMMENT '�����',
	type_file ENUM('photo', 'video') NOT NULL COMMENT '��� �����',
	path_file VARCHAR(255) NOT NULL COMMENT '���� � �����',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	UNIQUE unique_name(path_file),
	CONSTRAINT media_client_id_fk FOREIGN KEY (client_id)  REFERENCES clients(id),
	CONSTRAINT media_visit_id_fk FOREIGN KEY (visit_id)  REFERENCES visits(id)
) COMMENT = '����������';


DROP TABLE IF EXISTS promotions;
CREATE TABLE promotions (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT '�������� ������',
	servise_id BIGINT UNSIGNED COMMENT '������',
	discount FLOAT DEFAULT 1.0 COMMENT '������',
	from_date DATETIME NOT NULL COMMENT '���� ������ ������',
	to_date DATETIME NOT NULL COMMENT '���� ��������� ������',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	UNIQUE unique_name(name(10)),
	CONSTRAINT promotions_servise_id_fk FOREIGN KEY (servise_id)  REFERENCES servises(id)
) COMMENT = '����� ������';


DROP TABLE IF EXISTS expenses;
CREATE TABLE expenses (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) NOT NULL COMMENT '������������ �������',
	unit VARCHAR(20) NOT NULL COMMENT '������� ���������',
	price DECIMAL (11,2) NOT NULL COMMENT '���������',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	UNIQUE unique_name(name(10))
) COMMENT = '������� �� ������';

