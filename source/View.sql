-- CÀI ĐẶT VIEW --
-- 1. Tổng số lượng căn hộ và số lượng căn hộ còn trống
CREATE VIEW View_SoLuongCanHo 
AS
	SELECT COUNT(*) AS TongCanHo, 
    SUM(TinhTrang = 1) AS CanHoTrong
	FROM CanHo;
    
-- Kiểm tra
SELECT * FROM View_SoLuongCanHo;

-- 2. Tổng số cư dân
CREATE VIEW View_SoLuongCuDan
AS
SELECT COUNT(*) AS TongCuDan,
       SUM(CASE WHEN MONTH(NgVaoO) 
       = MONTH(CURRENT_DATE()) AND YEAR(NgVaoO) 
       = YEAR(CURRENT_DATE()) THEN 1 ELSE 0 END) AS SoLuongCuDanMoiCuaThang
FROM CuDan;

-- Kiểm tra
SELECT * FROM View_SoLuongCuDan;

-- 3. Tổng số hóa đơn, Tổng chi phí hóa đơn, tổng hóa đơn đã thanh toán, tổng tiền đã thanh toán và dư nợ
CREATE VIEW View_TongChiPhiHoaDon 
AS
		SELECT 
			SUM(TriGia) AS TongChiPhiHoaDon,
			COUNT(*) AS TongHoaDon,
			SUM(TinhTrang = 2) AS HoaDonDaThanhToan,
			SUM(CASE WHEN TinhTrang = 2 THEN TriGia END) AS TongTienDaThanhToan,
			SUM(CASE WHEN TinhTrang = 1 THEN TriGia END) AS DuNo
		FROM HoaDon;

-- Kiểm tra
SELECT * FROM View_TongChiPhiHoaDon;

-- 4. Biểu đồ đường biểu diễn số lượng phản ánh của cư dân theo từng tháng
CREATE VIEW View_SoLuongPhanAnh
AS
		SELECT DATE_FORMAT(NgPA, '%m-%Y') AS Thang, COUNT(*) AS SoLuongPhanAnh
		FROM PhanAnh
		WHERE YEAR(NgPA) = YEAR(CURDATE())
		GROUP BY DATE_FORMAT(NgPA, '%m%Y')
		ORDER BY DATE_FORMAT(NgPA, '%m%Y');

-- Kiểm tra         
SELECT * FROM View_SoLuongPhanAnh;

-- 5. Biểu đồ tròn biểu diễn cơ cấu sử dụng từng loại dịch vụ
CREATE VIEW View_SoLuongDichVu
AS
	SELECT TenDV, COUNT(*) AS SoLuong
	FROM HoaDon
	JOIN DichVu ON HoaDon.MaDV = DichVu.MaDV
	GROUP BY DichVu.MaDV;

-- Kiểm tra 
SELECT * FROM View_SoLuongDichVu;

-- 6. Biểu đồ biểu diễn cơ cấu chi phí bỏ ra cho các dịch vụ
CREATE VIEW View_ChiPhiDichVu
AS
	SELECT DV.TenDV, SUM(HD.TriGia) AS TongChiPhi
	FROM HoaDon HD
	INNER JOIN DichVu DV ON HD.MaDV = DV.MaDV
	GROUP BY DV.MaDV, DV.TenDV;

-- Kiểm tra 
SELECT * FROM View_ChiPhiDichVu;

-- 7. Biểu đồ đường biểu diễn cư dân mới được thêm vào mỗi tháng trong 12 tháng đổ lại
CREATE VIEW View_CuDanMoiTheoThang
AS
	SELECT DATE_FORMAT(NgVaoO, '%m-%Y') AS Thang, COUNT(*) AS SoLuong
	FROM CuDan
	WHERE NgVaoO >= DATE_SUB(CURRENT_DATE(), INTERVAL 12 MONTH)
	GROUP BY YEAR(NgVaoO), MONTH(NgVaoO)
	ORDER BY DATE_FORMAT(NgVaoO, '%m-%Y');

-- Kiểm tra 
SELECT * FROM View_CuDanMoiTheoThang;

-- 8. Lập báo cáo hóa đơn (Mã hộ, tên chủ hộ, mã hóa đơn, trị giá, tình trạng)
CREATE VIEW View_BaoCaoHoaDon
AS
	SELECT CD.MaCH, CD.TenCD AS ChuHo, HD.TenHD, HD.TriGia, HD.NgHD,
		CASE 
			WHEN HD.TinhTrang = 1 THEN 'Chưa thanh toán'
			WHEN HD.TinhTrang = 2 THEN 'Đã thanh toán'
		END AS TinhTrang
	FROM CuDan CD
	INNER JOIN HoaDon HD ON CD.MaCH = HD.MaCH
    INNER JOIN CanHo CH ON CH.ChuHo = CD.MaCD;
    
-- Kiểm tra 
SELECT * FROM View_BaoCaoHoaDon;
 
-- 9. Lập báo cáo phụ trách dịch vụ hóa đơn (MaHD, MaNV, TenNV, TenDV)
CREATE VIEW View_BaoCaoPhuTrachDichVuHoaDon
AS
	SELECT HD.MaHD, NV.MaNV, NV.TenNV, DV.TenDV
	FROM NhanVien NV, HoaDon HD, DichVu DV, PhuTrach PT
	WHERE HD.MaHD = PT.MaHD AND HD.MaDV = DV.MaDV AND NV.MaNV = PT.MaNV;

-- Kiểm tra 
SELECT * FROM View_BaoCaoPhuTrachDichVuHoaDon;
 
-- 10. Biểu đồ thể hiện top 3 loại căn hộ được sử dụng nhiều nhất.
CREATE VIEW View_Top3CanHo
AS
	SELECT LoaiCH, COUNT(*) AS SoLuong
	FROM CanHo
	WHERE TinhTrang = 2
	GROUP BY LoaiCH
	ORDER BY SoLuong DESC
	LIMIT 3;

-- Kiểm tra 
SELECT * FROM View_Top3CanHo;

-- 11. Lập báo cáo các hộ cư dân quá hạn thanh toán hóa đơn (thời hạn thanh toán là 15 ngày kể từ khi có hóa đơn)
CREATE VIEW View_BaoCaoHoaDonQuaHan
AS
	SELECT CD.MaCH, CD.TenCD AS ChuHo, HD.MaHD, HD.TenHD, HD.TriGia,
    DATEDIFF(CURRENT_DATE(), HD.NgHD) AS SoNgayQuaHan
	FROM CuDan CD
	INNER JOIN HoaDon HD ON HD.MaCH = CD.MaCH
    INNER JOIN CanHo CH ON CH.ChuHo = CD.MaCD
	WHERE HD.TinhTrang = 1 AND DATEDIFF(CURRENT_DATE(), HD.NgHD) > 15;

-- Kiểm tra 
SELECT * FROM View_BaoCaoHoaDonQuaHan;


-- 12. Biểu đồ cột ghép tình trạng thanh toán hóa đơn của các tháng
CREATE VIEW View_TinhTrangThanhToan 
AS
    SELECT 
        DATE_FORMAT(HD.NgHD, '%m-%Y') AS Thang,
        SUM(TinhTrang = 1) AS 'Chưa thanh toán',
        SUM(TinhTrang = 2) AS 'Đã thanh toán'
    FROM HoaDon HD
    GROUP BY DATE_FORMAT(HD.NgHD, '%m-%Y');

-- Kiểm tra 
SELECT * FROM View_TinhTrangThanhToan;

-- 13. Số lượng cư dân theo giới tính
CREATE VIEW View_SoLuongGioiTinh
AS
	SELECT 
		SUM(GioiTinh = 'Nam') AS 'Nam',
        SUM(GioiTinh = 'Nữ') AS 'Nữ'
	FROM CuDan CD;

-- Kiểm tra 
SELECT * FROM View_SoLuongGioiTinh;

-- 14. View ẩn thông tin cho Nhân viên
CREATE VIEW  View_ThongTin_NhanVien AS
SELECT MaNV, TenNV, GioiTinh, SDT, DiaChi, NgVL, LoaiNV 
FROM NhanVien;

-- Vaitro QuanLy
REVOKE SELECT ON QLCHUNGCU.NhanVien FROM VaiTro_QuanLy;
GRANT SELECT ON QLCHUNGCU.View_ThongTin_NhanVien TO VaiTro_QuanLy;

-- Vaitro NhanVien
REVOKE SELECT ON QLCHUNGCU.NhanVien FROM VaiTro_NhanVien;
GRANT SELECT ON QLCHUNGCU.View_ThongTin_NhanVien TO VaiTro_NhanVien;

-- View ẩn thông tin cho Cư dân
CREATE VIEW  View_ThongTin_CuDan 
AS
	SELECT MaCD, TenCD, GioiTinh, SDT, NgSinh, QueQuan, MaCH, NgVaoO 
	FROM CuDan;

-- Vaitro Cư dân
REVOKE SELECT ON QLCHUNGCU.CuDan FROM VaiTro_CuDan;
GRANT SELECT ON QLCHUNGCU.View_ThongTin_CuDan TO VaiTro_CuDan;

-- 15. View xem danh sách chi tiết các căn hộ theo tầng và tòa.
CREATE VIEW View_DanhSach_CanHo_TheoTang_TheoToa 
AS
	SELECT toa.TenToa, tang.TenTang, ch.MaCH, ch.LoaiCH, ch.DienTich, ch.Gia
	FROM CanHo ch
	JOIN Tang tang ON ch.MaTang = tang.MaTang
	JOIN Toa toa ON tang.MaToa = toa.MaToa
	ORDER BY toa.TenToa, tang.TenTang, ch.MaCH;

-- Kiểm tra 
SELECT * FROM View_DanhSach_CanHo_TheoTang_TheoToa;

-- 16. View tính toán tổng số thiết bị được bố trí theo từng tòa
CREATE VIEW View_TongSoThietBi_TheoToa 
AS
    SELECT t.MaToa, SUM(bt.SL) AS TongSoThietBi
    FROM Toa t
    JOIN Tang tg ON t.MaToa = tg.MaToa 
    JOIN BoTri bt ON tg.MaTang = bt.MaTang
    GROUP BY t.MaToa;

-- Kiểm tra 
SELECT * FROM View_TongSoThietBi_TheoToa; 
