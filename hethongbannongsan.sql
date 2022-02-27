create database He_thong_ban_nong_san;
use He_thong_ban_nong_san;

-- BẢNG NHÂN VIÊN
create table Nhan_vien(
	ID_nhan_vien char(7) primary key,
    Ten_nhan_vien varchar(50),
    Gioi_tinh enum('Nam','Nữ'),
    Nam_sinh date,
    Dia_chi varchar(100),
    Chuc_vu varchar(30),
    Sdt varchar(15)
);

-- BẢNG KHÁCH HÀNG
create table Khach_hang(
	ID_khach_hang char(7) primary key,
    Ten_khach_hang varchar(50),
    Gioi_tinh enum('Nam','Nữ', 'null'),
    Dia_chi varchar(100),
    Sdt varchar(15)
);

-- BẢNG LOẠI NÔNG SẢN
create table Loai_nong_san(
	ID_loai char(7) primary key,
    Ten_loai varchar(100)
);

-- BẢNG TÊN HANG HÓA
create table Hang_hoa(
	 ID_hang_hoa char(7) primary key,
     ID_loai char(7),
     Ten_hang_hoa varchar(100)
);

-- BẢNG HÓA ĐƠN NHẬP
create table Hoa_don_nhap (
	ID_hoa_don varchar(10) primary key,
	Ngay date,
	check (Ngay<=now()),
    ID_khach_hang char(7),
	ID_nhan_vien char(7)
);

-- BẢNG CHI TIẾT HÓA ĐƠN NHẬP
create table Chi_tiet_hoa_don_nhap(
	ID_loai char(7) primary key not null,
    Ten_loai_nong_san varchar(100) not null,
    Gia_ban decimal(8,3),
    So_luong int
);

-- BẢNG TỒN KHO
create table Ton_kho(
	ID_loai_ton char(7) primary key not null,
    Ten_loai_ton varchar(100),
    So_luong int
);

-- BẢNG HÓA ĐƠN XUẤT
create table Hoa_don_xuat(
	ID_hoa_don varchar(10),
	Ngay date,
	check (Ngay<=now()),
	ID_nhan_vien varchar(10)
);

-- BẢNG CHI TIẾT HÓA ĐƠN XUẤT
create table Chi_tiet_hoa_don_xuat(
	ID_hd_xuat char(7) primary key not null,
    Ten_loai_nong_san varchar(100),
    Gia_ban decimal(8,3),
    So_luong int
);