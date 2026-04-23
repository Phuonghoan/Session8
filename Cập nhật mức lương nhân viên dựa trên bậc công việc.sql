-- Tạo bảng
CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),
    job_level INT,
	salary NUMERIC
);

-- Dữ liệu mẫu
INSERT INTO employees (emp_name, job_level, salary) VALUES
('Nguyen Van A', 1, 10000000),
('Tran Thi B', 2, 12000000),
('Le Van C', 3, 15000000);

-- Tạo procedure
CREATE OR REPLACE PROCEDURE adjust_salary(
    IN p_emp_id INT,
    OUT p_new_salary NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE 
	v_job_level INT;
	v_salary NUMERIC;
BEGIN
	SELECT job_level, salary
	INTO v_job_level, v_salary
	FROM employees
	WHERE emp_id = p_emp_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'Không tìm thấy nhân viên';
	END IF;

	IF v_job_level = 1 THEN
		p_new_salary := v_salary * 1.05;
	ELSIF v_job_level = 2 THEN
		p_new_salary := v_salary * 1.10;
	ELSIF v_job_level = 3 THEN
		p_new_salary := v_salary * 1.15;
	ELSE 
		p_new_salary := v_salary;
	END IF;

	UPDATE employees
	SET salary = p_new_salary
	WHERE emp_id = p_emp_id;
END;
$$;

-- Thực thi thử
CALL adjust_salary(3, NULL);

-- Kiểm tra
SELECT * FROM employees