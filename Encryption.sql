 -- MÃ HÓA --

ALTER TABLE CuDan ADD salt CHAR(36);
ALTER TABLE NhanVien ADD salt CHAR(36);
-- 1. Trigger mã hóa mật khẩu cư dân
-- Khi insert
DELIMITER //
CREATE TRIGGER I_CD_MaHoa
BEFORE INSERT ON CuDan
FOR EACH ROW
BEGIN
    -- Tạo giá trị ngẫu nhiên của salt
    DECLARE p_salt CHAR(36);
    DECLARE p_MatKhau BLOB;
    
    SET p_MatKhau = CONCAT(LPAD(DAY(NEW.NgSinh), 2, 0), LPAD(MONTH(NEW.NgSinh), 2, 0), YEAR(NEW.NgSinh));
    SET p_salt = UUID();  -- Tạo giá trị salt ngẫu nhiên
    
    -- Gán giá trị salt mới tạo cho trường salt của hàng mới
    SET NEW.salt = p_salt;
    
    -- Mã hóa mật khẩu với AES_ENCRYPT với key là MaCD
    SET p_MatKhau = AES_ENCRYPT(CONCAT(p_MatKhau, p_salt), NEW.MaCD);
    
    -- Mã hóa mật khẩu đã mã hóa bằng SHA2
    SET NEW.MatKhau = SHA2(p_MatKhau, 256);
END //
DELIMITER ;

-- Khi update
DELIMITER //
CREATE TRIGGER U_CD_MaHoa
BEFORE UPDATE ON CuDan
FOR EACH ROW
BEGIN
    -- Tạo giá trị ngẫu nhiên của salt
    DECLARE p_salt CHAR(36);
    DECLARE p_MatKhau BLOB;

IF OLD.MatKhau <> NEW.MatKhau THEN
    SET p_salt = UUID();  -- Tạo giá trị salt ngẫu nhiên
    
    -- Gán giá trị salt mới tạo cho trường salt của hàng mới
    SET NEW.salt = p_salt;
    
    -- Mã hóa mật khẩu với AES_ENCRYPT với key là MaCD
    SET p_MatKhau = AES_ENCRYPT(CONCAT(NEW.MatKhau, p_salt), NEW.MaCD);
    
    -- Mã hóa mật khẩu đã mã hóa bằng SHA2
    SET NEW.MatKhau = SHA2(p_MatKhau, 256);
END IF;
END //
DELIMITER ;

INSERT INTO CuDan (MaCD, TenCD, GioiTinh, SDT, NgSinh, QueQuan, MaCH, NgVaoO)
VALUES ('CD0036', 'Nguyen Van A', 'Nam', '0912678098', '1990-01-01', 'Hanoi', 'CH001', '2024-01-01');
SELECT MatKhau FROM CuDan WHERE MaCD = 'CD0036';

-- 2. Trigger mã hóa mật khẩu nhân viên
-- Khi insert
DELIMITER //
CREATE TRIGGER I_NV_MaHoa
BEFORE INSERT ON NhanVien
FOR EACH ROW
BEGIN
    -- Tạo giá trị ngẫu nhiên của salt
    DECLARE p_salt CHAR(36);
    DECLARE p_MatKhau BLOB;
    
	SET p_MatKhau = CONCAT(LPAD(DAY(NEW.NgSinh), 2, 0), LPAD(MONTH(NEW.NgSinh), 2, 0), YEAR(NEW.NgSinh));
    SET p_salt = UUID(); 
    
    -- Gán giá trị salt
    SET NEW.salt = p_salt;
    
    -- Mã hóa mật khẩu với AES_ENCRYPT với key là MaNV
    SET p_MatKhau = AES_ENCRYPT(CONCAT(p_MatKhau, p_salt), NEW.MaNV);
    
    -- Mã hóa mật khẩu đã mã hóa bằng SHA2
    SET NEW.MatKhau = SHA2(p_MatKhau, 256);
END //
DELIMITER ;

-- Khi update
DELIMITER //
CREATE TRIGGER U_NV_MaHoa
BEFORE UPDATE ON NhanVien
FOR EACH ROW
BEGIN
    -- Tạo giá trị ngẫu nhiên của salt
    DECLARE p_salt CHAR(36);
    DECLARE p_MatKhau BLOB;
    
IF OLD.MatKhau <> NEW.MatKhau THEN

	-- Tạo giá trị salt ngẫu nhiên
    SET p_salt = UUID(); 
    
    -- Gán giá trị salt
    SET NEW.salt = p_salt;
    
    -- Mã hóa mật khẩu với AES_ENCRYPT với key là MaCD
    SET p_MatKhau = AES_ENCRYPT(CONCAT(NEW.MatKhau, p_salt), NEW.MaNV);
    
    -- Mã hóa mật khẩu đã mã hóa bằng SHA2
    SET NEW.MatKhau = SHA2(p_MatKhau, 256);
END IF;
END //
DELIMITER ;

-- Hàm xác thực mật khẩu
DELIMITER //
CREATE FUNCTION XacThuc_MK_CD (p_MaCD CHAR(6), p_MatKhau CHAR(255))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
	DECLARE p_MaHoa CHAR(255);
    DECLARE p_salt CHAR(255);
    DECLARE p_MK CHAR(255);
    
    SELECT salt, MatKhau INTO p_salt, p_MK
    FROM CuDan
    WHERE MaCD = p_MaCD;
    SET p_MaHoa = SHA2(AES_ENCRYPT(CONCAT(p_MatKhau, p_salt), p_MaCD), 256);
    IF (p_MaHoa = p_MK) THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END //
DELIMITER ;

SELECT XacThuc_MK_CD('CD0036', '01011990');
SELECT XacThuc_MK_CD('CD0036', '1011990');

-- Hàm xác thực mật khẩu cho nhân viên
DELIMITER //
CREATE FUNCTION XacThuc_MK_NV (p_MaNV CHAR(6), p_MatKhau CHAR(255))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
	DECLARE p_MaHoa CHAR(255);
    DECLARE p_salt CHAR(255);
    DECLARE p_MK CHAR(255);
    
    SELECT salt, MatKhau INTO p_salt, p_MK
    FROM NhanVien
    WHERE MaNV = p_MaNV;
    SET p_MaHoa = SHA2(AES_ENCRYPT(CONCAT(p_MatKhau, p_salt), p_MaNV), 256);
    IF (p_MaHoa = p_MK) THEN
		RETURN TRUE;
	ELSE
		RETURN FALSE;
	END IF;
END //
DELIMITER ;
