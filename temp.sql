-- MySQL dump 10.13  Distrib 5.7.17, for Win64 (x86_64)
--
-- Host: ckz-stage-au-v1.c10iwbfvsrnx.ap-southeast-2.rds.amazonaws.com    Database: ckz_stage
-- ------------------------------------------------------
-- Server version	5.6.27-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'ckz_stage'
--
/*!50003 DROP FUNCTION IF EXISTS `fnAcronym` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` FUNCTION `fnAcronym`(str TEXT, len INT, addspaces BIT) RETURNS text CHARSET utf8
BEGIN
DECLARE result TEXT DEFAULT '';
DECLARE buffer TEXT DEFAULT '';
DECLARE i INT DEFAULT 1;
IF (str IS NULL) then
	RETURN NULL;
END IF;
SET buffer = TRIM(str);
if addspaces THEN
	/* make sure upper is proceeded by space */
	WHILE i <= LENGTH(buffer) DO
		if SUBSTR(buffer, i, 1) REGEXP BINARY '[A-Z]' THEN
			SET result = CONCAT(result, ' ');			
		END IF;
		SET result = CONCAT(result, SUBSTR(buffer, i, 1 ));
		SET i = i + 1;
	END WHILE;
	SET buffer = result;
END IF;
SET result = fnInitials(TRIM(REPLACE(buffer, '  ', ' ')), '[[:alnum:]]');
RETURN SUBSTR(LOWER(result), 1, len);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnCreateToken` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` FUNCTION `fnCreateToken`() RETURNS varchar(32) CHARSET utf8
BEGIN
RETURN LOWER(HEX(UUID_SHORT()));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnCreateUUID` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` FUNCTION `fnCreateUUID`() RETURNS varchar(36) CHARSET utf8
BEGIN
RETURN REPLACE(UUID(), '-', '');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fnInitials` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` FUNCTION `fnInitials`(str TEXT, expr TEXT) RETURNS text CHARSET utf8
BEGIN
    DECLARE result TEXT DEFAULT '';
    DECLARE buffer TEXT DEFAULT '';
    DECLARE i INT DEFAULT 1;
    IF (str IS NULL) then
        RETURN NULL;
    END IF;
    SET buffer = TRIM(str);
    WHILE i <= LENGTH(buffer) DO
        if SUBSTR(buffer, i, 1) REGEXP expr THEN
            SET result = CONCAT(result, SUBSTR( buffer, i, 1 ));
            SET i = i + 1;
            WHILE i <= LENGTH(buffer) and SUBSTR(buffer, i, 1) REGEXP expr DO
                SET i = i + 1;
            END WHILE;
            WHILE i <= LENGTH(buffer) and SUBSTR(buffer, i, 1) NOT REGEXP expr DO
                SET i = i + 1;
            END WHILE;
        ELSE
            SET i = i + 1;
        END IF;
    END WHILE;
    RETURN result;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `_sfHashVectorTable` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` FUNCTION `_sfHashVectorTable`(
    `table_` SMALLINT UNSIGNED
  ) RETURNS binary(16)
BEGIN
    DECLARE `hash` BINARY(16);

    --  It doesn't matter how we join the hashes as long as the
    --  concatenation is deteministic and injective.
    SELECT UNHEX(MD5(GROUP_CONCAT(FLOOR(
        (`bv`.`value` - `lhf`.`partition`) / @`word_lsh_radius`)
        ORDER BY `bv`.`axis_id`, `lhf`.`id_in_table` SEPARATOR ',')))
      INTO `hash`
      FROM `lsh_hash_funs` AS `lhf`
      LEFT JOIN `_book_vector` AS `bv` USING (`axis_id`)
      WHERE `table`=`table_`;

    RETURN `hash`;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `_sfMinDistance` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` FUNCTION `_sfMinDistance`(
    `point1` FLOAT,
    `point2` FLOAT,
    `value` FLOAT
  ) RETURNS float
BEGIN
    IF `point1` IS NULL THEN
      RETURN ABS(`value` - `point2`);
    ELSE
      BEGIN
        DECLARE `point1_dist` FLOAT DEFAULT ABS(`value` - `point1`);
        DECLARE `point2_dist` FLOAT DEFAULT ABS(`value` - `point2`);

        IF `point1_dist` > `point2_dist` THEN
          RETURN `point2_dist`;
        ELSE
          RETURN `point1_dist`;
        END IF;
      END;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `_sfReadingLevelGaussian` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` FUNCTION `_sfReadingLevelGaussian`(
    `value` FLOAT
  ) RETURNS float
RETURN EXP(- `value` * `value`
               / (2 * @`rec_engn_level_preferred_range`
                    * @`rec_engn_level_preferred_range`)) ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `_sfWordDistanceFromBookVector` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` FUNCTION `_sfWordDistanceFromBookVector`(
    `book_id_` BIGINT(20)
  ) RETURNS float
BEGIN
    DECLARE `book_word_count` INT UNSIGNED;
    DECLARE `result` FLOAT;

    SELECT COUNT(*) INTO `book_word_count` FROM `book_words`
      WHERE `book_id`=`book_id_`
            AND `stripped_content` IN (SELECT `word` FROM `lsh_word_axes`);

    SELECT SUM(ABS(IFNULL(`bwq`.`proportion`,0) - `bv`.`value`))
      INTO `result`
      FROM `lsh_word_axes` AS `lwa`
      LEFT JOIN (SELECT `stripped_content`, COUNT(*) / `book_word_count`
                                            AS `proportion`
                 FROM `book_words`
                 WHERE `book_id`=`book_id_`
                 GROUP BY `stripped_content` ORDER BY NULL) AS `bwq`
        ON `lwa`.`word`=`bwq`.`stripped_content`
      LEFT JOIN `_book_vector` AS `bv` ON `lwa`.`id`=`bv`.`axis_id`;

    RETURN `result`;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAccessibleRolesForUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAccessibleRolesForUser`(IN in_user_id VARCHAR(36))
BEGIN
SELECT * 
FROM role_type 
WHERE role_type.id > (SELECT role_type_id FROM member JOIN authentication ON authentication.id = member.authentication_id WHERE member.id = in_user_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddBookToCourse` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddBookToCourse`(IN in_book_id VARCHAR(36), IN in_course_id VARCHAR(36), IN in_week_number INT)
BEGIN
SET @cb_id = fnCreateUUID();
INSERT INTO `course_book` (`id`, `book_id`, `course_id`, `week_number`) 
VALUES (@cb_id, in_book_id, in_course_id, in_week_number);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddBookToSelectedCollection` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddBookToSelectedCollection`(IN in_book_id BIGINT(20))
BEGIN
IF NOT EXISTS(SELECT * FROM selected_books WHERE book_id = in_book_id) THEN
	SET @pk = fnCreateUUID();
	INSERT INTO `selected_books` (`id`, `book_id`) VALUES (@pk, in_book_id);
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddClass` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddClass`(IN in_user_id VARCHAR(36), IN in_class_name VARCHAR(100), IN in_teacher_id VARCHAR(36), IN in_schoolsite_id VARCHAR(36))
BEGIN
/*check if the admin has permision.*/ 
SET @has_permision = (SELECT COUNT(*) FROM school_site WHERE admin_id = in_user_id AND id = in_schoolsite_id);
SET @user_role_id = (SELECT role_type_id FROM authentication JOIN member ON member.authentication_id = authentication.id WHERE member.id = in_user_id LIMIT 1);
/* just because we allow teachers to add class as well */
IF (true OR @has_permision <> 0 OR @user_role_id <= 20) THEN
	SET @pk_class = fnCreateUUID();
	INSERT INTO `class` (`id`, `name`, `teacher_id`, `school_site_id`,`create_date`) 
	VALUES (@pk_class, in_class_name, in_teacher_id, in_schoolsite_id, CURRENT_TIMESTAMP);
	SET @pk_class_group = fnCreateUUID();
	INSERT INTO `class_group` (`id`, `name`, `class_id`, `create_date`) 
	VALUES (@pk_class_group, 'default', @pk_class, CURRENT_TIMESTAMP);
END IF;
END ;;
DELIMITER ;