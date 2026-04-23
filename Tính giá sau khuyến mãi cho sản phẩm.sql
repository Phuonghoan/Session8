-- Tạo bảng
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    price NUMERIC,
	discount_percent INT
);

-- Dữ liệu mẫu
INSERT INTO products (name, price, discount_percent) VALUES
('Laptop', 20000000, 10),
('Phone', 15000000, 60),
('Tablet', 10000000, 25);

-- Tạo procedure
CREATE OR REPLACE PROCEDURE calculate_discount(
    IN p_id INT,
    OUT p_final_price NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE 
	v_price NUMERIC;
	v_discount_percent INT;
BEGIN
	SELECT price, discount_percent
	INTO v_price, v_discount_percent
	FROM products
	WHERE id = p_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'Không tìm thấy sản phẩm';
	END IF;

	IF v_discount_percent > 50 THEN
		v_discount_percent = 50;
	END IF;

	p_final_price = price - (price * discount_percent / 100);

	UPDATE products
	SET price = p_final_price
	WHERE id = p_id;
END;
$$;

-- Gọi thử
CALL calculate_discount(2, NULL);

-- Kiểm tra
SELECT * FROM products;