# Apartment-Management-Database
## Thực trạng
Ngày nay, với sự phát triển của đô thị và nhu cầu an cư, các chung cư cao tầng
mọc lên khắp nơi, trở thành một phần không thể thiếu trong đời sống của người dân
thành thị. Tuy nhiên, việc quản lý chung cư vẫn còn đối mặt với nhiều thách thức, từ
việc duy trì chất lượng cơ sở vật chất đến việc quản lý cư dân và các hoạt động sinh
hoạt chung, cụ thể như sau:

- **Khó khăn trong việc lưu trữ và quản lý thông tin:** Thông tin về cư dân, quy
định, quản lý phí dịch vụ thường được lưu trữ một cách không có hệ thống, dẫn
đến khó khăn trong việc tìm kiếm, truy cập và bảo mật thông tin.

- **Khó khăn trong việc quản lý tài chính:** Việc quản lý các hóa đơn, phí dịch vụ
khi sử dụng các tiện ích chung thường thiếu sự minh bạch, khiến việc ra quyết
định không dựa trên dữ liệu chính xác, ảnh hưởng đến hiệu quả quản lý.

- **Khó khăn trong việc kiểm soát các thiết bị và cơ sở vật chất của chung cư:**
Việc bảo trì và kiểm soát chất lượng hệ thống các thiết bị phòng cháy chữa
cháy, hệ thống chiếu sáng, thang máy, phòng tập gym, khu vui chơi trẻ
em,...thường không được thực hiện đều đặn, dẫn đến tình trạng hỏng hóc,
không đảm bảo an toàn cho cư dân.

Để đạt được mức độ quản lý chung cư hiệu quả, cần có sự chuyên nghiệp hóa trong
quản lý, áp dụng công nghệ thông tin vào việc lưu trữ và xử lý dữ liệu. Để thực hiện
được điều này, đòi hỏi phải có một hệ thống quản lý chặt chẽ và hiệu quả, đảm bảo an
ninh, an toàn và đáp ứng nhu cầu sinh hoạt của cư dân, góp phần nâng cao chất lượng
cuộc sống và đảm bảo sự hài lòng của cư dân.
## Mục tiêu
Hệ thống quản lý chung cư được thiết kế để đáp ứng nhu cầu của các tòa nhà từ
nhỏ đến vừa và lớn, có khả năng phục vụ cho ban quản lý và cư dân. Hệ thống này
cung cấp một giao diện thân thiện, cho phép ban quản lý và cư dân dễ dàng truy cập và
quản lý thông tin liên quan đến việc vận hành và bảo trì tòa nhà, từ việc theo dõi phí
quản lý, giao tiếp với cư dân, đến việc đặt lịch và quản lý các tiện ích chung.
## Thiết kế bài toán
### Mô hình quan hệ ERD
![image](https://github.com/user-attachments/assets/7a8bda8d-a88b-4c5d-8a0f-54deade34445)
### Các thực thể
- **NhanVien:** Nhân viên làm việc tại chung cư. Họ chịu trách nhiệm đảm bảo an
ninh, an toàn và vệ sinh môi trường sống cho cư dân.

- **DichVu:** Dịch vụ cung cấp cho cư dân của chung cư. Các dịch vụ có thể bao
gồm dọn dẹp, thu gom rác, bảo trì, bảo dưỡng, gửi xe, bảo vệ 24/7, dịch vụ
quản lý và các dịch vụ khác (điện nước, Internet,...).

- **HoaDon:** Hóa đơn chi trả cho các dịch vụ của cư dân. Mỗi dịch vụ mà cư dân
sử dụng sẽ có hóa đơn riêng cho từng loại dịch vụ. Hóa đơn có thể được kết
toán hàng tháng, hàng quý hoặc theo quy định của ban quản lý.

- **CanHo:** Căn hộ trong chung cư. Mỗi căn hộ là một đơn vị nhà ở riêng biệt
trong chung cư, có thể có diện tích và số lượng phòng khác nhau, tùy thuộc vào
thiết kế của tòa nhà.

- **ThietBi:** Thiết bị thuộc sở hữu chung được lắp đặt trong các tầng của tòa nhà
như hệ thống thang máy, máy bơm nước, máy phát điện, hệ thống báo cháy tự
động, hệ thống chữa cháy, dụng cụ chữa cháy, các thiết bị dự phòng và các thiết
bị khác.

- **CuDan:** Cư dân cư trú tại chung cư. Là những người sống và sinh hoạt tại các
căn hộ trong chung cư. Họ có thể là chủ sở hữu căn hộ hoặc người thuê căn hộ.
Cư dân có quyền sử dụng các dịch vụ và tiện ích chung, và có trách nhiệm tuân
thủ các quy định của chung cư.

- **Toa:** Tòa nhà trong chung cư. Một tòa nhà trong chung cư có thể bao gồm
nhiều tầng và nhiều căn hộ. Tòa nhà có thể có các tiện ích chung như hầm để
xe, khu vực tiếp tân, khu vực sinh hoạt chung, và các tiện ích khác phục vụ cho
cư dân.

- **Tang:** Tầng của tòa nhà. Mỗi tầng có thể bao gồm nhiều căn hộ. Các tầng có
thể được đánh số hoặc đặt tên để dễ dàng nhận diện. Mỗi tầng có thể có các
khu vực chung như hành lang, khu vực thang máy, và các thiết bị thuộc sở hữu
chung được lắp đặt tại tầng đó.

- **ThongBao:** Thông báo từ ban quản lý đến cư dân. Gồm các thông tin quan
trọng mà ban quản lý muốn truyền đạt đến cư dân như là lịch cúp điện, các quy
định mới, họp tòa nhà,...

- **PhanAnh:** Phản ánh, khiếu nại từ cư dân đến ban quản lý. Phản ánh có thể bao
gồm các khiếu nại về dịch vụ, góp ý về các vấn đề liên quan đến cuộc sống
trong chung cư. Ban quản lý sẽ tiếp nhận, xử lý và phản hồi các phản ánh này
để cải thiện chất lượng dịch vụ và đảm bảo sự hài lòng của cư dân
### Danh sách Trigger
![image](https://github.com/user-attachments/assets/eb3c5230-146c-401e-8b5a-45c989569123)
### Danh sách Store Procedure
![image](https://github.com/user-attachments/assets/be7d9c0c-55f8-4f6e-a3fe-00cc5295b5ac)
### Danh sách Function
![image](https://github.com/user-attachments/assets/0ca27f50-28c3-4e2a-aa04-00e50b3fb497)
### Danh sách View
![image](https://github.com/user-attachments/assets/109abd79-211e-45fa-8feb-fa22ecbb4561)
## Hướng phát triển
Với sự phát triển không ngừng của công nghệ, nhóm chúng em nhận thấy rằng hệ
thống quản lý chung cư và các bài toán về quản lý chung cư rất có tiềm năng phát
triển mạnh mẽ trong tương lai. Vì vậy nhóm chúng em có các định hướng phát triển
như sau:
- Cải thiện độ chính xác của bài toán.
- Mở rộng thêm nhiều chức năng.
- Phát triển ứng dụng thực tế và đưa vào sử dụng.



