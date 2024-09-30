-- CÀI ĐẶT FUNCTION --
-- 1. Tính số căn hộ dựa trên mã tầng và loại căn hộ.
DELIMITER //
CREATE FUNCTION FT_SoCanHo(p_MaTang CHAR(7), p_LoaiCH VARCHAR(10))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE SL INT;
    
    SELECT COUNT(MaCH) INTO SL
    FROM CanHo
    WHERE LoaiCH = p_LoaiCH AND MaTang=p_MaTang;
    
    RETURN SL;
END //
DELIMITER ;

-- Kiểm tra FT_SoCanHo
SELECT FT_SoCanHo('C05', 'Penthouse');

-- 2. Tính tổng số căn hộ trống của 1 tòa nhà
DELIMITER //
CREATE FUNCTION FT_SoPhongTrong(p_MaToa CHAR(6)) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE SL INT;
    
    SELECT COUNT(MaCH) INTO SL
    FROM CanHo CH 
    JOIN TANG ON CH.MaTang = TANG.MaTang
    JOIN TOA ON TANG.MaToa = TOA.MaToa
    WHERE TOA.MaToa = p_MaToa AND TinhTrang=1;
    RETURN SL;
END //
DELIMITER ;

-- Kiểm tra FT_SoPhongTrong
SELECT FT_SoPhongTrong('TOA002');

-- 3. Tính tổng số lượng cư dân của tòa nhà.  
DELIMITER //
CREATE FUNCTION FT_SLCuDan_Toa(p_MaToa CHAR(6)) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE SL INT;
    
    SELECT COUNT(distinct MaCD) INTO SL
    FROM CuDan CD, CanHo CH, Tang T
    WHERE T.MaToa = p_MaToa AND CD.MaCH = CH.MaCH AND CH.MaTang = T.MaTang;
    
    RETURN SL;
END //
DELIMITER ;

-- Kiểm tra FT_SLCuDan_Toa
SELECT FT_SLCuDan_Toa('TOA001');

-- 4.Tính tổng số lượng cư dân của chung cư.
DELIMITER //
CREATE FUNCTION FT_SLCuDan() 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE SL INT;
    
    SELECT COUNT(MaCD) INTO SL
    FROM CuDan;
    
    RETURN SL;
END //
DELIMITER ;

-- Kiểm tra
SELECT FT_SLCuDan();

-- 5. Tính tổng chi phí trong 1 tháng của 1 căn hộ
DELIMITER //

CREATE FUNCTION FT_TongChiPhi_CanHo(p_MaCH CHAR(6), p_Thang INT, p_Nam INT)
RETURNS DECIMAL(12, 2)
DETERMINISTIC
BEGIN
    DECLARE CHIPHI DECIMAL(12, 2);
    
    SELECT COALESCE(SUM(TriGia), 0.00)
    INTO CHIPHI
    FROM HoaDon HD
    WHERE HD.MaCH = p_MaCH AND MONTH(HD.NgHD) = p_Thang AND YEAR(HD.NgHD) = p_Nam; 
    
    RETURN CHIPHI;
END //

DELIMITER ;

-- Kiểm tra
SELECT FT_TongChiPhi_CanHo('CH001', 4, 2024);

-- 6. Tính tổng trị giá hóa đơn với tình trạng chưa thanh toán của cư dân.
DELIMITER //
CREATE FUNCTION FT_TongHDChuaTT_CuDan(p_MaCD CHAR(6))
RETURNS DECIMAL(12, 2)
DETERMINISTIC
BEGIN
    DECLARE CHIPHI DECIMAL(12, 2);
    
    SELECT SUM(TriGia) INTO CHIPHI
    FROM HoaDon HD
    JOIN CuDan CD ON CD.MaCH = HD.MaCH
	WHERE CD.MaCD = p_MaCD 
		AND TinhTrang = 1;
    RETURN CHIPHI;
END //
DELIMITER ;

-- Kiểm tra
SELECT FT_TongHDChuaTT_CuDan('CD0001');
