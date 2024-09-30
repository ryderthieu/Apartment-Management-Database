 -- CÀI ĐẶT THỦ TỤC LƯU TRỮ --
 
 -- 1. In ra danh sách cư dân của chung cư. 
DELIMITER //
CREATE PROCEDURE SP_In_DS_Cudan()
BEGIN
    SELECT MaCD, TenCD, GioiTinh, SDT, NgSinh, QueQuan, MaCH, NgVaoO 
    FROM CuDan
    ORDER BY MaCD;
END //
DELIMITER ;

-- Kiểm tra
CALL SP_In_DS_Cudan()


-- 2. In ra danh sách hóa đơn của một căn hộ
DELIMITER //
CREATE PROCEDURE  SP_In_DSHoadon_CanHo (p_MaCH CHAR(6))
BEGIN
    SELECT HD.*
    FROM HoaDon HD
    WHERE HD.MaCH = p_MaCH;
END //
DELIMITER ;

-- Kiểm tra
CALL SP_In_DSHoadon_CanHo('CH001')

-- 3. In ra danh sách cư dân sống trong căn hộ. 
DELIMITER //
CREATE PROCEDURE  SP_In_DSCuDan_CanHo(p_MaCH CHAR(6))
BEGIN
	SELECT MaCH, TenCD, GioiTinh, SDT, NgSinh, QueQuan
	FROM CuDan CD
	WHERE CD.MaCH = p_MaCH;
END //
DELIMITER ;

-- Kiểm tra
CALL SP_In_DSCuDan_CanHo('CH001')

-- 4. In danh sách nhân viên theo từng loại nhân viên. 
DELIMITER //
CREATE PROCEDURE  SP_In_DSNV_LoaiNV(p_LoaiNV VARCHAR(10))
BEGIN
	SELECT MaNV, TenNV, GioiTinh, NgSinh, SDT, DiaChi, NgVL, LoaiNV
	FROM NhanVien 
	WHERE LoaiNV = p_LoaiNV;
END //
DELIMITER ;

-- Kiểm tra
CALL  SP_In_DSNV_LoaiNV('Bảo vệ')

-- 5. In ra các căn hộ chưa thanh toán hóa đơn. 
DELIMITER //
CREATE PROCEDURE SP_In_DSCanHo_ChuaThanhToanHD()
BEGIN
	SELECT MaCH, MaHD, TriGia, TinhTrang 
	FROM HoaDon HD
	WHERE HD.TinhTrang = 1;
END //
DELIMITER ;

-- Kiểm tra
CALL  SP_In_DSCanHo_ChuaThanhToanHD()

-- 6. Cập nhật thông tin căn hộ.                    
DELIMITER //
CREATE PROCEDURE SP_CapNhatTT_CanHo(MaCH CHAR(6), LoaiCH VARCHAR(10), MoTa TEXT, DienTich DECIMAL(5, 2), Gia DECIMAL(14, 2), ChuHo CHAR(6))
BEGIN
	UPDATE CanHo
	SET LoaiCH = LoaiCH,
    	MoTa = MoTa,
    	DienTich = DienTich,
    	Gia = Gia,
        ChuHo = ChuHo
	WHERE MaCH = MaCH;
END //
DELIMITER ;

-- Kiểm tra
CALL  SP_CapNhatTT_CanHo ('CH001', 'Basic 4', 'Căn hộ thông thường 4 phòng ngủ, có ban công hướng Nam', 119.5, 5000000000, 'A01', 2)

-- 7. Tìm thông báo theo ngày. 
DELIMITER //
CREATE PROCEDURE SP_TimThongBao_Ngay (IN p_NgTB DATE)
BEGIN
    SELECT TB.*
    FROM ThongBao TB
    WHERE DATE(NgTB) = p_NgTB;
END //
DELIMITER ;

-- Kiểm tra
CALL  SP_TimThongBao_Ngay('2024-02-10')

-- 8. Tìm tất cả thông tin của các cư dân theo mã cư dân . 
DELIMITER //
CREATE PROCEDURE SP_In_TTCuDan_MaCD(IN p_MaCD CHAR(6))
BEGIN
    SELECT MaCD, TenCD, GioiTinh, SDT, NgSinh, QueQuan, MaCH, NgVaoO 
    FROM CuDan
    WHERE MaCD = p_MaCD;
END //
DELIMITER ;

-- Kiểm tra
CALL SP_TTCuDan_MaCD('CD0001')


-- 9. Gửi thông báo cho tất cả các thành viên trong căn hộ
DELIMITER //

CREATE PROCEDURE SP_GuiThongBaoChoCanHo(IN p_MaTB CHAR(6), IN p_MaCH CHAR(6))
BEGIN
    INSERT INTO TB_CD (MaTB, MaCD)
    SELECT p_MaTB, MaCD
    FROM CuDan
    WHERE MaCH = p_MaCH;
END//
DELIMITER ;

-- Kiểm tra
CALL SP_GuiThongBaoChoCanHo('TB006','CH004')

-- 10. Gửi thông báo cho tất cả các căn hộ   
DELIMITER //
CREATE PROCEDURE SP_GuiThongBaoChoTatCaCanHo(IN p_MaTB CHAR(6))
BEGIN
    INSERT INTO TB_CD (MaTB, MaCD)
    SELECT p_MaTB, MaCD
    FROM CuDan;
END//
DELIMITER ;      

-- Kiểm tra
CALL SP_GuiThongBaoChoTatCaCanHo('TB006')
