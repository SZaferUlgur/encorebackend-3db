/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS `eticaretdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_turkish_ci */;
USE `eticaretdb`;

DELIMITER //
CREATE PROCEDURE `addProductSP`(
	IN `p_urunAdi` VARCHAR(150),
	IN `p_fiyat` DECIMAL(9,2),
	IN `p_miktar` DECIMAL(9,2),
	IN `p_imageURL` VARCHAR(200)
)
BEGIN
    INSERT INTO tblproducts (urunAdi, fiyat, miktar, imageURL)
    VALUES (p_urunAdi, p_fiyat, p_miktar, p_imageURL);
    
    IF ROW_COUNT() > 0 THEN
    	SELECT JSON_OBJECT('isAdded', TRUE, 'message', 'Kayıt Eklenmiştir') AS result;
    ELSE
    	SELECT JSON_OBJECT('isAdded', FALSE, 'message', 'Kayıt Eklenirken Hata Oluştu') AS result;    
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `deleteProductByIdSP`(
	IN `p_id` INT
)
BEGIN
    DELETE FROM tblproducts WHERE id = p_id;
    IF ROW_COUNT() > 0 THEN
    	SELECT JSON_OBJECT('isDeleted', TRUE, 'message', 'Kayıt Silinmiştir') AS result;
    ELSE
    	SELECT JSON_OBJECT('isDeleted', FALSE, 'message', 'Kayıt Silinirken Hata Oluştu') AS result;    
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `getAllProductsSP`()
BEGIN
	SELECT json_arrayagg(
			JSON_OBJECT(
				'productID', id,
				'productName', urunAdi,
				'productPrice', fiyat,
				'productStock', miktar,
				'productPictureUrl', imageURL 
			)
			) AS result
		FROM tblproducts;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE `getProductByIdSP`(
	IN `p_id` INT
)
BEGIN
	SELECT JSON_OBJECT(
				'productID', id,
				'productName', urunAdi,
				'productPrice', fiyat,
				'productStock', miktar,
				'productPictureUrl', imageURL
			) AS result
		FROM tblproducts WHERE id=p_id;
END//
DELIMITER ;

CREATE TABLE IF NOT EXISTS `tblproducts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `urunAdi` varchar(150) DEFAULT '0',
  `fiyat` decimal(9,2) DEFAULT NULL,
  `miktar` decimal(9,2) DEFAULT NULL,
  `imageURL` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

INSERT INTO `tblproducts` (`id`, `urunAdi`, `fiyat`, `miktar`, `imageURL`) VALUES
	(1, 'Laptop', 22500.00, 14.00, '/uploads/products/laptop.jpg'),
	(2, 'Drone', 14250.00, 8.00, '/uploads/products/drone.jpg'),
	(3, 'Erkek Ayakkabısı', 4300.00, 0.00, '/uploads/products/ayakkabi.jpg'),
	(4, 'Lenovo Gözlük', 33200.00, 11.00, '/uploads/products/lenovogozluk.jpg'),
	(19, 'Akvaryum', 15780.00, 4.00, '/uploads/products/1728583709_akvaryum.jpg');

DELIMITER //
CREATE PROCEDURE `updateProductByIdSP`(
    IN p_id INT,
    IN p_urunAdi VARCHAR(150),
    IN p_fiyat DECIMAL(9,2),
    IN p_miktar DECIMAL(9,2),
    IN p_imageURL VARCHAR(200)
)
BEGIN
    UPDATE tblproducts
    SET urunAdi = p_urunAdi,
        fiyat = p_fiyat,
        miktar = p_miktar,
        imageURL = p_imageURL
    WHERE id = p_id;

    IF ROW_COUNT() > 0 THEN
        SELECT JSON_OBJECT('isUpdated', TRUE, 'message', 'Ürün başarıyla güncellendi') AS result;
    ELSE
        SELECT JSON_OBJECT('isUpdated', FALSE, 'message', 'Ürün güncellenemedi') AS result;
    END IF;
END//
DELIMITER ;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
