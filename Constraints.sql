-- TẠO RÀNG BUỘC TOÀN VẸN--

-- 1. Giới tính của nhân viên chỉ có thể là 'Nam' hoặc 'Nữ'.
ALTER TABLE NhanVien
ADD CONSTRAINT CK_NV_GIOITINH CHECK (GioiTinh IN ('Nam', 'Nữ'));
-- 2. Loại nhân viên chỉ có thể là 'Bảo vệ', 'Lao công', 'Bảo trì', 'Quản lý', 'BQT', 'Kế toán', 'Tư vấn'
 ALTER TABLE NhanVien
 ADD CONSTRAINT CK_NV_LOAINV CHECK (LoaiNV IN ('Bảo vệ', 'Lao công', 'Bảo trì', 'Quản lý', 'BQT', 'Kế toán', 'Tư vấn'));
-- 3. Tình trạng chỉ có thể là 1 (Chưa thanh toán), 2 (Đã thanh toán).
ALTER TABLE HoaDon
ADD CONSTRAINT CK_HD_TINHTRANG CHECK (TinhTrang IN ('1', '2'));
-- 4. Tổng giá trị của hóa đơn không được nhỏ hơn 0.
ALTER TABLE HoaDon
ADD CONSTRAINT CK_HD_TRIGIA CHECK (TriGia >= 0); 
-- 5. Giới tính cư dân chỉ có thể là 'Nam' hoặc 'Nữ'.
ALTER TABLE CuDan
ADD CONSTRAINT CK_CD_GIOITINH CHECK (GioiTinh IN ('Nam', 'Nữ'));
-- 6. Diện tích phải lớn hơn 0.
ALTER TABLE CanHo
ADD CONSTRAINT CK_CH_DIENTICH CHECK (DienTich > 0);
-- 7. Tình trạng chỉ có thể là 1 (Trống), 2 (Đang sử dụng).
ALTER TABLE CanHo
ADD CONSTRAINT CK_CH_TINHTRANG CHECK (TinhTrang IN ('1', '2'));
-- 8. Giá thuê phải lớn hơn 0.
ALTER TABLE CanHo
ADD CONSTRAINT CK_CH_GIA CHECK (Gia > 0);
-- 9. Phí dịch vụ không được nhỏ hơn 0.
ALTER TABLE DichVu
ADD CONSTRAINT CK_DV_PHIDV CHECK (PhiDV >= 0);
-- 10. Chi phí phát sinh không thể nhỏ hơn 0.
ALTER TABLE HoaDon
ADD CONSTRAINT CK_HD_PHIPS CHECK (PhiPS >= 0);
-- 11. Số tầng phải lớn hơn 0.
ALTER TABLE Toa
ADD CONSTRAINT CK_TOA_SOTANG CHECK (SoTang > 0);
-- 12. Tình trạng của phản ánh chỉ có thể là 1 (Mới), 2 (Đang xử lý), 3 (Hoàn thành).
ALTER TABLE PhanAnh
ADD CONSTRAINT CK_PA_TINHTRANG CHECK (TinhTrang IN (1, 2, 3));
