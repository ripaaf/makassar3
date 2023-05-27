-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: May 27, 2023 at 02:49 PM
-- Server version: 10.11.2-MariaDB-3
-- PHP Version: 8.2.5

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `itsla_maintenance`
--

-- --------------------------------------------------------

--
-- Table structure for table `report`
--

CREATE TABLE `report` (
  `id` int(11) NOT NULL,
  `lokasi` enum('tamalanrea','parangloe','biringkanaya') NOT NULL,
  `gerbang` enum('gerbang 1','gerbang 2') NOT NULL,
  `pesan` text NOT NULL,
  `status` enum('open','pending','proses','close') NOT NULL DEFAULT 'open' COMMENT 'open : maintenance terbuka dan bisa dikerjakan\r\npending : maintenance sedang ditunda karena ada masalah\r\nproses : maintenance sedang dalam pengerjaan\r\nclose : maintenance selesai dikerjakan ',
  `date_reported` timestamp NOT NULL DEFAULT current_timestamp(),
  `id_user` int(11) NOT NULL COMMENT 'user yang melaporkan masalah maintenance',
  `img_content` text NOT NULL DEFAULT '\'image.png\'' COMMENT 'foto kondisi yang terjadi di lapangan'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `report`
--

INSERT INTO `report` (`id`, `lokasi`, `gerbang`, `pesan`, `status`, `date_reported`, `id_user`, `img_content`) VALUES
(2, 'tamalanrea', 'gerbang 1', 'drghfctfgjhf', 'open', '2023-05-26 18:53:49', 5, '\'image.png\''),
(3, 'biringkanaya', 'gerbang 2', 'fgkjmjh', 'open', '2023-05-26 18:55:26', 5, '\'image.png\''),
(4, 'tamalanrea', 'gerbang 2', 'mengapakdasasdadasdadadadadadadadsdadsdasd', 'pending', '2023-05-26 19:07:38', 1, 'mengerikan.png'),
(5, 'parangloe', 'gerbang 1', 'xodkxkjddidkdkdkdkdkdkdkdkdkdkdkdkdkdkkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdkdk', 'open', '2023-05-27 10:17:34', 1, 'guga.png');

-- --------------------------------------------------------

--
-- Table structure for table `tangani`
--

CREATE TABLE `tangani` (
  `id` int(11) NOT NULL,
  `status_ditangani` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'jika true maka maintenance telah diselesaikan, jika false maintenance belum selesai',
  `id_report` int(11) NOT NULL COMMENT 'report yang mana yang akan ditangani',
  `id_user` int(11) NOT NULL COMMENT 'id user yang menangani mainteance ',
  `img_content` text NOT NULL DEFAULT 'image.png' COMMENT 'foto sesudah maintenance',
  `jam_pengerjaan` int(11) NOT NULL COMMENT 'waktu lamanya maintenance dilakukan',
  `tunda` enum('true','false') NOT NULL DEFAULT 'false' COMMENT 'jika tunda berstatus true maka ada masalah dan pengerjaan harus ditunda'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(11) NOT NULL,
  `username` text NOT NULL,
  `email` text NOT NULL,
  `password` text NOT NULL,
  `teknisi` enum('true','false') NOT NULL COMMENT 'jika teknisi berstatus true maka dia masuk sebagai pegawai yang aktif di lapangan kalau merah itu sekedar mengecek'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `email`, `password`, `teknisi`) VALUES
(1, 'rifa', 'ri@gmail.com', '$2y$10$97vuyCb9u1fz2wK0iqsbMOqaB0OK5qsT1CgO2mUpvLJhhUro1kmxe', 'true'),
(2, 'yusarinn', 'yusarinn@gmail.com', '$2y$10$6n8uXhul4SeoNMYA4jGlpO/pX.3RY3N0T9g4x9L0K8XWPmXIy1726', 'true'),
(3, 'rifa', 'rifa@gmail.com', '$2y$10$uc.AI7ebG5aGRkYsbEXySO6DE3BNiFnQYEYE/UjHx3iTB1MZpY89S', 'false'),
(4, 'qiv12', 'qiv@gmail.com', '$2y$10$BWA5VbSx8ta9B9up4gVg9et/cvKiBfF9ORK7I5m55F9hk0IJrrVgO', 'false'),
(5, 'Shadow', 'shadow@gmail.com', '$2y$10$qU1A4c4K55cvOZ684yZSa.u8GfNrY2dy3VAn5r4shSsligAVKzX2C', 'true');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `report`
--
ALTER TABLE `report`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `tangani`
--
ALTER TABLE `tangani`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `report`
--
ALTER TABLE `report`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `report`
--
ALTER TABLE `report`
  ADD CONSTRAINT `report_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
