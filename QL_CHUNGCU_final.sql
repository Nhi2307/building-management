USE master;
IF DB_ID('QL_CHUNGCU') IS NOT NULL
    DROP DATABASE QL_CHUNGCU;
GO

CREATE DATABASE QL_CHUNGCU

USE QL_CHUNGCU

--=========================
-- TẠO BẢNG
--=========================

--1. Bảng TAIKKHOAN
CREATE TABLE TAIKHOAN (
    TenDangNhap NVARCHAR(50) PRIMARY KEY,
    MatKhau NVARCHAR(100),
    Quyen NVARCHAR(20) CHECK (Quyen IN ('Admin','CuDan'))
);

-- 2. Bảng CANHO
CREATE TABLE CANHO (
    MaCanHo CHAR(10) NOT NULL PRIMARY KEY,
    SoPhong INT,
    DienTich FLOAT,
    Tang INT,
    TrangThai NVARCHAR(50) CHECK (TrangThai IN (N'Trống',N'Đã được mua',N'Đã cho thuê')),
    LoaiCanHo NVARCHAR(50),
    Huong NVARCHAR(20),
    Block NVARCHAR(10) -- mã tòa nhà( tòa nhà A tòa nhà B)
);

-- 3. Bảng CU_DAN
CREATE TABLE CU_DAN (
    MaCD CHAR(10) NOT NULL PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    SDT VARCHAR(15),
    CCCD VARCHAR(20),
    Email VARCHAR(100),
    DiaChiThuongTru NVARCHAR(200)
);

-- 4. Bảng HOPDONG
CREATE TABLE HOPDONG (
    MaHDong CHAR(10) NOT NULL PRIMARY KEY,
    MaCanHo CHAR(10) NOT NULL,
    MaCD CHAR(10) NOT NULL,
	LoaiHopDong NVARCHAR(50) CHECK (LoaiHopDong IN (N'Mua', N'Thuê')),
    NgayKy DATE,
    NgayHetHan DATE,
    GiaTriHopDong DECIMAL(18,2),
    TrangThai NVARCHAR(50) CHECK (TrangThai IN (N'Còn hiệu lực', N'Hết hiệu lực')),
    FOREIGN KEY (MaCanHo) REFERENCES CANHO(MaCanHo),
    FOREIGN KEY (MaCD) REFERENCES CU_DAN(MaCD)
);

-- 5. Bảng NHANVIEN
CREATE TABLE NHANVIEN (
    MaNV CHAR(10) NOT NULL PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    ChucVu NVARCHAR(50),
    PhongBan NVARCHAR(50),
    SDT VARCHAR(15),
    Luong DECIMAL(18,2),
    NgayVaoLam DATE
);

-- 6. Bảng DICHVU
CREATE TABLE DICHVU (
    MaDV CHAR(10) NOT NULL PRIMARY KEY,
    TenDV NVARCHAR(100) NOT NULL,
    DonGia DECIMAL(18,2),
    DonViTinh NVARCHAR(50),
    MoTa NVARCHAR(200)
);

-- 7. Bảng SU_DUNG_DV
CREATE TABLE SU_DUNG_DV (
    MaSDDV CHAR(10) NOT NULL PRIMARY KEY,
    MaCanHo CHAR(10) NOT NULL,
    MaDV CHAR(10) NOT NULL,
    SoLuong FLOAT,
    ThangSuDung CHAR(7),
    ThanhTien DECIMAL(18,2),
    FOREIGN KEY (MaCanHo) REFERENCES CANHO(MaCanHo),
    FOREIGN KEY (MaDV) REFERENCES DICHVU(MaDV)
);

-- 8. Bảng HOADON
CREATE TABLE HOADON (
    MaHD CHAR(10) NOT NULL PRIMARY KEY,
    MaHDong CHAR(10) NOT NULL,
    NgayLap DATE,
    Thang CHAR(7),
    TongTien DECIMAL(18,2),
    TrangThai NVARCHAR(50) 
        CHECK (TrangThai IN (N'Đã thanh toán', N'Chưa thanh toán',N'Quá hạn')),
    FOREIGN KEY (MaHDong) REFERENCES HOPDONG(MaHDong)
);

-- 9. Bảng CT_HOADON
CREATE TABLE CT_HOADON (
    MaCTHD CHAR(10) NOT NULL PRIMARY KEY,
    MaHD CHAR(10) NOT NULL,
    MaDV CHAR(10) NOT NULL,
    SoLuong FLOAT,
    DonGia DECIMAL(18,2),
    ThanhTien DECIMAL(18,2),
    FOREIGN KEY (MaHD) REFERENCES HOADON(MaHD),
    FOREIGN KEY (MaDV) REFERENCES DICHVU(MaDV)
);

-- 10. Bảng SUCO
CREATE TABLE SUCO (
    MaSC CHAR(10) NOT NULL PRIMARY KEY,
    MaCanHo CHAR(10) NOT NULL,
    MaNV CHAR(10) NOT NULL,
    MoTa NVARCHAR(200),
    NgayBao DATE,
    TrangThai NVARCHAR(50)
        CHECK (TrangThai IN (N'Chưa xử lý', N'Đang xử lý', N'Đã xử lý')),
    FOREIGN KEY (MaCanHo) REFERENCES CANHO(MaCanHo),
    FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)
);

-- 11. Bảng LICH_SU_SUCO
CREATE TABLE LICH_SU_SUCO (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    MaSC CHAR(10) NOT NULL,
    MaNV CHAR(10) NOT NULL,
    NgayHoanThanh DATETIME,
    GhiChu NVARCHAR(200),
    FOREIGN KEY (MaSC) REFERENCES SUCO(MaSC),
    FOREIGN KEY (MaNV) REFERENCES NHANVIEN(MaNV)
);

--12. Bảng LICH_SU_CAN_HO
CREATE TABLE LICH_SU_CANHO (
    MaLichSu INT IDENTITY(1,1) PRIMARY KEY,
    MaCD CHAR(10) NOT NULL,
    MaCanHoCu CHAR(10),
    MaCanHoMoi CHAR(10) NOT NULL,
    MaHDongCu CHAR(10),
    MaHDongMoi CHAR(10) NOT NULL,
    NgayChuyen DATE,
    GhiChu NVARCHAR(200),
    FOREIGN KEY (MaCD) REFERENCES CU_DAN(MaCD)
);

--13. Bảng XE - quản lý phương tiện
CREATE TABLE XE (
    MaXe CHAR(10) NOT NULL PRIMARY KEY,
    MaCanHo CHAR(10) NOT NULL,
    BienSo VARCHAR(20),
    LoaiXe NVARCHAR(50),
    MauSac NVARCHAR(30),
    NgayDangKy DATE,
    TrangThai NVARCHAR(20)
        CHECK (TrangThai IN (N'Còn hiệu lực', N'Hết hạn')),
    FOREIGN KEY (MaCanHo) REFERENCES CANHO(MaCanHo)
);

--14. Bảng THANH_TOAN - quản lý thanh toán hóa đơn
CREATE TABLE THANH_TOAN (
    MaTT CHAR(10) NOT NULL PRIMARY KEY,
    MaHD CHAR(10) NOT NULL,
    NgayThanhToan DATE,
    SoTien DECIMAL(18,2),
    HinhThuc NVARCHAR(50),
    NguoiThu CHAR(10),
    FOREIGN KEY (MaHD) REFERENCES HOADON(MaHD),
    FOREIGN KEY (NguoiThu) REFERENCES NHANVIEN(MaNV)
);

--15. Bảng NGUOI_O - người sống cùng cư dân
CREATE TABLE NGUOI_O (
    MaNguoiO CHAR(10) NOT NULL PRIMARY KEY,
    MaCanHo CHAR(10) NOT NULL,
    HoTen NVARCHAR(100),
    NgaySinh DATE,
    QuanHe NVARCHAR(50),
    CCCD VARCHAR(20),
    FOREIGN KEY (MaCanHo) REFERENCES CANHO(MaCanHo)
);

--=========================
-- NHẬP LIỆU
--=========================

--1. Bảng TAIKHOAN
INSERT INTO TAIKHOAN VALUES
('admin01','123456','Admin'),
('cd001','cd001','CuDan'),
('cd002','cd002','CuDan'),
('cd003','cd003','CuDan');

--2. Bảng CANHO
INSERT INTO CANHO VALUES
('CH001',3,75.5,5,N'Đã được mua','2PN','Đông','A'),
('CH002',2,50,3,N'Trống','1PN','Tây','A'),
('CH003',1,45,2,N'Đã cho thuê','Studio','Nam','B'),
('CH004',4,95,8,N'Đã được mua','3PN',N'Bắc','C'),
('CH005',2,60,4,N'Đã cho thuê','2PN','Đông Nam','B');

--3. Bảng CU_DAN
INSERT INTO CU_DAN VALUES
('CD001',N'Nguyễn Thị Thu Hà','1990-04-12',N'Nữ','0901111222','012345678001','nguyenthithuha@gmail.com',N'Hải Châu, Đà Nẵng'),
('CD002',N'Đặng Thiên Kim','1995-07-20',N'Nữ','0903333444','012345678002','dangthienkim@gmail.com',N'Thanh Xuân, Hà Nội'),
('CD003',N'Lê Hồ Bảo Long','1988-11-05',N'Nam','0905555666','012345678003','lehobaolong@gmail.com',N'Bình Thạnh, TP.HCM');

--4. Bảng HOPDONG
INSERT INTO HOPDONG VALUES
('HD001','CH001','CD001',N'Mua','2022-02-01',NULL,1500000000,N'Còn hiệu lực'),
('HD002','CH003','CD002',N'Thuê','2023-07-01','2024-07-01',8000000,N'Còn hiệu lực'),
('HD003','CH004','CD003',N'Mua','2021-12-15',NULL,2000000000,N'Còn hiệu lực');

--5. Bảng NHANVIEN
INSERT INTO NHANVIEN VALUES
('NV001',N'Phạm Quốc Trung',N'Kỹ thuật viên',N'Kỹ thuật','0911222333',12000000,'2020-05-10'),
('NV002',N'Hoàng Gia Hân',N'Lễ tân',N'Hành chính','0911444555',9000000,'2021-03-20'),
('NV003',N'Vũ Minh Khang',N'Bảo vệ',N'An ninh','0911666777',8000000,'2019-11-01');

--6. Bảng DICHVU
INSERT INTO DICHVU VALUES
('DV001',N'Phí quản lý',500000,N'Tháng',N'Phí quản lý tòa nhà'),
('DV002',N'Tiền nước',15000,N'm3',N'Tính theo số m3 sử dụng'),
('DV003',N'Tiền điện',3500,N'kWh',N'Tính theo kWh'),
('DV004',N'Gửi xe máy',100000,N'Tháng',N'Phí giữ xe máy'),
('DV005',N'Gửi xe ô tô',1200000,N'Tháng',N'Phí giữ xe ô tô');

--7. Bảng SU_DUNG_DV
INSERT INTO SU_DUNG_DV VALUES
-- CH001: phí quản lý + nước + điện
('SD001','CH001','DV001',1,'2024-01',500000),
('SD002','CH001','DV002',12,'2024-01',180000),
('SD003','CH001','DV003',85,'2024-01',297500),

-- CH003: phí quản lý + gửi xe máy
('SD004','CH003','DV001',1,'2024-01',500000),
('SD005','CH003','DV004',1,'2024-01',100000),

-- CH004: phí quản lý + gửi xe ô tô
('SD006','CH004','DV001',1,'2024-01',500000),
('SD007','CH004','DV005',1,'2024-01',1200000);

--8. Bảng HOADON
INSERT INTO HOADON VALUES
('HDN001','HD001','2024-02-01','2024-01',977500,N'Chưa thanh toán'),
('HDN002','HD002','2024-02-02','2024-01',600000,N'Đã thanh toán'),
('HDN003','HD003','2024-02-03','2024-01',1700000,N'Chưa thanh toán');

--9. Bảng CT_HOADON
INSERT INTO CT_HOADON VALUES
('CT001','HDN001','DV001',1,500000,500000),
('CT002','HDN001','DV002',12,15000,180000),
('CT003','HDN001','DV003',85,3500,297500),

('CT004','HDN002','DV001',1,500000,500000),
('CT005','HDN002','DV004',1,100000,100000),

('CT006','HDN003','DV001',1,500000,500000),
('CT007','HDN003','DV005',1,1200000,1200000);

--10. Bảng SUCO
INSERT INTO SUCO VALUES
('SC001','CH001','NV001',N'Rò rỉ nước phòng tắm','2024-01-15',N'Đã xử lý'),
('SC002','CH003','NV003',N'Mất điện khu vực bếp','2024-01-20',N'Chưa xử lý'),
('SC003','CH002','NV002',N'Hỏng cửa chính','2024-11-20',N'Đang xử lý');

--11. Bảng LICH_SU_SUCO
INSERT INTO LICH_SU_SUCO (MaSC, MaNV, NgayHoanThanh, GhiChu) VALUES
('SC001', 'NV001', '2024-01-16 10:30:00', N'Sửa chữa hoàn tất. Đã kiểm tra lại không còn rò rỉ.');

--12. Bảng LICH_SU_CANHO
INSERT INTO LICH_SU_CANHO (MaCD, MaCanHoCu, MaCanHoMoi, MaHDongCu, MaHDongMoi, NgayChuyen, GhiChu)
VALUES
('CD001', NULL, 'CH001', NULL, 'HD001', '2022-02-01', N'Nhận căn hộ mua'),
('CD002', NULL, 'CH003', NULL, 'HD002', '2023-07-01', N'Nhận căn hộ thuê'),
('CD003', NULL, 'CH004', NULL, 'HD003', '2021-12-15', N'Nhận căn hộ mua');

--13. Bảng XE
INSERT INTO XE (MaXe, MaCanHo, BienSo, LoaiXe, MauSac, NgayDangKy, TrangThai) VALUES
('XE001','CH001','43A1-12345',N'Xe máy',N'Đen','2023-01-10', N'Còn hiệu lực'),  -- đã đăng ký >1 năm → sẽ hết hạn
('XE002','CH003','30E-99888',N'Xe máy',N'Trắng','2024-05-01', N'Còn hiệu lực'), -- <1 năm → còn hiệu lực
('XE003','CH004','51H-88888',N'Ô tô',N'Đỏ','2024-02-15', N'Còn hiệu lực');      -- <1 năm → còn hiệu lực

--14. Bảng THANH_TOAN
INSERT INTO THANH_TOAN VALUES
('TT001','HDN002','2024-02-05',100000,N'Tiền mặt','NV002');

--15. Bảng NGUOI_O
INSERT INTO NGUOI_O VALUES
('NO001','CH001',N'Trần Phúc Hậu','2015-05-10',N'Con','012345670001'),
('NO002','CH004',N'Nguyễn Minh Tâm','1985-02-14',N'Vợ','012345670002');

SELECT * FROM TAIKHOAN
SELECT * FROM CANHO
SELECT * FROM CU_DAN
SELECT * FROM HOPDONG
SELECT * FROM NHANVIEN
SELECT * FROM DICHVU
SELECT * FROM SU_DUNG_DV
SELECT * FROM HOADON
SELECT * FROM CT_HOADON
SELECT * FROM SUCO
SELECT * FROM LICH_SU_SUCO
SELECT * FROM LICH_SU_CANHO
SELECT * FROM XE
SELECT * FROM THANH_TOAN
SELECT * FROM NGUOI_O

--=========================
-- CÁC CÂU LỆNH PROCEDURE , FUNCTION, TRIGGER, CURSOR
--=========================

--LUÂN
-- =============================================
-- Procedure: sp_ThemCuDanVaoCanHo
-- Mô tả: Thêm cư dân, tạo hợp đồng, cập nhật trạng thái căn hộ
-- Ngày tạo: 28/10/2025
-- =============================================
IF OBJECT_ID('sp_ThemCuDanVaoCanHo','P') IS NOT NULL
    DROP PROCEDURE sp_ThemCuDanVaoCanHo;
GO

CREATE PROCEDURE sp_ThemCuDanVaoCanHo
    @MaCD CHAR(10),
    @HoTen NVARCHAR(100),
    @NgaySinh DATE,
    @GioiTinh NVARCHAR(10),
    @SDT VARCHAR(15),
    @CCCD VARCHAR(20),
    @Email VARCHAR(100),
    @MaCanHo CHAR(10),
    @LoaiHopDong NVARCHAR(50),   -- Mua hoặc Thuê
    @GiaTriHopDong DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TrangThaiCanHo NVARCHAR(50);
    DECLARE @MaHDong CHAR(10);
    DECLARE @NgayKy DATE = GETDATE();
    DECLARE @NgayHetHan DATE = DATEADD(MONTH, 12, @NgayKy);

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Kiểm tra loại hợp đồng hợp lệ
        IF @LoaiHopDong NOT IN (N'Mua', N'Thuê')
        BEGIN
            RAISERROR(N'Loại hợp đồng không hợp lệ! Chỉ được nhập Mua hoặc Thuê.',16,1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 2. Kiểm tra căn hộ
        SELECT @TrangThaiCanHo = TrangThai
        FROM CANHO 
        WHERE MaCanHo = @MaCanHo;

        IF @TrangThaiCanHo IS NULL
        BEGIN
            RAISERROR(N'Căn hộ không tồn tại!',16,1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @TrangThaiCanHo <> N'Trống'
        BEGIN
            RAISERROR(N'Căn hộ không còn trống! Không thể tạo hợp đồng mới.',16,1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 3. Kiểm tra cư dân
        IF EXISTS(SELECT 1 FROM CU_DAN WHERE MaCD=@MaCD)
        BEGIN
            RAISERROR(N'Mã cư dân đã tồn tại!',16,1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM CU_DAN WHERE Email=@Email)
        BEGIN
            RAISERROR(N'Email đã tồn tại!',16,1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF EXISTS(SELECT 1 FROM CU_DAN WHERE CCCD=@CCCD)
        BEGIN
            RAISERROR(N'CCCD đã tồn tại!',16,1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- 4. Thêm cư dân mới
        INSERT INTO CU_DAN(MaCD,HoTen,NgaySinh,GioiTinh,SDT,CCCD,Email)
        VALUES(@MaCD,@HoTen,@NgaySinh,@GioiTinh,@SDT,@CCCD,@Email);

        -- 5. Tạo mã hợp đồng tự động
        DECLARE @NextID INT = ISNULL(
            (SELECT MAX(CAST(SUBSTRING(MaHDong,4,5) AS INT)) FROM HOPDONG),0) + 1;

        SET @MaHDong = 'HDG' + RIGHT('00000' + CAST(@NextID AS VARCHAR(5)), 5);

        -- 6. Tạo hợp đồng
        INSERT INTO HOPDONG(MaHDong,MaCanHo,MaCD,LoaiHopDong,NgayKy,NgayHetHan,GiaTriHopDong,TrangThai)
        VALUES(@MaHDong,@MaCanHo,@MaCD,@LoaiHopDong,@NgayKy,@NgayHetHan,@GiaTriHopDong,N'Còn hiệu lực');

        -- 7. Cập nhật trạng thái căn hộ theo loại hợp đồng
        UPDATE CANHO
        SET TrangThai = CASE 
                            WHEN @LoaiHopDong = N'Mua' THEN N'Đã được mua'
                            WHEN @LoaiHopDong = N'Thuê' THEN N'Đã cho thuê'
                        END
        WHERE MaCanHo = @MaCanHo;

        -- 8. Ghi lịch sử
        INSERT INTO LICH_SU_CANHO(MaCD,MaCanHoCu,MaCanHoMoi,MaHDongMoi,NgayChuyen,GhiChu)
        VALUES(@MaCD,NULL,@MaCanHo,@MaHDong,@NgayKy,N'Thêm cư dân mới');

        COMMIT TRANSACTION;

        PRINT N'Thêm cư dân và tạo hợp đồng thành công!';
        PRINT N'Mã hợp đồng mới là: ' + @MaHDong;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;

        DECLARE @Err NVARCHAR(4000)=ERROR_MESSAGE();
        RAISERROR(@Err,16,1);
    END CATCH
END
GO

-- Trường hợp đúng
EXEC sp_ThemCuDanVaoCanHo
    @MaCD = 'CD010',
    @HoTen = N'Lê Văn Nam',
    @NgaySinh = '1999-05-11',
    @GioiTinh = N'Nam',
    @SDT = '0912121212',
    @CCCD = '012345678999',
    @Email = 'levannam@gmail.com',
    @MaCanHo = 'CH002',
    @LoaiHopDong = N'Thuê',
    @GiaTriHopDong = 9000000;

-- Trường hợp sai
EXEC sp_ThemCuDanVaoCanHo
    @MaCD='CD011',
    @HoTen=N'Ngô Hải Minh',
    @NgaySinh='1998-10-10',
    @GioiTinh=N'Nam',
    @SDT='0999888777',
    @CCCD='012345679000',
    @Email='ngohaiminh@gmail.com',
    @MaCanHo='CH001',
    @LoaiHopDong=N'Mua',
    @GiaTriHopDong=1500000000;

-- =============================================
-- Cấu trúc: sp_ChuyenCanHo
-- Mô tả: Cập nhật hợp đồng mới, đổi trạng thái căn hộ cũ → Trống, mới → Đang ở.
-- Ngày tạo: 28/10/2025
-- =============================================
-- Tạo bảng LICH_SU_CANHO để lưu lịch sử chuyển căn hộ
CREATE PROCEDURE sp_ChuyenCanHo
(
    @MaCD CHAR(10),
    @MaCanHoMoi CHAR(10),
    @LoaiHopDongMoi NVARCHAR(50),
    @GiaTriHopDongMoi DECIMAL(18,2),
    @GhiChu NVARCHAR(200) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaCanHoCu CHAR(10);
    DECLARE @MaHDongCu CHAR(10);
    DECLARE @LoaiHopDongCu NVARCHAR(50);
    DECLARE @MaHDongMoi CHAR(10);
    DECLARE @TrangThaiMoi NVARCHAR(50);
    DECLARE @NgayChuyen DATE = GETDATE();
    DECLARE @MaxHDongNum INT;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Kiểm tra cư dân tồn tại
        IF NOT EXISTS (SELECT 1 FROM CU_DAN WHERE MaCD = @MaCD)
            THROW 51001, N'Cư dân không tồn tại!', 1;

        -- 2. Lấy hợp đồng hiện tại
        SELECT TOP 1 
            @MaCanHoCu = MaCanHo,
            @MaHDongCu = MaHDong,
            @LoaiHopDongCu = LoaiHopDong
        FROM HOPDONG
        WHERE MaCD = @MaCD AND TrangThai = N'Còn hiệu lực'
        ORDER BY NgayKy DESC;

        IF @MaCanHoCu IS NULL
            THROW 51002, N'Cư dân không có hợp đồng hiệu lực!', 1;

        -- 3. CHỈ CHO CHUYỂN NẾU LOẠI HỢP ĐỒNG HIỆN TẠI = THUÊ
        IF @LoaiHopDongCu <> N'Thuê'
            THROW 51006, N'Cư dân đã mua căn hộ. Không được phép chuyển!', 1;

        -- 4. Kiểm tra căn hộ mới
        SELECT @TrangThaiMoi = TrangThai
        FROM CANHO WHERE MaCanHo = @MaCanHoMoi;

        IF @TrangThaiMoi IS NULL
            THROW 51003, N'Căn hộ mới không tồn tại!', 1;

        IF @TrangThaiMoi <> N'Trống'
            THROW 51004, N'Căn hộ mới không trống!', 1;

        IF @MaCanHoCu = @MaCanHoMoi
            THROW 51005, N'Không thể chuyển cùng căn hộ!', 1;

        -- 5. Dừng hợp đồng cũ
        UPDATE HOPDONG
        SET TrangThai = N'Hết hiệu lực', NgayHetHan = @NgayChuyen
        WHERE MaHDong = @MaHDongCu;

        -- 6. Tạo mã hợp đồng mới
        SELECT @MaxHDongNum = ISNULL(MAX(CAST(SUBSTRING(MaHDong, 4, 5) AS INT)), 0)
        FROM HOPDONG;

        SET @MaHDongMoi = 'HDG' + RIGHT('00000' + CAST(@MaxHDongNum + 1 AS VARCHAR(5)), 5);

        INSERT INTO HOPDONG (MaHDong, MaCanHo, MaCD, LoaiHopDong,
                             NgayKy, NgayHetHan, GiaTriHopDong, TrangThai)
        VALUES (@MaHDongMoi, @MaCanHoMoi, @MaCD, @LoaiHopDongMoi,
                @NgayChuyen, DATEADD(MONTH, 12, @NgayChuyen),
                @GiaTriHopDongMoi, N'Còn hiệu lực');

        -- 7. Cập nhật trạng thái căn hộ
        UPDATE CANHO SET TrangThai = N'Trống'
        WHERE MaCanHo = @MaCanHoCu;

        UPDATE CANHO SET TrangThai = N'Đã cho thuê'
        WHERE MaCanHo = @MaCanHoMoi;

        -- 8. Ghi lịch sử
        INSERT INTO LICH_SU_CANHO (MaCD, MaCanHoCu, MaCanHoMoi, MaHDongCu, MaHDongMoi, NgayChuyen, GhiChu)
        VALUES (@MaCD, @MaCanHoCu, @MaCanHoMoi, @MaHDongCu, @MaHDongMoi, @NgayChuyen, @GhiChu);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW;
    END CATCH
END;


-- Trường hợp đúng:
EXEC sp_ChuyenCanHo
    @MaCD = 'CD001',
    @MaCanHoMoi = 'CH005',
    @LoaiHopDongMoi = N'Thuê',
    @GiaTriHopDongMoi = 8000000,
    @GhiChu = N'Chuyển căn hộ hợp lệ';

-- Trường hợp sai: chuyển vào căn hộ đang sử dụng
EXEC sp_ChuyenCanHo
    @MaCD = 'CD002',
    @MaCanHoMoi = 'CH010',
    @LoaiHopDongMoi = N'Thuê',
    @GiaTriHopDongMoi = 7000000,
    @GhiChu = N'Test sai: đã mua không được chuyển';

-- =============================================
-- Cấu trúc: fn_TinhThoiHanHopDong
-- Mô tả: Trả về số ngày còn lại trước khi hợp đồng hết hạn.
-- Ngày tạo: 28/10/2025
-- =============================================
CREATE FUNCTION fn_TinhThoiHanHopDong (@MaHDong CHAR(10))
RETURNS INT
AS
BEGIN
    DECLARE @NgayHet DATE, @TrangThai NVARCHAR(30);

    SELECT @NgayHet = NgayHetHan, @TrangThai = TrangThai
    FROM HOPDONG WHERE MaHDong = @MaHDong;

    IF @NgayHet IS NULL OR @TrangThai <> N'Còn hiệu lực'
        RETURN NULL;

    RETURN CASE WHEN DATEDIFF(DAY, GETDATE(), @NgayHet) < 0
                THEN 0 ELSE DATEDIFF(DAY, GETDATE(), @NgayHet) END;
END

-- Trường hợp đúng:
UPDATE HOPDONG
SET TrangThai = N'Còn hiệu lực',
    NgayHetHan = DATEADD(MONTH, 6, GETDATE())
WHERE MaHDong = 'HD002';

SELECT dbo.fn_TinhThoiHanHopDong('HD002') AS SoNgayConLai;


-- Trường hợp sai:
-- HD001 không có ngày hết hạn (NULL), nên hàm phải trả về NULL
SELECT dbo.fn_TinhThoiHanHopDong('HD001') AS SoNgayConLai;

-- =============================================
-- Cấu trúc: sp_TangGiaTriHopDongBangCursor
-- Mô tả: Duyệt toàn bộ HOPDONG có TrangThai='Hiệu lực', tăng GiaTriHopDong thêm 5% nếu hợp đồng ký trước 1 năm.
-- Ngày tạo: 28/10/2025
-- =============================================
CREATE PROCEDURE sp_TangGiaTriHopDongBangCursor
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaHDong CHAR(10);
    DECLARE @GiaTri DECIMAL(18,2);
    DECLARE @NgayKy DATE;
    DECLARE @NewGiaTri DECIMAL(18,2);

    DECLARE crs CURSOR FOR
        SELECT MaHDong, GiaTriHopDong, NgayKy
        FROM HOPDONG
        WHERE TrangThai = N'Còn hiệu lực'
          AND NgayKy < DATEADD(YEAR, -1, GETDATE());

    BEGIN TRY
        OPEN crs;

        FETCH NEXT FROM crs INTO @MaHDong, @GiaTri, @NgayKy;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @NewGiaTri = @GiaTri * 1.05;

            UPDATE HOPDONG
            SET GiaTriHopDong = @NewGiaTri
            WHERE MaHDong = @MaHDong;

            FETCH NEXT FROM crs INTO @MaHDong, @GiaTri, @NgayKy;
        END

        CLOSE crs;
        DEALLOCATE crs;
    END TRY
    BEGIN CATCH
        CLOSE crs;
        DEALLOCATE crs;
        THROW;
    END CATCH
END

-- Trường hợp đúng: (hợp đồng sẽ được tăng giá trị)
-- Kiểm tra
SELECT MaHDong, GiaTriHopDong FROM HOPDONG WHERE MaHDong='HD003';

-- Chạy Procedure
EXEC sp_TangGiaTriHopDongBangCursor;

-- Kiểm tra kết quả
SELECT MaHDong, GiaTriHopDong FROM HOPDONG WHERE MaHDong='HD003';

--Giá trị mới: 2.100.000.000 (tăng 5%)

-- Trường hợp sai: (hợp đồng KHÔNG được tăng giá trị)
--Kiểm tra
SELECT MaHDong, GiaTriHopDong FROM HOPDONG WHERE MaHDong='HDG00004';

-- Chạy procedure
EXEC sp_TangGiaTriHopDongBangCursor;

-- Kiểm tra kết quả
SELECT MaHDong, GiaTriHopDong FROM HOPDONG WHERE MaHDong='HDG00004';
-- kết quả giữ nguyên

 --NHI
--======================================================================================
-- Cấu trúc: sp_TaoHoaDonMoi
-- Mô tả: Tạo hóa đơn mới cho cư dân, tự động lấy danh sách dịch vụ đã sử dụng
--        trong tháng từ bảng SU_DUNG_DV, thêm vào CT_HOADON và cập nhật HOADON.TongTien
-- Ngày tạo: 26/10/2025
--======================================================================================
IF OBJECT_ID('sp_TaoHoaDonMoi','P') IS NOT NULL
    DROP PROCEDURE sp_TaoHoaDonMoi;
GO

CREATE PROCEDURE sp_TaoHoaDonMoi
    @MaHD CHAR(10),
    @MaHDong CHAR(10),
    @NgayLap DATE,
    @Thang CHAR(7)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRAN;

        -- 1. Không cho trùng mã hóa đơn
        IF EXISTS (SELECT 1 FROM HOADON WHERE MaHD = @MaHD)
            THROW 51010, N'Mã hóa đơn đã tồn tại!', 1;

        -- 2. Kiểm tra hợp đồng
        IF NOT EXISTS (SELECT 1 FROM HOPDONG WHERE MaHDong=@MaHDong)
            THROW 51011, N'Hợp đồng không tồn tại!', 1;

        DECLARE @TrangThaiHD NVARCHAR(50), @MaCanHo CHAR(10);

        SELECT @TrangThaiHD = TrangThai,
               @MaCanHo = MaCanHo
        FROM HOPDONG
        WHERE MaHDong = @MaHDong;

        IF @TrangThaiHD NOT IN (N'Hiệu lực', N'Còn hiệu lực')
            THROW 51012, N'Hợp đồng không còn hiệu lực!', 1;

        -- 3. Kiểm tra căn hộ
        IF NOT EXISTS (SELECT 1 FROM CANHO WHERE MaCanHo=@MaCanHo)
            THROW 51013, N'Căn hộ của hợp đồng không tồn tại!', 1;

        -- 4. Thêm hóa đơn
        INSERT INTO HOADON (MaHD, MaHDong, NgayLap, Thang, TongTien, TrangThai)
        VALUES (@MaHD, @MaHDong, @NgayLap, @Thang, 0, N'Chưa thanh toán');

        -- 5. Lấy danh sách dịch vụ tháng đó
        ;WITH DS_DV AS (
            SELECT 
                ROW_NUMBER() OVER (ORDER BY s.MaSDDV) AS STT,
                s.MaDV, s.SoLuong, d.DonGia,
                (s.SoLuong * d.DonGia) AS ThanhTien
            FROM SU_DUNG_DV s
            JOIN DICHVU d ON s.MaDV = d.MaDV
            WHERE s.MaCanHo = @MaCanHo
              AND s.ThangSuDung = @Thang
        )
        INSERT INTO CT_HOADON (MaCTHD, MaHD, MaDV, SoLuong, DonGia, ThanhTien)
        SELECT 
            'CT' + RIGHT('00000' + CAST(STT AS VARCHAR(5)), 5),
            @MaHD, MaDV, SoLuong, DonGia, ThanhTien
        FROM DS_DV;

        -- 6. Cập nhật tổng tiền HÓA ĐƠN
        UPDATE HOADON
        SET TongTien = (
            SELECT SUM(ThanhTien) FROM CT_HOADON WHERE MaHD = @MaHD
        )
        WHERE MaHD = @MaHD;

        COMMIT TRAN;

        -- ⭐ THÊM DÒNG NÀY ĐỂ HIỂN THỊ TONGTIEN SAU KHI THỦ TỤC CHẠY XONG
        SELECT MaHD, TongTien FROM HOADON WHERE MaHD = @MaHD;

    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK;
        THROW;
    END CATCH;
END

--Trường hợp đúng
EXEC sp_TaoHoaDonMoi
    @MaHD = 'HDN010',
    @MaHDong = 'HD001',
    @NgayLap = '2024-02-10',
    @Thang = '2024-01';

--Trường hợp sai
EXEC sp_TaoHoaDonMoi
    @MaHD = 'HDN011',
    @MaHDong = 'HD999',   -- không tồn tại
    @NgayLap = '2024-02-10',
    @Thang = '2024-01';

--=======================================================================
-- Cấu trúc: trg_TinhTongTienHoaDon
-- Mô tả: Tự động cập nhật HOADON.TongTien khi có thay đổi (thêm/sửa/xóa)
--        trong bảng CT_HOADON.
-- Ngày tạo: 26/10/2025
--=======================================================================

IF OBJECT_ID('trg_TinhTongTienHoaDon','TR') IS NOT NULL
    DROP TRIGGER trg_TinhTongTienHoaDon;
GO

CREATE TRIGGER trg_TinhTongTienHoaDon
ON CT_HOADON
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy tất cả MaHD bị ảnh hưởng
    DECLARE @MaHDTmp TABLE(MaHD CHAR(10));

    INSERT INTO @MaHDTmp(MaHD)
    SELECT DISTINCT MaHD FROM inserted WHERE MaHD IS NOT NULL
    UNION
    SELECT DISTINCT MaHD FROM deleted WHERE MaHD IS NOT NULL;

    -- Cập nhật tổng tiền hóa đơn
    UPDATE H
    SET TongTien = ISNULL(T.TongTien, 0)
    FROM HOADON H
    INNER JOIN @MaHDTmp TMP ON H.MaHD = TMP.MaHD
    LEFT JOIN (
        SELECT MaHD, SUM(ThanhTien) AS TongTien
        FROM CT_HOADON
        GROUP BY MaHD
    ) T ON TMP.MaHD = T.MaHD;
END

--Trường hợp đúng:
--Thêm
-- Kiểm tra tổng tiền ban đầu
SELECT MaHD, TongTien FROM HOADON WHERE MaHD='HDN002';

-- Thêm dịch vụ DV002 vào HDN002
INSERT INTO CT_HOADON (MaCTHD, MaHD, MaDV, SoLuong, DonGia, ThanhTien)
VALUES ('CT011', 'HDN002', 'DV002', 3, 15000, 45000);

-- Kiểm tra TongTien đã tăng
SELECT MaHD, TongTien FROM HOADON WHERE MaHD='HDN002';

-- Sửa
-- Update số lượng dịch vụ CT011
UPDATE CT_HOADON
SET SoLuong=5, ThanhTien=5*15000
WHERE MaCTHD='CT011';

-- Kiểm tra TongTien đã cập nhật
SELECT MaHD, TongTien FROM HOADON WHERE MaHD='HDN002';

--Xóa
-- Xóa chi tiết dịch vụ vừa thêm
DELETE FROM CT_HOADON
WHERE MaCTHD='CT011';

-- Kiểm tra TongTien giảm về giá trị trước khi thêm
SELECT MaHD, TongTien FROM HOADON WHERE MaHD='HDN002';

--Trường hợp sai:
--Thêm
-- HDN999 chưa tồn tại
INSERT INTO CT_HOADON (MaCTHD, MaHD, MaDV, SoLuong, DonGia, ThanhTien)
VALUES ('CT099', 'HDN999', 'DV001', 2, 500000, 1000000);

-- Kiểm tra HOADON: HDN999 không tồn tại → trigger không cập nhật gì
SELECT * FROM HOADON WHERE MaHD='HDN999';

--Sửa
UPDATE CT_HOADON
SET SoLuong=10, ThanhTien=10*500000
WHERE MaCTHD='CT099';

-- HOADON không tồn tại, TongTien không thay đổi
SELECT * FROM HOADON WHERE MaHD='HDN999';

--Xóa
DELETE FROM CT_HOADON
WHERE MaCTHD='CT099';

-- HOADON không tồn tại, TongTien không thay đổi
SELECT * FROM HOADON WHERE MaHD='HDN999';

--==================================================================================
-- Cấu trúc: fn_DoanhThuTheoThang
-- Mô tả: Hàm trả về tổng doanh thu của tất cả hóa đơn có trạng thái 'Đã thanh toán'
--        theo tháng và năm chỉ định.
-- Ngày tạo: 26/10/2025
--==================================================================================

IF OBJECT_ID('fn_DoanhThuTheoThang','FN') IS NOT NULL
    DROP FUNCTION fn_DoanhThuTheoThang;
GO

CREATE FUNCTION fn_DoanhThuTheoThang(@Thang INT, @Nam INT)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Result DECIMAL(18,2) = 0;

    -- Kiểm tra tháng hợp lệ
    IF @Thang < 1 OR @Thang > 12
        RETURN 0;

    -- Tính tổng doanh thu các hóa đơn đã thanh toán
    SELECT @Result = ISNULL(SUM(TongTien), 0)
    FROM HOADON
    WHERE TrangThai = N'Đã thanh toán'
      AND ((LEFT(Thang,4) + RIGHT(Thang,2)) = RIGHT('0000'+CAST(@Nam AS NVARCHAR(4)),4) + RIGHT('00'+CAST(@Thang AS NVARCHAR(2)),2)
           OR (MONTH(NgayLap) = @Thang AND YEAR(NgayLap) = @Nam));

    RETURN @Result;
END

-- Trường hợp đúng:
-- Kiểm tra HDN002 đã thanh toán
SELECT * FROM HOADON WHERE MaHD='HDN002';

-- Tính doanh thu tháng 01/2024
SELECT dbo.fn_DoanhThuTheoThang(1,2024) AS DoanhThuThang;

--Trường hợp sai:
SELECT dbo.fn_DoanhThuTheoThang(12,2025) AS DoanhThuThang;
--Tháng 12/2025 không có hóa đơn 'Đã thanh toán' →  trả về 0

--======================================================================================
-- Cấu trúc: sp_CapNhatTrangThaiHoaDon
-- Mô tả: Duyệt từng hóa đơn, nếu NgayLap < GETDATE()-7 và TrangThai = 'Chưa thanh toán'
--        thì cập nhật thành 'Quá hạn'.
-- Ngày tạo: 26/10/2025
--======================================================================================
IF OBJECT_ID('sp_CapNhatTrangThaiHoaDon','P') IS NOT NULL
    DROP PROCEDURE sp_CapNhatTrangThaiHoaDon;
GO

CREATE PROCEDURE sp_CapNhatTrangThaiHoaDon
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Cập nhật trực tiếp tất cả hóa đơn 'Chưa thanh toán' quá 7 ngày
        UPDATE HOADON
        SET TrangThai = N'Quá hạn'
        WHERE TrangThai = N'Chưa thanh toán'
          AND NgayLap < DATEADD(DAY, -7, CAST(GETDATE() AS DATE));

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END

-- Trường hợp đúng:
-- Kiểm tra trạng thái trước khi chạy
SELECT MaHD, NgayLap, TrangThai FROM HOADON WHERE MaHD='HDN001';

-- Chạy procedure
EXEC sp_CapNhatTrangThaiHoaDon;

-- Kiểm tra trạng thái sau khi chạy
SELECT MaHD, NgayLap, TrangThai FROM HOADON WHERE MaHD='HDN001';

-- Trường hợp sai:
-- Kiểm tra trạng thái trước khi chạy
SELECT MaHD, NgayLap, TrangThai FROM HOADON WHERE MaHD='HDN002';

-- Chạy procedure
EXEC sp_CapNhatTrangThaiHoaDon;

-- Kiểm tra trạng thái sau khi chạy
SELECT MaHD, NgayLap, TrangThai FROM HOADON WHERE MaHD='HDN002';

--BÌNH
-- =============================================
-- Cấu trúc: sp_GhiNhanSuCo
-- Mô tả: Khi cư dân báo sự cố, thêm bản ghi mới vào SUCO với TrangThai='Đang xử lý';
--        Gán tự động nhân viên bảo trì ít việc nhất (dựa trên COUNT).
-- Ngày tạo: 25/10/2025
-- =============================================
IF OBJECT_ID('sp_GhiNhanSuCo','P') IS NOT NULL
    DROP PROCEDURE sp_GhiNhanSuCo;
GO

CREATE PROCEDURE sp_GhiNhanSuCo
    @MaCanHo CHAR(10),
    @MoTa NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @MaNV CHAR(10), @NewMaSC CHAR(10);

        -- 1. Kiểm tra căn hộ tồn tại
        IF NOT EXISTS (SELECT 1 FROM CANHO WHERE MaCanHo=@MaCanHo)
        BEGIN
            RAISERROR(N'Căn hộ không tồn tại!',16,1);
            RETURN;
        END;

        -- 2. Chọn nhân viên kỹ thuật ít việc nhất
        SELECT TOP 1 @MaNV = NV.MaNV
        FROM NHANVIEN NV
        WHERE NV.ChucVu=N'Kỹ thuật viên'
        ORDER BY (
            SELECT COUNT(*) 
            FROM SUCO S 
            WHERE S.MaNV=NV.MaNV AND S.TrangThai=N'Đang xử lý'
        );

        IF @MaNV IS NULL
        BEGIN
            RAISERROR(N'Không có nhân viên kỹ thuật nào để xử lý sự cố!',16,1);
            RETURN;
        END

        -- 3. Tạo mã sự cố tự động
        SELECT @NewMaSC = 'SC' + RIGHT('000' + CAST(ISNULL(MAX(CAST(SUBSTRING(MaSC,3,3) AS INT)),0)+1 AS VARCHAR(3)),3)
        FROM SUCO;

        -- 4. Thêm bản ghi sự cố
        INSERT INTO SUCO(MaSC, MaCanHo, MaNV, MoTa, NgayBao, TrangThai)
        VALUES(@NewMaSC,@MaCanHo,@MaNV,@MoTa,GETDATE(),N'Đang xử lý');

        PRINT N'Thêm sự cố thành công cho căn hộ '+@MaCanHo+ N', mã sự cố: '+@NewMaSC;
    END TRY
    BEGIN CATCH
        PRINT N'Lỗi: '+ERROR_MESSAGE();
    END CATCH
END;

-- Trường hợp đúng:
-- Chạy procedure
EXEC sp_GhiNhanSuCo
    @MaCanHo='CH002',
    @MoTa=N'Rò rỉ nước phòng bếp';

-- Kiểm tra dữ liệu
SELECT * FROM SUCO WHERE MaCanHo='CH002';

-- Trường hợp sai:
-- Chạy procedure
EXEC sp_GhiNhanSuCo
    @MaCanHo='CH999',
    @MoTa=N'Mất điện';

-- Kiểm tra dữ liệu
SELECT * FROM SUCO WHERE MaCanHo='CH999';

-- =============================================
-- Cấu trúc: trg_LuuLichSuSuCo
-- Mô tả: Khi SUCO.TrangThai cập nhật từ 'Đang xử lý' → 'Hoàn thành',
--        trigger tự động ghi log vào bảng LICH_SU_SUCO.
-- Ngày tạo: 25/10/2025
-- =============================================
-- Tạo bảng log nếu chưa có, có ID tự tăng
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='LICH_SU_SUCO' AND xtype='U')

-- Xóa trigger nếu đã tồn tại
IF OBJECT_ID('trg_LuuLichSuSuCo','TR') IS NOT NULL
    DROP TRIGGER trg_LuuLichSuSuCo;
GO

CREATE TRIGGER trg_LuuLichSuSuCo
ON SUCO
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO LICH_SU_SUCO(MaSC, MaNV, NgayHoanThanh, GhiChu)
    SELECT i.MaSC, i.MaNV, GETDATE(), N'Sự cố đã được xử lý hoàn tất'
    FROM inserted i
    INNER JOIN deleted d ON i.MaSC=d.MaSC
    WHERE d.TrangThai IN (N'Chưa xử lý', N'Đang xử lý') AND i.TrangThai=N'Đã xử lý';
END;

-- Trường hợp đúng: trigger ghi log
-- Cập nhật trạng thái SC002 từ 'Đang xử lý' → 'Đã xử lý'
UPDATE SUCO
SET TrangThai = N'Chưa xử lý'
WHERE MaSC='SC002';

UPDATE SUCO
SET TrangThai = N'Đã xử lý'
WHERE MaSC='SC002';

-- Kiểm tra log
SELECT * FROM LICH_SU_SUCO WHERE MaSC='SC002';

-- Trường hợp sai: trigger không ghi log
-- Cập nhật SC001 từ 'Đã xử lý' → 'Đang xử lý'
UPDATE SUCO
SET TrangThai = N'Chưa xử lý'
WHERE MaSC='SC001';

-- Kiểm tra log, không có bản ghi mới
SELECT * FROM LICH_SU_SUCO WHERE MaSC='SC001';

-- =============================================
-- Cấu trúc: fn_ThongKeSuCoTheoNhanVien(@MaNV)
-- Mô tả: Trả về số lượng sự cố mà nhân viên đã xử lý thành công trong tháng hiện tại.
-- Ngày tạo: 25/10/2025
-- =============================================
-- Xóa hàm cũ nếu đã tồn tại
IF OBJECT_ID('fn_ThongKeSuCoTheoNhanVien','FN') IS NOT NULL
    DROP FUNCTION fn_ThongKeSuCoTheoNhanVien;
GO

CREATE FUNCTION fn_ThongKeSuCoTheoNhanVien(
    @MaNV CHAR(10),
    @Thang INT,
    @Nam INT
)
RETURNS INT
AS
BEGIN
    DECLARE @SoLuong INT;

    SELECT @SoLuong = COUNT(*)
    FROM SUCO
    WHERE MaNV = @MaNV
      AND TrangThai = N'Đã xử lý'  -- Chỉ tính sự cố đã hoàn thành
      AND MONTH(NgayBao) = @Thang
      AND YEAR(NgayBao) = @Nam;

    RETURN ISNULL(@SoLuong,0);
END;

-- Trường hợp đúng: nhân viên có sự cố đã hoàn thành
-- Kiểm tra hàm
SELECT dbo.fn_ThongKeSuCoTheoNhanVien('NV003', 1, 2024) AS SoSuCo;
-- Kết quả mong đợi: 1

-- Trường hợp sai: nhân viên không có sự cố hoàn thành trong tháng & năm đó
-- Kiểm tra nhân viên NV002 trong tháng 1/2024 (không có sự cố hoàn thành)
SELECT dbo.fn_ThongKeSuCoTheoNhanVien('NV002', 1, 2024) AS SoSuCo;
-- Kết quả trả về là: 0

-- =============================================
-- Cấu trúc: crs_KiemTraTheXeHetHan
-- Mô tả: Duyệt bảng THE_XE, nếu NgayDangKy < GETDATE()-365 và TrangThai='Còn hiệu lực'
--        thì cập nhật sang 'Hết hạn'.
-- Ngày tạo: 25/10/2025
-- =============================================

IF OBJECT_ID('crs_KiemTraTheXeHetHan','P') IS NOT NULL
    DROP PROCEDURE crs_KiemTraTheXeHetHan;
GO

CREATE PROCEDURE crs_KiemTraTheXeHetHan
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @MaXe CHAR(10), @NgayDangKy DATE;

    BEGIN TRAN;

    DECLARE cur CURSOR FOR
        SELECT MaXe, NgayDangKy
        FROM XE
        WHERE TrangThai=N'Còn hiệu lực';

    OPEN cur;
    FETCH NEXT FROM cur INTO @MaXe,@NgayDangKy;

    WHILE @@FETCH_STATUS=0
    BEGIN
        IF @NgayDangKy < DATEADD(DAY,-365,GETDATE())
        BEGIN
            UPDATE XE SET TrangThai=N'Hết hạn' WHERE MaXe=@MaXe;
        END
        FETCH NEXT FROM cur INTO @MaXe,@NgayDangKy;
    END

    CLOSE cur; DEALLOCATE cur;
    COMMIT TRAN;
END;

-- Trường hợp đúng:
-- Kiểm tra trước
SELECT MaXe, NgayDangKy, TrangThai FROM XE WHERE MaXe='XE001';

-- Chạy procedure
EXEC crs_KiemTraTheXeHetHan;

-- Kiểm tra sau
SELECT MaXe, NgayDangKy, TrangThai FROM XE WHERE MaXe='XE001';
-- Kết quả mong đợi: TrangThai = 'Hết hạn'

-- Trường hợp sai:
-- Kiểm tra trước
SELECT MaXe, NgayDangKy, TrangThai FROM XE WHERE MaXe='XE002';

-- Chạy procedure
EXEC crs_KiemTraTheXeHetHan;

-- Kiểm tra sau
SELECT MaXe, NgayDangKy, TrangThai FROM XE WHERE MaXe='XE002';
-- Kết quả trả về: TrangThai vẫn = 'Còn hiệu lực'

--=========================
-- PHÂN QUYỀN
--=========================

-- Tạo Login cho Admin
CREATE LOGIN admin01 WITH PASSWORD = '123456';
CREATE USER admin01 FOR LOGIN admin01;

-- Tạo Login cho cư dân
CREATE LOGIN cd001 WITH PASSWORD = 'cd001';
CREATE LOGIN cd002 WITH PASSWORD = 'cd002';
CREATE USER cd001 FOR LOGIN cd001;
CREATE USER cd002 FOR LOGIN cd002;

-- Tạo Role nhóm quyền
CREATE ROLE db_Admin;
CREATE ROLE db_CuDan;

-- Gán user vào role
EXEC sp_addrolemember 'role_admin','admin01';
EXEC sp_addrolemember 'role_cudan','cd001';
EXEC sp_addrolemember 'role_cudan','cd002';


-- Grant toàn quyền
GRANT SELECT, INSERT, UPDATE, DELETE ON DATABASE:: QL_CHUNGCU TO db_Admin;
GRANT EXECUTE TO db_Admin; -- cho stored procedure và function

-- Grant quyền hạn chế
GRANT SELECT ON CU_DAN TO db_CuDan;
GRANT SELECT ON HOADON TO db_CuDan;
GRANT SELECT ON CT_HOADON TO db_CuDan;
GRANT SELECT ON SU_DUNG_DV TO db_CuDan;

--=========================
-- SAO LƯU
--=========================
ALTER DATABASE QL_CHUNGCU
SET RECOVERY FULL;
GO

-- Full backup (Thứ 2 và Thứ 5)
BACKUP DATABASE QL_CHUNGCU
TO DISK = 'D:\Backup\QL_CHUNGCU_Full.bak'
WITH INIT, NAME = 'Full Backup QL_CHUNGCU';

-- Differential backup (Thứ 3 và Thứ 6)
BACKUP DATABASE QL_CHUNGCU
TO DISK = 'D:\Backup\QL_CHUNGCU_Diff.bak'
WITH DIFFERENTIAL, NAME = 'Differential Backup QL_CHUNGCU';

-- Log backup (Thứ 4 và Thứ 7)
BACKUP LOG QL_CHUNGCU
TO DISK = 'D:\Backup\QL_CHUNGCU_Log.trn'
WITH NAME = 'Transaction Log Backup QL_CHUNGCU';

--=========================
--PHỤC HỒI DỮ LIỆU
--=========================
ALTER DATABASE QL_CHUNGCU
SET RECOVERY FULL;
GO

-- Bước 1: Restore full
RESTORE DATABASE QL_CHUNGCU
FROM DISK = 'D:\Backup\QL_CHUNGCU_Full.bak'
WITH NORECOVERY;

-- Bước 2: Restore differential
RESTORE DATABASE QL_CHUNGCU
FROM DISK = 'D:\Backup\QL_CHUNGCU_Diff.bak'
WITH NORECOVERY;

-- Bước 3: Restore log
RESTORE LOG QL_CHUNGCU
FROM DISK = 'D:\Backup\QL_CHUNGCU_Log.trn'
WITH RECOVERY;

--=========================
-- GIAO TÁC
--=========================

-- ================================
-- 1. Kiểm tra dữ liệu hợp đồng
-- ================================
PRINT N'Kiểm tra hợp đồng thuê hết hạn và cập nhật trạng thái...';
UPDATE HOPDONG
SET TrangThai = N'Hết hiệu lực'
WHERE TrangThai = N'Còn hiệu lực' 
  AND NgayHetHan IS NOT NULL
  AND NgayHetHan < GETDATE();

-- Cập nhật trạng thái căn hộ theo hợp đồng
UPDATE CANHO
SET TrangThai = CASE 
                    WHEN H.TrangThai = N'Còn hiệu lực' AND H.LoaiHopDong = N'Mua' THEN N'Đã được mua'
                    WHEN H.TrangThai = N'Còn hiệu lực' AND H.LoaiHopDong = N'Thuê' THEN N'Đã cho thuê'
                    ELSE N'Trống'
                 END
FROM CANHO C
LEFT JOIN HOPDONG H ON C.MaCanHo = H.MaCanHo
  AND H.TrangThai = N'Còn hiệu lực'; 

SELECT *FROM HOPDONG
-- ================================
-- 2. Kiểm tra xe hết hạn (> 1 năm)
-- ================================
PRINT N'Cập nhật trạng thái xe hết hạn...';

-- Cập nhật trạng thái xe hết hạn
UPDATE XE
SET TrangThai = N'Hết hạn'
WHERE NgayDangKy < DATEADD(YEAR,-1,GETDATE())
  AND TrangThai = N'Còn hiệu lực';

-- Lấy số lượng xe hết hạn vào biến
DECLARE @SoXeHetHan INT;

SET @SoXeHetHan = (SELECT COUNT(*) 
                   FROM XE 
                   WHERE NgayDangKy < DATEADD(YEAR,-1,GETDATE()) 
                     AND TrangThai = N'Hết hạn');

-- Hiển thị kết quả
PRINT N'Số xe hết hạn: ' + CAST(@SoXeHetHan AS NVARCHAR(10));

-- ================================
-- 3. Backup dữ liệu theo lịch
-- ================================
DECLARE @DayOfWeek NVARCHAR(10);
DECLARE @BackupPath NVARCHAR(255);

SET @DayOfWeek = DATENAME(WEEKDAY, GETDATE());

-- Full backup: Thứ 2, Thứ 5
IF @DayOfWeek IN ('Monday','Thursday')
BEGIN
    SET @BackupPath = N'D:\Backup\QL_CHUNGCU_Full_' 
                      + CONVERT(NVARCHAR(8), GETDATE(), 112) + '.bak';

    BACKUP DATABASE QL_CHUNGCU
    TO DISK = @BackupPath
    WITH INIT, NAME = N'Full Backup QL_CHUNGCU';

    PRINT N'Full backup đã thực hiện: ' + @BackupPath;
END
ELSE IF @DayOfWeek IN ('Tuesday','Friday')  -- Differential backup
BEGIN
    SET @BackupPath = N'D:\Backup\QL_CHUNGCU_Diff_' 
                      + CONVERT(NVARCHAR(8), GETDATE(), 112) + '.bak';

    BACKUP DATABASE QL_CHUNGCU
    TO DISK = @BackupPath
    WITH DIFFERENTIAL, NAME = N'Differential Backup QL_CHUNGCU';

    PRINT N'Differential backup đã thực hiện: ' + @BackupPath;
END
ELSE IF @DayOfWeek IN ('Wednesday','Saturday')  -- Log backup
BEGIN
    SET @BackupPath = N'D:\Backup\QL_CHUNGCU_Log_' 
                      + CONVERT(NVARCHAR(8), GETDATE(), 112) + '.trn';

    BACKUP LOG QL_CHUNGCU
    TO DISK = @BackupPath
    WITH NAME = N'Transaction Log Backup QL_CHUNGCU';

    PRINT N'Log backup đã thực hiện: ' + @BackupPath;
END

-- ================================
-- 4. Kiểm tra dữ liệu rỗng / NULL
-- ================================
PRINT N'Kiểm tra dữ liệu rỗng trong các bảng quan trọng...';
SELECT * FROM HOPDONG WHERE NgayKy IS NULL OR MaCanHo IS NULL OR MaCD IS NULL;
SELECT * FROM HOADON WHERE MaHDong IS NULL OR NgayLap IS NULL;
SELECT * FROM XE WHERE MaCanHo IS NULL OR NgayDangKy IS NULL;

-- ================================
-- 5. Báo cáo nhanh
-- ================================
PRINT N'Báo cáo tình trạng hợp đồng và căn hộ...';
SELECT
    COUNT(*) AS TongSoCanHo,
    SUM(CASE WHEN TrangThai = N'Trống' THEN 1 ELSE 0 END) AS SoCanHoTrong,
    SUM(CASE WHEN TrangThai = N'Đã được mua' THEN 1 ELSE 0 END) AS SoCanHoDaMua,
    SUM(CASE WHEN TrangThai = N'Đã cho thuê' THEN 1 ELSE 0 END) AS SoCanHoDaThue
FROM CANHO;

PRINT N'Báo cáo số hợp đồng còn hiệu lực...';
SELECT
    COUNT(*) AS TongHopDong,
    SUM(CASE WHEN TrangThai = N'Còn hiệu lực' THEN 1 ELSE 0 END) AS HopDongConHieuLuc,
    SUM(CASE WHEN TrangThai = N'Hết hiệu lực' THEN 1 ELSE 0 END) AS HopDongHetHieuLuc
FROM HOPDONG;

PRINT N'Báo cáo xe hết hạn...';
SELECT COUNT(*) AS XeHetHan
FROM XE
WHERE TrangThai = N'Hết hạn';


