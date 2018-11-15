--create database SQL_BookRegistrationManagement

go
use SQL_BookRegistrationManagement

--Tao cac Table
go
create table KHOA
(
	MaKhoa nchar(10) primary key not null,
	TenKhoa nvarchar(100) not null,
	VanPhongKhoa nvarchar(100) not null,
	SDT char(10)
)

go
create table LOP(
	MaLop nchar(10) primary key not null,
	TenLop nvarchar(100) not null,
	GVChuNhiem nvarchar(50) not null,
	MaKhoa nchar(10)
)

go
create table SINHVIEN(
	MaSV nchar(10) NOT NULL PRIMARY KEY,
	HoSV NVARCHAR(30) NOT NULL,
	TenSV NVARCHAR(25) NOT NULL,
	GioiTinh NCHAR(3) not null,
	NgaySinh DATE not null,
	NoiSinh NVARCHAR(50)not null,
	DiaChi NVARCHAR(50) not null,
	MaLop nchar(10)
)
--ALTER TABLE SINHVIEN
--ALTER COLUMN MaSV nchar(10)

go
create table KYHOC(
	MaKyHoc nchar(10) primary key not null,
	TenKyHoc nvarchar(100) not null,
	MaSV nchar(10)
)

go
create table LOAISACH(
	MaLoaiSach nchar(10) primary key not null,
	TenLoaiSach nvarchar(100) not null,
	MaKyHoc nchar(10)
)

go
create table SACH(
	MaSach nchar(10) primary key not null,
	TenSach nvarchar(100) not null,
	SoLuong int not null,
	GiaTien int not null,
	MaLoaiSach nchar(10),
	MaTG nchar(10),
	MaNSX nchar(10),
)

-- Tạo table tac gia
go
create table TACGIA(
	MaTG nchar(10) primary key not null,
	TenTG nvarchar (100) not null,
	NamSinh	int
)

go
create table NSX(
	MaNSX nchar(10) primary key not null,
	TenNSX nvarchar(100) not null,
	DiaChi nvarchar(250) not null,
	SDT char(10)
)
--go
--alter table NSX
--alter column SDT char(10)
-- Tạo table chi tiet hóa đơn
go
create table CHITIETHOADON(
	MaHD nchar(10) not null,
	SoLuong int not null,
	MaSach nchar(10) not null,
)

-- Tạo table hóa đơn
go
create table HOADON(
	MaHD nchar(10) primary key not null,
	MaNV nchar(10) not null,
	MaSV nchar(10) not null,
	MaSach nchar(10) not null,
	SoLuong int not null,
	NgayLapHD nvarchar(20) not null,
)

-- Tạo table nhân viên
go
create table NHANVIEN(
	MaNV nchar(10) primary key not null,
	HoTenNV nvarchar(25) not null,
	DiaChi nvarchar(250) not null,
	GioiTinh nvarchar(5) not null,
	SDT char(10) not null
)

--thêm khóa ngoại bảng KHOA - LOP
go
alter table LOP
Add constraint fk_KHOA_LOP foreign key (MaKhoa) references KHOA(MaKhoa)

--thêm khóa ngoại bảng LOP - SINHVIEN
go
alter table SINHVIEN
Add constraint fk_LOP_SINHVIEN foreign key (MaLop) references LOP(MaLop)

--thêm khóa ngoại bảng SINHVIEN - KYHOC
go
alter table KYHOC
Add constraint fk_SINHVIEN_KYHOC foreign key (MaSV)references SINHVIEN(MaSV)

--thêm khóa ngoại bảng KYHOC - LOAISACH
go
alter table LOAISACH
Add constraint fk_KYHOC_LOAISACH foreign key (MaKyHoc)references KYHOC(MaKyHoc)

--thêm khóa ngoại bảng - LOAISACH - SACH
go
alter table SACH
Add constraint fk_LOAISACH_SACH foreign key (MaLoaiSach) references LOAISACH(MaLoaiSach)

--thêm khóa ngoại bảng SACH - CHITIETHOADON
go
alter table CHITIETHOADON 
Add constraint fk_SACH_CHITIETHOADON foreign key (MaSach) references SACH(MaSach) 

--thêm khóa ngoại bảng TACGIA - SACH
go
alter table SACH 
Add constraint fk_TACGIA_SACH foreign key (MaTG) references TACGIA(MaTG)

--thêm khóa ngoại bảng NSX - SACH
go
alter table SACH 
Add constraint fk_NSX_SACH foreign key (MaNSX) references NSX(MaNSX)

-- khoa ngoai HOADON - CHITIETHOADON
go
alter table CHITIETHOADON
Add constraint fk_HoaDon_ChiTietHoaDon foreign key (MaHD) references HoaDon(MaHD)

--thêm khóa ngoại bảng nhân viên - hóa đơn
go
alter table HOADON
Add constraint fk_NHANVIEN_HOADON foreign key (MaNV) references NHANVIEN(MaNV)

--thêm khóa ngoại bảng khách hàng - hóa đơn
go
alter table HOADON
Add constraint fk_SINHVIEN_HOADON foreign key (MaSV) references SINHVIEN(MaSV)

-- Store

----them sua xoa KHOA
--them
go
create proc sp_themKhoa(@MaKhoa nchar(10),@TenKhoa nvarchar(100),@VanPhongKhoa nvarchar(100),@SDT char(10))
as
insert into KHOA values(@MaKhoa,@TenKhoa,@VanPhongKhoa,@SDT)
go
create proc sp_capnhapKhoa(@MaKhoa nchar(10),@TenKhoa nvarchar(100),@VanPhongKhoa nvarchar(100),@SDT char(10))
as
update KHOA
set TenKhoa = @TenKhoa,
VanPhongKhoa = @VanPhongKhoa,
SDT =@SDT
where MaKhoa = @MaKhoa
--xoa KHOA
go
create proc sp_xoaKhoa(@maKhoa nchar(10))
as
delete from KHOA where MaKhoa = @maKhoa

--tim kiem KHOA

--tim theo ten
go
create proc sp_timKiemKhoaTheoTen(@tenKhoa nvarchar(100))
as
select * from KHOA where TenKhoa like '%' + @tenKhoa + '%'

--tim kiem theo ma
go
create proc sp_timKiemKhoaTheoMa(@maKhoa nchar(10))
as
select * from KHOA where MaKhoa like '%' + @maKhoa + '%'
go
--lay danh sach khach hang
create proc sp_layDSKhoa
as
select * from KHOA

----them sua xoa LOP
--them
go
create proc sp_themLop(@MaLop nchar(10),@TenLop nvarchar(100),@GVChuNhiem nvarchar(50),@MaKhoa nchar(10))
as
insert into LOP values(@MaLop,@TenLop,@GVChuNhiem,@MaKhoa)
go
create proc sp_capnhapLop(@MaLop nchar(10),@TenLop nvarchar(100),@GVChuNhiem nvarchar(50),@MaKhoa nchar(10))
as
update LOP
set TenLop = @TenLop,
GVChuNhiem = @GVChuNhiem
where MaLop = @MaLop

--xoa LOP
go
create proc sp_xoaLop(@maLop nchar(10))
as
delete from LOP where MaLop = @maLop

--tim kiem LOP

--tim theo ten
go
create proc sp_timKiemLopTheoTen(@tenLop nvarchar(100))
as
select * from LOP where TenLop like '%' + @tenLop + '%'

--tim kiem theo ma
go
create proc sp_timKiemLopTheoMa(@maLop nchar(10))
as
select * from LOP where MaLop like '%' + @maLop + '%'
go
--lay danh sach khach hang
create proc sp_layDSLop
as
select * from LOP

--them xoa sua SINHVIEN
--them
go
create proc sp_themSV(@MaSV nchar(10),@HoSV NVARCHAR(30),@TenSV NVARCHAR(25),@GioiTinh NCHAR(3),@NgaySinh DATE,@NoiSinh NVARCHAR(50),@DiaChi NVARCHAR(50),@MaLop nchar(10))
as
insert into SINHVIEN values(@MaSV,@HoSV,@TenSV,@GioiTinh,@NgaySinh,@NoiSinh,@DiaChi,@MaLop)
go
create proc sp_capnhapSV(@MaSV nchar(10),@HoSV NVARCHAR(30),@TenSV NVARCHAR(25),@GioiTinh NCHAR(3),@NgaySinh DATE,@NoiSinh NVARCHAR(50),@DiaChi NVARCHAR(50),@MaLop nchar(10))
as
update SINHVIEN
set HoSV = @HoSV,
TenSV = @TenSV,
GioiTinh = @GioiTinh,
NgaySinh = @NgaySinh,
NoiSinh = @NoiSinh,
DiaChi = @DiaChi,
MaLop = @MaLop
where MaSV = @MaSV

--xoa SINHVIEN
go
create proc sp_xoaSV(@maSV nchar(10))
as
delete from SINHVIEN where MaSV = @maSV

--tim kiem SINHVIEN
--tim theo ten
go
create proc sp_timKiemSVTheoTen(@tenSV nvarchar(25))
as
select * from SINHVIEN where TenSV like '%' + @tenSV + '%'
--tim kiem theo ma
go
create proc sp_timKiemSVTheoMa(@maSV nvarchar(30))
as
select * from SINHVIEN where MaSV like '%' + @maSV + '%'
go
--lay danh sach SINHVIEN
create proc sp_layDSSV
as
select * from SINHVIEN

--them xoa sua KYHOC
--them
go
create proc sp_themKyHoc(@MaKyHoc nchar(10),@TenKyHoc nvarchar(100),@MaSV nchar(10))
as
insert into KYHOC values(@MaKyHoc,@TenKyHoc,@MaSV)
go
create proc sp_capnhapKyHoc(@MaKyHoc nchar(10),@TenKyHoc nvarchar(100),@MaSV nchar(10))
as
update KYHOC
set TenKyHoc = @TenKyHoc,
MaSV = @MaSV
where MaKyHoc = @MaKyHoc

--xoa KYHOC
go
create proc sp_xoaKyHoc(@maKyHoc nchar(10))
as
delete from KYHOC where MaKyHoc = @maKyHoc

--tim kiem KYHOC
--tim theo ten
go
create proc sp_timKiemKyHocTheoTen(@tenKyHoc nvarchar(100))
as
select * from KYHOC where TenKyHoc like '%' + @tenKyHoc + '%'
--tim kiem theo ma
go
create proc sp_timKiemKyHocTheoMa(@maKyHoc nvarchar(10))
as
select * from KYHOC where MaKyHoc like '%' + @maKyHoc + '%'
go
--lay danh sach KYHOC
create proc sp_layDSKyHoc
as
select * from KYHOC

--them, xoa, sua LOAISACH
--proc them
go
create proc sp_themLoaiSach(@MaLoaiSach nchar(10),@TenLoaiSach nvarchar(100),@MaKyHoc nchar(10))
as
insert into LOAISACH values(@MaLoaiSach,@TenLoaiSach,@MaKyHoc)

-- thực thi 

-- proc sua
go
create proc sp_capnhapLoaiSach(@MaLoaiSach nchar(10),@TenLoaiSach nvarchar(100),@MaKyHoc nchar(10))
as
update LOAISACH
set TenLoaiSach = @TenLoaiSach,
MaKyHoc = @MaKyHoc
where MaLoaiSach = @MaLoaiSach
--xoa loai sach
go
create proc sp_xoaLoaiSach(@maLoaiSach nchar(10))
as
delete from LOAISACH where MaLoaiSach = @maLoaiSach

--tim kiem theo loại sách
-- tìm kiếm theo mã
go
create proc sp_timKiemLoaiSachTheoMa(@maLoaiSach nvarchar(30))
as
select * from LOAISACH where MaLoaiSach like '%' + @maLoaiSach + '%'

--tim kiếm theo ten
go
create proc sp_timKiemLoaiSachTheoTen(@tenLoaiSach nvarchar(30))
as
select * from LOAISACH where TenLoaiSach like '%' + @tenLoaiSach + '%'

--them xoa sua SACH
--them
go
create proc sp_themSach(@MaSach nchar(10),@TenSach nvarchar(100),@SoLuong int,@GiaTien int,@MaLoaiSach nchar(10),@MaTG nchar(10),@MaNSX nchar(10))
as
insert into SACH values(@MaSach,@TenSach,@SoLuong,@GiaTien,@MaLoaiSach,@MaTG,@MaNSX)
go
create proc sp_capnhapSach(@MaSach nchar(10),@TenSach nvarchar(100),@SoLuong int,@GiaTien int,@MaLoaiSach nchar(10),@MaTG nchar(10),@MaNSX nchar(10))
as
update SACH
set TenSach = @TenSach,
SoLuong = @SoLuong,
GiaTien = @GiaTien,
MaLoaiSach = @MaLoaiSach,
MaTG = @MaTG,
MaNSX = @MaNSX
where MaSach = @MaSach

--xoa SACH
go
create proc sp_xoaSach(@maSach nchar(10))
as
delete from SACH where MaSach = @maSach

--tim kiem SACh
--tim theo ten
go
create proc sp_timKiemSachTheoTen(@tenSach nvarchar(100))
as
select * from SACH where TenSach like '%' + @tenSach + '%'
--tim kiem theo ma
go
create proc sp_timKiemSachTheoMa(@maSach nvarchar(10))
as
select * from SACH where MaSach like '%' + @maSach + '%'
go
--lay danh sach SACH
create proc sp_layDSSach
as
select * from SACH

--them xoa sua TACGIA
--proc them tac gia
go
create proc sp_themTacGia(@MaTG nchar(10),@TenTG nvarchar(100),@NamSinh int)
as
insert into TACGIA values(@MaTG,@TenTG,@NamSinh)

--proc sua tac gia
go
create proc sp_capnhapTacGia(@MaTG nchar(10),@TenTG nvarchar(100),@NamSinh int)
as
update TACGIA
set TenTG = @TenTG,
NamSinh = @NamSinh
where MaTG = @MaTG

--proc xoa tac gia
go
create proc sp_xoaTacGia(@maTG nchar(10))
as
delete from TACGIA where MaTG = @maTG

-- tim kiếm tác giả
 --tim theo ten
go
create proc sp_timKiemTGTheoTen(@tenTG nvarchar(50))
as
select * from TACGIA where TenTG like '%' + @tenTG + '%'
--tim kiem theo ma
go
create proc sp_timKiemTGTheoMa(@maTG nvarchar(30))
as
select * from TACGIA where MaTG like '%' + @maTG + '%'

-- Lay danh sach TACGIA
go
create proc sp_layDSTG
as
select * from TACGIA

--them xoa sua NSX
-- proc them nsx
go
create proc sp_themNSX(@MaNSX nchar(10),@TenNSX nvarchar(100),@DiaChi nvarchar(250),@SDT char(10))
as
insert into NSX values(@MaNSX,@TenNSX,@DiaChi,@SDT)

--proc sua nsx
go
create proc sp_capnhapNSX(@MaNSX nchar(10),@TenNSX nvarchar(100),@DiaChi nvarchar(250),@SDT char(10))
as
update NSX
set TenNSX = @TenNSX,
DiaChi = @DiaChi,
SDT = @SDT
where MaNSX = @MaNSX

-- xoa nsx
go
create proc sp_xoaNSX(@maNSX nchar(10))
as
delete from NSX where MaNSX = @maNSX

-- thuc thi exec
exec sp_capnhapNSX N'nsx001','sdsfdsf','sdfsdf','098776543'
--tim kiem NSX
--tim theo ten
go
create proc sp_timKiemNSX(@tenNSX nvarchar(30))
as
select * from NSX where TenNSX like '%' + @tenNSX + '%'

--tim kiem theo ma
go
create proc sp_timKiemNSXMa(@maNSX nvarchar(30))
as
select * from NSX where MaNSX like '%' + @maNSX + '%'

--lay danh sach nsx
go
create proc sp_layDSNSX
as
select * from NSX

-- Them xoa sửa CHITIETHOADON
-- proc thêm

go
create proc sp_themCTHD(@MaHD nchar(10),@MaSach nchar(10),@SoLuong int )
as
insert into CHITIETHOADON values(@MaHD,@MaSach ,@SoLuong )

--proc sua CHITIETHOADON
go
create proc sp_capnhapCTHD(@MaHD nchar(10),@MaSach nchar(10),@SoLuong int )
as
update CHITIETHOADON
set MaSach = @MaSach,
SoLuong= @SoLuong
where MaHD = @MaHD

-- xoa CHITIETHOADON
go
create proc sp_xoaCTHD(@maCTHD nchar(10))
as
delete from CHITIETHOADON where MaHD = @maCTHD


--Thêm xóa sửa hóa đơn
-- proc thêm

go
create proc sp_themHoaDon(@MaHD nchar(10),@MaNV nchar(10),@MaSV nchar(10),@MaSach nchar(10),@SoLuong int,@NgayLapHD nvarchar(20))
as
insert into HOADON values(@MaHD ,@MaNV,@MaSV,@MaSach,@SoLuong,CONVERT(varchar,@NgaylapHD, 103) )

--proc sua hóa đơn
go
create proc sp_capnhapHoaDon(@MaHD nchar(10) ,@MaNV nchar(10),@MaSV nchar(10),@MaSach nchar(10), @SoLuong int,@NgayLapHD nvarchar(20))
as
update HOADON
set MaNV = @MaNV,
MaSV= @MaSV,
MaSach = @MaSach,
SoLuong = @SoLuong,
NgayLapHD = CONVERT(varchar,@NgaylapHD, 103)
where MaHD = @MaHD
-- xoa Hoa Don
go
create proc sp_xoaHoaDon(@maHD nchar(10))
as
delete from HOADON where MaHD = @maHD

--lay danh sach hoa don
go
create proc sp_layDSHD
as
select hd.MaHD,hd.MaNV,nv.HoTenNV,sv.MaSV,hd.MaSach,sa.TenSach,sa.GiaTien,hd.NgayLapHD,hd.SoLuong,(hd.SoLuong * sa.GiaTien) as 'Thành Tiền' from HOADON hd
INNER JOIN SACH sa ON hd.MaSach = sa.MaSach
INNER JOIN NHANVIEN nv ON hd.MaNV = nv.MaNV
INNER JOIN SINHVIEN sv ON hd.MaSV = sv.MaSV
--tim kiem hoa don theo khach hang va nhan vien
--go
--create function sp_timkiemHD(@MaNV nchar(10),@MaSV nchar(10))
--returns table as
--return(select nv.HoTenNV,sv.MaSV,sa.TenSach,sa.GiaTien,hd.NgayLapHD,hd.SoLuong, (hd.SoLuong * sa.GiaTien) as 'Thành Tiền'
--from HOADON hd
--INNER JOIN SACH sp ON hd.MaSach = sp.MaSach
--INNER JOIN NHANVIEN nv ON hd.MaNV = nv.MaNV
--INNER JOIN SINHVIEN sv ON hd.MaSV = sv.MaSV
--where nv.MaNV LIKE '%' + @MaNV+ '%' and sv.MaSV LIKE '%' + @MaSV + '%')
---- goi ham
--go
--create proc sp_timHD(@MaNV nchar(10),@MaKH nchar(10))
--as
--select * from sp_timkiemHD(@MaNV,@MaKH)

--them xoa sua nhan vien
--them

go
create proc sp_themNV(@MaNV nchar(10),@HoTenNV nvarchar(25),@DiaChi nvarchar(250),@GioiTinh nvarchar(5),@SDT char(11))
as
insert into NHANVIEN values(@MaNV,@HoTenNV,@DiaChi,@GioiTinh,@SDT)
go
create proc sp_capnhapNV(@MaNV nchar(10),@HoTenNV nvarchar(25),@DiaChi nvarchar(250),@GioiTinh nvarchar(5),@SDT char(11))
as
update NHANVIEN
set HoTenNV = @HoTenNV,
DiaChi = @DiaChi,
GioiTinh = @GioiTinh,
SDT =@SDT
where MaNV = @MaNV
--xoa nhan vien
go
create proc sp_xoaNV(@maNV nchar(10))
as
delete from NHANVIEN where MaNV = @maNV
--tim kiem nhan vien
--tim theo ten
go
create proc sp_timKiemNVTheoTen(@tenNV nvarchar(30))
as
select * from NHANVIEN where HoTenNV like '%' + @tenNV + '%'
--tim kiem theo ma
go
create proc sp_timKiemNVTheoMa(@maNV nvarchar(30))
as
select * from NHANVIEN where MaNV like '%' + @maNV + '%'
go
--lay danh sach khach hang
create proc sp_layDSNV
as
select * from NHANVIEN
