-- TRIGGER -- 

-- 1. Kiểm tra quyền hạn phụ trách của nhân viên.
DELIMITER //
CREATE TRIGGER TRG_KT_QuyenHan_NVPT
BEFORE INSERT ON PhuTrach
FOR EACH ROW
BEGIN
    DECLARE loaiNV VARCHAR(10);
    DECLARE maDV CHAR(6);

    SELECT LoaiNV INTO loaiNV
    FROM NhanVien
    WHERE MaNV = NEW.MaNV;
    
    SELECT MaDV INTO maDV
    FROM HoaDon HD
    WHERE MaHD = NEW.MaHD;

    IF (loaiNV = 'Lao công' AND maDV NOT IN ('DV01')) OR
	   (loaiNV = 'Bảo vệ' AND maDV NOT IN ('DV04', 'DV05')) OR 
       (loaiNV = 'Bảo trì' AND maDV NOT IN ('DV02', 'DV03')) OR 
       (loaiNV = 'Quản lý' AND maDV NOT IN ('DV06', 'DV07')) THEN 
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Nhân viên không được phân công đúng nhiệm vụ!';
    END IF;
END//
DELIMITER ;

-- 2. Tự động cập nhật trị giá của hóa đơn.

-- Khi sửa 1 hóa đơn
DELIMITER //
CREATE TRIGGER TRG_HoaDon_UP
BEFORE UPDATE ON HoaDon
FOR EACH ROW
BEGIN
    -- Tính TriGia = PhiPS + (SELECT PhiDV FROM DichVu WHERE MaDV = NEW.MaDV)
    SET NEW.TriGia = NEW.PhiPS + (SELECT PhiDV FROM DichVu WHERE MaDV = NEW.MaDV);
END //
DELIMITER ;

-- Khi thêm 1 hóa đơn.
DELIMITER //
CREATE TRIGGER TRG_HoaDon_IN
BEFORE INSERT ON HoaDon
FOR EACH ROW
BEGIN
    -- Tính TriGia = PhiPS + (SELECT PhiDV FROM DichVu WHERE MaDV = NEW.MaDV)
    SET NEW.TriGia = NEW.PhiPS + (SELECT PhiDV FROM DichVu WHERE MaDV = NEW.MaDV);
END //
DELIMITER ;

-- Khi Update PhiDV
DELIMITER // 
CREATE TRIGGER TRG_DichVu_UP
AFTER UPDATE ON DichVu
FOR EACH ROW
BEGIN
    -- Cập nhật TriGia cho tất cả các hóa đơn có MaDV bị thay đổi
    UPDATE HoaDon
    SET TriGia = PhiPS + NEW.PhiDV
    WHERE MaDV = NEW.MaDV;
END //
DELIMITER ;

-- Kiểm tra
							-- Thêm dữ liệu 
INSERT INTO HoaDon (MaHD, TenHD, NgHD, PhiPS, TinhTrang, GhiChu, MaDV, MaCH) VALUES
    ('HD040', 'Hóa đơn điện nước', '2024-06-01 00:00:00', 800000, 1, NULL, 'DV06', 'CH002'),
	('HD041', 'Hóa đơn bảo dưỡng', '2024-06-01 00:00:00', 150000, 1, 'Thay 2 bóng đèn', 'DV02', 'CH002');

							-- Kiểm tra
SELECT * FROM HoaDon WHERE MaHD IN ('HD040', 'HD041');

							-- Cập nhật dữ liệu
UPDATE HoaDon SET PhiPS = '900000' WHERE MaHD = 'HD040';
UPDATE HoaDon SET PhiPS = '100000' WHERE MaHD = 'HD041';

							-- Kiểm tra
SELECT * FROM HoaDon WHERE MaHD IN ('HD040', 'HD041');

-- 3. Xóa một cư dân sẽ xóa các thông tin liên quan đến cư dân đó.
DELIMITER //
CREATE TRIGGER TRG_Xoa_CD 
BEFORE DELETE ON CUDAN
FOR EACH ROW
BEGIN
    DECLARE v_MaCD CHAR(6);
    SET v_MaCD = OLD.MaCD;
    DELETE FROM TB_CD WHERE MaCD = v_MaCD;
    DELETE FROM PhanAnh WHERE MaCD = v_MaCD;
    UPDATE CanHo SET ChuHo = NULL WHERE ChuHo = v_MaCD;
END //
DELIMITER ;

-- Kiểm tra
-- Trước khi xóa CD0030
SELECT * FROM PhanAnh 
WHERE MaCD = 'CD0030'

-- Xóa CD0030
DELETE FROM CUDAN
WHERE MaCD = 'CD0030'

-- Sau khi xóa CD0030
SELECT * FROM PhanAnh 
WHERE MaCD = 'CD0030'

-- 4. Cập nhật trạng thái căn hộ khi có người chuyển đến.
DELIMITER //
CREATE TRIGGER TRG_TTCanHo_UP
AFTER INSERT ON CuDan
FOR EACH ROW
BEGIN
	UPDATE CanHo
	SET TinhTrang = 2 -- Cập nhật trạng thái căn hộ sang "Đang có người sử dụng"
	WHERE MaCH = (SELECT MaCH FROM CuDan WHERE MaCD = New.MaCD);
END //
DELIMITER ;

-- Kiểm tra
-- Xem tình trạng của một căn hộ
SELECT * FROM CanHo WHERE MaCH = 'CH012';

-- Cập nhật cư dân vào căn hộ
INSERT INTO CuDan VALUES('CD0033', 'Hoàng Thanh Sơn', 'Nam', '0568232212', '2004-05-12', 'Hà Nội', 'CH012', '2024-06-10');  

-- Cập nhật chủ hộ
UPDATE CanHo
SET ChuHo = 'CD0033'
WHERE MaCH = 'CH012'

-- Tình trạng căn hộ đã được thay đổi sang "Đang có người sử dụng"
SELECT * FROM CanHo WHERE MaCH = 'CH012'

-- 5. Tự động cập nhật số lượng thiết bị trong kho khi có thiết bị được lắp đặt
-- Khi thêm
DELIMITER //
CREATE TRIGGER TRG_SLTbi_IN
AFTER INSERT ON BoTri
FOR EACH ROW
BEGIN
  UPDATE ThietBi
  SET SL = SL - NEW.SL
  WHERE MaTBi = (SELECT DISTINCT MaTBi FROM BoTri WHERE MaTBi = NEW.MaTBi);
END //
DELIMITER ;

-- Khi sửa
DELIMITER //
CREATE TRIGGER TRG_SLTbi_UP
AFTER UPDATE ON BoTri
FOR EACH ROW
BEGIN
  UPDATE ThietBi
  SET SL = SL - (NEW.SL - OLD.SL)
  WHERE MaTBi = (SELECT DISTINCT MaTBi FROM BoTri WHERE MaTBi = NEW.MaTBi);
END //
DELIMITER ;

-- Khi xóa
DELIMITER //
CREATE TRIGGER TRG_SLTbi_DE
AFTER DELETE ON BoTri
FOR EACH ROW
BEGIN
  UPDATE ThietBi
  SET SL = SL + OLD.SL
  WHERE MaTBi = (SELECT DISTINCT MaTBi FROM BoTri WHERE MaTBi = OLD.MaTBi);
END // 
DELIMITER ;

-- Kiểm tra
SELECT TBi.MaTBi, TBi.SL AS 'Ton kho', BT.MaTang, BT.SL AS 'Da bo tri' 
FROM ThietBi Tbi JOIN BoTri BT ON Tbi.MaTBi = BT.MaTBi;

			-- Thêm dữ liệu
INSERT INTO BoTri VALUES ('TBi002', 'A06', 2);
INSERT INTO BoTri VALUES ('TBi004', 'A05', 11);

			-- Cập nhật dữ liệu
UPDATE BoTri SET SL = 35 WHERE MaTBi = 'TBi003' AND MaTang = 'C05';
UPDATE BoTri SET SL = 3 WHERE MaTBi = 'TBi002' AND MaTang = 'A02';

			-- Xóa dữ liệu
DELETE FROM BoTri WHERE MaTBi = 'TBi002' AND MaTang = 'A06';
DELETE FROM BoTrI WHERE MaTBi = 'TBi004' AND MaTang = 'A05';


-- 6. Giới hạn số lượng người ở trong một căn hộ 
DELIMITER //
CREATE TRIGGER TRG_GioiHan_CanHo
BEFORE INSERT ON CuDan
FOR EACH ROW
BEGIN
    DECLARE v_LoaiCH VARCHAR(10);
    DECLARE v_SoThanhVien INT;
    DECLARE v_SoThanhVien_Moi INT;

    -- Lấy loại căn hộ
    SELECT LoaiCH INTO v_LoaiCH FROM CanHo WHERE MaCH = NEW.MaCH;

    -- Lấy số thành viên hiện tại (nếu cập nhật)
    IF NEW.MaCD IS NOT NULL THEN
        SELECT COUNT(*) INTO v_SoThanhVien FROM CuDan WHERE MaCH = NEW.MaCH;
    ELSE
        SET v_SoThanhVien = 0;
    END IF;

    -- Tính toán số thành viên mới
    SET v_SoThanhVien_Moi = v_SoThanhVien + 1;

    -- Kiểm tra giới hạn dựa trên loại căn hộ
    IF (v_LoaiCH = 'Basic 1' AND v_SoThanhVien_Moi > 2) OR
	(v_LoaiCH = 'Basic 2' AND v_SoThanhVien_Moi > 4) OR
	(v_LoaiCH = 'Basic 3' AND v_SoThanhVien_Moi > 6) OR
	(v_LoaiCH = 'Basic 4' AND v_SoThanhVien_Moi > 8) THEN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Căn hộ vượt quá số thành viên quy định!';
    END IF;
END //

-- Kiểm tra thử số cư dân có trong các căn hộ ở hiện tại
SELECT CH.MaCH, CH.LoaiCH, COUNT(*) AS SoLuongCuDan
FROM CanHo CH JOIN CuDan CD ON CH.MaCH = CD.MaCH
GROUP BY CH.MaCH, CH.LoaiCH

-- Thử thêm các cư dân mới vào các căn hộ
INSERT INTO CuDan VALUES ('CD0035', 'Huỳnh Văn Thiệu', 'Nam', '0871238871', '1972-07-20', 'Phú Yên', 'CH001', '2024-06-10');
INSERT INTO CuDan VALUES ('CD0036', 'Trần Nhật Trường', 'Nam', '0888888888', '1992-11-03', 'Long An', 'CH002', '2024-06-10');
INSERT INTO CuDan VALUES ('CD0034', 'Trịnh Thị Phương Quỳnh', 'Nữ', '0336278378', '1975-05-15', 'Bình Phước', 'CH008', '2024-06-10');


-- 7.Kiểm tra số lượng thiết bị không vượt quá số lượng có sẵn trong bảng ThietBi khi thêm, cập nhật vào bảng BoTri

-- Khi thêm
DELIMITER //
CREATE TRIGGER TRG_Check_SoLuong_ThietBi_IN
AFTER INSERT ON BoTri
FOR EACH ROW
BEGIN
    DECLARE SL_Tong INT;

    -- Lấy tổng số lượng thiết bị có sẵn trong kho
    SELECT SL INTO SL_Tong
    FROM ThietBi
    WHERE MaTBi = NEW.MaTBi;

    -- Kiểm tra nếu số lượng cần bố trí vượt quá số lượng có sẵn trong kho
    IF NEW.SL > SL_Tong THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng thiết bị không đủ để bố trí!';
    END IF;
END //
DELIMITER ;

-- Khi sửa
DELIMITER //
CREATE TRIGGER TRG_Check_SoLuong_ThietBi_UP
AFTER UPDATE ON BoTri
FOR EACH ROW
BEGIN
    DECLARE SL_Tong INT;

    -- Lấy tổng số lượng thiết bị có sẵn trong kho
    SELECT SL INTO SL_Tong
    FROM ThietBi
    WHERE MaTBi = NEW.MaTBi;

    -- Kiểm tra nếu số lượng cần bố trí thêm có vượt quá số lượng có sẵn trong kho hay không
    IF (NEW.SL - OLD.SL) > SL_Tong THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng thiết bị không đủ để bố trí!';
    END IF;
END //
DELIMITER ;

-- Kiểm tra 
SELECT TBi.MaTBi, TBi.SL AS 'Ton kho', BT.MaTang, BT.SL AS 'Da bo tri' 
FROM ThietBi Tbi JOIN BoTri BT ON Tbi.MaTBi = BT.MaTBi

			-- Thêm dữ liệu
INSERT INTO BoTri VALUES ('TBi002', 'A06', 2)
INSERT INTO BoTri VALUES ('TBi004', 'A05', 30)

			-- Cập nhật dữ liệu
UPDATE BoTri SET SL = 20 WHERE MaTBi = 'TBi004' AND MaTang = 'B03'
UPDATE BoTri SET SL = 30 WHERE MaTBi = 'TBi004' AND MaTang = 'C06'
