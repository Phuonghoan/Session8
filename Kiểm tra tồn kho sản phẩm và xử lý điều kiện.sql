-- Tạo bảng
CREATE TABLE inventory (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    quantity INT
);

-- Tạo procedure
CREATE OR REPLACE PROCEDURE check_stock(
    IN p_id INT,
    IN p_qty INT
)
LANGUAGE plpgsql
AS $$
DECLARE 
	v_quantity INT;
BEGIN
	SELECT quantity
	INTO v_quantity
	FROM inventory
	WHERE product_id = p_id;

	IF v_quantity IS NULL THEN
		RAISE EXCEPTION 'Sản phẩm này không tồn tại';
	END IF;

	IF v_quantity < p_qty THEN
		RAISE EXCEPTION 'Không đủ hàng trong kho';
	END IF;
END;
$$;

-- Trường hợp đủ hàng
CALL check_stock(1, 10);

-- Trường hợp không đủ hàng
CALL check_stock(2, 10);