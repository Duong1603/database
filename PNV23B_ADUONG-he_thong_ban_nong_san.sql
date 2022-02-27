-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 25, 2021 at 03:02 AM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 7.4.13

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `he_thong_ban_nong_san`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `hienthinamban` (IN `nam` YEAR)  NO SQL
SELECT cthdx.Ten_loai_nong_san AS ten_nong_san_da_ban, hdx.Ngay AS nam_ban FROM hoa_don_xuat hdx JOIN chi_tiet_hoa_don_xuat cthdx
ON hdx.ID_hoa_don = cthdx.ID_hoa_don
WHERE (year(hdx.Ngay)) = nam$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `timkiemmanhanvien` (IN `ID_nhan_vien` CHAR(7))  NO SQL
BEGIN
	SELECT * FROM nhan_vien
    WHERE nhan_vien.ID_nhan_vien = ID_nhan_vien;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `timkiemnammua` (IN `nam` YEAR)  NO SQL
SELECT cthdn.Ten_loai_nong_san, hdn.Ngay AS ngaynhap FROM hoa_don_nhap hdn JOIN chi_tiet_hoa_don_nhap cthdn
ON hdn.ID_hoa_don = cthdn.ID_hoa_don
WHERE (year(hdn.Ngay)) = nam$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `check_giabancuanongsan_bang_manhanvien` (`ID_nhan_vien` CHAR(7)) RETURNS VARCHAR(50) CHARSET utf8mb4 NO SQL
BEGIN
	RETURN 
	(SELECT SUM(cthdx.Gia_ban)
	FROM chi_tiet_hoa_don_xuat cthdx 
	JOIN hoa_don_xuat hdx on hdx.ID_hoa_don = cthdx.ID_hoa_don
     JOIN nhan_vien nv 
     ON nv.ID_nhan_vien = hdx.ID_nhan_vien
	WHERE hdx.ID_nhan_vien = ID_nhan_vien
    GROUP BY hdx.ID_nhan_vien );
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `check_soluongban_bang_ten_loai` (`Ten_loai` VARCHAR(20)) RETURNS INT(11) NO SQL
BEGIN
	RETURN 
	(SELECT SUM(cthdx.So_luong)
	FROM chi_tiet_hoa_don_xuat cthdx 
	JOIN loai_nong_san lns on lns.ID_loai = cthdx.ID_loai
	WHERE lns.Ten_loai = Ten_loai
    GROUP BY cthdx.ID_loai);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `hàm_tim_kiếm_nhan_vien_mua_hang_theo_năm` (`manv` CHAR(7), `nam` YEAR) RETURNS INT(11) NO SQL
BEGIN
	RETURN 
	(SELECT COUNT(HDN.Ngay ) 
	FROM hoa_don_nhap HDN 
	JOIN nhan_vien nv on nv.ID_nhan_vien = HDN.ID_nhan_vien
	WHERE (year(HDN.Ngay) = nam) and nv.ID_nhan_vien = manv);
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `loinhuanhangthang` (`thang` INT, `nam` INT) RETURNS INT(11) NO SQL
RETURN
(SELECT SUM(cthdx.Gia_ban - cthdn.Gia_mua) 
 FROM chi_tiet_hoa_don_xuat cthdx
 JOIN hoa_don_xuat hdx ON cthdx.ID_hoa_don = hdx.ID_hoa_don
 JOIN chi_tiet_hoa_don_nhap cthdn
 ON cthdx.ID_loai = cthdn.ID_loai
WHERE (month(hdx.Ngay))= thang AND (year(hdx.Ngay))= nam)$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `chi_tiet_hoa_don_nhap`
--

CREATE TABLE `chi_tiet_hoa_don_nhap` (
  `ID_hoa_don` char(7) NOT NULL,
  `Ten_loai_nong_san` varchar(100) NOT NULL,
  `Gia_mua` decimal(8,3) DEFAULT NULL,
  `So_luong` int(11) DEFAULT NULL,
  `ID_loai` char(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `chi_tiet_hoa_don_nhap`
--

INSERT INTO `chi_tiet_hoa_don_nhap` (`ID_hoa_don`, `Ten_loai_nong_san`, `Gia_mua`, `So_luong`, `ID_loai`) VALUES
('HD10235', 'Ổi hạt tiêu', '15.000', 10, 'L000001'),
('HD10265', 'Quýt tam hoa', '60.000', 10, 'L000001'),
('HD10278', 'Hạt sen', '200.000', 10, 'L000004'),
('HD10459', 'cacao', '450.000', 15, 'L000006'),
('HD10498', 'Hoa cúc vàng', '60.000', 10, 'L000005'),
('HD10856', 'Khoai tây', '50.000', 10, 'L000003'),
('HD13659', 'Lựu siêu nước', '150.000', 10, 'L000001'),
('HD14522', 'Khoai lang', '15.000', 2, 'L000003'),
('HD14538', 'Ngò gai', '30.000', 5, 'L000002'),
('HD15454', 'Bắp nếp', '35.000', 5, 'L000006'),
('HD15963', 'Sắn dây', '80.000', 10, 'L000004'),
('HD18564', 'Hoa sen', '900.000', 20, 'L000004'),
('HD25697', 'cần tây', '35.000', 10, 'L000002'),
('HD25698', 'luly', '100.000', 10, 'L000005');

-- --------------------------------------------------------

--
-- Table structure for table `chi_tiet_hoa_don_xuat`
--

CREATE TABLE `chi_tiet_hoa_don_xuat` (
  `ID_hoa_don` char(7) NOT NULL,
  `Ten_loai_nong_san` varchar(100) DEFAULT NULL,
  `Gia_ban` decimal(8,3) DEFAULT NULL,
  `So_luong` int(11) DEFAULT NULL,
  `ID_loai` char(7) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `chi_tiet_hoa_don_xuat`
--

INSERT INTO `chi_tiet_hoa_don_xuat` (`ID_hoa_don`, `Ten_loai_nong_san`, `Gia_ban`, `So_luong`, `ID_loai`) VALUES
('HDX0368', 'Rau xà lách', '300.000', 20, 'L000002'),
('HDX1564', 'Hạt điều', '250.000', 10, 'L000004'),
('HDX3654', 'Táo Canada', '100.000', 10, 'L000001'),
('HDX4442', 'Lúa thơm', '500.000', 20, 'L000006'),
('HDX4895', 'cacao', '900.000', 25, 'L000006'),
('HDX4956', 'Hạt sen', '90.000', 15, 'L000004'),
('HDX6235', 'Ổi hạt tiêu', '60.000', 5, 'L000001'),
('HDX6548', 'Hoa anh đào', '8000.000', 2, 'L000005'),
('HDX6987', 'Hoa cúc vàng', '45.000', 10, 'L000005'),
('HDX9459', 'Cà rốt', '200.000', 10, 'L000003');

-- --------------------------------------------------------

--
-- Table structure for table `hang_hoa`
--

CREATE TABLE `hang_hoa` (
  `ID_hang_hoa` char(7) NOT NULL,
  `ID_loai` char(7) DEFAULT NULL,
  `Ten_hang_hoa` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `hang_hoa`
--

INSERT INTO `hang_hoa` (`ID_hang_hoa`, `ID_loai`, `Ten_hang_hoa`) VALUES
('HH01013', 'L000001', 'Ổi hạt tiêu'),
('HH01014', 'L000001', 'Quýt tam hoa'),
('HH01016', 'L000006', 'Lúa thơm lài\r\n'),
('HH01019', 'L000003', 'cà rốt'),
('HH01026', 'L000005', 'cúc vàng'),
('HH01027', 'L000004', 'sen'),
('HH01098', 'L000006', 'bắp nếp'),
('HH01204', 'L000005', 'anh đào'),
('HH01658', 'L000003', 'khoai tây'),
('HH02056', 'L000002', 'ngò gai'),
('HH10101', 'L000001', 'Táo Canada'),
('HH10103', 'L000001', 'Lựu siêu nước'),
('HH10105', 'L000002', 'xà lách'),
('HH10115', 'L000004', 'sắn dây'),
('HH10126', 'L000004', 'điều'),
('HH10205', 'L000005', 'luly'),
('HH10308', 'L000002', 'cần tây'),
('HH10456', 'L000006', 'cacao'),
('HH10563', 'L000001', 'Xoài'),
('HH12154', 'L000003', 'khoai lang');

--
-- Triggers `hang_hoa`
--
DELIMITER $$
CREATE TRIGGER `INSERT_Hanghoa` BEFORE INSERT ON `hang_hoa` FOR EACH ROW INSERT INTO lichsu_hanghoa(Ten_hang_hoa,su_kien,ngay_dienra)VALUES
(new.Ten_hang_hoa,'INSERT',now())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `check_ma_loai_hang_hoa` BEFORE UPDATE ON `hang_hoa` FOR EACH ROW BEGIN
    IF (new.ID_hang_hoa IN (SELECT ID_hang_hoa FROM hang_hoa)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'không thể update';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `hien_thi_hang_xuat_hien_tren_3_lan`
-- (See below for the actual view)
--
CREATE TABLE `hien_thi_hang_xuat_hien_tren_3_lan` (
`tong_so_hang_xuat_hon_3_lan` int(1)
);

-- --------------------------------------------------------

--
-- Table structure for table `hoa_don_nhap`
--

CREATE TABLE `hoa_don_nhap` (
  `ID_hoa_don` varchar(10) NOT NULL,
  `Ngay` date DEFAULT NULL,
  `ID_nhan_vien` char(7) DEFAULT NULL
) ;

--
-- Dumping data for table `hoa_don_nhap`
--

INSERT INTO `hoa_don_nhap` (`ID_hoa_don`, `Ngay`, `ID_nhan_vien`) VALUES
('HD10235', '2016-05-06', 'NV00010'),
('HD10265', '2016-05-19', 'NV00010'),
('HD10278', '2017-04-24', 'NV00008'),
('HD10459', '2015-10-16', 'NV00004'),
('HD10498', '2018-01-19', 'NV00007'),
('HD10856', '2019-06-14', 'NV00007'),
('HD13659', '2019-12-22', 'NV00009'),
('HD14522', '2016-02-05', 'NV00006'),
('HD14538', '2016-07-25', 'NV00005'),
('HD15454', '2020-06-25', 'NV00003'),
('HD15963', '2018-12-14', 'NV00010'),
('HD18564', '2020-08-31', 'NV00004'),
('HD25697', '2016-03-16', 'NV00008'),
('HD25698', '2017-11-28', 'NV00009'),
('HD35578', '2020-09-22', 'NV00007'),
('HD35698', '2016-09-17', 'NV00006'),
('HD44457', '2017-02-05', 'NV00003');

-- --------------------------------------------------------

--
-- Table structure for table `hoa_don_xuat`
--

CREATE TABLE `hoa_don_xuat` (
  `ID_hoa_don` varchar(10) NOT NULL,
  `Ngay` date DEFAULT NULL,
  `ID_nhan_vien` varchar(10) DEFAULT NULL
) ;

--
-- Dumping data for table `hoa_don_xuat`
--

INSERT INTO `hoa_don_xuat` (`ID_hoa_don`, `Ngay`, `ID_nhan_vien`) VALUES
('HDX0368', '2016-12-15', 'NV00004'),
('HDX1564', '2020-03-28', 'NV00005'),
('HDX3654', '2020-05-10', 'NV00003'),
('HDX4442', '2015-10-28', 'NV00004'),
('HDX4895', '2016-04-18', 'NV00007'),
('HDX4956', '2021-10-12', 'NV00006'),
('HDX6235', '2018-12-16', 'NV00010'),
('HDX6548', '2015-10-20', 'NV00009'),
('HDX6987', '2018-12-29', 'NV00005'),
('HDX9459', '2017-03-25', 'NV00004');

-- --------------------------------------------------------

--
-- Table structure for table `khach_hang`
--

CREATE TABLE `khach_hang` (
  `ID_khach_hang` char(7) NOT NULL,
  `Ten_khach_hang` varchar(50) DEFAULT NULL,
  `Gioi_tinh` enum('Nam','Nữ','null') DEFAULT NULL,
  `Dia_chi` varchar(100) DEFAULT NULL,
  `Sdt` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `khach_hang`
--

INSERT INTO `khach_hang` (`ID_khach_hang`, `Ten_khach_hang`, `Gioi_tinh`, `Dia_chi`, `Sdt`) VALUES
('KH11111', 'Hoàng Thùy Tiên', 'Nữ', 'số 75 đường Sơn Nam huyện Hào Sơn tỉnh Nghệ An', '0597763345'),
('KH11112', 'Nguyễn Hòa Tuy Vũ', 'Nam', 'số 16 khu công nghiệp Hòa Trơn huyện Tam Thủy tỉnh Vĩnh Long', '0469953357'),
('KH11121', 'Lê Đăng Sơn Phong', 'Nam', 'huyện Ba Vì thành phố Hà Nội', '0254698763'),
('KH11122', 'Nguyễn Thanh Tâm', 'Nữ', 'xẫ Hòa Lộc huyện Tuy Phước tỉnh Tiền Giang', '0578894564'),
('KH11126', 'Trương Quang Trí', 'Nam', 'số 57 đường Hòa Nghi huyện Đăk Tô tỉnh Kon Tum', '0485612354'),
('KH11236', 'Phạm Văn Sang', 'Nam', 'thôn 2 xã Kon Đào huyện Đăk Tô tỉnh Kon Tum', '0489635515'),
('KH11457', 'Võ Trí Hội', 'Nam', 'khối 5 thị trấn Đăk Tô huyện Đăk Tô tỉnh Kon Tum', '0486635976'),
('KH11964', 'Buôn Giá Đa Cô Vi', 'Nữ', 'Huyện Đăk Hà Kon Tum', '0895455858'),
('KH14546', 'Trương Nguyễn Tuấn Anh', 'Nam', 'khối 10 thị trấn Đăk Tô huyện Đăk Tô tỉnh Kon Tum', '0546698876'),
('KH14698', 'Võ Thị Hoàng Oanh', 'Nữ', 'khối 4 thị trấn Đăk Tô huyện Đăk Tô tỉnh Kon Tum', '0569873356'),
('KH17596', 'Trương Nguyễn Thúy Vân', 'Nữ', 'xã Tân Cảnh huyện Đăk Tô tỉnh Kon Tum', '0499635788');

--
-- Triggers `khach_hang`
--
DELIMITER $$
CREATE TRIGGER `DELETE_khachhang` BEFORE DELETE ON `khach_hang` FOR EACH ROW INSERT INTO lichsu_khachhang(Ten_khach_hang,Gioi_tinh,Dia_chi,Sdt,su_kien,ngay_dienra)VALUES
(old.Ten_khach_hang,old.Gioi_tinh,old.Dia_chi,old.Sdt,'DELETE',now())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `INSERT_khachhang` BEFORE INSERT ON `khach_hang` FOR EACH ROW INSERT INTO lichsu_khachhang(Ten_khach_hang,Gioi_tinh,Dia_chi,Sdt,su_kien,ngay_dienra)VALUES
(new.Ten_khach_hang,new.Gioi_tinh,new.Dia_chi,new.Sdt,'INSERT',now())
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `Update_khachhang` BEFORE UPDATE ON `khach_hang` FOR EACH ROW INSERT INTO lichsu_khachhang(Ten_khach_hang,Gioi_tinh,Dia_chi,Sdt,su_kien,ngay_dienra)VALUES
(new.Ten_khach_hang,new.Gioi_tinh,new.Dia_chi,new.Sdt,'update',now())
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `lichsu_hanghoa`
--

CREATE TABLE `lichsu_hanghoa` (
  `Ten_hang_hoa` varchar(50) NOT NULL,
  `STT` int(11) NOT NULL,
  `su_kien` varchar(100) NOT NULL,
  `ngay_dienra` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `lichsu_hanghoa`
--

INSERT INTO `lichsu_hanghoa` (`Ten_hang_hoa`, `STT`, `su_kien`, `ngay_dienra`) VALUES
('Xoài', 1, 'INSERT', '2021-10-22 06:46:12');

-- --------------------------------------------------------

--
-- Table structure for table `lichsu_khachhang`
--

CREATE TABLE `lichsu_khachhang` (
  `Ten_khach_hang` varchar(50) NOT NULL,
  `Gioi_tinh` varchar(10) DEFAULT NULL,
  `Dia_chi` varchar(100) NOT NULL,
  `Sdt` varchar(10) NOT NULL,
  `su_kien` varchar(20) NOT NULL,
  `ngay_dienra` datetime NOT NULL,
  `STT` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `lichsu_khachhang`
--

INSERT INTO `lichsu_khachhang` (`Ten_khach_hang`, `Gioi_tinh`, `Dia_chi`, `Sdt`, `su_kien`, `ngay_dienra`, `STT`) VALUES
('Hoàng Thùy Tiên', 'Nữ', 'số 75 đường Sơn Nam huyện Hào Sơn tỉnh Sơn La', '0597763345', 'update', '2021-10-22 06:33:22', 1),
('Hoàng Thùy Tiên', 'Nữ', 'số 75 đường Sơn Nam huyện Hào Sơn tỉnh Nghệ An', '0597763345', 'update', '2021-10-22 06:33:41', 2),
('Hoàng Thị Thủy', 'Nữ', 'hflajd', '0336698865', 'INSERT', '2021-10-22 06:37:12', 3),
('Hoàng Thị Thủy', 'Nữ', 'hflajd', '0336698865', 'DELETE', '2021-10-22 06:37:31', 4);

-- --------------------------------------------------------

--
-- Table structure for table `lichsu_nhanvien`
--

CREATE TABLE `lichsu_nhanvien` (
  `Ten_nhan_vien` varchar(50) NOT NULL,
  `Chuc_vu` varchar(30) NOT NULL,
  `Sdt` varchar(10) NOT NULL,
  `ngay` datetime NOT NULL,
  `su_kien` varchar(20) NOT NULL,
  `stt` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `lichsu_nhanvien`
--

INSERT INTO `lichsu_nhanvien` (`Ten_nhan_vien`, `Chuc_vu`, `Sdt`, `ngay`, `su_kien`, `stt`) VALUES
('Nguyễn Văn Hiếu', 'Quản lý', '0965506612', '2021-10-22 00:04:39', 'update', 1),
('Nguyễn Văn Tủng', 'Bán hàng', '069451547', '2021-10-22 00:07:42', 'insert', 2),
('Nguyễn Văn Thiên', 'Quản lý', '0965506612', '2021-10-22 08:46:31', 'update', 11),
('Nguyễn Văn Hiếu', 'Quản lý', '0965506612', '2021-10-22 08:46:56', 'update', 12);

-- --------------------------------------------------------

--
-- Table structure for table `loai_nong_san`
--

CREATE TABLE `loai_nong_san` (
  `ID_loai` char(7) NOT NULL,
  `Ten_loai` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `loai_nong_san`
--

INSERT INTO `loai_nong_san` (`ID_loai`, `Ten_loai`) VALUES
('L000001', 'Trái cây'),
('L000002', 'Rau'),
('L000003', 'Củ'),
('L000004', 'Hạt'),
('L000005', 'Hoa\r\n'),
('L000006', 'Lương thực');

-- --------------------------------------------------------

--
-- Stand-in structure for view `loi_nhuan`
-- (See below for the actual view)
--
CREATE TABLE `loi_nhuan` (
`Loi_nhuan` decimal(31,3)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `nhanvienbanduoccacmathang`
-- (See below for the actual view)
--
CREATE TABLE `nhanvienbanduoccacmathang` (
`Ten_nhan_vien` varchar(50)
,`Ten_loai_nong_san` varchar(100)
,`Gia_mua` decimal(8,3)
,`So_luong` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `nhanvienmuaduoccacmathang`
-- (See below for the actual view)
--
CREATE TABLE `nhanvienmuaduoccacmathang` (
`Ten_nhan_vien` varchar(50)
,`Ten_loai_nong_san` varchar(100)
,`Gia_ban` decimal(8,3)
,`So_luong` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `nhan_vien`
--

CREATE TABLE `nhan_vien` (
  `ID_nhan_vien` char(7) NOT NULL,
  `Ten_nhan_vien` varchar(50) DEFAULT NULL,
  `Gioi_tinh` enum('Nam','Nữ') DEFAULT NULL,
  `Nam_sinh` date DEFAULT NULL,
  `Dia_chi` varchar(100) DEFAULT NULL,
  `Chuc_vu` varchar(30) DEFAULT NULL,
  `Sdt` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `nhan_vien`
--

INSERT INTO `nhan_vien` (`ID_nhan_vien`, `Ten_nhan_vien`, `Gioi_tinh`, `Nam_sinh`, `Dia_chi`, `Chuc_vu`, `Sdt`) VALUES
('NV00001', 'Nguyễn Văn Hiếu', 'Nam', '2002-01-01', 'Thôn 3 xã Tân Cảnh huyện Đăk Tô tỉnh Kon Tum', 'Quản lý', '0965506612'),
('NV00002', 'Lê Hoàng Nam', 'Nam', '1978-03-02', 'Thôn 7 xã Chi Đại Huyện Mê Linh tỉnh Kon Tum', 'Thu ngân', '0965534754'),
('NV00003', 'Hoàng Thu Linh', 'Nữ', '1989-05-09', 'xã Chí Lộc huyện Cù Lao tỉnh Hà Giang', 'Bán hàng, vận chuyển, thu mua', '0866334495'),
('NV00004', 'Trần Hoàng Phương', 'Nữ', '1978-12-15', 'xã Hòa Bình huyện Hòa Bình tỉnh Điện Biên', 'Bán hàng, vận chuyển, thu mua', '0364895521'),
('NV00005', 'Trà Thị Mỹ Duyên', 'Nữ', '1999-11-25', 'huyện Kon Rãy tỉnh Kon Tum', 'Bán hàng, vận chuyển, thu mua', '0658894235'),
('NV00006', 'Lê Tọa Am', 'Nam', '1996-08-11', 'phường Hòa Nghĩa thành phố Hà Nội', 'Bán hàng, vận chuyển, thu mua', '0845533268'),
('NV00007', 'Đoàn Tiến Hữu', 'Nam', '1985-10-15', 'xã Kim Long huyện Chư Mon Rây tỉnh Vũng Tàu', 'Bán hàng, vận chuyển, thu mua', '0695354456'),
('NV00008', 'Nguyễn Hoàng Xuân', 'Nam', '1999-03-29', 'huyện Chí Linh tỉnh Cao Bằng', 'Bán hàng, vận chuyển, thu mua', '0365547891'),
('NV00009', 'Tạ Thu Thủy', 'Nữ', '1995-08-24', 'huyện Hòa Nam tỉnh Sơn La', 'Bán hàng, vận chuyển, thu mua', '0698741235'),
('NV00010', 'A Toàn', 'Nam', '1986-02-23', 'xã Chí Nghĩa huyện Đông Xoài tỉnh Quảng Nam', 'Bán hàng, vận chuyển, thu mua', '0698762245');

--
-- Triggers `nhan_vien`
--
DELIMITER $$
CREATE TRIGGER `delete_nhanvien` BEFORE DELETE ON `nhan_vien` FOR EACH ROW INSERT INTO lichsu_nhanvien(Ten_nhan_vien,Chuc_vu,Sdt,ngay,su_kien)VALUES
(old.Ten_nhan_vien,old.Chuc_vu,old.Sdt,now(),'delete')
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `them_nhanvien` BEFORE INSERT ON `nhan_vien` FOR EACH ROW INSERT INTO lichsu_nhanvien(Ten_nhan_vien,Chuc_vu,Sdt,ngay,su_kien)VALUES
(new.Ten_nhan_vien,new.Chuc_vu,new.Sdt,now(),'insert')
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `update_nhan_vien` BEFORE UPDATE ON `nhan_vien` FOR EACH ROW INSERT INTO lichsu_nhanvien(Ten_nhan_vien,Chuc_vu,Sdt,ngay,su_kien)VALUES
(new.Ten_nhan_vien,new.Chuc_vu,new.Sdt,now(),'update')
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `ton_kho`
-- (See below for the actual view)
--
CREATE TABLE `ton_kho` (
`Tonkho` decimal(33,0)
);

-- --------------------------------------------------------

--
-- Structure for view `hien_thi_hang_xuat_hien_tren_3_lan`
--
DROP TABLE IF EXISTS `hien_thi_hang_xuat_hien_tren_3_lan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `hien_thi_hang_xuat_hien_tren_3_lan`  AS SELECT count(`hang_hoa`.`ID_loai`) > 3 AS `tong_so_hang_xuat_hon_3_lan` FROM `hang_hoa` ;

-- --------------------------------------------------------

--
-- Structure for view `loi_nhuan`
--
DROP TABLE IF EXISTS `loi_nhuan`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `loi_nhuan`  AS SELECT sum(`cthdx`.`Gia_ban` - `cthdn`.`Gia_mua`) AS `Loi_nhuan` FROM (`chi_tiet_hoa_don_xuat` `cthdx` join `chi_tiet_hoa_don_nhap` `cthdn` on(`cthdx`.`ID_loai` = `cthdn`.`ID_loai`)) ;

-- --------------------------------------------------------

--
-- Structure for view `nhanvienbanduoccacmathang`
--
DROP TABLE IF EXISTS `nhanvienbanduoccacmathang`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `nhanvienbanduoccacmathang`  AS SELECT `nv`.`Ten_nhan_vien` AS `Ten_nhan_vien`, `cthdn`.`Ten_loai_nong_san` AS `Ten_loai_nong_san`, `cthdn`.`Gia_mua` AS `Gia_mua`, `cthdn`.`So_luong` AS `So_luong` FROM ((`chi_tiet_hoa_don_nhap` `cthdn` join `hoa_don_nhap` `hdn` on(`cthdn`.`ID_hoa_don` = `hdn`.`ID_hoa_don`)) join `nhan_vien` `nv` on(`nv`.`ID_nhan_vien` = `hdn`.`ID_nhan_vien`)) ;

-- --------------------------------------------------------

--
-- Structure for view `nhanvienmuaduoccacmathang`
--
DROP TABLE IF EXISTS `nhanvienmuaduoccacmathang`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `nhanvienmuaduoccacmathang`  AS SELECT `nv`.`Ten_nhan_vien` AS `Ten_nhan_vien`, `cthdx`.`Ten_loai_nong_san` AS `Ten_loai_nong_san`, `cthdx`.`Gia_ban` AS `Gia_ban`, `cthdx`.`So_luong` AS `So_luong` FROM ((`chi_tiet_hoa_don_xuat` `cthdx` join `hoa_don_xuat` `hdx` on(`hdx`.`ID_hoa_don` = `cthdx`.`ID_hoa_don`)) join `nhan_vien` `nv` on(`nv`.`ID_nhan_vien` = `hdx`.`ID_nhan_vien`)) ;

-- --------------------------------------------------------

--
-- Structure for view `ton_kho`
--
DROP TABLE IF EXISTS `ton_kho`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ton_kho`  AS SELECT sum(`cthdx`.`So_luong` - `cthdn`.`So_luong`) AS `Tonkho` FROM (`chi_tiet_hoa_don_nhap` `cthdn` join `chi_tiet_hoa_don_xuat` `cthdx` on(`cthdn`.`ID_loai` = `cthdx`.`ID_loai`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `chi_tiet_hoa_don_nhap`
--
ALTER TABLE `chi_tiet_hoa_don_nhap`
  ADD KEY `ID_hoa_don` (`ID_hoa_don`),
  ADD KEY `ID_loai` (`ID_loai`);

--
-- Indexes for table `chi_tiet_hoa_don_xuat`
--
ALTER TABLE `chi_tiet_hoa_don_xuat`
  ADD KEY `ID_hoa_don` (`ID_hoa_don`),
  ADD KEY `ID_loai` (`ID_loai`);

--
-- Indexes for table `hang_hoa`
--
ALTER TABLE `hang_hoa`
  ADD PRIMARY KEY (`ID_hang_hoa`),
  ADD KEY `ID_loai` (`ID_loai`);

--
-- Indexes for table `hoa_don_nhap`
--
ALTER TABLE `hoa_don_nhap`
  ADD PRIMARY KEY (`ID_hoa_don`);

--
-- Indexes for table `hoa_don_xuat`
--
ALTER TABLE `hoa_don_xuat`
  ADD PRIMARY KEY (`ID_hoa_don`);

--
-- Indexes for table `khach_hang`
--
ALTER TABLE `khach_hang`
  ADD PRIMARY KEY (`ID_khach_hang`);

--
-- Indexes for table `lichsu_hanghoa`
--
ALTER TABLE `lichsu_hanghoa`
  ADD PRIMARY KEY (`STT`);

--
-- Indexes for table `lichsu_khachhang`
--
ALTER TABLE `lichsu_khachhang`
  ADD PRIMARY KEY (`STT`);

--
-- Indexes for table `lichsu_nhanvien`
--
ALTER TABLE `lichsu_nhanvien`
  ADD PRIMARY KEY (`stt`);

--
-- Indexes for table `loai_nong_san`
--
ALTER TABLE `loai_nong_san`
  ADD PRIMARY KEY (`ID_loai`);

--
-- Indexes for table `nhan_vien`
--
ALTER TABLE `nhan_vien`
  ADD PRIMARY KEY (`ID_nhan_vien`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `lichsu_hanghoa`
--
ALTER TABLE `lichsu_hanghoa`
  MODIFY `STT` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `lichsu_khachhang`
--
ALTER TABLE `lichsu_khachhang`
  MODIFY `STT` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `lichsu_nhanvien`
--
ALTER TABLE `lichsu_nhanvien`
  MODIFY `stt` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `chi_tiet_hoa_don_nhap`
--
ALTER TABLE `chi_tiet_hoa_don_nhap`
  ADD CONSTRAINT `chi_tiet_hoa_don_nhap_ibfk_1` FOREIGN KEY (`ID_hoa_don`) REFERENCES `hoa_don_nhap` (`ID_hoa_don`),
  ADD CONSTRAINT `chi_tiet_hoa_don_nhap_ibfk_2` FOREIGN KEY (`ID_loai`) REFERENCES `hang_hoa` (`ID_loai`);

--
-- Constraints for table `chi_tiet_hoa_don_xuat`
--
ALTER TABLE `chi_tiet_hoa_don_xuat`
  ADD CONSTRAINT `chi_tiet_hoa_don_xuat_ibfk_1` FOREIGN KEY (`ID_hoa_don`) REFERENCES `hoa_don_xuat` (`ID_hoa_don`),
  ADD CONSTRAINT `chi_tiet_hoa_don_xuat_ibfk_2` FOREIGN KEY (`ID_loai`) REFERENCES `hang_hoa` (`ID_loai`);

--
-- Constraints for table `hang_hoa`
--
ALTER TABLE `hang_hoa`
  ADD CONSTRAINT `hang_hoa_ibfk_1` FOREIGN KEY (`ID_loai`) REFERENCES `loai_nong_san` (`ID_loai`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
