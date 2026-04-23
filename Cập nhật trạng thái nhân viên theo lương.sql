
-- Tạo bảng
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(50),
    salary NUMERIC(10,2),
    bonus NUMERIC(10,2) DEFAULT 0
);

-- Thêm cột status vì đề yêu cầu cập nhật status
ALTER TABLE employees
ADD COLUMN status TEXT;

-- Thêm dữ liệu
INSERT INTO employees (name, department, salary) VALUES
('Nguyen Van A', 'HR', 4000),
('Tran Thi B', 'IT', 6000),
('Le Van C', 'Finance', 10500),
('Pham Thi D', 'IT', 8000),
('Do Van E', 'HR', 12000);

-- Tạo procedure
CREATE OR REPLACE PROCEDURE update_employee_status(
    IN p_emp_id INT,
    INOUT p_status TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_salary NUMERIC(10,2);
BEGIN
    SELECT salary
    INTO v_salary
    FROM employees
    WHERE id = p_emp_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Employee not found';
    END IF;

    IF v_salary < 5000 THEN
        p_status := 'Junior';
    ELSIF v_salary BETWEEN 5000 AND 10000 THEN
        p_status := 'Mid-level';
    ELSE
        p_status := 'Senior';
    END IF;

    UPDATE employees
    SET status = p_status
    WHERE id = p_emp_id;
END;
$$;

-- Gọi thử
CALL update_employee_status(1, NULL);
CALL update_employee_status(2, NULL);
CALL update_employee_status(3, NULL);
CALL update_employee_status(4, NULL);
CALL update_employee_status(5, NULL);

-- Kiểm tra kết quả
SELECT * FROM employees;