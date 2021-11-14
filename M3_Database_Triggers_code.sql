-- M3 db triggers assignment
-- dropping table if it exists

DROP TABLE IF EXISTS t_sup_supplier_hist;

-- creating the table for the history
CREATE TABLE t_sup_supplier_hist (
	sup_id varchar(50) NOT NULL, 
    last_modified date NOT NULL,
    PRIMARY KEY (`sup_id`)
);

-- dropping and creating insert trigger
DROP TRIGGER IF EXISTS ins_date;

CREATE TRIGGER ins_date
 AFTER INSERT ON t_sup_supplier FOR EACH ROW 
    INSERT INTO t_sup_supplier_hist 
    SET sup_id = new.sup_id, last_modified = SYSDATE();
    
-- dropping and creating delete trigger
DROP TRIGGER IF EXISTS delete_date;

CREATE TRIGGER delete_date
 AFTER DELETE ON t_sup_supplier FOR EACH ROW 
INSERT INTO t_sup_supplier_hist
(sup_id,last_modified) VALUES (old.sup_id, SYSDATE()) 
ON DUPLICATE KEY UPDATE last_modified=SYSDATE();

-- dropping and creating update trigger
DROP TRIGGER IF EXISTS update_date;

CREATE TRIGGER update_date
 AFTER UPDATE ON t_sup_supplier FOR EACH ROW 
INSERT INTO t_sup_supplier_hist (sup_id,last_modified) VALUES (old.sup_id, SYSDATE()) 
ON DUPLICATE KEY UPDATE last_modified=SYSDATE();

-- testing t_sup_supplier
SELECT * FROM t_sup_supplier
LIMIT 5;

-- inserting values into t_sup_supplier
INSERT INTO t_sup_supplier (sup_id, status_code, country_code, sup_name_en) 
VALUES ('2904474', 'val', 'CO', 'ABAX INC.');

-- testing to see if triggers worked
SELECT * FROM t_sup_supplier where sup_id = '2904474';
SELECT * FROM t_sup_supplier_hist;

-- updating t_sup_supplier
UPDATE t_sup_supplier set status_code = 'ini' where sup_id = '2904473';
SELECT * FROM t_sup_supplier_hist;