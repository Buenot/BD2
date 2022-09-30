#1D

drop procedure test;
DELIMITER // 
CREATE PROCEDURE test(in vendor_id_var int) 
BEGIN 
    DECLARE max_invoice_total DECIMAL (9, 2);
    DECLARE min_invoice_total DECIMAL (9, 2);
    DECLARE percent_difference DECIMAL (9, 2);
    DECLARE count_invoice_id INT;
    #DECLARE vendor_id_var INT;
    SELECT MAX(invoice_total),
           MIN(invoice_total),
           COUNT(invoice_id) INTO max_invoice_total,
           min_invoice_total,
           count_invoice_id
    FROM   invoices
    WHERE  vendor_id = vendor_id_var;
    SET percent_difference = (max_invoice_total - min_invoice_total) / min_invoice_total * 100;
    SELECT CONCAT('$', max_invoice_total) AS 'Maximum invoice',
           CONCAT('$', min_invoice_total) AS 'Minimum invoice',
           CONCAT(' % ', ROUND (percent_difference, 2 ) ) AS ' Percent difference ',
           count_invoice_id AS ' Number of invoices ';
END//
call test(108);



#2D

	set @max_invoice_total = 0;
	set @min_invoice_total = 0;
    set @percent_difference = 0;
    set @count_invoice_id = 0;
    #DECLARE vendor_id_var INT;
    SELECT MAX(invoice_total),
           MIN(invoice_total),
           COUNT(invoice_id) INTO @max_invoice_total,
           @in_invoice_total,
           @count_invoice_id
    FROM   invoices
    WHERE  vendor_id = 108;
    SET @percent_difference = (@max_invoice_total - @min_invoice_total) / @min_invoice_total * 100;
    SELECT CONCAT('$', @max_invoice_total) AS 'Maximum invoice',
           CONCAT('$', @min_invoice_total) AS 'Minimum invoice',
           CONCAT(' % ', ROUND (@percent_difference, 2 ) ) AS ' Percent difference ',
           @count_invoice_id AS ' Number of invoices ';



#3D

drop procedure GetCustomerLevel;
DELIMITER $$

CREATE PROCEDURE GetCustomerLevel(
    IN  pCustomerNumber INT, 
    OUT pCustomerLevel  VARCHAR(20),
    OUT pCustomerName varchar(50))
BEGIN
    DECLARE credit DECIMAL(10,2) DEFAULT 0;
	
    select customerName
    into pCustomerName
    from customers
    WHERE customerNumber = pCustomerNumber;
    
    
    SELECT creditLimit 
    INTO credit
    FROM customers
    WHERE customerNumber = pCustomerNumber;

    IF credit > 50000 THEN
        SET pCustomerLevel = 'PLATINUM';
    ELSEIF credit <= 50000 AND credit > 10000 THEN
        SET pCustomerLevel = 'GOLD';
    ELSE
        SET pCustomerLevel = 'SILVER';
    END IF;
END$$

DELIMITER ;
CALL GetCustomerLevel(447, @level, @cnome);
SELECT @level as 'status cliente', @cnome as 'nome cliente';



#4D

DELIMITER $$
CREATE PROCEDURE GetCustomerShipping(
	IN  pCustomerNUmber INT, 
	OUT pShipping       VARCHAR(50),
    OUT pcity varchar(50))
BEGIN
    DECLARE customerCountry VARCHAR(100);
    
    SELECT city
	INTO pcity
    FROM customers
	WHERE customerNumber = pCustomerNUmber;
    
	SELECT country
	INTO customerCountry 
    FROM customers
	WHERE customerNumber = pCustomerNUmber;
    
    CASE customerCountry
		WHEN  'USA' THEN
		   SET pShipping = '2-day Shipping';
		WHEN 'Canada' THEN
		   SET pShipping = '3-day Shipping';
		ELSE
		   SET pShipping = '5-day Shipping';
	END CASE;
END$$
DELIMITER ;

CALL GetCustomerShipping(112,@shipping, @pcity);
SELECT @shipping as 'pazo da entrega', @pcity as 'cidade';



#5D

drop procedure GetDeliveryStatus; 
DELIMITER $$
CREATE PROCEDURE GetDeliveryStatus(
	IN pOrderNumber INT, 
    OUT pDeliveryStatus VARCHAR(100),
    OUT pCustomername varchar(50))
BEGIN
	DECLARE waitingDay INT DEFAULT 0;
    
    
	SELECT customerName
	INTO pCustomername
	FROM customers c
    inner join orders o on c.customerNumber = o.customerNumber
    WHERE o.orderNumber = pOrderNumber;
    
    SELECT DATEDIFF(requiredDate, shippedDate)
	INTO waitingDay
	FROM orders
    WHERE orderNumber = pOrderNumber;
    
    CASE 
		WHEN waitingDay = 0 THEN 
			SET pDeliveryStatus = 'On Time';
        WHEN waitingDay >= 1 AND waitingDay < 5 THEN
			SET pDeliveryStatus = 'Late';
		WHEN waitingDay >= 5 THEN
			SET pDeliveryStatus = 'Very Late';
		ELSE
			SET pDeliveryStatus = 'No Information';
	END CASE;	
END$$
DELIMITER ;

CALL GetDeliveryStatus(10200,@delivery, @pCustomername);
select @delivery as 'status da entrega', @pCustomername as 'nome do cliente';






