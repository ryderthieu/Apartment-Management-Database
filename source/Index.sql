 -- INDEX --

/*
Chỉ mục hoạt động hiệu quả trên các cột có tần suất truy cập cao ở các lệnh where hay join giúp các câu lệnh thực thi nhanh hơn.
*/
-- index trong bảng HoaDon
CREATE INDEX I_HoaDon_NgHD ON HoaDon(NgHD);

-- index trong bảng CanHo
CREATE INDEX I_CanHo_LoaiCH ON CanHo(LoaiCH);

-- index trong bảng CuDan
CREATE INDEX I_CuDan_TenCD ON CuDan(TenCD);

-- index trong bảng PhanAnh
CREATE INDEX I_PhanAnh_NgPA ON PhanAnh(NgPA);

-- index trong bảng ThongBao
CREATE INDEX I_ThongBao_NgTB ON ThongBao(NgTB);
