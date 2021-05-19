USE salon;
-- ТРИГГЕРЫ, ПРОЦЕДУРЫ

DELIMITER //


-- Изменение данных в таблице - склад
DROP PROCEDURE IF EXISTS storehouse_change_value //
CREATE PROCEDURE storehouse_change_value(add_value BOOL, target_id BIGINT, volume FLOAT)
	BEGIN
		IF (add_value) THEN 
			UPDATE storehouse SET quantity = quantity + volume WHERE target_id = id;
		ELSE 
			UPDATE storehouse SET quantity = quantity - volume WHERE target_id = id;
		END IF;
	END //



-- Добавление записи в таблицу - закупки
DROP TRIGGER IF EXISTS add_purchase //
CREATE TRIGGER add_purchase AFTER INSERT ON purchases
	FOR EACH ROW
	BEGIN
		CALL storehouse_change_value(TRUE, NEW.consumable_id, NEW.unit_volume);
	END //
 
	
-- Удаление записи из таблицы - закупки
DROP TRIGGER IF EXISTS del_purchase //
CREATE TRIGGER del_purchase BEFORE DELETE ON purchases
	FOR EACH ROW
	BEGIN
		CALL storehouse_change_value(FALSE, OLD.consumable_id, OLD.unit_volume);
	END //
 
	
-- Добавление записи в таблицу - продажи
DROP TRIGGER IF EXISTS add_sale //
CREATE TRIGGER add_sale AFTER INSERT ON sales
	FOR EACH ROW
	BEGIN
		CALL storehouse_change_value(FALSE, NEW.consumable_id, NEW.unit_volume);
	END //
 
	
-- Удаление записи из таблицы - продажи
DROP TRIGGER IF EXISTS del_sale //
CREATE TRIGGER del_sale BEFORE DELETE ON sales
	FOR EACH ROW
	BEGIN
		CALL storehouse_change_value(TRUE, OLD.consumable_id, OLD.unit_volume);
	END //
 
	
	
DELIMITER ;



