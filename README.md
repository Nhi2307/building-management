## Building Management - Hệ thống quản lý tòa nhà

## Giới thiệu
Hệ thống quản lý tòa nhà được xây dựng trong khuôn khổ đồ án môn Hệ quản trị cơ sở dữ liệu - Năm 3.  
Dự án tập trung vào việc thiết kế cơ sở dữ liệu và xây dựng các chức năng quản lý thông tin tòa nhà, cư dân và các hoạt động liên quan.

## Công nghệ sử dụng
- SQL Server
- WinForms

## Chức năng chính
- Quản lý thông tin căn hộ
- Quản lý cư dân  
- Quản lý hợp đồng mua/thuê
- Quản lý chi phí (điện, nước, phí dịch vụ)  
- Thống kê và truy vấn dữ liệu  

## Nhóm thực hiện
Nhóm 3 người
Môn: Hệ quản trị cơ sở dữ liệu - Đại học Công Thương TP.HCM
Năm học: 2025 - 2026 

## Cài đặt và chạy dự án
**Yêu cầu:** Yêu cầu: Visual Studio 2019/2022, SQL Server, SQL Server Management Studio (SSMS)

1. Clone repo về máy git clone 

2. Tạo database
- Mở SSMS  
- Tạo database mới (ví dụ: QL_CHUNGCU)  
- Mở file `database.sql` trong repo  
- Chạy toàn bộ script để tạo bảng và dữ liệu  

3. 
- Mở folder `/code` bằng Visual Studio  
- Cập nhật connection string phù hợp với SQL Server trên máy  
- Chạy project  

**Yêu cầu:** Visual Studio 2019/2022, SQL Server, SQL Server Management Studio (SSMS)

1. Clone repo về máy git clone https://github.com/Nhi2307/building-management.git

2. Tạo database
   - Mở SSMS, tạo database mới tên QL
   - Mở file .sql trong repo và chạy toàn bộ để tạo bảng và dữ liệu mẫu

3. Mở và chạy project
   - Mở file .sln bằng Visual Studio
   - Cập nhật connection string phù hợp với SQL Server trên máy 
   - Chuột phải vào Solution → Restore NuGet Packages
   - Nhấn Ctrl + F5 để chạy
