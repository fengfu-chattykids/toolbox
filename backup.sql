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
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddClassGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddClassGroup`(IN in_name VARCHAR(100),IN in_class_id VARCHAR(36))
BEGIN
SET @pk = fnCreateUUID();
INSERT INTO `class_group` (`id`, `name`, `class_id`,`create_date`) 
VALUES (@pk, in_name, in_class_id, CURRENT_TIMESTAMP);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddCopyRestrictionAccess` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddCopyRestrictionAccess`(IN in_session_key VARCHAR(36), IN in_book_id BIGINT)
BEGIN
/* first lets delete any access token older than 1 hour */
DELETE
FROM copy_restriction_access
WHERE
datetime < DATE_SUB(now(), INTERVAL 1 HOUR);
/* next add new access */
SET @id = fnCreateUUID();
SET @access_token = fnCreateToken();
INSERT INTO copy_restriction_access(id, session_key, book_id, access_token) VALUES(@id, in_session_key, in_book_id, @access_token);
SELECT
@id AS id,
@access_token AS access_token;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddDownload` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddDownload`(IN in_member_id VARCHAR(36), IN in_metadata VARCHAR(255), IN in_filename VARCHAR(255))
BEGIN
INSERT INTO downloads (member_id, metadata, filename)
VALUES
(in_member_id, in_metadata, in_filename);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddMemberByAuthenticationId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddMemberByAuthenticationId`(IN in_auth_id VARCHAR(36), IN in_name_first VARCHAR(100), IN in_name_last VARCHAR(100), IN in_date_of_birth DATETIME, IN in_is_child TINYINT)
BEGIN
/* get primary key */
SET @pk = fnCreateUUID();
INSERT INTO member (id, authentication_id, name_first, name_last, primary_user, date_of_birth, is_child)
VALUES (@pk, in_auth_id, in_name_first, in_name_last, 0, in_date_of_birth, in_is_child);

IF NOT EXISTS(SELECT * FROM progress_table WHERE member_id = @pk) THEN
	INSERT INTO progress_table (id, member_id, level) VALUES (fnCreateUUID(), @pk, 1); 
END IF;

SELECT
member.*,
authentication.email,
progress_table.level AS level
FROM authentication
JOIN member ON authentication.id = member.authentication_id
JOIN progress_table ON progress_table.member_id = member.id
WHERE member.id = @pk;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddMessageQueue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddMessageQueue`(IN in_transport VARCHAR(10), IN in_address VARCHAR(100), IN in_subject VARCHAR(255), IN in_message VARCHAR(1024))
BEGIN
SET @pk = fnCreateUUID();
INSERT INTO messaging_queue
(id, transport, address, subject, message)
VALUES
(@pk, in_transport, in_address, in_subject, in_message);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddNewStudentToClass` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddNewStudentToClass`(IN in_namefirst VARCHAR(100), IN in_namelast VARCHAR(100),IN in_email VARCHAR(255),IN in_password VARCHAR(255), IN in_class_group_id VARCHAR(36))
BEGIN
/* First create a user - memeber with authentication */
/* get primary key */
SET @pk = fnCreateUUID();
/* insert into authentication then member with user type */
INSERT INTO authentication (id, email, password, role_type_id)
VALUES
(@pk, in_email, in_password,
(SELECT id FROM role_type WHERE name = 'user'));
/* create a member */
SET @member_id = fnCreateUUID();
INSERT INTO member (id, authentication_id, class_group_id, primary_user) VALUES (@member_id, @pk, in_class_group_id, 1);
IF NOT EXISTS(SELECT * FROM progress_table WHERE member_id = @member_id) THEN
	INSERT INTO progress_table (id, member_id,level) VALUES (fnCreateUUID(), @member_id,1); 
END IF;
/* return new user */
SELECT
member.id AS id,
authentication.id AS authentication_id,
authentication.email AS email,
progress_table.level = level
FROM authentication
JOIN member ON authentication.id = member.authentication_id
JOIN progress_table ON progress_table.member_id = member.id
WHERE authentication.id = @pk;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddNewWechatFollower` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddNewWechatFollower`(IN in_unionid VARCHAR(50), IN in_tag00 SMALLINT(5),IN in_tag01 SMALLINT(5),IN in_tag02 SMALLINT(5),
IN in_subscribe_time  INT(10),IN in_sex TINYINT(2),IN in_province VARCHAR(30),IN in_openid VARCHAR(50),
IN in_nickname VARCHAR(30),IN in_lang CHAR(5),IN in_groupid SMALLINT(5),IN in_country VARCHAR(25),IN in_city VARCHAR(25))
BEGIN
#delete if member exists
DELETE
FROM wechat_followers
WHERE
unionid = in_unionid;
#add new member
INSERT INTO wechat_followers (unionid,tag00,tag01,tag02,subscribe_time,sex,province,openid,nickname,lang,groupid,country,city)
VALUES (in_unionid,in_tag00,in_tag01,in_tag02,in_subscribe_time,in_sex,in_province,in_openid,in_nickname,in_lang,in_groupid,in_country,in_city);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddOpenTokSession` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddOpenTokSession`(IN in_session_id VARCHAR(1024), IN in_member1_id VARCHAR(36), IN in_member2_id VARCHAR(36), IN in_session_token1 VARCHAR(1024), IN in_session_token2 VARCHAR(1024), IN in_socket1_id VARCHAR(255))
BEGIN
/* remove any older sessions */
DELETE
FROM opentok_session
WHERE
member1_id = in_member1_id AND
member2_id = in_member2_id;
INSERT INTO opentok_session
(session_id, member1_id, member2_id, session_token1, session_token2, socket1_id, controlling_member)
VALUES
(in_session_id, in_member1_id, in_member2_id, in_session_token1, in_session_token2, in_socket1_id, in_member1_id);
/* delete any sessions older than a week */
DELETE
FROM opentok_session
WHERE
date_created < DATE_SUB(now(), INTERVAL 1 HOUR);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddPrimaryMemberByEmailPasswordType` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddPrimaryMemberByEmailPasswordType`(IN in_email VARCHAR(255), IN in_password VARCHAR(1024), IN in_password_salt VARCHAR(1024), IN in_role_type VARCHAR(255))
ADD_USER: BEGIN
/* check user does not exist (note this was based on legacy data, so there are existing dups... need to clean)*/
SET @err = 0;
SELECT COUNT(*)
INTO @err
FROM authentication WHERE email = in_email;
IF @err > 0 THEN
	SELECT 'ERROR' AS id;
	LEAVE ADD_USER;
END IF;
/* get primary key and verify token */
SET @pk = fnCreateUUID();
SET @verifyToken = fnCreateToken();
SET @roleTypeId = -1;
/* grab role type id */
SELECT id INTO @roleTypeId FROM role_type WHERE role_type.name = in_role_type;
/* insert into authentication then member */
INSERT INTO authentication (id, email, password, password_salt, role_type_id, verify_token)
VALUES
(@pk, in_email, in_password, in_password_salt, @roleTypeId, @verifyToken);
SET @member_id = fnCreateUUID();
INSERT INTO member (id, authentication_id, primary_user, is_child, auth_type) VALUES (@member_id, @pk, 1, 0, 'EMAIL');
/* return new user */
CALL spGetMemberById(@member_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddPrimaryMemberByEmailPasswordTypeToExisting` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddPrimaryMemberByEmailPasswordTypeToExisting`(IN existing_member_id VARCHAR(36), IN in_email VARCHAR(255), IN in_password VARCHAR(1024), IN in_password_salt VARCHAR(1024), IN in_role_type VARCHAR(255))
ADD_USER: BEGIN
/* check user does not exist (note this was based on legacy data, so there are existing dups... need to clean)*/
SET @err = 0;
SELECT COUNT(*)
INTO @err
FROM authentication WHERE email = in_email;
IF @err > 0 THEN
	SELECT 'ERROR' AS id;
	LEAVE ADD_USER;
END IF;

/* we need to grab the existing auth id */
SET @existing_auth_id = 0;
SELECT authentication_id INTO @existing_auth_id FROM member WHERE member.id = existing_member_id;

/* verify token and role type */
SET @verifyToken = fnCreateToken();
SET @roleTypeId = -1;

/* grab role type id */
SELECT id INTO @roleTypeId FROM role_type WHERE role_type.name = in_role_type;

/* make sure all existing members are not flagged as primary */
UPDATE member SET primary_user = 0 WHERE authentication_id = @existing_auth_id;

/* add new member record */
SET @member_id = fnCreateUUID();
INSERT INTO member (id, authentication_id, primary_user, is_child, auth_type) VALUES (@member_id, @existing_auth_id, 1, 0, 'EMAIL');

/* finally update the authentication record */
UPDATE authentication SET email = in_email, password = in_password, password_salt = in_password_salt, role_type_id = @roleTypeId, verify_token = @verifyToken WHERE id = @existing_auth_id;

/* return new user */
CALL spGetMemberById(@member_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddPrimaryMemberByOAuthType` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddPrimaryMemberByOAuthType`(IN in_oauth_token VARCHAR(255), IN in_oauth_type VARCHAR(255), IN in_role_type VARCHAR(255))
ADD_USER: BEGIN
SET @err = 0;
SELECT COUNT(*)
INTO @err
FROM authentication WHERE oauth_token = in_oauth_token AND oauth_type = in_oauth_type;
IF @err > 0 THEN
	SELECT 'ERROR' AS id;
	LEAVE ADD_USER;
END IF;
/* get primary key and verify token */
SET @pk = fnCreateUUID();
SET @verifyToken = fnCreateToken();
SET @roleTypeId = -1;
/* grab role type id */
SELECT id INTO @roleTypeId FROM role_type WHERE role_type.name = in_role_type;
/* insert into authentication then member */
INSERT INTO authentication (id, oauth_token, oauth_type, role_type_id, verify_token)
VALUES
(@pk, in_oauth_token, in_oauth_type, @roleTypeId, @verifyToken);
SET @member_id = fnCreateUUID();
INSERT INTO member (id, authentication_id, primary_user, is_child, auth_type) VALUES (@member_id, @pk, 1, 0, 'OAUTH');
/* return new user */
CALL spGetMemberById(@member_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddPrimaryMemberByOAuthTypeToExisting` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddPrimaryMemberByOAuthTypeToExisting`(IN existing_member_id VARCHAR(36), IN in_oauth_token VARCHAR(255), IN in_oauth_type VARCHAR(255), IN in_role_type VARCHAR(255))
ADD_USER: BEGIN
/* check user does not exist */
SET @err = 0;
SELECT COUNT(*)
INTO @err
FROM authentication WHERE oauth_token = in_oauth_token AND oauth_type = in_oauth_type;
IF @err > 0 THEN
	SELECT 'ERROR' AS id;
	LEAVE ADD_USER;
END IF;

/* we need to grab the existing auth id */
SET @existing_auth_id = 0;
SELECT authentication_id INTO @existing_auth_id FROM member WHERE member.id = existing_member_id;

/* verify token and role type */
SET @verifyToken = fnCreateToken();
SET @roleTypeId = -1;

/* grab role type id */
SELECT id INTO @roleTypeId FROM role_type WHERE role_type.name = in_role_type;

/* make sure all existing members are not flagged as primary */
UPDATE member SET primary_user = 0 WHERE authentication_id = @existing_auth_id;

/* add new member record */
SET @member_id = fnCreateUUID();
INSERT INTO member (id, authentication_id, primary_user, is_child, auth_type) VALUES (@member_id, @existing_auth_id, 1, 0, 'OAUTH');

/* finally update the authentication record */
UPDATE authentication SET oauth_token = in_oauth_token, oauth_type = in_oauth_type, role_type_id = @roleTypeId, verify_token = @verifyToken WHERE id = @existing_auth_id;

/* return new user */
CALL spGetMemberById(@member_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddPrimaryMemberByUserNamePasswordType` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddPrimaryMemberByUserNamePasswordType`(IN in_username VARCHAR(255), IN in_password VARCHAR(255), IN in_role_type VARCHAR(255))
ADD_USER: BEGIN
/* check user does not exist (note this was based on legacy data, so there are existing dups... need to clean)*/
SET @err = 0;
SELECT COUNT(*)
INTO @err
FROM member WHERE username = in_username;
IF @err > 0 THEN
	SELECT 'ERROR' AS id;
	LEAVE ADD_USER;
END IF;
/* get primary key and verify token */
SET @pk = fnCreateUUID();
SET @roleTypeId = -1;
/* grab role type id */
SELECT id INTO @roleTypeId FROM role_type WHERE role_type.name = in_role_type;
/* insert into authentication then member */
INSERT INTO authentication (id, role_type_id)
VALUES
(@pk, @roleTypeId);
SET @member_id = fnCreateUUID();
INSERT INTO member (id, authentication_id, primary_user, is_child, username, password, auth_type) VALUES (@member_id, @pk, 1, 1, in_username, in_password, 'USERNAME');
/* return new user */
CALL spGetMemberById(@member_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddRedemptionCode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddRedemptionCode`(IN in_code VARCHAR(100), IN in_approver_id VARCHAR(36), IN in_subscription_expire_date TIMESTAMP)
BEGIN
SET @pk = fnCreateUUID();
INSERT INTO redemption (id, code, approver_id, subscription_expire_date)
VALUES
(@pk, in_code, in_approver_id, in_subscription_expire_date);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddResetPasswordRecord` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddResetPasswordRecord`(IN in_member_id VARCHAR(36), IN in_email VARCHAR(255), IN in_token VARCHAR(255))
BEGIN
INSERT INTO 
member_reset_password (member_id, email, token) 
VALUES(in_member_id, in_email, in_token)
ON DUPLICATE KEY UPDATE
	token = in_token,
	create_date = CURRENT_TIMESTAMP;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddSchoolGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddSchoolGroup`(IN in_name VARCHAR(100), IN in_admin_id VARCHAR(36), IN in_country VARCHAR(45))
BEGIN
SET @pk = fnCreateUUID();

INSERT INTO school_group (id, name, admin_id, country, create_date)
    VALUES (@pk, in_name, in_admin_id, in_country, CURRENT_TIMESTAMP);
SELECT @pk;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddSchoolSite` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddSchoolSite`(IN in_name VARCHAR(100), IN in_school_code_seed VARCHAR(255), IN in_school_group_id VARCHAR(36), IN in_admin_id VARCHAR(36))
BEGIN
/* get primary key */
SET @ss_pk = fnCreateUUID();
/* if we dont have a group create one */
SET @group_id = in_school_group_id;
IF @group_id IS NULL THEN
	SET @group_id = fnCreateUUID();    
    SET @group_name = CONCAT(in_name, ' Group');
	INSERT INTO school_group (id, name, admin_id)
    VALUES (@group_id, @group_name, in_admin_id);
END IF;
/* find code */
SET @schoolcode = NULL;
SET @codeinc = 1;
SET @codecount = 0;
/* first try basic name */
SET @schoolcode = in_school_code_seed;
/* see if exists */
SELECT COUNT(id) INTO @codecount FROM school_site WHERE code = @schoolcode;
IF @codecount > 0 THEN	
	/* no joy, lets append with a number */
	WHILE @codecount > 0 DO
		SET @schoolcode = in_school_code_seed;
		SET @schoolcode = CONCAT(@schoolcode, @codeinc, 'x');
		/* see if exists */
		SELECT COUNT(id) INTO @codecount FROM school_site WHERE code = @schoolcode;        
		SET @codeinc = @codeinc + 1;
	END WHILE;
END IF;
/* insert into site */
INSERT INTO school_site (id, name, code, school_group_id, admin_id)
VALUES (@ss_pk, in_name, @schoolcode, @group_id, in_admin_id);
/* assign the admin to the school site */
SET @mss_pk = fnCreateUUID();
INSERT INTO member_school_site (`id`, `school_site_id`, `member_id`) 
VALUES (@mss_pk, @ss_pk, in_admin_id);
/* out put the school site */
SELECT *
FROM school_site
WHERE id = @ss_pk;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddStartEndDateToContentDelivery` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddStartEndDateToContentDelivery`(IN in_member_id VARCHAR(36), IN in_class_group_id VARCHAR(36), IN in_book_id VARCHAR(36), IN in_start_date DATETIME, IN in_end_date DATETIME)
BEGIN
-- finds the record by in_member_id, in_group_id and in_book_id and upate the startdate and enddate 

UPDATE content_delivery SET 
    start_date = COALESCE(in_start_date, content_delivery.start_date),
    end_date = COALESCE(in_end_date, content_delivery.end_date)
WHERE book_id = in_book_id
AND (member_id = in_member_id OR class_group_id = in_class_group_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddSystemErrorTracking` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddSystemErrorTracking`(IN in_user_token VARCHAR(1024), IN in_error_message VARCHAR(20480))
BEGIN
SET @pk = fnCreateUUID();
INSERT INTO system_error_tracking (id, user_token, error_message) VALUES (@pk, in_user_token, in_error_message);
SELECT @pk AS id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddTrackingBookEvent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddTrackingBookEvent`(IN in_tracking_member_id VARCHAR(36), IN in_read_session_id VARCHAR(45), IN in_bookid BIGINT(20), IN in_task_id VARCHAR(36), IN in_event VARCHAR(45))
BEGIN
/* get primary key */
SET @pk = fnCreateUUID();
INSERT INTO tracking_book_event (id, tracking_member_event_id, read_session_id, book_id, task_id, event)
VALUES (@pk, in_tracking_member_id, in_read_session_id, in_bookid, in_task_id,  in_event);
/* make sure we return the pk */
SELECT @pk AS id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddTrackingBookVideoEvent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddTrackingBookVideoEvent`(IN in_tracking_member_id VARCHAR(36), IN in_read_session_id VARCHAR(45), IN in_bookid BIGINT(20), IN in_videoid VARCHAR(100), IN in_task_id VARCHAR(36), IN in_event VARCHAR(45))
BEGIN
/* get primary key */
SET @pk = fnCreateUUID();
INSERT INTO tracking_book_event (id, tracking_member_event_id, read_session_id, book_id, video_id, task_id, event)
VALUES (@pk, in_tracking_member_id, in_read_session_id, in_bookid, in_videoid, in_task_id, in_event);
/* make sure we return the pk */
SELECT @pk AS id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddTrackingPageEvent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddTrackingPageEvent`(IN tracking_book_id VARCHAR(36), IN in_event VARCHAR(45), IN in_pagenumber INT(11), IN in_lastpagenumber INT(11))
BEGIN
/* get primary key */
SET @pk = fnCreateUUID();
INSERT INTO tracking_page_event (id, tracking_book_event_id, event, page_number, last_page_number)
VALUES (@pk, tracking_book_id, in_event, in_pagenumber, in_lastpagenumber);
/* make sure we return the pk */
SELECT @pk AS id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddTrackingUserEvent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddTrackingUserEvent`(IN in_member_id VARCHAR(36), IN in_session_id VARCHAR(45), IN in_ip_address VARCHAR(45), IN in_event VARCHAR(45))
BEGIN
/* get primary key */
SET @pk = fnCreateUUID();
INSERT INTO tracking_member_event(id, member_id, session_id, ip_address, event)
VALUES (@pk, in_member_id, in_session_id, in_ip_address, in_event);
/* make sure we return the pk */
SELECT @pk AS id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddTrackingWordEvent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddTrackingWordEvent`(
    `tracking_book_event_id` VARCHAR(36),
    `book_id` BIGINT(20),
    `pdf_file_number` INT UNSIGNED,
    `pdf_page_number` INT UNSIGNED,
    `word_id` INT UNSIGNED,
    `image_page_number` INT,
    `click_x_in_pdf_page` FLOAT,
    `click_y_in_pdf_page` FLOAT,
    `event` VARCHAR(45)
  )
BEGIN
    DECLARE `id` VARCHAR(36) DEFAULT fnCreateUUID();
    
    INSERT INTO `tracking_word_event` (
        `id`, `tracking_book_event_id`, `book_id`, `pdf_file_number`,
        `pdf_page_number`, `word_id`, `image_page_number`,
        `click_x_in_pdf_page`, `click_y_in_pdf_page`, `event`
      ) VALUES (
        `id`, `tracking_book_event_id`, `book_id`, `pdf_file_number`,
        `pdf_page_number`, `word_id`, `image_page_number`,
        `click_x_in_pdf_page`, `click_y_in_pdf_page`, `event`
      );

    SELECT `id`;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddUpdateCourse` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddUpdateCourse`(IN in_course_id VARCHAR(36), IN in_owner_id VARCHAR(36), IN in_course_name VARCHAR(255), IN in_course_description VARCHAR(255), IN in_access_type VARCHAR(45), IN in_course_level INT, IN in_course_length INT, IN in_course_script MEDIUMTEXT)
BEGIN
	SET @course_id = in_course_id;
	IF (@course_id IS NULL) THEN SET @course_id = fnCreateUUID(); END IF;
    INSERT INTO course_script (id, name, description, owner_id, access_type, course_level, course_length, script) VALUES (@course_id, in_course_name, in_course_description, in_owner_id, in_access_type, in_course_level, in_course_length, in_course_script)
		ON DUPLICATE KEY UPDATE
			name = COALESCE(in_course_name, course_script.name), 
            description = COALESCE(in_course_description, course_script.description),
            owner_id = COALESCE(in_owner_id, course_script.owner_id), 			
            course_level = COALESCE(in_course_level, course_script.course_level),
            course_length = COALESCE(in_course_length, course_script.course_length),
            script = COALESCE(in_course_script, course_script.script);
	SELECT * FROM course_script WHERE id = @course_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddUpdateCourseResult` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddUpdateCourseResult`(IN in_member_course_id VARCHAR(36), IN in_item_id VARCHAR(255), IN in_item_type VARCHAR(10), IN in_result VARCHAR(1024))
BEGIN
/* first make sure we do not have an existing result */
SET @id = '';
SELECT id INTO @id
FROM course_result
WHERE
member_course_id = in_member_course_id AND
item_id = in_item_id AND
item_type = in_item_type;

/* update or insert */
IF @id = '' THEN
	SET @id = fnCreateUUID();
	INSERT INTO
	course_result (id, member_course_id, item_id, item_type, result, completed)
	VALUES
	(@id, in_member_course_id, in_item_id, in_item_type, in_result, (in_result IS NOT NULL));
ELSE
	UPDATE course_result
    SET result = in_result, completed = (in_result IS NOT NULL)
    WHERE id = @id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddUpdateSubscriptionForUserWithExpireDate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddUpdateSubscriptionForUserWithExpireDate`(IN in_authentication_id VARCHAR(36), IN in_product_type_id INT, IN in_transaction_provider VARCHAR(255), IN in_transaction_id VARCHAR(255), IN in_transaction_object VARCHAR(1024), IN in_expire_date DATETIME, IN in_auto_renew BIT(1))
BEGIN
SET @pk = '';
SET @authentication_id = '';
SET @product_type_id = '';
SET @transaction_provider = '';
SET @transaction_id = '';
SET @transaction_object = '';
SET @expire_date = '';
SET @auto_renew = '';
/* lets grab any existing */
SELECT id, authentication_id, product_type_id, transaction_provider, transaction_id, transaction_object, expire_date, auto_renew
INTO @pk, @authentication_id, @product_type_id, @transaction_provider, @transaction_id, @transaction_object, @expire_date, @auto_renew
FROM subscription
WHERE authentication_id = in_authentication_id;
IF @pk <> '' THEN
	/* update existing */
	UPDATE subscription
    SET
    product_type_id = in_product_type_id,
    transaction_provider = in_transaction_provider,    
    transaction_id = (CASE WHEN in_transaction_id IS NULL THEN @pk ELSE in_transaction_id END),
    transaction_object = in_transaction_object,
    expire_date = in_expire_date,
    auto_renew = in_auto_renew
    WHERE id = @pk;
    /* add to audit table */
    INSERT INTO subscription_audit
    	(subscription_id, authentication_id, product_type_id, transaction_provider, transaction_id, transaction_object, expire_date, auto_renew)
    VALUES
    	(@pk, @authentication_id, @product_type_id, @transaction_provider, @transaction_id, @transaction_object, @expire_date, @auto_renew);
ELSE
	/* add new entry, get new pk */
	SET @pk = fnCreateUUID();
	INSERT INTO subscription
    (id, authentication_id, product_type_id, transaction_provider, transaction_id, transaction_object, expire_date, auto_renew)
	VALUES
    (@pk, in_authentication_id, in_product_type_id, in_transaction_provider, (CASE WHEN in_transaction_id IS NULL THEN @pk ELSE in_transaction_id END), in_transaction_object, in_expire_date, in_auto_renew);	
END IF;    
/* make sure we return the update record */
SELECT * FROM subscription WHERE id = @pk;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddUserMediaContentForBook` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddUserMediaContentForBook`(IN in_book_id BIGINT(20), IN in_name VARCHAR(255), IN in_record_id VARCHAR(255), IN in_author_id VARCHAR(36), IN in_type VARCHAR(255))
BEGIN
SET @pk = fnCreateUUID();
INSERT INTO media_content (id, book_id, name, record_id, author_id, content_type_id)
VALUES
(@pk, in_book_id, in_name, in_record_id, in_author_id,
(SELECT id FROM content_type WHERE name = in_type));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddUserNameAndUpdateSchoolSiteSeed` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddUserNameAndUpdateSchoolSiteSeed`(IN in_school_site_id VARCHAR(36), IN in_class_group_id VARCHAR(36), IN in_username VARCHAR(100), IN in_password VARCHAR(100))
BEGIN
/* first check to ensure username does not exist */
SET @count = 0;
SET @userseed = 0;
SET @newmember = '';
SELECT COUNT(id) INTO @count FROM member WHERE username = in_username;
/* all good... important to return nothing if we DID find a user */
IF @count = 0 THEN	
	/* update user seed */
    SELECT user_seed INTO @userseed FROM school_site WHERE id = in_school_site_id;
    SET @userseed = @userseed + 1;
    UPDATE school_site SET user_seed = @userseed WHERE id = in_school_site_id;    
    /* return next seed fyi - do this BEFORE adding user, otherwise this will not be the first entry in the returning select array */
    SELECT @userseed AS user_seed;
    /* finally add user */
    CALL spAddPrimaryMemberByUserNamePasswordType(in_username, in_password, 'user');
    /* lets get the new user */
    SELECT member.id INTO @newmember FROM member JOIN authentication ON member.authentication_id = authentication.id WHERE member.username = in_username;
    /* now insert against class group */
    CALL spAssignMemberToGroup(@newmember, in_class_group_id);
    /* insert memeber to the school site */
    SET @ss_pk = fnCreateUUID();
    INSERT INTO member_school_site 
			(`id`, `school_site_id`, `member_id`) 
			VALUES (@ss_pk, in_school_site_id, @newmember);
	-- insert member to the porgress table
    IF NOT EXISTS (SELECT * FROM progress_table WHERE member_id = @newmember) THEN
    SET @pt_pk = fnCreateUUID();
    INSERT INTO progress_table
			(id, member_id, level)
            VALUES (@pt_pk, @newmember, 1);
	END IF;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddUserRatingForBook` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddUserRatingForBook`(IN in_book_id BIGINT, IN in_member_id VARCHAR(36), IN in_rating FLOAT)
BEGIN
INSERT INTO book_rating (book_id, member_id, rating)
VALUES (in_book_id, in_member_id, in_rating)
ON DUPLICATE KEY UPDATE rating = VALUES (rating);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddVerifyCopyRestrictionContent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddVerifyCopyRestrictionContent`(IN in_book_id BIGINT, IN in_access_token VARCHAR(45), IN in_content VARCHAR(255))
BEGIN
/* make sure content does not exist */
SET @crId = '';
SELECT id INTO @crId
FROM copy_restriction_access
WHERE book_id = in_book_id AND access_token = in_access_token;
IF @crId <> '' THEN
	/* make sure we have not accessed the content yet */
    SET @content_count = 0;
	SELECT COUNT(*) INTO @content_count
	FROM copy_restriction_content
    WHERE access_id = @crId AND content = in_content;
    IF @content_count <> 0 THEN
		/* found content, been accessed already */
        SELECT 'ERROR_ACCESS_DENIED' AS content;
    ELSE
		/* all good, add the content */
        INSERT INTO copy_restriction_content(access_id, content) VALUES (@crId, in_content);
        SELECT in_content AS content;
    END IF;
ELSE
	/* nothing found */
    SELECT 'ERROR_NO_ACCESS' AS content;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddWechatMetadata` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddWechatMetadata`(IN in_authentication_id VARCHAR(36), IN in_unionid VARCHAR(50), IN in_sex TINYINT(2), IN in_province VARCHAR(30), IN in_openid VARCHAR(50),
IN in_openid_web VARCHAR(50), IN in_nickname VARCHAR(30), IN in_lang CHAR(5), IN in_country VARCHAR(25), IN in_city VARCHAR(25), IN in_subscribe bit(1))
ADD_WECHAT:BEGIN
# check if user exists
SET @existance = 0;
SELECT COUNT(*)
INTO @existance
FROM wechat_metadata WHERE unionid = in_unionid;
IF @existance > 0 THEN	
	LEAVE ADD_WECHAT;
END IF;
#add new member
INSERT INTO wechat_metadata (authentication_id, unionid, sex, province, openid, openid_web, nickname, lang, country, city, subscriber)
VALUES (in_authentication_id, in_unionid, in_sex, in_province, in_openid, in_openid_web, in_nickname, in_lang, in_country, in_city, in_subscribe);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAddWechatTradeNo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAddWechatTradeNo`(In in_out_trade_no VARCHAR(32))
ADD_TRADE:BEGIN
# check if trade number exists
SET @existance = 0;
SELECT COUNT(*)
INTO @existance
FROM wechat_traderecorde WHERE out_trade_no = in_out_trade_no;
IF @existance > 0 THEN	
	LEAVE ADD_TRADE;
END IF;
#add new trade number
INSERT INTO wechat_traderecorde (out_trade_no)
VALUES (in_out_trade_no);


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAssignCourseToMember` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAssignCourseToMember`(IN in_course_id VARCHAR(36), IN in_member_id VARCHAR(36), IN in_start_date TIMESTAMP)
BEGIN
	/* lets see if we are updating... or creating a new course */
    SET @id = '';
    SET @course_id = '';
    SET @start_date = NULL;
    SELECT id, course_script_id, start_date INTO @id, @course_id, @start_date FROM member_course WHERE member_id = in_member_id AND active = 1;
	/* update or new */
    IF @id <> '' AND @course_id = in_course_id THEN
		/* update */
        UPDATE member_course SET start_date = COALESCE(in_start_date, @start_date) WHERE id = @id;
	ELSE    
		/* new... members can only has 1 active course at a time, so flag all existing as not active */	
		UPDATE member_course SET active = 0 WHERE member_id = in_member_id;
		/* assign new course */
		INSERT INTO member_course (id, member_id, course_script_id, start_date, completed, process_session_id, create_date)
		VALUES(fnCreateUUID(), in_member_id, in_course_id,
			COALESCE(in_start_date, @start_date),
			0, NULL, CURRENT_TIMESTAMP);
	END IF;
    /* update progress table */
    SET @course_level = 0;
    SELECT course_level INTO @course_level FROM course_script WHERE id = in_course_id;
    IF NOT EXISTS(SELECT * FROM progress_table WHERE member_id = in_member_id) THEN
		INSERT INTO progress_table (id, member_id, level) VALUES (fnCreateUUID(), in_member_id, @course_level); 
	ELSE
		UPDATE progress_table SET level = @course_level WHERE member_id = in_member_id;
	END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAssignCourseToMemberGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAssignCourseToMemberGroup`(IN in_course_id VARCHAR(36), IN in_member_id VARCHAR(36), IN in_group_id VARCHAR(36), IN in_start_date DATE)
BEGIN
-- make sure it is se to deliver to either member or a group not both
IF (in_member_id IS NOT NULL AND in_group_id IS NOT NULL) THEN SELECT true AS error, 'You can not assign a course to both member and group' AS message;
-- if the course to be assigned to the member
ELSEIF in_member_id IS NOT NULL THEN
	-- make sure same record doesnt exist. 
	IF (SELECT COUNT(*) FROM content_delivery WHERE member_id = in_member_id AND course_id = in_course_id) THEN
		SELECT true AS error, 'You already assigned this course to this member' AS message;
	ELSEIF (SELECT COUNT(*) FROM content_delivery WHERE member_id = in_member_id AND course_id IS NOT NULL) THEN
    SELECT course_id INTO @prev_course_id FROM content_delivery WHERE course_id IS NOT NULL AND member_id = in_member_id;
		-- delete the course from course-book and the course tables
        DELETE FROM course_book WHERE course_id = @prev_course_id;
		DELETE FROM content_delivery WHERE course_id = @prev_course_id;
        DELETE FROM course WHERE id = @prev_course_id;
        SET @cd_id = fnCreateUUID();
		INSERT INTO `content_delivery` (`id`, `member_id`, `class_group_id`, `start_date`, `end_date`, `book_id`, `course_id`) 
        VALUES (@cd_id, in_member_id, NULL, in_start_date, NULL, NULL, in_course_id);
        SELECT null AS err, 'previous old course is replaced with new one.' AS message;
    ELSE
		SET @cd_id = fnCreateUUID();
		INSERT INTO `content_delivery` (`id`, `member_id`, `class_group_id`, `start_date`, `end_date`, `book_id`, `course_id`) 
        VALUES (@cd_id, in_member_id, NULL, in_start_date, NULL, NULL, in_course_id);
        SELECT null AS err, 'a new course is created as there were not any other courses were assigned to this member.' AS message;
    END IF;
-- if the course to be assigned to the group
ELSEIF in_group_id IS NOT NULL THEN
	-- make sure same record doesnt exist. 
	IF (SELECT COUNT(*) FROM content_delivery WHERE class_group_id = in_group_id AND course_id = in_course_id) THEN
		SELECT true AS error, 'You already assigned this course to this group' AS message;
	ELSE
		SET @cd_id = fnCreateUUID();
		INSERT INTO `content_delivery` (`id`, `member_id`, `class_group_id`, `start_date`, `end_date`, `book_id`, `course_id`) 
        VALUES (@cd_id, NULL, in_group_id, in_start_date, NULL, NULL, in_course_id);
        SELECT null AS error, 'The new course is assigned the group' AS message;
	END IF;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAssignDefaultCourseByMemberLevel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAssignDefaultCourseByMemberLevel`(IN in_member_id VARCHAR(36), IN in_level INT(11))
BEGIN
	SET @course_name='';
	CASE in_level
		WHEN 1 THEN SET @course_name = 'Level 1';
        WHEN 3 THEN SET @course_name = 'Level 3';
        WHEN 5 THEN SET @course_name = 'Level 5';
        WHEN 10 THEN SET @course_name = 'Level 10';
        WHEN 15 THEN SET @course_name = 'Level 15';
        WHEN 20 THEN SET @course_name = 'Level 20';
        WHEN 21 THEN SET @course_name = 'Level 21';
        WHEN 25 THEN SET @course_name = 'Level 25';
        WHEN 30 THEN SET @course_name = 'Level 30';
	END CASE;
    
    /* get script id (this must resolve) */
    SELECT id INTO @course_id FROM course_script WHERE name = @course_name AND access_type = 'DEFAULT';
    /* members can only has 1 active course at a time */	
    UPDATE member_course SET active = 0 WHERE member_id = in_member_id;    
    /* insert new course */
	INSERT INTO member_course (id, member_id, course_script_id, completed, start_date, create_date) VALUE (fnCreateUUID(), in_member_id, @course_id, 0, CURDATE(), CURRENT_TIMESTAMP);    
    /* update the level in the progress table */
    IF NOT EXISTS(SELECT * FROM progress_table WHERE member_id = in_member_id) THEN
		INSERT INTO progress_table (id, member_id, level) VALUES (fnCreateUUID(), in_member_id, in_level); 
	ELSE
		UPDATE progress_table SET level = in_level WHERE member_id = in_member_id;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAssignLevelToMember` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAssignLevelToMember`(IN in_member_id VARCHAR(36), IN in_level INT)
BEGIN
IF NOT EXISTS(SELECT * FROM progress_table WHERE member_id = in_member_id) THEN
	SET @pk = fnCreateUUID();
	INSERT INTO `progress_table` (`id`, `member_id`, `level`) 
    VALUES (@pk, in_member_id, COALESCE(in_level, 1));
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAssignMemberToGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAssignMemberToGroup`(IN in_member_id VARCHAR(36), IN in_class_group_id VARCHAR(36))
BEGIN
-- first make sure that the same record does not exist
SELECT COUNT(*) INTO @record_exist 
FROM member_class_group 
WHERE member_class_group.member_id = in_member_id 
AND member_class_group.class_group_id = in_class_group_id;

IF (@record_exist = 0) THEN
	 INSERT INTO member_class_group 
     (`id`, `class_group_id`, `member_id`) 
     VALUES (fnCreateUUID(), in_class_group_id, in_member_id);
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spAssignMemberToSchoolSite` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spAssignMemberToSchoolSite`(IN in_user_id VARCHAR(36), IN in_member_id VARCHAR(36), IN in_schoolsite_id VARCHAR(36))
BEGIN
	/*get school_site_id for the user*/
    SET @has_access = (SELECT COUNT(*) 
		FROM school_site
        JOIN class ON class.school_site_id = school_site.id 
		WHERE (admin_id = in_user_id AND school_site.id = in_schoolsite_id) OR class.teacher_id = in_user_id);
    /* get user role, we should allow user with group admin 20 and lower to create a row here*/
    SET @role_id = (SELECT role_type_id 
		FROM member 
        JOIN authentication ON authentication.id = member.authentication_id 
        WHERE member.id = in_user_id);
    /* create the row in the table */
    IF (@has_access <> 0 OR @role_id <= 20) THEN
		/* check if the record already exist */
        SET @record_exist= (SELECT COUNT(*) FROM member_school_site WHERE school_site_id = in_schoolsite_id AND member_id = in_member_id);
		IF(@record_exist = 0) THEN
			SET @ss_pk = fnCreateUUID();
			INSERT INTO member_school_site 
			(`id`, `school_site_id`, `member_id`) 
			VALUES (@ss_pk, in_schoolsite_id, in_member_id);
		END IF;
        /* return success */
		SELECT false AS error;
	ELSE 
		/* return fail, the user doesn't have access */
        SELECT true AS error, 'User does not have permision to assign a member to this school';
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spCreateAndAssignCourseToMember` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spCreateAndAssignCourseToMember`(IN in_school_site_id VARCHAR(36), IN in_teacher_id VARCHAR(36), IN in_course_name VARCHAR(100),IN in_course_length INT(11), IN in_start_date DATE, IN in_books_per_week INT, IN in_member_id VARCHAR(36), IN in_clXpp INT)
BEGIN
-- create a course and assign 5 books of level 3 to it. 
-- 
SET @course_id = fnCreateUUID();
SET @row = 0;
INSERT INTO course(id, name, course_length, teacher_id, school_site_id) values(@course_id,in_course_name, in_course_length, in_teacher_id, in_school_site_id);
INSERT INTO course_book(id, course_id, book_id, week_number)
SELECT temp_id, temp_course_id, book_id, ((@row:=@row+1) % (in_course_length))+1 as week_number FROM (
SELECT fnCreateUUID() AS temp_id, @course_id AS temp_course_id, book.id AS book_id FROM book WHERE reading_level = (SELECT LEVEL FROM progress_table WHERE member_id = in_member_id) ORDER BY rand() LIMIT in_clXpp) AS temp;

-- assign the above course to a member. 

-- check in the content_delivey if the member is already assigned to other course?? in that case
-- delete all information about that course so we can replace it with the new course. 
IF (SELECT COUNT(*) FROM content_delivery WHERE member_id = in_member_id AND course_id IS NOT NULL) THEN
    SELECT course_id INTO @prev_course_id FROM content_delivery WHERE course_id IS NOT NULL AND member_id = in_member_id;
		-- delete the course from course-book and the course tables
        DELETE FROM course_book WHERE course_id = @prev_course_id;
		DELETE FROM content_delivery WHERE course_id = @prev_course_id;
        DELETE FROM course WHERE id = @prev_course_id;
END IF; 
INSERT INTO content_delivery(id, member_id, course_id, start_date) VALUES (fnCreateUUID(), in_member_id, @course_id, in_start_date);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spCreateCourseOnLevel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spCreateCourseOnLevel`(IN in_user_id VARCHAR(36), IN in_level INT)
BEGIN

SET @in_book_id = NULL;
CASE in_level
	WHEN 1 THEN SET @in_book_id = 1171;
	WHEN 3 THEN SET @in_book_id = 1096;
	WHEN 5 THEN SET @in_book_id = 1121;
	WHEN 10 THEN SET @in_book_id = 2189;
	WHEN 15 THEN SET @in_book_id = 2252;
	WHEN 19 THEN SET @in_book_id = 1409;
	WHEN 20 THEN SET @in_book_id = 1409;
	WHEN 25 THEN SET @in_book_id = 1390;
	WHEN 30 THEN SET @in_book_id = 2442;
END CASE;
    

-- registering user the main user class. 

IF NOT EXISTS(SELECT * FROM member_class_group WHERE class_group_id = '9278fb01a24811e68f2322000ba8862d' AND member_id = in_user_id) THEN
	INSERT INTO member_class_group(id, class_group_id, member_id) VALUES (fnCreateUUID(), '9278fb01a24811e68f2322000ba8862d', in_user_id);
END IF;
 

SET @course_id = fnCreateUUID();
SET @row = 0;

INSERT INTO course(id, name, course_length, teacher_id, school_site_id) VALUES (@course_id,'Standard Course', 12 , 'c03b1bf7b29e11e6bd1002a76cde81a3', '89ac8a1ba24811e68f2322000ba8862d'); 
-- Assigne books to the course.
IF @in_book_id IS NOT NULL THEN 
	INSERT INTO course_book(id, course_id, book_id, week_number) VALUES (fnCreateUUID(), @course_id, @in_book_id, 1);
	INSERT INTO course_book(id, course_id, book_id, week_number)
	SELECT temp_id, temp_course_id, book_id, ((@row:=@row+1) % (12))+1 as week_number FROM (
	SELECT fnCreateUUID() AS temp_id, @course_id AS temp_course_id, book.id AS book_id FROM book WHERE book.id <> @in_book_id AND reading_level = in_level ORDER BY rand() LIMIT 59) AS temp;
ELSE
	INSERT INTO course_book(id, course_id, book_id, week_number)
	SELECT temp_id, temp_course_id, book_id, ((@row:=@row+1) % (12))+1 as week_number FROM (
	SELECT fnCreateUUID() AS temp_id, @course_id AS temp_course_id, book.id AS book_id FROM book WHERE book.id <> @in_book_id AND reading_level = in_level ORDER BY rand() LIMIT 60) AS temp;
END IF;

-- assign the above course to a member. 

-- check in the content_delivey if the member is already assigned to other course?? in that case
-- delete all information about that course so we can replace it with the new course. 
IF (SELECT COUNT(*) FROM content_delivery WHERE member_id = in_user_id AND course_id IS NOT NULL) THEN
    SELECT course_id INTO @prev_course_id FROM content_delivery WHERE course_id IS NOT NULL AND member_id = in_user_id;
		-- delete the course from course-book and the course tables
        DELETE FROM course_book WHERE course_id = @prev_course_id;
		DELETE FROM content_delivery WHERE course_id = @prev_course_id;
        DELETE FROM course WHERE id = @prev_course_id;
END IF; 
INSERT INTO content_delivery(id, member_id, course_id, start_date) VALUES (fnCreateUUID(), in_user_id, @course_id, CURDATE());

UPDATE progress_table 
SET level = in_level
WHERE member_id = in_user_id;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spCreateNewCourse` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spCreateNewCourse`(IN in_school_site_id VARCHAR(36), IN in_teacher_id VARCHAR(36), IN in_name VARCHAR(100), IN in_course_length INT)
BEGIN
SET @course_id = fnCreateUUID();
INSERT INTO `course` (`id`, `name`, `teacher_id`, `school_site_id`, `course_length`) 
VALUES (@course_id, in_name, in_teacher_id, in_school_site_id, in_course_length);
SELECT * FROM course WHERE id = @course_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spCreateWechatFollowersTable` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spCreateWechatFollowersTable`()
BEGIN
DROP TABLE IF EXISTS
wechat_followers;

CREATE TABLE wechat_followers
(unionid VARCHAR(50) NOT NULL PRIMARY KEY,
tag00 SMALLINT(5),
tag01 SMALLINT(5),
tag02 SMALLINT(5),
subscribe_time  INT(10), 
sex TINYINT(2),
province VARCHAR(30),
openid VARCHAR(50) NOT NULL,
nickname VARCHAR(30) NOT NULL,
lang CHAR(5),
groupid SMALLINT(5) NOT NULL,
country VARCHAR(25),
city VARCHAR(25)
);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteAllBooksInCourseById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeleteAllBooksInCourseById`(IN in_course_id VARCHAR(36))
BEGIN
DELETE FROM course_book 
WHERE course_id = in_course_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteClassById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeleteClassById`(IN in_user_id VARCHAR(36), IN in_class_id VARCHAR(36))
BEGIN
	-- delete all member in the group note we don't do this if the user has created any content.
    -- DELETE content_delivery, member_class_group FROM member_class_group 
    -- LEFT JOIN class_group ON class_group.id = member_class_group.class_group_id
    -- LEFT JOIN content_delivery ON content_delivery.member_id = member_class_group.member_id
    -- WHERE class_group.class_id = in_class_id;
    /*first delete the related class_groups*/
	DELETE FROM class_group
	WHERE class_group.class_id = in_class_id;
	/*then delete the class*/
	DELETE FROM class
	WHERE class.id = in_class_id;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteClassGroupById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeleteClassGroupById`(IN in_id VARCHAR(36))
BEGIN
/* check if the number of class_group in that class is greater than on before delete; we need to have at least one class_group in the class*/
SELECT 
class_group.class_id 
INTO @class 
FROM class_group 
WHERE class_group.id = in_id;

SELECT 
count(*) 
INTO @NumberOfGroups 
FROM class_group 
WHERE class_id = @class;
IF @NumberOfGroups > 1 THEN
	DELETE FROM class_group 
	WHERE class_group.id = in_id;
    SELECT TRUE;
ELSE
	SELECT FALSE;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteCourseById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeleteCourseById`(IN in_course_id VARCHAR(36))
BEGIN
DELETE FROM course WHERE id = in_course_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteCourseFromGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeleteCourseFromGroup`(IN in_course_id VARCHAR(36), IN in_group_id VARCHAR(36))
BEGIN
DELETE FROM content_delivery WHERE course_id = in_course_id AND class_group_id = in_group_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteCourseScriptById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeleteCourseScriptById`(IN in_course_id VARCHAR(36))
BEGIN
	DELETE FROM course_script WHERE id = in_course_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteDeliveredBookFromGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeleteDeliveredBookFromGroup`(IN in_book_id VARCHAR(36), IN in_group_id VARCHAR(36))
BEGIN
DELETE FROM content_delivery 
WHERE book_id = in_book_id 
AND class_group_id = in_group_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteDeliveredBookFromMember` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeleteDeliveredBookFromMember`(IN in_book_id VARCHAR(36), IN in_member_id VARCHAR(36))
BEGIN
DELETE FROM content_delivery 
WHERE book_id = in_book_id 
AND member_id = member_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteMemberById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeleteMemberById`(IN in_member_id VARCHAR(36))
BEGIN
/* determine if primary */
SET @authid = '';
SET @pm = 0;
SELECT authentication_id, primary_user
INTO @authId, @pm
FROM member
WHERE member.id = in_member_id;

IF NOT EXISTS(SELECT * FROM tracking_member_event WHERE member_id = in_member_id) THEN
	/* delete the member from the school */
	DELETE FROM member_school_site WHERE member_id = in_member_id;
	DELETE FROM progress_table WHERE member_id = in_member_id;
	DELETE FROM member_class_group WHERE member_id = in_member_id;
	DELETE FROM content_delivery WHERE member_id = in_member_id;
END IF;

IF @pm = 0 THEN
	/* simple delete */
	DELETE FROM member
	WHERE member.id = in_member_id;
ELSE
	/* delete all members then authentication */
	DELETE FROM member
	WHERE member.authentication_id = @authid;
	DELETE FROM authentication
	WHERE authentication.id = @authid;
	
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteRedemptionById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeleteRedemptionById`(IN in_id VARCHAR(36))
BEGIN
DELETE FROM redemption
WHERE id = in_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteSchoolGroupById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeleteSchoolGroupById`(IN in_schoolgroup_id VARCHAR(36))
BEGIN
DELETE FROM school_group
WHERE school_group.id = in_schoolgroup_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteSchoolSiteById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeleteSchoolSiteById`(IN in_schoolsite_id VARCHAR(36))
BEGIN
DELETE FROM school_site
WHERE school_site.id = in_schoolsite_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteSubscriptionForUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeleteSubscriptionForUser`(IN in_authentication_id VARCHAR(36))
BEGIN
DELETE FROM subscription
WHERE authentication_id = in_authentication_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeleteUserMediaContentByUserArchiveId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeleteUserMediaContentByUserArchiveId`(IN in_member_id VARCHAR(36), IN in_record_id VARCHAR(255))
BEGIN
DELETE FROM media_content
WHERE author_id = in_member_id AND record_id = in_record_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeliverBooksToGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeliverBooksToGroup`(IN in_book_array VARCHAR(255), IN in_group_id VARCHAR(36))
BEGIN
SET @arrayOfBooks = in_book_array;
WHILE (LOCATE(',', @arrayOfBooks) > 0)
Do
    SET @book_id = SUBSTRING(@arrayOfBooks,1,LOCATE(',', @arrayOfBooks)-1);
	SET @pk = fnCreateUUID();
    SET @arrayOfBooks= SUBSTRING(@arrayOfBooks, LOCATE(',',@arrayOfBooks) + 1);
	INSERT INTO content_delivery 
	(`id`, `member_id`, `class_group_id`, `start_date`, `end_date`, `book_id`) 
	VALUES (@pk, NULL, in_group_id, NULL, NULL, @book_id);
END WHILE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeliverBookToGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeliverBookToGroup`(IN in_book_id VARCHAR(36), IN in_group_id VARCHAR(36))
BEGIN
/*make its not already assigned with the group*/
SELECT COUNT(*) INTO @is_assigned FROM content_delivery WHERE class_group_id = in_group_id AND book_id = in_book_id;
IF (@is_assigned = 0) THEN
	SET @pk = fnCreateUUID();
	INSERT INTO content_delivery 
		(`id`, `class_group_id`, `start_date`, `end_date`, `book_id`) 
		VALUES (@pk, in_group_id, NULL, NULL, in_book_id);
	SELECT 'FALSE' AS error;
ELSE 
	SELECT 'TRUE' AS error, 'The item has been already delivered for this group' AS message;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeliverBookToMember` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeliverBookToMember`(IN in_book_id VARCHAR(36), IN in_member_id VARCHAR(36))
BEGIN
/*make its not already assigned with the group*/
SELECT COUNT(*) INTO @is_assigned FROM content_delivery WHERE member_id = in_member_id AND book_id = in_book_id;
IF (@is_assigned = 0) THEN
	SET @pk = fnCreateUUID();
	INSERT INTO content_delivery 
		(`id`, `member_id`, `start_date`, `end_date`, `book_id`) 
		VALUES (@pk, in_member_id, NULL, NULL, in_book_id);
	SELECT 'FALSE' AS error;
ELSE 
	SELECT 'TRUE' AS error, 'The item has been already delivered for this group' AS message;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spDeliverCourseToGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spDeliverCourseToGroup`(IN in_course_id VARCHAR(36), IN in_group_id VARCHAR(36), IN in_start_date DATE)
BEGIN
/*make its not already assigned with the group*/
SELECT COUNT(*) INTO @is_assigned FROM content_delivery WHERE class_group_id = in_group_id AND course_id = in_course_id;
IF(@is_assigned = 0) THEN	
    SET @pk = fnCreateUUID();
	INSERT INTO content_delivery 
		(`id`, `class_group_id`, `start_date`, `course_id`) 
		VALUES (@pk, in_group_id, in_start_date, in_book_id);
	SELECT 'FALSE' AS error;
ELSE 
	SELECT 'TRUE' AS error, 'The item has been already delivered for this group' AS message;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spFindBooksByKeyword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spFindBooksByKeyword`(IN in_keyword VARCHAR(100))
BEGIN
SET @searchStr = '%';
IF in_keyword <> '*' THEN
	SET @searchStr = REPLACE(in_keyword, ' ', '%');
	SET @searchStr = CONCAT('%', @searchStr, '%');
END IF;
SELECT * 
FROM book 
WHERE book.name LIKE @searchStr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spFindClassByKeyword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spFindClassByKeyword`(IN in_keyword VARCHAR(100))
BEGIN
/* determine search filter */
SET @searchStr = '%';
IF in_keyword <> '*' THEN
	SET @searchStr = REPLACE(in_keyword, ' ', '%');
	SET @searchStr = CONCAT('%', @searchStr, '%');
END IF;

SELECT * 
FROM class
WHERE
class.name LIKE @searchStr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spFindClassesWithGroupsByKeyword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spFindClassesWithGroupsByKeyword`(IN in_user_id VARCHAR(36),IN in_schoolsite_id VARCHAR(36), IN in_keyword VARCHAR(100))
BEGIN
/* determine search filter */
SET @searchStr = '%';
IF in_keyword <> '*' THEN
	SET @searchStr = REPLACE(in_keyword, ' ', '%');
	SET @searchStr = CONCAT('%', @searchStr, '%');
END IF;
SET @role_id = (SELECT role_type_id FROM member JOIN authentication ON authentication.id = member.authentication_id WHERE member.id = in_user_id);
SELECT 
class.*,
class_group.id AS group_id,
class_group.name AS group_name 
FROM class 
JOIN class_group ON class.id = class_group.class_id
JOIN school_site ON school_site.id = class.school_site_id
WHERE class.name LIKE @searchStr
AND (school_site.admin_id = in_user_id OR @role_id <= 20 OR teacher_id = in_user_id)
AND (((@role_id <= 20 AND in_schoolsite_id IS NULL) OR school_site.id = in_schoolsite_id))
ORDER BY class.name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spFindMemberByIdAndVerifyToken` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spFindMemberByIdAndVerifyToken`(IN in_member_id VARCHAR(36), IN in_verify_token VARCHAR(45))
BEGIN
SET @member_id = '';
SELECT member.id
INTO @member_id
FROM authentication
JOIN member ON authentication.id = member.authentication_id
JOIN role_type ON authentication.role_type_id = role_type.id
WHERE
member.id = in_member_id AND authentication.verify_token = in_verify_token;
IF @member_id <> '' THEN
	UPDATE authentication
	SET
    last_login = CURRENT_TIMESTAMP,
    email_verified = 1,
    verify_token = NULL
	WHERE authentication.id = @authentication_id;
	CALL spGetMemberById(@member_id);
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spFindMemberByKeywordRoleType` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spFindMemberByKeywordRoleType`(IN in_user_id VARCHAR(36), IN in_schoolsite_id VARCHAR(36), IN in_keyword VARCHAR(100), IN in_role_type VARCHAR(45))
BEGIN
/* determine search filter */
SET @searchStr = '%';
IF in_keyword <> '*' THEN
	SET @searchStr = REPLACE(in_keyword, ' ', '%');
	SET @searchStr = CONCAT('%', @searchStr, '%');
END IF;
/* get the user role id if it is smaller or equal than 20 the user can see all members. */
SET @role_id = (SELECT role_type_id 
	FROM member 
	JOIN authentication ON authentication.id = member.authentication_id 
	WHERE member.id = in_user_id);
/* resolve role type */
SET @role_type_id = -1;
SELECT id
INTO @role_type_id
FROM role_type
WHERE name = in_role_type;
/* get members */
IF @role_type_id <> -1 THEN
	SELECT
	member.id AS id,    
	authentication.id AS authentication_id,
    member.username AS username,
    member.name_first AS name_first,
    member.name_last AS name_last,
    authentication.email AS email,
    member.primary_user AS primary_user,
	role_type.name AS role_type,
    subscription.expire_date AS subscription_expire_date
	FROM member
	JOIN authentication ON member.authentication_id = authentication.id
	JOIN role_type ON authentication.role_type_id = role_type.id
    LEFT JOIN subscription ON authentication.id = subscription.authentication_id
    /*considering the site admin previlages */
    LEFT JOIN member_school_site ON member_school_site.member_id = member.id
    LEFT JOIN school_site ON school_site.id = member_school_site.school_site_id
	WHERE
    /* a user can see its own school members or it needs to be admin with global access */
	((@role_id <= 20 AND in_schoolsite_id IS NULL) OR school_site.id = in_schoolsite_id) AND
    /*end*/
    role_type_id = @role_type_id AND
    (
	authentication.email LIKE @searchStr OR
    member.username LIKE @searchStr OR
    member.name_first LIKE @searchStr OR
    member.name_last LIKE @searchStr OR
    CONCAT(member.name_first, ' ', member.name_last) LIKE @searchStr) 
    GROUP BY member.id
    ORDER BY authentication.email, member.primary_user DESC, member.name_first, member.name_last;
ELSE
	SELECT
	member.id AS id,    
	authentication.id AS authentication_id,
    member.username AS username,
    member.name_first AS name_first,
    member.name_last AS name_last,
    authentication.email AS email,
    member.primary_user AS primary_user,
	role_type.name AS role_type,
    subscription.expire_date AS subscription_expire_date
	FROM member
	JOIN authentication ON member.authentication_id = authentication.id
	JOIN role_type ON authentication.role_type_id = role_type.id
    LEFT JOIN subscription ON authentication.id = subscription.authentication_id
	/*considering the site admin previlages */
	LEFT JOIN member_school_site ON member_school_site.member_id = member.id
    LEFT JOIN school_site ON school_site.id = member_school_site.school_site_id
	WHERE
    /* a user can see its own school members or it needs to be admin with global access */
	((@role_id <= 20 AND in_schoolsite_id IS NULL) OR school_site.id = in_schoolsite_id) AND
    /*end*/
    (
		authentication.email LIKE @searchStr OR
    member.username LIKE @searchStr OR
    member.name_first LIKE @searchStr OR
    member.name_last LIKE @searchStr OR
    CONCAT(member.name_first, ' ', member.name_last) LIKE @searchStr)
    GROUP BY member.id
    ORDER BY authentication.email, member.primary_user DESC, member.name_first, member.name_last;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spFindMembersByRoleType` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spFindMembersByRoleType`(IN in_role_type VARCHAR(45), IN in_include_higher_role_type BIT)
BEGIN
/* resolve role type */
SET @role_type_id = -1;
SELECT id
INTO @role_type_id
FROM role_type
WHERE name = in_role_type;
/* get members */
IF @role_type_id <> -1 THEN
	IF in_include_higher_role_type != 0 THEN
		SELECT
        member.*,
        authentication.*,
        role_type.name AS role_type 
        FROM member
        JOIN authentication ON member.authentication_id = authentication.id
        JOIN role_type ON authentication.role_type_id = role_type.id
        WHERE role_type_id <= @role_type_id;
	ELSE
		SELECT
        member.*,
        authentication.*,
        role_type.name AS role_type 
        FROM member
        JOIN authentication ON member.authentication_id = authentication.id
        JOIN role_type ON authentication.role_type_id = role_type.id
        WHERE role_type_id = @role_type_id;
    END IF;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spFindPrimaryMemberByEmailPassword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spFindPrimaryMemberByEmailPassword`(IN in_email VARCHAR(255), IN in_password VARCHAR(1024))
BEGIN
SET @member_id = '';
SET @authentication_id = '';
SELECT member.id, authentication.id
INTO @member_id, @authentication_id
FROM authentication
JOIN member ON authentication.id = member.authentication_id
WHERE
authentication.email = in_email AND
authentication.password = in_password AND
member.primary_user = 1;
IF @member_id <> '' THEN
	/* update authentication record */
	UPDATE authentication
	SET last_login = CURRENT_TIMESTAMP
	WHERE id = @authentication_id;
    /* update member record */
    UPDATE member
    SET auth_type = 'EMAIL'
    WHERE id = @member_id;
    /* return user */
	CALL spGetMemberById(@member_id);
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spFindPrimaryMemberByOAuthType` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spFindPrimaryMemberByOAuthType`(IN in_oauth_token VARCHAR(255), IN in_oauth_type VARCHAR(255))
BEGIN
SET @member_id = '';
SET @authentication_id = '';
SELECT member.id, authentication.id
INTO @member_id, @authentication_id
FROM authentication
JOIN member ON authentication.id = member.authentication_id
WHERE
authentication.oauth_token = in_oauth_token AND
authentication.oauth_type = in_oauth_type AND
member.primary_user = 1;
IF @member_id <> '' THEN
	/* update authentication record */
	UPDATE authentication
	SET last_login = CURRENT_TIMESTAMP
	WHERE id = @authentication_id;
    /* update member record */
    UPDATE member
    SET auth_type = 'OAUTH'
    WHERE id = @member_id;
    /* return user */
	CALL spGetMemberById(@member_id);
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spFindPrimaryMemberByUsernamePassword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spFindPrimaryMemberByUsernamePassword`(IN in_username VARCHAR(255), IN in_password VARCHAR(255))
BEGIN
SET @member_id = '';
SET @authentication_id = '';
SELECT member.id, authentication.id
INTO @member_id, @authentication_id
FROM authentication
JOIN member ON authentication.id = member.authentication_id
WHERE
member.username = in_username AND
member.password = in_password;
IF @member_id <> '' THEN
	/* update authentication record */
	UPDATE authentication
	SET last_login = CURRENT_TIMESTAMP
	WHERE id = @authentication_id;
	/* update member record */
	UPDATE member
	SET auth_type = 'USERNAME'
	WHERE id = @member_id;
	/* return user */
	CALL spGetMemberById(@member_id);
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spFindSchoolByKeyword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spFindSchoolByKeyword`(IN in_keyword VARCHAR(100))
BEGIN
/* determine search filter */
SET @searchStr = '%';
IF in_keyword <> '*' THEN
	SET @searchStr = REPLACE(in_keyword, ' ', '%');
	SET @searchStr = CONCAT('%', @searchStr, '%');
END IF;

SELECT * 
FROM school_site
WHERE
school_site.name LIKE @searchStr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spFindSchoolGroupByKeyword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spFindSchoolGroupByKeyword`(IN in_keyword VARCHAR(100))
BEGIN
/* determine search filter */
SET @searchStr = '%';
IF in_keyword <> '*' THEN
	SET @searchStr = REPLACE(in_keyword, ' ', '%');
	SET @searchStr = CONCAT('%', @searchStr, '%');
END IF;

SELECT * 
FROM school_group
WHERE
school_group.name LIKE @searchStr OR
school_group.country LIKE @searchStr;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllAccessibleTeachers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllAccessibleTeachers`(IN in_member_id VARCHAR(36), IN in_school_site_id VARCHAR(36))
BEGIN
SELECT role_type_id into @role_type_id FROM member

JOIN authentication ON authentication.id = member.authentication_id WHERE member.id = in_member_id;
SET @has_admin_access = 0;

IF EXISTS(SELECT * FROM school_site WHERE id = in_school_site_id AND admin_id = in_member_id) THEN
	SET @has_admin_access = 1;
END IF;

IF @role_type_id = 30 AND @has_admin_access = 0 THEN
	SET @role_type_id = 40;
END IF;

SELECT
member.*,
authentication.email
FROM member 
JOIN authentication ON authentication.id = member.authentication_id 
JOIN member_school_site ON member_school_site.member_id = member.id
WHERE school_site_id = in_school_site_id
AND role_type_id <= 40 AND (role_type_id > @role_type_id OR member.id = in_member_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllClasses` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllClasses`(IN in_user_id VARCHAR(36),IN in_schoolsite_id VARCHAR(36))
BEGIN
SET @role_id = (SELECT role_type_id FROM member JOIN authentication ON authentication.id = member.authentication_id WHERE member.id = in_user_id);
SELECT 
class.*,
class_group.id AS group_id,
class_group.name AS group_name 
FROM class 
JOIN class_group ON class.id = class_group.class_id
JOIN school_site ON school_site.id = class.school_site_id
WHERE (school_site.admin_id = in_user_id OR @role_id <= 20 OR teacher_id = in_user_id)
AND (((@role_id <= 20 AND in_schoolsite_id IS NULL) OR school_site.id = in_schoolsite_id))
GROUP BY class.id
ORDER BY class.name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllClassesBySchoolId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllClassesBySchoolId`(IN in_school_site_id VARCHAR(36))
BEGIN
SELECT * FROM class WHERE school_site_id = in_school_site_id OR in_school_site_id IS NULL;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllClassesByTeacherAndSchoolId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllClassesByTeacherAndSchoolId`(IN in_teacher_id VARCHAR(36), IN in_school_site_id VARCHAR(36))
BEGIN
	SELECT * FROM class WHERE teacher_id = in_teacher_id AND school_site_id = in_school_site_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllClassesWithGroups` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllClassesWithGroups`()
BEGIN
SELECT 
class.*,
class_group.id AS group_id,
class_group.name AS group_name 
FROM class 
JOIN class_group ON class.id = class_group.class_id
ORDER BY class.name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllCourseForSchool` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllCourseForSchool`(IN in_school_site_id VARCHAR(36))
BEGIN
SELECT * 
FROM course 
WHERE school_site_id  = in_school_site_id OR in_school_site_id IS NULL; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllCoursesByClassId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllCoursesByClassId`(IN in_class_id VARCHAR(36))
BEGIN
SELECT course.* 
FROM course 
JOIN content_delivery ON content_delivery.course_id = course.id
JOIN class_group ON content_delivery.class_group_id = class_group.id
WHERE class_group.class_id = in_class_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllDeliveredBooksForMember` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllDeliveredBooksForMember`(IN in_member_id VARCHAR(36))
BEGIN
SELECT class_group_id INTO @member_group_id FROM member_class_group where member_id = in_member_id LIMIT 1;

SELECT 
content_delivery.id AS id,
book.id AS book_id,
book.name AS book_name,
content_delivery.start_date AS start_date,
content_delivery.end_date AS end_date  
FROM content_delivery 
JOIN book ON book.id = content_delivery.book_id
WHERE member_id = in_member_id 
OR class_group_id = @member_group_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllRedemptions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllRedemptions`(IN in_include_redeemed BIT(1))
BEGIN
SELECT *
FROM redemption
WHERE
(in_include_redeemed AND redeem_member_id IS NOT NULL) OR
(redeem_member_id IS NULL);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllRelatedSchoolForUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllRelatedSchoolForUser`(IN in_user_id VARCHAR(36))
BEGIN
SELECT school_site.* 
FROM member_school_site 
JOIN school_site ON school_site.id = member_school_site.school_site_id 
WHERE member_school_site.member_id = in_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllRoleTypes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllRoleTypes`()
BEGIN
SELECT *
FROM role_type
ORDER BY id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllRunningMemberCourses` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllRunningMemberCourses`(IN in_process_session_id VARCHAR(255))
BEGIN
/* if process session id is null, create */
SET @process_session_id = in_process_session_id;
IF @process_session_id IS NULL THEN
	SET @process_session_id = fnCreateUUID();
END IF;
SELECT
member_course.*,
(SELECT item_id FROM course_result WHERE member_course_id = member_course.id AND item_type = 'EVENT' AND completed = 1 ORDER BY create_date DESC LIMIT 1) AS last_event_id,
(SELECT item_id FROM course_result WHERE member_course_id = member_course.id AND item_type = 'TASK' AND completed = 1 ORDER BY create_date DESC LIMIT 1) AS last_task_id,
course_script.script,
member.name_first AS name_first,
member.name_last AS name_last,
authentication.email AS transport_email,
authentication.oauth_token AS transport_oauth_token,

@process_session_id AS process_session_id
FROM member_course
JOIN course_script ON member_course.course_script_id = course_script.id
JOIN member ON member_course.member_id = member.id
JOIN authentication ON member.authentication_id = authentication.id
JOIN member AS member_owner ON course_script.owner_id = member_owner.id
JOIN authentication AS authentication_owner ON member_owner.authentication_id = authentication_owner.id
WHERE
((start_date IS NULL) OR (start_date < NOW())) AND
completed = 0 AND
(process_session_id IS NULL OR process_session_id <> @process_session_id)
LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllSchoolGroups` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllSchoolGroups`()
BEGIN
SELECT * FROM school_group;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllSchoolsByOptionalSchoolGroupId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllSchoolsByOptionalSchoolGroupId`(IN in_school_group_id VARCHAR(36))
BEGIN
IF in_school_group_id IS NULL THEN
SELECT *
FROM school_site
ORDER By name;
ELSE
SELECT *
FROM school_site
WHERE school_group_id = in_school_group_id
ORDER By name;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetAllSchoolSites` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetAllSchoolSites`(IN in_user_id VARCHAR(36))
BEGIN
SET @user_role_id = (SELECT role_type_id FROM authentication JOIN member ON member.authentication_id = authentication.id WHERE member.id = in_user_id LIMIT 1);
SELECT * 
FROM school_site
WHERE (school_site.admin_id = in_user_id OR @user_role_id <= 20);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetBookById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetBookById`(IN in_book_id INT)
BEGIN
SELECT
book.id AS book_id,
book.name AS book_name,
book.pages AS page_count,
book_category.name AS category_name
FROM book
LEFT JOIN book_category_book ON book.id = book_category_book.book_id
LEFT JOIN book_category ON book_category_book.book_category_id = book_category.id
WHERE book.id = in_book_id AND (book_category.cprimary IS NULL OR book_category.cprimary = 1);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetBookCategoryVideo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetBookCategoryVideo`()
BEGIN
SELECT
book.*,
book_category.name AS category_name,
book_category.cprimary AS category_primary,
book_category.corder AS category_order,
book_category_book.book_order AS book_order,
(SELECT COUNT(*) FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1) AS media_content_count,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 1 LIMIT 1) AS book_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 3 LIMIT 1) AS standalone_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 5 LIMIT 1) AS standalone_image_record_id
FROM book
JOIN book_category_book ON book.id = book_category_book.book_id
JOIN book_category ON book_category_book.book_category_id = book_category.id
WHERE
book.disabled = 0 AND
book_category.cprimary = 1
ORDER BY category_order, CAST(SUBSTRING(category_name , LOCATE(" ", category_name) + 1) AS SIGNED), book.name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetBookCategoryVideoByCategory` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetBookCategoryVideoByCategory`(IN in_category_name VARCHAR(255))
BEGIN
SELECT
book.*,
book_category.name AS category_name,
book_category.cprimary AS category_primary,
book_category.corder AS category_order,
book_category_book.book_order AS book_order,
(SELECT COUNT(*) FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1) AS media_content_count,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 1 LIMIT 1) AS book_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 3 LIMIT 1) AS standalone_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 5 LIMIT 1) AS standalone_image_record_id
FROM book
JOIN book_category_book ON book.id = book_category_book.book_id
JOIN book_category ON book_category_book.book_category_id = book_category.id
WHERE
book.disabled = 0 AND
book_category.name = in_category_name
ORDER BY book_order, category_order, CAST(SUBSTRING(category_name , LOCATE(" ", category_name) + 1) AS SIGNED), book.name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetBookCategoryVideoByUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetBookCategoryVideoByUser`(IN in_member_id VARCHAR(36))
BEGIN
SELECT
book.*,
NULL AS task_id,
book_category.name AS category_name,
book_category.cprimary AS category_primary,
book_category.corder AS category_order,
book_category_book.book_order AS book_order,
(SELECT COUNT(*) FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1) AS media_content_count,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 1 LIMIT 1) AS book_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 3 LIMIT 1) AS standalone_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 5 LIMIT 1) AS standalone_image_record_id,
NULL AS my_content_name,
NULL AS my_content_record_id,
NULL AS my_content_created,
book.name AS bn
FROM book
JOIN book_category_book ON book.id = book_category_book.book_id
JOIN book_category ON book_category_book.book_category_id = book_category.id
WHERE
book.disabled = 0 AND
book_category.cprimary = 1
UNION ALL
SELECT 
book.*,
content_delivery.id AS task_id,
'Tasks' AS category_name,
0 AS category_primary,
NULL AS category_order,
NULL AS book_order,
1 AS media_content_count,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 1 LIMIT 1) AS book_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 3 LIMIT 1) AS standalone_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 5 LIMIT 1) AS standalone_image_record_id,
media_content.name AS my_content_name,
media_content.record_id AS my_content_record_id,
media_content.create_date AS my_content_created,
book.name AS bn
FROM content_delivery 
LEFT JOIN member_class_group ON content_delivery.class_group_id = member_class_group.class_group_id 
JOIN book ON book.id = content_delivery.book_id
LEFT JOIN media_content ON media_content.book_id = book.id
WHERE (member_class_group.member_id = in_member_id OR content_delivery.member_id = in_member_id) AND (content_delivery.start_date IS NULL OR content_delivery.start_date <= NOW())
GROUP BY book.id
UNION ALL
SELECT
book.*,
NULL AS task_id,
'My content' AS category_name,
0 AS category_primary,
NULL AS category_order,
NULL AS book_order,
1 AS media_content_count,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 1 LIMIT 1) AS book_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 3 LIMIT 1) AS standalone_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 5 LIMIT 1) AS standalone_image_record_id,
media_content.name AS my_content_name,
media_content.record_id AS my_content_record_id,
media_content.create_date AS my_content_created,
book.name AS bn
FROM book
RIGHT JOIN media_content ON book.id = media_content.book_id
WHERE
book.disabled = 0 AND
media_content.author_id = in_member_id
ORDER BY category_order, CAST(SUBSTRING(category_name , LOCATE(" ", category_name) + 1) AS SIGNED), my_content_created DESC, bn;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetBookPagesByBookId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetBookPagesByBookId`(IN in_book_id BIGINT(20))
BEGIN
SELECT *
FROM book_page
WHERE book_id = in_book_id
ORDER BY page_number;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetBookReadingLevelById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetBookReadingLevelById`(IN in_book_id BIGINT)
BEGIN
SELECT reading_level
FROM book
WHERE id = in_book_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetBooksByCourseId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetBooksByCourseId`(IN in_course_id VARCHAR(36))
BEGIN
	SELECT book.*, week_number as week_number FROM
    course_book
    RIGHT JOIN book ON book.id = course_book.book_id
    WHERE course_book.course_id = in_course_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetBooksByIds` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetBooksByIds`(IN in_book_ids MEDIUMTEXT)
BEGIN
	SELECT 
	book.*,
	(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 1 LIMIT 1) AS book_video_record_id,
	(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 3 LIMIT 1) AS standalone_video_record_id,
	(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 5 LIMIT 1) AS standalone_image_record_id
	FROM book
	WHERE FIND_IN_SET(book.id, in_book_ids);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetBooksByMemberAndCourseId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetBooksByMemberAndCourseId`(IN in_user_id VARCHAR(36), IN in_course_id VARCHAR(36))
BEGIN
-- get all the courses assigned to the member through its group
SELECT null as is_read,
book.*,course.name as course_name, week_number, content_delivery.start_date, content_delivery.id as task_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 1 LIMIT 1) AS book_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 3 LIMIT 1) AS standalone_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 5 LIMIT 1) AS standalone_image_record_id
FROM book
RIGHT JOIN course_book ON course_book.book_id = book.id
RIGHT JOIN course ON course_book.course_id = course.id
RIGHT JOIN content_delivery ON content_delivery.course_id = course.id
LEFT JOIN member_class_group ON content_delivery.class_group_id = member_class_group.class_group_id
JOIN member ON member.id = member_class_group.member_id
WHERE member.id = in_user_id 
AND course.id = in_course_id
UNION ALL 
-- get all the courses assigned to the student directly to its member_id.
SELECT (CASE WHEN MAX(tracking_page_event.page_number) >= book.pages*2/3 THEN 1 ELSE 0 END) AS is_read,
book.*,course.name as course_name, week_number, content_delivery.start_date, content_delivery.id as task_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 1 LIMIT 1) AS book_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 3 LIMIT 1) AS standalone_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 5 LIMIT 1) AS standalone_image_record_id
FROM content_delivery
LEFT JOIN course ON course.id = content_delivery.course_id
LEFT JOIN course_book ON course_book.course_id = content_delivery.course_id
LEFT JOIN book ON book.id = course_book.book_id 

left join tracking_member_event on tracking_member_event.member_id = content_delivery.member_id
left join tracking_book_event on tracking_book_event.tracking_member_event_id = tracking_member_event.id and tracking_book_event.book_id = course_book.book_id
left join tracking_page_event on tracking_page_event.tracking_book_event_id = tracking_book_event.id

WHERE content_delivery.course_id =in_course_id AND content_delivery.member_id = in_user_id

group by book.id, week_number
ORDER BY is_read ASC;


END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetBookWords` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetBookWords`(`book_id` BIGINT(20))
SELECT `bpp`.`image_page_number`,
         `bpp`.`trimbox_origin_x`,
         `bpp`.`trimbox_origin_y`,
         `bpp`.`trimbox_width`,
         `bpp`.`trimbox_height`,
         `bpp`.`box_origin_x_offset`,
         `bpp`.`box_origin_y_offset`,
         `bpp`.`box_width_scale`,
         `bpp`.`box_height_scale`,
         `bw`.`stripped_content`,
         `bw`.`book_id`,
         `bw`.`pdf_file_number`,
         `bw`.`pdf_page_number`,
         `bw`.`word_id`,
         `bw`.`raw_content`,
         `bw`.`origin_x`,
         `bw`.`origin_y`,
         `bw`.`width`,
         `bw`.`height` FROM `book_pdf_pages` AS `bpp`
    INNER JOIN `book_words` AS `bw`
      ON `bpp`.`book_id`=`bw`.`book_id`
         AND `bpp`.`pdf_file_number`=`bw`.`pdf_file_number`
         AND `bpp`.`page_number_in_file`=`bw`.`pdf_page_number`
    WHERE `bpp`.`book_id`=`book_id` ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetClassById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetClassById`(IN class_id VARCHAR(36))
BEGIN
SELECT * 
FROM class
WHERE class.id = class_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetClassCourseScriptReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetClassCourseScriptReport`(IN in_class_id VARCHAR(36))
BEGIN
	SELECT 
    member.id AS member_id,
    member.username AS username,
    member.name_first AS name_first,
    member.name_last AS name_last,
    member.reading_level AS reading_level,   
    COALESCE(progress_table.level, 1) AS progress_level,
    class_group.name AS group_name, 
    course_script.script AS script,
    course_result.result AS result,
    course_result.* FROM class
	JOIN class_group ON class_group.class_id = class.id
	JOIN member_class_group ON member_class_group.class_group_id = class_group.id
	JOIN member ON member.id = member_class_group.member_id
	JOIN member_course ON member_course.member_id = member.id
    JOIN course_script ON course_script.id = member_course.course_script_id
    LEFT JOIN progress_table ON member.id = progress_table.member_id
	RIGHT JOIN course_result ON course_result.member_course_id = member_course.id
	WHERE class.id = in_class_id AND member_course.active = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetClassGroupByClassId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetClassGroupByClassId`(IN in_class_id VARCHAR(36))
BEGIN
SELECT * 
FROM class_group 
WHERE class_group.class_id = in_class_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetClassReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetClassReport`(IN in_class_id VARCHAR(36), IN in_week_number INT)
BEGIN
SELECT 
class_group.name AS group_name,
member.username AS username,
member.name_first AS name_first, 
member.name_last AS name_last, 
book.name AS book_name, 
(CASE WHEN MAX(tracking_page_event.page_number) >= book.pages*2/3 THEN 1 ELSE 0 END) AS is_read
FROM 
content_delivery 
/* going to the member */
LEFT JOIN member ON member.id = content_delivery.member_id
LEFT JOIN member_class_group ON member.id = member_class_group.member_id
LEFT JOIN class_group ON class_group.id = member_class_group.class_group_id
LEFT JOIN authentication ON authentication.id = member.authentication_id
/* going to the course book */
JOIN course ON course.id = content_delivery.course_id
JOIN course_book ON course_book.course_id = course.id
/* going to the class */
JOIN class ON class_group.class_id = class.id
LEFT JOIN tracking_member_event ON tracking_member_event.member_id = member.id
LEFT JOIN tracking_book_event ON (tracking_book_event.tracking_member_event_id = tracking_member_event.id AND tracking_book_event.book_id = course_book.book_id)
LEFT JOIN tracking_page_event ON tracking_page_event.tracking_book_event_id = tracking_book_event.id 
JOIN book on book.id = course_book.book_id
WHERE class.id = in_class_id AND course_book.week_number = in_week_number
GROUP BY member.id, course_book.book_id;
/*
UNION all 
SELECT 
class_group.name AS group_name,
member.username AS username,
member.name_first AS name_first, 
member.name_last AS name_last, 
null AS book_name, 
null AS is_read
FROM 
content_delivery 
-- going to the member

LEFT JOIN member ON member.id = content_delivery.member_id
LEFT JOIN member_class_group ON member.id = member_class_group.member_id
LEFT JOIN class_group ON class_group.id = member_class_group.class_group_id
LEFT JOIN authentication ON authentication.id = member.authentication_id

WHERE class_id = in_class_id;
*/
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetClassReportByCourseAndWeek` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetClassReportByCourseAndWeek`(IN in_class_id VARCHAR(36), IN in_course_id VARCHAR(36), IN in_week_number INT)
BEGIN
SELECT 
class_group.name AS group_name,
member.username AS username,
member.name_first AS name_first, 
member.name_last AS name_last, 
book.name AS book_name, 
(CASE WHEN MAX(tracking_page_event.page_number) >= book.pages*2/3 THEN 1 ELSE 0 END) AS is_read
FROM 
content_delivery 
/* going to the member */
JOIN class_group ON class_group.id = content_delivery.class_group_id
JOIN member_class_group ON class_group.id = member_class_group.class_group_id
JOIN member ON member.id = member_class_group.member_id
JOIN authentication ON authentication.id = member.authentication_id
/* going to the course book */
JOIN course ON course.id = content_delivery.course_id
JOIN course_book ON course_book.course_id = course.id
/* going to the class */
JOIN class ON class_group.class_id = class.id
LEFT JOIN tracking_member_event ON tracking_member_event.member_id = member.id
LEFT JOIN tracking_book_event ON (tracking_book_event.tracking_member_event_id = tracking_member_event.id AND tracking_book_event.book_id = course_book.book_id)
LEFT JOIN tracking_page_event ON tracking_page_event.tracking_book_event_id = tracking_book_event.id 
JOIN book on book.id = course_book.book_id
WHERE class.id = in_class_id AND course.id = in_course_id AND course_book.week_number = in_week_number
GROUP BY member.id, course_book.book_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetClassReportForWeek` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetClassReportForWeek`(IN in_class_id VARCHAR(36), IN in_week_number INT)
BEGIN
SELECT 
class_group.name AS group_name,
member.username AS username,
authentication.email AS email,
member.name_first AS name_first, 
member.name_last AS name_last, 
book.name AS book_name, 
(CASE WHEN MAX(tracking_page_event.page_number) >= book.pages*2/3 THEN 1 ELSE 0 END) AS is_read
FROM 
content_delivery 
/* going to the member */
LEFT JOIN member ON member.id = content_delivery.member_id
LEFT JOIN member_class_group ON member.id = member_class_group.member_id
LEFT JOIN class_group ON class_group.id = member_class_group.class_group_id
LEFT JOIN authentication ON authentication.id = member.authentication_id
/* going to the course book */
JOIN course ON course.id = content_delivery.course_id
JOIN course_book ON course_book.course_id = course.id
/* going to the class */
JOIN class ON class_group.class_id = class.id
LEFT JOIN tracking_member_event ON tracking_member_event.member_id = member.id
LEFT JOIN tracking_book_event ON (tracking_book_event.tracking_member_event_id = tracking_member_event.id AND tracking_book_event.book_id = course_book.book_id)
LEFT JOIN tracking_page_event ON tracking_page_event.tracking_book_event_id = tracking_book_event.id 
JOIN book on book.id = course_book.book_id
WHERE class.id = in_class_id AND course_book.week_number = in_week_number
GROUP BY member.id, course_book.book_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetCourseById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetCourseById`(IN in_course_id VARCHAR(36))
BEGIN
	SELECT * FROM course WHERE id = in_course_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetCourseByMemberId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetCourseByMemberId`(IN in_member_id VARCHAR(36))
BEGIN
SELECT course.*, content_delivery.start_date AS start_date FROM content_delivery
LEFT JOIN course ON course.id = course_id
WHERE content_delivery.member_id = in_member_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetCourseInfoByUserId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetCourseInfoByUserId`(IN in_user_id VARCHAR(36))
BEGIN
-- getting course from the class group
SELECT 
course.*, 
content_delivery.start_date,
FLOOR(DATEDIFF(CURDATE(),content_delivery.start_date)/7)+1 current_week
FROM 
member 
JOIN member_class_group ON member_class_group.member_id = member.id
JOIN content_delivery ON content_delivery.class_group_id = member_class_group.class_group_id
LEFT JOIN course ON content_delivery.course_id = course.id
WHERE member.id = in_user_id
AND course.course_length >= FLOOR(DATEDIFF(CURDATE(),content_delivery.start_date)/7)+1
AND FLOOR(DATEDIFF(CURDATE(),content_delivery.start_date)/7)+1 >= 1
UNION ALL
SELECT 
course.*,
content_delivery.start_date,
FLOOR(DATEDIFF(CURDATE(),content_delivery.start_date)/7)+1 current_week
FROM content_delivery 
LEFT JOIN course ON course.id = content_delivery.course_id
WHERE member_id = in_user_id AND FLOOR(DATEDIFF(CURDATE(),content_delivery.start_date)/7)+1 <> 0;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetCourseResultScriptsByMemberCourseId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetCourseResultScriptsByMemberCourseId`(IN in_member_id VARCHAR(36), IN in_course_id VARCHAR(36))
BEGIN
	SELECT 
	course_result.result AS result,
    course_result.item_id AS item,
    member_course.start_date AS start_date,
    member_course.completed AS completed
	FROM member_course
	LEFT JOIN course_result ON course_result.member_course_id = member_course.id 
    JOIN course_script ON member_course.course_script_id = course_script.id
	WHERE member_course.course_script_id = in_course_id 
    AND member_course.active = 1
	AND member_id = in_member_id
	AND (course_result.item_type IS NULL OR course_result.item_type = 'TASK');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetCourseScriptById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetCourseScriptById`(IN in_id VARCHAR(36))
BEGIN
SELECT * FROM course_script WHERE id = in_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetCourseScriptByMemberId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetCourseScriptByMemberId`(IN in_member_id VARCHAR(36))
BEGIN
	SELECT 
    course_script.id AS id,
    course_script.name AS name, 
    course_script.access_type AS access_type,
    course_script.course_level AS course_level,
	course_script.course_length AS course_length,
    course_script.script AS script,
    member_course.start_date AS start_date,
    member_course.completed AS completed
    FROM member_course
	LEFT JOIN course_script ON course_script.id = course_script_id
	WHERE member_course.member_id = in_member_id AND member_course.active = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetCourseScriptByMemberIdCourseId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetCourseScriptByMemberIdCourseId`(IN in_member_id VARCHAR(36), IN in_course_id VARCHAR(36))
BEGIN
SELECT 
	course_script.id AS id,
	course_script.name AS name, 	
    course_script.access_type AS access_type,
    course_script.course_level AS course_level,
    course_script.course_length AS course_length,
    course_script.script AS script,
	member_course.start_date AS start_date ,
	member_course.completed AS completed
	FROM member_course
	LEFT JOIN course_script ON course_script.id = course_script_id
	WHERE member_course.member_id = in_member_id AND course_script.id = in_course_id
	ORDER BY member_course.create_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetCourseScriptsByAccessType` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetCourseScriptsByAccessType`(IN in_access_type VARCHAR(100))
BEGIN
SELECT * FROM course_script WHERE access_type = in_access_type
ORDER BY create_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetCourseScriptsByMemberOrCourseId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetCourseScriptsByMemberOrCourseId`(IN in_member_id VARCHAR(36), IN in_school_site_id VARCHAR(36), IN in_course_id VARCHAR(36))
BEGIN
	SET @has_root_access = 0;
    SELECT 
	CASE WHEN role_type_id <= 20 THEN 1 ELSE 0 END AS has_access INTO @has_root_access
    FROM member JOIN authentication ON authentication.id = member.authentication_id
    WHERE member.id = in_member_id;
    
	SELECT 
	course_script.id AS id,
	course_script.name AS name,
	course_script.description AS description,	
    course_script.access_type AS access_type,
    course_script.course_level AS course_level,
	course_script.course_length AS course_length,
    course_script.script AS course_script,
	authentication.email AS owner_email,
    course_script.access_type AS access_type
	FROM course_script
	LEFT JOIN member ON member.id = course_script.owner_id
	LEFT JOIN authentication ON authentication.id = member.authentication_id
    LEFT JOIN course_script_school_site ON course_script.id = course_script_school_site.course_script_id
    WHERE (in_course_id IS NULL OR course_script.id = in_course_id)
    AND (course_script.access_type = 'PUBLIC' 
    OR (course_script.access_type = 'PRIVATE' AND course_script.owner_id = in_member_id) 
    OR (course_script.access_type = 'LIMITED' AND course_script_school_site.school_site_id = in_school_site_id)
    OR (course_script.access_type = 'SPECIFIC' AND in_course_id IS NOT NULL)
    OR (course_script.access_type = 'DEFAULT' AND @has_root_access = 1));
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetDeliveredBooksForGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetDeliveredBooksForGroup`(IN in_group_id VARCHAR(36))
BEGIN
SELECT book.*,
content_delivery.start_date AS start_date,
content_delivery.end_date AS end_date   
FROM content_delivery 
JOIN book ON book.id = content_delivery.book_id
WHERE class_group_id = in_group_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetDeliveredBooksForMember` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetDeliveredBooksForMember`(IN in_member_id VARCHAR(36))
BEGIN
SELECT book.*,
content_delivery.start_date AS start_date,
content_delivery.end_date AS end_date  
FROM content_delivery 
JOIN book ON book.id = content_delivery.book_id
WHERE member_id = in_member_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetDeliveredCourseByGroupId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetDeliveredCourseByGroupId`(IN in_group_id VARCHAR(36))
BEGIN
SELECT course.*,
content_delivery.start_date AS start_date,
content_delivery.end_date AS end_date   
FROM content_delivery 
JOIN course ON course.id = content_delivery.course_id
WHERE class_group_id = in_group_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetFollowersByGroupid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetFollowersByGroupid`(IN in_groupid SMALLINT(5))
BEGIN
SELECT openid FROM wechat_followers WHERE groupid = in_groupid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetGeneralReportByMemberId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetGeneralReportByMemberId`(IN in_member_id VARCHAR(36))
BEGIN
SELECT SUM(is_read) INTO @read_books FROM (
SELECT (CASE WHEN (MAX(tracking_page_event.page_number) >= book.pages*2/3 AND MAX(tracking_book_event.event) NOT LIKE '%video%') THEN 1 ELSE 0 END) AS is_read
FROM member
LEFT JOIN tracking_member_event ON tracking_member_event.member_id = member.id
LEFT JOIN tracking_book_event ON tracking_book_event.tracking_member_event_id = tracking_member_event.id
LEFT JOIN tracking_page_event ON tracking_page_event.tracking_book_event_id = tracking_book_event.id
LEFT JOIN book ON book.id = tracking_book_event.book_id
WHERE member.id = in_member_id
group by book.id) book_stats;


SELECT SUM(video_watched) INTO @watched_videos FROM (
SELECT (CASE WHEN (MAX(tracking_book_event.event) like '%video%' AND MAX(tracking_page_event.page_number) >= book.pages*2/3) THEN 1 ELSE 0 END) AS video_watched
FROM member
LEFT JOIN tracking_member_event ON tracking_member_event.member_id = member.id
LEFT JOIN tracking_book_event ON tracking_book_event.tracking_member_event_id = tracking_member_event.id
LEFT JOIN tracking_page_event ON tracking_page_event.tracking_book_event_id = tracking_book_event.id
LEFT JOIN book ON book.id = tracking_book_event.book_id
WHERE member.id = in_member_id
group by tracking_book_event.video_id) AS video_stats;

SELECT @read_books AS read_books, @watched_videos AS watched_videos;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetGroupsForClass` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetGroupsForClass`(IN in_class_id VARCHAR(36))
BEGIN
SELECT *
FROM class_group
WHERE class_id = in_class_id
ORDER BY name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetMaxReadingLevel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetMaxReadingLevel`()
BEGIN
SELECT MAX(reading_level) AS MAX_LEVEL FROM book;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetMemberById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetMemberById`(IN in_member_id VARCHAR(36))
BEGIN
SELECT
member.id AS member_id,
authentication.id AS authentication_id,
authentication.email AS email,
role_type.name AS role_type,
authentication.role_type_id AS role_type_id,
member.auth_type AS auth_type,
member.primary_user AS primary_user,
member.username AS username,
member.password AS password,
member.name_first AS name_first,
member.name_last AS name_last,
member.is_child AS is_child,
authentication.affiliate_code AS affiliate_code,
member.`online` AS `online`,
((SELECT COUNT(*) FROM member_friend WHERE member_friend.member_id = in_member_id) + (SELECT COUNT(*) FROM member_friend WHERE member_friend.friend_id = in_member_id)) AS friend_count,
subscription.id AS subscription_id,
(CASE WHEN subscription.id IS NOT NULL AND subscription.expire_date >= NOW() THEN 1 ELSE 0 END) AS valid_subscription,
subscription.expire_date AS subscription_expire_date,
authentication.last_login AS last_login,
authentication.create_date AS create_date
FROM authentication
JOIN member ON authentication.id = member.authentication_id
JOIN role_type ON authentication.role_type_id = role_type.id
LEFT JOIN subscription ON authentication.id = subscription.authentication_id
WHERE member.id = in_member_id;
/* currently we require ALL member to have an entry in the progress table (this needs to be fixed long term)... check here and add if needed */
IF NOT EXISTS(SELECT * FROM progress_table WHERE member_id = in_member_id) THEN
	INSERT INTO progress_table (id, member_id, level) VALUES (fnCreateUUID(), in_member_id, 1); 
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetMemberFriends` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetMemberFriends`(IN in_member_id VARCHAR(36))
BEGIN
SELECT
member_friend.friend_id AS friend_id,
member.name_first AS friend_name_first,
member.name_last AS friend_name_last,
authentication.email AS friend_email,
`online` AS friend_online
FROM member_friend
JOIN member ON member_friend.friend_id = member.id
JOIN authentication ON member.authentication_id = authentication.id
WHERE member_friend.member_id = in_member_id AND approved = 1
UNION ALL
SELECT
member_friend.member_id AS friend_id,
member.name_first AS friend_name_first,
member.name_last AS friend_name_last,
authentication.email AS friend_email,
`online` AS friend_online
FROM member_friend
JOIN member ON member_friend.member_id = member.id
JOIN authentication ON member.authentication_id = authentication.id
WHERE member_friend.friend_id = in_member_id AND approved = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetMembersByAuthenticationId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetMembersByAuthenticationId`(IN in_auth_id VARCHAR(36))
BEGIN
SELECT
member.*,
authentication.email,
progress_table.level AS level,
progress_table.level_change_request AS level_change_request,
member_preference.report_frequency_days AS report_frequency_days
FROM authentication
JOIN member ON authentication.id = member.authentication_id
JOIN progress_table ON progress_table.member_id = member.id
LEFT JOIN member_preference ON member_preference.member_id = member.id
WHERE authentication.id = in_auth_id
ORDER BY member.is_child, member.create_date ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetMembersByEmail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetMembersByEmail`(IN in_email VARCHAR(255))
BEGIN
SELECT
member.*,
authentication.email
FROM authentication
JOIN member ON authentication.id = member.authentication_id
WHERE email = in_email
ORDER BY member.create_date ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetMembersByIds` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetMembersByIds`(IN in_member_ids VARCHAR(65535))
BEGIN
    
SELECT
member.id AS member_id,
authentication.id AS authentication_id,
authentication.email AS email,
role_type.name AS role_type,
authentication.role_type_id AS role_type_id,
member.auth_type AS auth_type,
member.primary_user AS primary_user,
member.username AS username,
member.password AS password,
member.name_first AS name_first,
member.name_last AS name_last,
member.is_child AS is_child,
authentication.affiliate_code AS affiliate_code,
member.`online` AS `online`,
((SELECT COUNT(*) FROM member_friend WHERE member_friend.member_id = member_id) + (SELECT COUNT(*) FROM member_friend WHERE member_friend.friend_id = member_id)) AS friend_count,
subscription.id AS subscription_id,
(CASE WHEN subscription.id IS NOT NULL AND subscription.expire_date >= NOW() THEN 1 ELSE 0 END) AS valid_subscription,
subscription.expire_date AS subscription_expire_date,
authentication.last_login AS last_login,
authentication.create_date AS create_date
FROM authentication
JOIN member ON authentication.id = member.authentication_id
JOIN role_type ON authentication.role_type_id = role_type.id
LEFT JOIN subscription ON authentication.id = subscription.authentication_id
WHERE FIND_IN_SET(member.id, in_member_ids);
/* currently we require ALL member to have an entry in the progress table (this needs to be fixed long term)... check here and add if needed */

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetNewCourseInfoByUserId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetNewCourseInfoByUserId`(IN in_member_id VARCHAR(36))
BEGIN
	SELECT 
    course_script.id AS id,
	name AS name,
	owner_id AS owner_id,
	course_length AS course_length,
	start_date AS start_date
    -- FLOOR(DATEDIFF(CURDATE(), member_course.start_date) / 7) + 1 AS current_week, ***** this will not work as the week needs to be calc at the client
	FROM course_script
	JOIN member_course on member_course.course_script_id = course_script.id
	WHERE member_id = in_member_id AND member_course.active = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetNextMessageQueue` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetNextMessageQueue`(IN in_allow_retry INT)
BEGIN
/* get the next message in the queue */
IF in_allow_retry <> 0 THEN
	SELECT *
    FROM messaging_queue
    WHERE sent_date IS NULL AND retries < 10
    ORDER BY create_date
    LIMIT 1;
ELSE
	SELECT *
    FROM messaging_queue
    WHERE sent_date IS NULL AND retries = 0
    ORDER BY create_date
    LIMIT 1;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetOpenTokIncomingCall` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetOpenTokIncomingCall`(IN in_session_id VARCHAR(255), IN in_member1_id VARCHAR(36))
BEGIN
SELECT *
FROM opentok_session
WHERE
session_id = in_session_id AND
member2_id = in_member1_id
ORDER BY date_created DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetOpenTokSessionById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetOpenTokSessionById`(IN in_session_id VARCHAR(1024))
BEGIN
SELECT *
FROM opentok_session
WHERE session_id = in_session_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetPasswordSaltForMemberByEmail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetPasswordSaltForMemberByEmail`(IN in_email VARCHAR(255))
BEGIN
SELECT password_salt
FROM authentication
WHERE email = in_email;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetPasswordSaltForMemberByMemberId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetPasswordSaltForMemberByMemberId`(IN in_member_id VARCHAR(36))
BEGIN
SELECT authentication.password_salt
FROM authentication
JOIN member ON authentication.id = member.authentication_id
WHERE member.id = in_member_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetPrimaryMemberByEmail` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetPrimaryMemberByEmail`(IN in_email VARCHAR(255))
BEGIN
SELECT
member.*,
authentication.email
FROM authentication
JOIN member ON authentication.id = member.authentication_id
WHERE email = in_email AND member.primary_user = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetPrimaryMemberById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetPrimaryMemberById`(IN in_user_id VARCHAR(36))
BEGIN
SELECT
member.*,
authentication.email
FROM authentication
JOIN member ON authentication.id = member.authentication_id
WHERE member.id = in_user_id AND member.primary_user = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetPrimaryUsersByRoleType` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetPrimaryUsersByRoleType`(IN in_user_id VARCHAR(36), IN in_role_type VARCHAR(45))
BEGIN
SELECT 
member.id AS member_id,
member.authentication_id,
member.name_first,
member.name_last,
authentication.email
FROM member 
JOIN authentication ON member.authentication_id = authentication.id 
WHERE role_type_id <= (SELECT role_type.id FROM role_type WHERE role_type.name =in_role_type LIMIT 1)
AND primary_user = TRUE;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetPublicContentByBook` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetPublicContentByBook`(IN in_book_id BIGINT(20))
BEGIN
SELECT
media_content.*,
content_type.name AS content_type
FROM media_content
JOIN content_type ON media_content.content_type_id = content_type.id
WHERE book_id = in_book_id AND public_access = 1
ORDER BY create_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetRandomBooksByReadLevelRange` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetRandomBooksByReadLevelRange`(IN in_min_level INT, IN in_max_level INT, IN in_limit INT)
BEGIN
/* if min / max null, then get any books */
SELECT *
FROM book
WHERE
(reading_level >= in_min_level OR in_min_level IS NULL) AND
(reading_level <= in_max_level OR in_max_level IS NULL) AND
disabled = 0
ORDER BY rand()
LIMIT in_limit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetRecentAssessmentsByDays` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetRecentAssessmentsByDays`(IN in_days INT)
BEGIN
SELECT

authentication.id AS authentication_id,
authentication.email AS email,
member.username AS username,
member.id AS member_id,
member.name_first,
member.name_last,
book.name,
book.id,
media_content.record_id,
media_content.create_date,
CASE media_content.process_action
  WHEN 4 THEN 'yes'
  ELSE 'no'
  END as 'assessment'
FROM authentication
JOIN member ON authentication.id = member.authentication_id
JOIN media_content ON member.id = author_id
JOIN book ON media_content.book_id = book.id
WHERE
media_content.create_date >= SUBDATE(CURDATE(), in_days) AND
media_content.process_action = 4
ORDER BY create_date DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetRecommendationsForUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetRecommendationsForUser`(
    `member_id` VARCHAR(36),
    `limit` INT(11) UNSIGNED
  )
BEGIN
    --  Set all the parameters.
    CALL `_spSetReccEngnParameters`();

    --  Make all the tables we need.
    CALL `_spCreateReccEngnTables`();

    --  Get seed.
    CALL `_spGetSeed`(`member_id`);

    --  Generate candidates.
    CALL `_spGetCommonViewsCandidates`(`member_id`);
    CALL `_spGetSimilarVocabCandidates`();

    --  Assign scores to candidates
    CALL `_spGetEmptyScoresFromCandidates`();
    CALL `_spAddCommonViewsScores`(`member_id`);
    CALL `_spAddSimilarVocabScores`();
    TRUNCATE TABLE `_seed`;  -- Cleanup.
    CALL `_spAddQualityScores`(`member_id`);
    CALL `_spAddExtrasScores`();
    CALL `_spAddLevelScores`(`member_id`, NULL);

    CALL `_spAddDiversityScores`();  -- Needs to follow all other scores.
    TRUNCATE TABLE `_candidates`;  -- Cleanup.

    --  Select
    SELECT * FROM `_scores` ORDER BY `score` DESC LIMIT `limit`;
    TRUNCATE TABLE `_scores`;  -- Cleanup.
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetRecommendationsFromBook` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetRecommendationsFromBook`(
    `book_id` BIGINT(20),
    `member_id` VARCHAR(36),
    `limit` INT(11) UNSIGNED
  )
BEGIN
    --  Set all the parameters.
    CALL `_spSetReccEngnParameters`();

    --  Make all the tables we need.
    CALL `_spCreateReccEngnTables`();

    --  Get seed (i.e., the one book).
    INSERT INTO `_seed` VALUE (`book_id`);

    --  Generate candidates.
    CALL `_spGetCommonViewsCandidates`(`member_id`);
    CALL `_spGetSimilarVocabCandidates`();

    --  Assign scores to candidates
    CALL `_spGetEmptyScoresFromCandidates`();
    TRUNCATE TABLE `_candidates`;  -- Cleanup.
    CALL `_spAddCommonViewsScores`(`member_id`);
    CALL `_spAddSimilarVocabScores`;
    TRUNCATE TABLE `_seed`;  -- Cleanup.
    CALL `_spAddQualityScores`(`member_id`);
    CALL `_spAddExtrasScores`();
    CALL `_spAddLevelScores`(`member_id`, `book_id`);

    --  Select
    SELECT * FROM `_scores` ORDER BY `score` DESC LIMIT `limit`;
    TRUNCATE TABLE `_scores`;  -- Cleanup.
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetRedemptionByCode` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetRedemptionByCode`(IN in_code VARCHAR(100))
BEGIN
SELECT *
FROM redemption
WHERE code = in_code;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetReportOfActiveUsers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetReportOfActiveUsers`(IN in_startdate datetime,IN in_enddate datetime)
BEGIN
SELECT 
user_report.user_id,
firstname,
surname,
email,
date_created AS registered_on,
books_opened,
books_read,
videos_opened,
last_time_book_opened,
subscription_name
FROM(
	SELECT 
		user_id,
		SUM(CASE WHEN event = 'BOOK_OPEN' THEN 1 ELSE 0 end) books_opened,
		SUM(CASE WHEN event = 'BOOK_OPEN_WITH_VIDEO' THEN 1 ELSE 0 end) videos_opened,
		SUM(CASE WHEN event = 'BOOK_OPEN' AND pages_read>=(2/3*pages_in_book) THEN 1 ELSE 0 end) books_read,
		MAX(event_time) AS last_time_book_opened
	FROM(
		SELECT metrics_book_event.*,
		COUNT(metrics_page_event.id) AS pages_read
		FROM metrics_book_event
		RIGHT JOIN metrics_page_event ON metrics_book_event.read_session_id = metrics_page_event.read_session_id
		WHERE metrics_book_event.read_session_id IS NOT NULL
        AND metrics_book_event.event_time BETWEEN in_startdate AND in_enddate
		GROUP BY metrics_book_event.read_session_id
		) as result
	LEFT JOIN (
		SELECT 
		pages.book_id,
		COUNT(pages.book_id) AS pages_in_book
		FROM pages
		GROUP BY(pages.book_id)
		) AS book_pages
	ON book_pages.book_id = result.book_id
	GROUP BY user_id) AS user_report
INNER JOIN users ON users.users_id = user_report.user_id
LEFT JOIN users_subscription ON users_subscription.user_id = user_report.user_id
ORDER BY last_time_book_opened ASC; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetReportOfRegisteredUsers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetReportOfRegisteredUsers`(IN in_startdate datetime,IN in_enddate datetime)
BEGIN
SELECT 
users_id,
firstname,
surname,
email,
date_created,
last_active_time

FROM 
users
LEFT JOIN (
		SELECT 
		user_id, 
		MAX(event_time) as last_active_time
		FROM 
		metrics_book_event
		GROUP BY user_id) as user_action on user_id = users.users_id
WHERE date_created BETWEEN in_startdate AND in_enddate
ORDER BY date_created;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetReportOfUsersVideos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetReportOfUsersVideos`(IN in_startdate datetime,IN in_enddate datetime)
BEGIN
SELECT 
user_id,
firstname,
surname,
email,
record_id,
book_id,
record_name,
date_time
FROM 
user_videos
LEFT JOIN users on users.users_id = user_videos.user_id
WHERE date_time BETWEEN in_startdate AND in_enddate
ORDER BY user_id,date_time;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetResetToken` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetResetToken`(IN in_token VARCHAR(255))
BEGIN
SELECT
member.id AS member_id
FROM member_reset_password
JOIN member ON member_reset_password.member_id = member.Id
JOIN authentication ON member.authentication_id = authentication.id
JOIN role_type ON authentication.role_type_id = role_type.id
WHERE token = in_token;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetSchoolsHaveAccessToCourse` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetSchoolsHaveAccessToCourse`(IN in_course_id VARCHAR(36))
BEGIN
	SELECT * FROM course_script_school_site 
    JOIN school_site ON school_site.id = school_site_id
    WHERE course_script_id = in_course_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetSchoolSiteById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetSchoolSiteById`(IN in_school_site_id VARCHAR(36))
BEGIN
SELECT * FROM school_site WHERE id = in_school_site_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetSchoolSiteCodeByClassGroupId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetSchoolSiteCodeByClassGroupId`(IN in_class_group_id VARCHAR(36))
BEGIN
SELECT school_site.id AS school_site_id, school_site.code, school_site.user_seed
FROM school_site
JOIN class ON school_site.id = class.school_site_id
JOIN class_group ON class.id = class_group.class_id
WHERE class_group.id = in_class_group_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetSchoolSitesForUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetSchoolSitesForUser`(IN in_user_id VARCHAR(36))
BEGIN
SET @role_id = (SELECT role_type_id 
	FROM member 
	JOIN authentication ON authentication.id = member.authentication_id 
	WHERE member.id = in_user_id);

-- the user might be either admin or a teacher 
IF (@role_id <= 20) THEN
	SELECT * FROM school_site;
ELSE
	SELECT 
    school_site.*,
    CASE WHEN school_site.admin_id = in_user_id THEN 1 ELSE 0 END AS admin_access
	FROM school_site
	LEFT JOIN member_school_site ON school_site.id = member_school_site.school_site_id
	WHERE member_school_site.member_id = in_user_id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetSiteMainMembers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetSiteMainMembers`(IN in_user_id VARCHAR(36), IN in_site_id VARCHAR(36), IN in_max_role_id VARCHAR(45))
BEGIN
SELECT 
member.*,
authentication.email AS email
FROM member_school_site 
JOIN member ON member.id = member_school_site.member_id
JOIN authentication ON authentication.id = member.authentication_id
WHERE 
(school_site_id = in_site_id AND role_type_id > COALESCE(in_max_role_id, 0) AND role_type_id <50) OR member.id = in_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetSiteMemberWithRoleHigherThan` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetSiteMemberWithRoleHigherThan`(IN in_site_id VARCHAR(36), IN in_max_role_id VARCHAR(45))
BEGIN
SELECT 
member.*,
authentication.email AS email
FROM member_school_site 
JOIN member ON member.id = member_school_site.member_id
JOIN authentication ON authentication.id = member.authentication_id
WHERE 
school_site_id = in_site_id AND role_type_id <= COALESCE(in_max_role_id, 0);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetStudentsInGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetStudentsInGroup`(IN in_class_group_id VARCHAR(36))
BEGIN

SELECT 
member.*,
authentication.email AS email,
member.username AS username,
COALESCE(progress_table.level, 1) AS progress_level,
class_group.name AS group_name,
(CASE WHEN member.password IS NOT NULL THEN member.password ELSE NULL END) AS password
FROM member_class_group
JOIN member ON member.id = member_class_group.member_id
JOIN authentication ON authentication.id = member.authentication_id
LEFT JOIN progress_table ON member.id = progress_table.member_id
LEFT JOIN class_group ON member_class_group.class_group_id = class_group.id
WHERE class_group_id = in_class_group_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetSubscribeFromWechatMetadata` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetSubscribeFromWechatMetadata`(IN in_union_id VARCHAR(50))
BEGIN
SELECT
CAST(subscriber AS UNSIGNED) AS subscriber
FROM wechat_metadata
WHERE unionid = in_union_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetSubscriptionPlanByUserId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetSubscriptionPlanByUserId`(IN in_authentication_id VARCHAR(36))
BEGIN
SELECT * 
FROM subscription
WHERE authentication_id = in_authentication_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetSystemDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetSystemDetails`()
BEGIN
SELECT *
FROM system
WHERE id = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetTrackingUserBySessionId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetTrackingUserBySessionId`(IN in_member_id VARCHAR(36), IN in_session_id VARCHAR(45))
BEGIN
SELECT *
FROM tracking_member_event
WHERE member_id = in_member_id AND session_id = in_session_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetUserAndSharedContentByUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetUserAndSharedContentByUser`(IN in_member_id VARCHAR(36))
BEGIN
SELECT * FROM media_content
WHERE author_id = in_member_id
ORDER BY create_date DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetUserLevel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetUserLevel`(IN in_user_id VARCHAR(36))
BEGIN

IF NOT EXISTS(SELECT * FROM progress_table WHERE member_id = in_user_id) THEN
	INSERT INTO progress_table (id, member_id, level) VALUES (fnCreateUUID(), in_user_id, 1); 
END IF;

SELECT level FROM progress_table WHERE member_id = in_user_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetUserRatingForBook` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetUserRatingForBook`(IN in_book_id BIGINT, IN in_member_id VARCHAR(36))
BEGIN
SELECT *
FROM book_rating
WHERE book_id = in_book_id AND member_id = in_member_id LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetUserReportByTask` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetUserReportByTask`(IN in_task_id VARCHAR(36))
BEGIN
SELECT 
book_name,
MAX(lastpageread) AS last_page_read,
book_pages,
MAX(is_read) AS is_read,
book_id,
email,
name_first,
name_last,
event_time
FROM
	(SELECT 
	book.name AS book_name,
	MAX(tracking_page_event.page_number) AS lastpageread,
	book.pages AS book_pages,
	(CASE WHEN MAX(tracking_page_event.page_number) >= book.pages*2/3 THEN 1 ELSE 0 END) AS is_read,
	book_id AS book_id,
	email AS email,
	name_first AS name_first,
	name_last AS name_last,
	tracking_member_event.event_time AS event_time
	FROM member 
	JOIN tracking_member_event ON member.id = tracking_member_event.member_id
	JOIN tracking_book_event ON tracking_book_event.tracking_member_event_id = tracking_member_event.id
	JOIN tracking_page_event ON tracking_page_event.tracking_book_event_id = tracking_book_event.id
	JOIN book ON book.id = book_id
	JOIN authentication ON authentication.id = member.authentication_id
	WHERE tracking_book_event.task_id=in_task_id
	GROUP BY tracking_book_event.id) AS report
GROUP BY book_id
ORDER BY event_time DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetUsersByDateCreated` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetUsersByDateCreated`(IN in_start_date datetime, IN in_end_date datetime)
BEGIN
SELECT
member.*,
authentication.email
FROM authentication
JOIN member ON authentication.id = member.authentication_id
WHERE
member.create_date BETWEEN in_start_date AND in_end_date
ORDER BY member.create_date ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetUsersReportByDate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetUsersReportByDate`(IN in_startdate datetime,IN in_enddate datetime)
BEGIN
SELECT 
user_report.user_id,
firstname,
surname,
email,
date_created AS registered_on,
books_opened,
books_read,
videos_opened,
last_time_book_opened,
subscription_name AS plan
FROM(
	SELECT 
		user_id,
		SUM(CASE WHEN event = 'BOOK_OPEN' THEN 1 ELSE 0 end) books_opened,
		SUM(CASE WHEN event = 'BOOK_OPEN_WITH_VIDEO' THEN 1 ELSE 0 end) videos_opened,
		SUM(CASE WHEN event = 'BOOK_OPEN' AND pages_read>=(2/3*pages_in_book) THEN 1 ELSE 0 end) books_read,
		MAX(event_time) AS last_time_book_opened
	FROM(
		SELECT metrics_book_event.*,
		COUNT(metrics_page_event.id) AS pages_read
		FROM metrics_book_event
		RIGHT JOIN metrics_page_event ON metrics_book_event.read_session_id = metrics_page_event.read_session_id
		WHERE metrics_book_event.read_session_id IS NOT NULL
        AND metrics_book_event.event_time BETWEEN in_startdate AND in_enddate
		GROUP BY metrics_book_event.read_session_id
		) as result
	LEFT JOIN (
		SELECT 
		pages.book_id,
		COUNT(pages.book_id) AS pages_in_book
		FROM pages
		GROUP BY(pages.book_id)
		) AS book_pages
	ON book_pages.book_id = result.book_id
	GROUP BY user_id) AS user_report
INNER JOIN users ON users.users_id = user_report.user_id
LEFT JOIN users_subscription ON users_subscription.user_id = user_report.user_id
ORDER BY last_time_book_opened ASC; 
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetUsersVideos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetUsersVideos`(IN in_start_date datetime, IN in_end_date datetime)
BEGIN
SELECT *
FROM media_content
WHERE create_date BETWEEN in_start_date AND in_end_date
ORDER BY create_date;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetVideoByAuthorId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetVideoByAuthorId`(IN in_author_id VARCHAR(36), IN in_public_only BIT(1))
BEGIN
SELECT
book.id AS id,
book.name AS name,
media_content.id AS book_video_id,
media_content.record_id AS book_video_record_id,
media_content.name AS book_video_name,
media_content.author_id AS author_id,
media_content.approver_id AS approver_id,
CAST(media_content.public_access AS UNSIGNED) AS public_access,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 5 LIMIT 1) AS standalone_image_record_id,
1 AS media_content_count,
media_content.create_date AS create_date,
book_category.name AS category_name,
book_category.cprimary AS category_primary,
book_category.corder AS category_order,
book_category_book.book_order AS book_order,
TRUE AS is_filtered_content
FROM 
media_content LEFT JOIN book ON book.id = media_content.book_id
JOIN book_category_book ON book.id = book_category_book.book_id
JOIN book_category ON book_category_book.book_category_id = book_category.id
WHERE
book.disabled = 0 AND
book_category.cprimary = 1 AND
media_content.author_id = in_author_id AND
((media_content.public_access = 1) OR (in_public_only = 0))
ORDER BY category_order, CAST(SUBSTRING(category_name , LOCATE(" ", category_name) + 1) AS SIGNED), book.name;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetVideoForAllAuthors` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetVideoForAllAuthors`()
BEGIN
SELECT book.*,
book.name AS bn,
book_category.name AS category_name,
book_category.cprimary AS category_primary,
book_category.corder AS category_order,
book_category_book.book_order AS book_order,
media_content.author_id AS author_id,
media_content.record_id AS book_video_record_id,
(SELECT record_id FROM media_content WHERE media_content.book_id = book.id AND media_content.public_access = 1 AND media_content.content_type_id = 5 LIMIT 1) AS standalone_image_record_id,
1 AS media_content_count,
TRUE AS is_filtered_content
FROM 
media_content LEFT JOIN book ON book.id = media_content.book_id
JOIN book_category_book ON book.id = book_category_book.book_id
JOIN book_category ON book_category_book.book_category_id = book_category.id
WHERE
media_content.content_type_id = (SELECT content_type.id FROM content_type WHERE content_type.name = 'book_video') AND
book.disabled = 0 AND
book_category.cprimary = 1 AND
public_access = 1
ORDER BY category_order, CAST(SUBSTRING(category_name , LOCATE(" ", category_name) + 1) AS SIGNED), bn;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGetWechatAllTrade` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGetWechatAllTrade`()
BEGIN

SELECT out_trade_no
FROM wechat_traderecorde;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spGiveCourseAccessToSchoolsList` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spGiveCourseAccessToSchoolsList`(IN in_school_list VARCHAR(2048), IN in_course_id VARCHAR(36))
BEGIN
	DELETE FROM course_script_school_site WHERE course_script_id = in_course_id;
	INSERT INTO course_script_school_site (id, school_site_id, course_script_id)
	SELECT fnCreateUUID(), id, in_course_id FROM school_site WHERE FIND_IN_SET(id, in_school_list);
      
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spIsBookReadByMember` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spIsBookReadByMember`(IN in_book_id VARCHAR(36), IN in_member_id VARCHAR(36))
BEGIN
    SELECT 
	(CASE WHEN MAX(page_number)>=(2/3*book.pages) THEN true ELSE false end) AS is_read
	FROM book
    LEFT join tracking_book_event ON tracking_book_event.book_id = book.id
	LEFT JOIN tracking_page_event ON tracking_page_event.tracking_book_event_id = tracking_book_event.id
	LEFT JOIN tracking_member_event ON tracking_member_event.id = tracking_book_event.tracking_member_event_id
	WHERE book.id = in_book_id AND tracking_member_event.member_id = in_member_id
	GROUP BY book.id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spMakeLSHTables` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spMakeLSHTables`()
BEGIN
    CREATE TABLE IF NOT EXISTS `lsh_word_axes` (
        `id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
        `word` VARCHAR(25) NOT NULL,
        PRIMARY KEY (`id`) USING HASH
      ) ENGINE=MEMORY;

    CREATE TABLE IF NOT EXISTS `lsh_hash_tables` (
        `id` SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
        PRIMARY KEY (`id`) USING HASH
      ) ENGINE=MEMORY;

    CREATE TABLE IF NOT EXISTS `lsh_hash_funs` (
        `table` SMALLINT UNSIGNED NOT NULL,
        `id_in_table` SMALLINT UNSIGNED NOT NULL,
        `axis_id` SMALLINT UNSIGNED NOT NULL,
        `partition` FLOAT NOT NULL,
        PRIMARY KEY (`table`, `id_in_table`, `axis_id`) USING HASH,
        INDEX (`table`) USING HASH
      ) ENGINE=MEMORY;

    CREATE TABLE IF NOT EXISTS `lsh_hashes` (
        `table_id` SMALLINT UNSIGNED NOT NULL,
        `hash` BINARY(16) NOT NULL,
        `book_id` BIGINT(20) NOT NULL,
        PRIMARY KEY (`table_id`, `hash`, `book_id`) USING HASH,
        INDEX (`table_id`, `hash`) USING HASH,
        INDEX (`book_id`) USING HASH
      ) ENGINE=MEMORY;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spMergePrimaryMemberToExisting` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spMergePrimaryMemberToExisting`(IN merge_member_id VARCHAR(36), existing_member_id VARCHAR(36), IN in_role_type VARCHAR(255))
BEGIN
/* fyi - the merge user is the auth record we are going to retain... with the exitsing auth user to be deleted */
SET @merge_auth_id = 0;
SET @existing_auth_id = 0;
SET @roleTypeId = -1;

/* grab role type id */
SELECT id INTO @roleTypeId FROM role_type WHERE role_type.name = in_role_type;

/* we need to grab the merge / existing auth id */
SELECT authentication_id INTO @merge_auth_id FROM member WHERE member.id = merge_member_id;
SELECT authentication_id INTO @existing_auth_id FROM member WHERE member.id = existing_member_id;

/* make sure all existing members are not flagged as primary */
UPDATE member SET primary_user = 0 WHERE authentication_id = @existing_auth_id;

/* merge existing member */
UPDATE member SET authentication_id = @merge_auth_id WHERE authentication_id = @existing_auth_id;

/* update the authentication record for merged user */
UPDATE authentication SET role_type_id = @roleTypeId WHERE id = @merge_auth_id;

/* remove old auth record */
DELETE FROM authentication WHERE id = @existing_auth_id;

/* return merged user */
CALL spGetMemberById(merge_member_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spPickNumOfBooksByLevelRandomly` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spPickNumOfBooksByLevelRandomly`(IN in_book_number INT, IN in_level_number INT, IN in_mode VARCHAR(20))
BEGIN
-- if in_mode = 'selected' it will get the books from selected_books table otherwise it will get them from entire book database. 
IF(in_mode = 'selected') THEN
	SELECT book.* 
	FROM selected_books
    LEFT JOIN book ON book.id = selected_books.book_id
    WHERE reading_level IS NOT NULL 
	AND reading_level = in_level_number ORDER BY RAND() LIMIT in_book_number;
ELSE    
	SELECT * 
	FROM book WHERE 
	reading_level IS NOT NULL 
	AND reading_level = in_level_number ORDER BY RAND() LIMIT in_book_number;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spQueryLSHTables` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spQueryLSHTables`(
    `book_id_` BIGINT(20),
    `max_results` INT UNSIGNED
  )
BEGIN
    IF `max_results` IS NULL THEN
      SELECT `lh2`.`book_id`, COUNT(*) AS `similarity`
        FROM `lsh_hashes` AS `lh1`
        INNER JOIN `lsh_hashes` AS `lh2` USING (`table_id`, `hash`)
        WHERE `lh1`.`book_id`=`book_id_` AND `lh2`.`book_id`<>`book_id_`
        GROUP BY `lh2`.`book_id`
        ORDER BY `similarity` DESC;
    ELSE
      SELECT `lh2`.`book_id`, COUNT(*) AS `similarity`
        FROM `lsh_hashes` AS `lh1`
        INNER JOIN `lsh_hashes` AS `lh2` USING (`table_id`, `hash`)
        WHERE `lh1`.`book_id`=`book_id_` AND `lh2`.`book_id`<>`book_id_`
        GROUP BY `lh2`.`book_id`
        ORDER BY `similarity` DESC
        LIMIT `max_results`;
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spRegisteredUsersReport` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spRegisteredUsersReport`(IN in_startdate datetime,IN in_enddate datetime)
BEGIN
SELECT 
users_id,
firstname,
surname,
email,
date_created,
last_active_time

FROM 
users
LEFT JOIN (
		SELECT 
		user_id, 
		MAX(event_time) as last_active_time
		FROM 
		metrics_book_event
		GROUP BY user_id) as user_action on user_id = users.users_id
WHERE date_created BETWEEN in_startdate AND in_enddate
ORDER BY date_created;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spRemoveBookFromCourse` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spRemoveBookFromCourse`(IN in_book_id VARCHAR(36), IN in_course_id VARCHAR(36))
BEGIN
DELETE FROM course_book 
WHERE book_id = in_book_id AND course_id = in_course_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spRemoveBookFromSelectedCollection` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spRemoveBookFromSelectedCollection`(IN in_book_id BIGINT(20))
BEGIN
DELETE FROM selected_books 
WHERE book_id = in_book_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spReportActiveUsers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spReportActiveUsers`(IN in_startdate datetime, IN in_enddate datetime)
BEGIN
SELECT 
firstname,
surname,
email,
registered_on,
SUM(CASE WHEN members_activity.book_event = 'BOOK_OPEN' THEN 1 ELSE 0 end) books_opened,
SUM(CASE WHEN members_activity.book_event = 'BOOK_OPEN' AND pages_read>=(2/3*number_of_pages) THEN 1 ELSE 0 end) books_read,
SUM(CASE WHEN members_activity.book_event = 'BOOK_OPEN_WITH_VIDEO' THEN 1 ELSE 0 end) videos_opened,
MAX(members_activity.member_event_time) AS last_time_loggedin
FROM (
	SELECT 
	tracking_page_event.*,
	member.name_first AS firstname,
	member.name_last AS surname,
    member.id AS member_id,
    member.create_date AS registered_on,
	authentication.email AS email,
	tracking_member_event.event AS member_event,
	tracking_member_event.event_time AS member_event_time,
	tracking_book_event.book_id,
	tracking_book_event.event_time AS book_event_time,
	tracking_book_event.event AS book_event,
	tracking_book_event.read_session_id,
	book.pages AS number_of_pages,
	MAX(tracking_page_event.last_page_number) AS pages_read
	FROM 
	tracking_member_event
	JOIN tracking_book_event ON tracking_member_event.id = tracking_book_event.tracking_member_event_id
	JOIN member ON tracking_member_event.member_id = member.id
	JOIN authentication ON member.authentication_id = authentication.id
	JOIN tracking_page_event ON tracking_book_event.id = tracking_page_event.tracking_book_event_id
	JOIN book ON book.id = tracking_book_event.book_id
	GROUP BY tracking_book_event.id
	ORDER BY tracking_member_event.event_time DESC, member.id) AS members_activity
    WHERE member_event_time BETWEEN in_startdate AND in_enddate
GROUP BY members_activity.member_id
ORDER BY members_activity.member_event_time DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spReportCreatedVideos` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spReportCreatedVideos`(IN in_startdate datetime, IN in_enddate datetime)
BEGIN
SELECT 
member.name_first AS firstname,
member.name_last AS surname,
authentication.email AS email,
media_content.record_id AS record_id,
media_content.book_id AS book_id,
media_content.name AS record_name,
media_content.create_date AS date_time
FROM 
media_content 
JOIN member ON media_content.author_id = member.id
JOIN authentication ON member.authentication_id = authentication.id
WHERE content_type_id = 1
AND media_content.create_date BETWEEN in_startdate AND in_enddate
ORDER BY media_content.create_date DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spReportRegisteredMembers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spReportRegisteredMembers`(IN in_startdate datetime,IN in_enddate datetime)
BEGIN
SELECT 
member.name_first AS firstname,
member.name_last AS surname,
authentication.email AS email,
member.create_date AS date_created, 
MAX(event_time) AS last_active_time 
FROM tracking_member_event
JOIN member on member.id = tracking_member_event.member_id
JOIN authentication on member.authentication_id = authentication.id
WHERE event ='USER_LOGIN' 
AND member.create_date BETWEEN in_startdate AND in_enddate
GROUP BY member_id
ORDER BY member.create_date DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spRequestToChangeLevel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spRequestToChangeLevel`(IN in_member_id VARCHAR(36), IN in_level_change_request VARCHAR(45))
BEGIN
	IF(in_level_change_request = 'HARDER' OR in_level_change_request = 'EASIER' OR in_level_change_request = 'NONE') THEN
		UPDATE progress_table
		SET level_change_request = in_level_change_request
		WHERE member_id = in_member_id;
        SELECT false AS error, 'REQUSET HAS BEEN SENT' AS message;
    ELSE 
		SELECT true AS error, 'WRONG INPUT' AS message;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spResetCopyRestrictionAccessToken` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spResetCopyRestrictionAccessToken`(IN in_session_key VARCHAR(36), in_access_token VARCHAR(32))
BEGIN
/* get access token id */
SET @id = 0;
SELECT id INTO @id FROM copy_restriction_access WHERE session_key = in_session_key AND access_token = in_access_token; 
DELETE FROM copy_restriction_content WHERE access_id = @id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spResetVerifyMemberEmailToken` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spResetVerifyMemberEmailToken`(IN in_member_id VARCHAR(36))
BEGIN
SET @verifyToken = fnCreateToken();
UPDATE authentication
JOIN member ON authentication.id = member.authentication_id
SET
email_verified = 0,
verify_token = @verifyToken
WHERE member.id = in_member_id;
SELECT
member.id AS id,
authentication.id AS authentication_id,
authentication.email AS email,
role_type.name AS role_type,
role_type.id AS role_type_id,
member.name_first AS name_first,
member.name_last AS name_last,
@verifyToken AS verify_token
FROM authentication
JOIN member ON authentication.id = member.authentication_id
JOIN role_type ON authentication.role_type_id = role_type.id
WHERE member.id = in_member_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSetResultCompletedByMemberCourseItemId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spSetResultCompletedByMemberCourseItemId`(IN in_member_id VARCHAR(36), IN in_course_id VARCHAR(36), IN in_item_id VARCHAR(36))
BEGIN
	SET @member_course_id = null;
	SELECT member_course_id into @member_course_id FROM member_course WHERE member_course.member_id = in_member_id AND member_course.course_id = in_course_id AND member_course.active = 1;
    IF member_course_id IS NOT NULL THEN 
		INSERT INTO course_result(id, member_course_id, item_id, item_type, result, completed, create_date)
		VALUES(fnCreateUUID(), @member_course_id, in_item_id, 'TASK', '{"completed":"true"}', 1, CURRENT_TIMESTAMP);
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSwitchMemberGroupFromTo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spSwitchMemberGroupFromTo`(IN in_member_id VARCHAR(36), IN in_from_class_group_id VARCHAR(36), IN in_to_class_group_id VARCHAR(36))
BEGIN
UPDATE member_class_group 
SET class_group_id = in_to_class_group_id
WHERE member_id =in_member_id AND class_group_id = in_from_class_group_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spSystemInit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spSystemInit`()
BEGIN
/* nothing to do */
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spToolsAddUpdateSubscriptionForUserWithExpireDate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spToolsAddUpdateSubscriptionForUserWithExpireDate`(IN in_authentication_id VARCHAR(36), IN in_product_type_id INT, IN in_transaction_provider VARCHAR(255), IN in_transaction_id VARCHAR(255), IN in_transaction_object VARCHAR(1024), IN in_expire_date DATETIME, IN in_auto_renew BIT(1))
BEGIN
SET @pk = '';
SET @authentication_id = '';
SET @product_type_id = '';
SET @transaction_provider = '';
SET @transaction_id = '';
SET @transaction_object = '';
SET @expire_date = '';
SET @auto_renew = '';
/* lets grab any existing */
SELECT id, authentication_id, product_type_id, transaction_provider, transaction_id, transaction_object, expire_date, auto_renew
INTO @pk, @authentication_id, @product_type_id, @transaction_provider, @transaction_id, @transaction_object, @expire_date, @auto_renew
FROM subscription
WHERE authentication_id = in_authentication_id;
IF @pk <> '' THEN
	/* update existing */
	UPDATE subscription
    SET
    product_type_id = in_product_type_id,
    transaction_provider = in_transaction_provider,    
    transaction_id = (CASE WHEN in_transaction_id IS NULL THEN @pk ELSE in_transaction_id END),
    transaction_object = in_transaction_object,
    expire_date = in_expire_date,
    auto_renew = in_auto_renew
    WHERE id = @pk;
    /* add to audit table */
    INSERT INTO subscription_audit
    	(subscription_id, authentication_id, product_type_id, transaction_provider, transaction_id, transaction_object, expire_date, auto_renew)
    VALUES
    	(@pk, @authentication_id, @product_type_id, @transaction_provider, @transaction_id, @transaction_object, @expire_date, @auto_renew);
ELSE
	/* add new entry, get new pk */
	SET @pk = fnCreateUUID();
	INSERT INTO subscription
    (id, authentication_id, product_type_id, transaction_provider, transaction_id, transaction_object, expire_date, auto_renew)
	VALUES
    (@pk, in_authentication_id, in_product_type_id, in_transaction_provider, (CASE WHEN in_transaction_id IS NULL THEN @pk ELSE in_transaction_id END), in_transaction_object, in_expire_date, in_auto_renew);	
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spToolsDeleteWechatUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spToolsDeleteWechatUser`(IN union_id VARCHAR(100))
BEGIN
DELETE FROM wechat_metadata
WHERE unionid = union_id;
UPDATE authentication SET oauth_token = CONCAT('removed_', union_id) WHERE authentication.oauth_token = union_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spToolsDeleteWechatUserAnthony` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spToolsDeleteWechatUserAnthony`()
BEGIN
CALL spToolsDeleteWechatUser('oJ7qYw_dCTDOVJZzccnv4M9106_s');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spToolsDeleteWechatUserKen` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spToolsDeleteWechatUserKen`()
BEGIN
CALL spToolsDeleteWechatUser('oJ7qYw1t52KxUu9r5Qggm6JjGZcs');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spToolsDeleteWechatUserRobin` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spToolsDeleteWechatUserRobin`()
BEGIN
CALL spToolsDeleteWechatUser('oJ7qYw8e9esiunTXJehDv_q2A_O0');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spToolsGetOldCourseInfo` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spToolsGetOldCourseInfo`()
BEGIN
SELECT
	content_delivery.member_id AS member_id,
    class.teacher_id AS teacher_id,
    course.id AS course_id,
	course.name AS course_name, 
	course.course_length AS course_length,
	course_book.book_id AS book_id,
    book.name AS book_name,
    book.reading_level AS course_level,
    content_delivery.start_date AS start_date,
    course_book.week_number AS week_number
FROM content_delivery
	JOIN course ON content_delivery.course_id = course.id
	JOIN course_book ON course.id = course_book.course_id
    JOIN book on course_book.book_id = book.id
    LEFT JOIN member_class_group ON member_class_group.member_id = content_delivery.member_id
    LEFT JOIN class_group ON member_class_group.class_group_id = class_group.id
    LEFT JOIN class ON class_group.class_id = class.id
	ORDER BY week_number, course.id;
    
-- this condition is just0 for testing. 
-- WHERE content_delivery.member_id = '6f6495b9dfde11e6b550008cfaf59458'
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spToolsRefreshLionWorldSubscriptions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spToolsRefreshLionWorldSubscriptions`(IN in_expire_date DATETIME)
BEGIN

DECLARE done BOOLEAN DEFAULT FALSE;        
DECLARE aid VARCHAR(36) DEFAULT NULL;
DECLARE cur CURSOR
	FOR SELECT authentication.id
		FROM authentication
		JOIN member ON authentication.id = member.authentication_id
		LEFT JOIN member_school_site ON member.id = member_school_site.member_id
		LEFT JOIN school_site ON member_school_site.school_site_id = school_site.id
		WHERE
		authentication.affiliate_code = 'lionworld' OR
		school_site.name = 'Jiyuqiao' OR
		school_site.name = 'Wujiashan'
		GROUP BY authentication.id;	
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done := TRUE;

OPEN cur;
	selloop: LOOP
		FETCH cur INTO aid;
		IF done THEN
			LEAVE selloop;
		END IF;
		CALL spToolsAddUpdateSubscriptionForUserWithExpireDate(aid, 10, 'CHATTY_KIDS',
			CONCAT('ckz_', aid),
            CONCAT('{"type": "temp_lionworld", "authorization_id": "', aid, '"}'), in_expire_date, 0);
	END LOOP selloop;
CLOSE cur;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateAffiliateCodeByMemberId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateAffiliateCodeByMemberId`(IN in_member_id VARCHAR(36), IN in_affiliate_code VARCHAR(255))
BEGIN
UPDATE authentication
JOIN member ON authentication.id = member.authentication_id
SET authentication.affiliate_code = in_affiliate_code
WHERE member.id = in_member_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateAllMembersOnline` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateAllMembersOnline`()
BEGIN
UPDATE member
SET `online` = 0
WHERE `online` = 1 AND last_access < DATE_SUB(NOW(), INTERVAL 15 MINUTE);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateAuthenticationById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateAuthenticationById`(IN in_authentication_id VARCHAR(36), IN in_email VARCHAR(100), IN in_password VARCHAR(1024), IN in_password_salt VARCHAR(1024), IN in_role_type VARCHAR(45))
BEGIN
UPDATE authentication
SET
authentication.email = COALESCE(in_email, authentication.email),
authentication.password = COALESCE(in_password, authentication.password),
authentication.password_salt = COALESCE(in_password_salt, authentication.password_salt),
authentication.role_type_id = COALESCE((SELECT id FROM role_type WHERE name = in_role_type), authentication.role_type_id)
WHERE authentication.id = in_authentication_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateBookDetails` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateBookDetails`(IN in_book_id BIGINT, IN in_isbn VARCHAR(100), IN in_author VARCHAR(200), IN in_publisher VARCHAR(200))
BEGIN
IF in_book_id > 0 THEN
	/* get author */
	SET @authorId = 0;
	SELECT id INTO @authorId FROM book_author WHERE name = in_author;
	IF @authorId = 0 THEN
		INSERT INTO book_author (name) VALUES (in_author);
		SELECT id INTO @authorId FROM book_author WHERE name = in_author;
	END IF;
	/* get publisher */
	SET @publisherId = 0;
	SELECT id INTO @publisherId FROM book_publisher WHERE name = in_publisher;
	IF @publisherId = 0 THEN
		INSERT INTO book_publisher (name) VALUES (in_publisher);
		SELECT id INTO @publisherId FROM book_publisher WHERE name = in_publisher;
	END IF;
	/* update details */
	UPDATE book
	SET isbn = in_isbn, book_author_id = @authorId, book_publisher_id = @publisherId
    WHERE id = in_book_id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateClass` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateClass`(IN in_user_id VARCHAR(36), IN in_id VARCHAR(36), IN in_name VARCHAR(100), IN in_teacher_id VARCHAR(36), IN in_schoolsite_id VARCHAR(36))
BEGIN
/*check if the admin has permision.*/ 
SET @has_permision = 
(SELECT COUNT(*) 
FROM school_site
JOIN class ON class.school_site_id = school_site.id 
WHERE (admin_id = in_user_id AND school_site.id = in_schoolsite_id) OR class.teacher_id = in_user_id);

/* get user role_id */
SET @role_id = (SELECT role_type_id FROM authentication JOIN member ON member.authentication_id = authentication.id WHERE member.id = in_user_id LIMIT 1);

IF (@has_permision <> 0 OR @role_id <= 20) THEN
	UPDATE class
	SET
	class.name = COALESCE(in_name, class.name),
	class.teacher_id = COALESCE(in_teacher_id, class.teacher_id),
	class.school_site_id = COALESCE(in_schoolsite_id, class.school_site_id)
	WHERE 
	class.id = in_id;
ELSE
	SELECT 'true' AS error, 'User does not have permision to edit' AS message;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateClassGroupName` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateClassGroupName`(IN in_id VARCHAR(36), IN in_name VARCHAR(100))
BEGIN
UPDATE class_group
SET
class_group.name = COALESCE(in_name, class_group.name)
WHERE class_group.id = in_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateClientVersion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateClientVersion`(IN in_client_version INT)
BEGIN
UPDATE system
SET client_version = in_client_version
WHERE id = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateCourseById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateCourseById`(IN in_course_id VARCHAR(36), IN in_name VARCHAR(100), IN in_length INT)
BEGIN
	UPDATE course SET
		name = COALESCE(in_name, name),
        course_length = COALESCE(in_length, course_length)
    WHERE id = in_course_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateDateForAssignedCourseToGroup` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateDateForAssignedCourseToGroup`(IN in_course_id VARCHAR(36), IN in_group_id VARCHAR(36), IN in_start_date DATETIME)
BEGIN
	UPDATE content_delivery
    SET start_date = in_start_date
    WHERE course_id = in_course_id AND class_group_id = in_group_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateLSHTables` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateLSHTables`()
BEGIN
    CALL `_spSetLSHParameters`();
    CALL `_spComputeLSHAxes`();
    CALL `_spGenerateHashTables`();
    CALL `_spGenerateHashFuns`();
    CALL `_spIndexAll`();
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateMemberById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateMemberById`(IN in_member_id VARCHAR(36), IN in_name_first VARCHAR(100), IN in_name_last VARCHAR(100), IN in_date_of_birth DATETIME, IN in_is_child TINYINT, IN in_level INT)
BEGIN
UPDATE member
SET
member.name_first = COALESCE(in_name_first, member.name_first),
member.name_last = COALESCE(in_name_last, member.name_last),
member.date_of_birth = COALESCE(in_date_of_birth, member.date_of_birth),
member.is_child = COALESCE(in_is_child, member.is_child)
WHERE member.id = in_member_id;

SET @is_level_changed = TRUE;
IF (in_level = (SELECT level FROM progress_table WHERE progress_table.member_id = in_member_id) OR in_level IS NULL) THEN 
    SET @is_level_changed = FALSE; 
END IF;

UPDATE progress_table 
SET progress_table.level = COALESCE(in_level, progress_table.level)
WHERE member_id = in_member_id;

IF(@is_level_changed) THEN
CALL spCreateAndAssignCourseToMember('89ac8a1ba24811e68f2322000ba8862d', 'c03b1bf7b29e11e6bd1002a76cde81a3', 'Chatty Kids', 12, CURDATE(), 5, in_member_id, 60);
END IF;
/* return new user */
CALL spGetMemberById(in_member_id);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateMemberCourseCompleted` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateMemberCourseCompleted`(IN member_course_id VARCHAR(36))
BEGIN
UPDATE member_course
SET completed = 1
WHERE id = member_course_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateMemberCourseProcessSession` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateMemberCourseProcessSession`(IN member_course_id VARCHAR(36), IN in_process_session_id VARCHAR(255))
BEGIN
UPDATE member_course
SET process_session_id = in_process_session_id
WHERE id = member_course_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateMemberCourseStartDate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateMemberCourseStartDate`(IN in_id VARCHAR(36), IN in_start_date DATETIME)
BEGIN
UPDATE member_course
SET start_date = in_start_date
WHERE id = in_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateMemberLevelById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateMemberLevelById`(IN in_member_id VARCHAR(36), IN in_level INT)
BEGIN
UPDATE progress_table 
SET progress_table.level = in_level
WHERE member_id = in_member_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateMemberOfflineState` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateMemberOfflineState`(IN in_member_id VARCHAR(36))
BEGIN
UPDATE member
SET `online` = 0, last_access = NOW()
WHERE id = in_member_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateMemberOnlineState` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateMemberOnlineState`(IN in_member_id VARCHAR(36))
BEGIN
UPDATE member
SET `online` = 1, last_access = NOW()
WHERE id = in_member_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateMessageQueueSent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateMessageQueueSent`(IN in_id VARCHAR(36), IN in_error VARCHAR(255))
BEGIN
/* if there error is not null, then message not sent */
IF in_error IS NOT NULL THEN
	/* was an error */
	UPDATE messaging_queue
    SET
    retries = retries + 1,
    error = in_error,
    sent_date = NULL
    WHERE id = in_id;
ELSE
	/* all good, set as sent */
    UPDATE messaging_queue
    SET
    sent_date = NOW()
    WHERE id = in_id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateOpenTokControllingMember` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateOpenTokControllingMember`(IN in_session_id VARCHAR(1024), IN controlling_member_id VARCHAR(36))
BEGIN
UPDATE opentok_session
SET
controlling_member = controlling_member_id
WHERE
session_id = in_session_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateOpenTokIncomingCall` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateOpenTokIncomingCall`(IN in_session_id VARCHAR(1024), IN in_socket2_id VARCHAR(255))
BEGIN
UPDATE opentok_session
SET
socket2_id = in_socket2_id,
call_connected = 1
WHERE
session_id = in_session_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateOpenTokSessionEndCall` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateOpenTokSessionEndCall`(IN in_session_id VARCHAR(1024))
BEGIN
UPDATE opentok_session
SET call_connected = 0, date_ended = NOW()
WHERE session_id = in_session_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdatePassword` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdatePassword`(IN in_member_id VARCHAR(36), IN in_old_password VARCHAR(1024), IN in_new_password VARCHAR(1024), IN in_new_password_salt VARCHAR(1024))
BEGIN
-- check the old password
SELECT COUNT(*) INTO @password_check 
FROM authentication 
JOIN member ON member.authentication_id = authentication.id 
WHERE member.id = in_member_id AND
authentication.password = in_old_password;
-- updating the password
IF (@password_check > 0) THEN
	UPDATE authentication JOIN member ON member.authentication_id = authentication.id
	SET authentication.password = in_new_password, authentication.password_salt = in_new_password_salt
	WHERE member.id = in_member_id;
    CALL spGetMemberById(in_member_id);
ELSE 
	SELECT 'ERROR' AS id;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdatePasswordByToken` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdatePasswordByToken`(IN in_token VARCHAR(255), IN in_new_password VARCHAR(1024), IN in_new_password_salt VARCHAR(1024))
BEGIN
SET @authId = '0';
/* get authentication id */
SELECT authentication.id
INTO @authId
FROM member_reset_password
JOIN member ON member_reset_password.member_id = member.id
JOIN authentication ON member.authentication_id = authentication.id
WHERE member_reset_password.token = in_token;
/* update auth table */
UPDATE authentication
SET authentication.password = in_new_password, authentication.password_salt = in_new_password_salt
WHERE authentication.id = @authId;
/* finally remove token entry */
DELETE FROM member_reset_password WHERE member_reset_password.token = in_token;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdatePlainTextAuthenticationById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdatePlainTextAuthenticationById`(IN in_authentication_id VARCHAR(36), IN in_username VARCHAR(100), IN in_password VARCHAR(100), IN in_role_type VARCHAR(45))
BEGIN
/* update member first */
UPDATE member
SET
username = COALESCE(in_username, username),
password = COALESCE(in_password, password)
WHERE authentication_id = in_authentication_id AND primary_user = 1;
/* update role */
UPDATE authentication
SET
role_type_id = COALESCE((SELECT id FROM role_type WHERE name = in_role_type), role_type_id)
WHERE authentication.id = in_authentication_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateRedemptionCodeById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateRedemptionCodeById`(IN in_id VARCHAR(36), IN in_redeem_member_id VARCHAR(36))
BEGIN
UPDATE redemption
SET
redeem_member_id = in_redeem_member_id,
redeemed_date = NOW()
WHERE id = in_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateReportFrequencyDays` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateReportFrequencyDays`(IN in_member_id VARCHAR(36), IN in_days INT)
BEGIN
IF NOT EXISTS(SELECT * FROM member_preference WHERE member_id = in_member_id) THEN
	INSERT INTO member_preference (id, report_frequency_days, member_id) VALUES (fnCreateUUID(), in_days, in_member_id);
ELSE
	UPDATE member_preference 
	SET report_frequency_days = in_days
    WHERE member_id = in_member_id;
END IF;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateResultByMemberCourseItemId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateResultByMemberCourseItemId`(IN in_member_id VARCHAR(36), IN in_course_id VARCHAR(36), IN in_item_id VARCHAR(36), IN in_result VARCHAR(1024))
BEGIN
	IF EXISTS(SELECT * FROM course_result JOIN member_course ON member_course.id = course_result.member_course_id 
		WHERE member_course.member_id = in_member_id AND member_course.active = 1
		AND member_course.course_script_id = in_course_id 
		AND course_result.item_id = in_item_id
		AND course_result.item_type = 'TASK') THEN
			UPDATE course_result
			JOIN member_course ON member_course.id = course_result.member_course_id
			SET course_result.result = in_result, course_result.completed = 1
			WHERE member_course.member_id = in_member_id
			AND member_course.course_script_id = in_course_id 
			AND course_result.item_id = in_item_id
			AND course_result.item_type = 'TASK';
	ELSE
			SELECT id INTO @member_course_id FROM member_course WHERE member_id = in_member_id AND course_script_id = in_course_id LIMIT 1;
			INSERT INTO course_result (id, member_course_id, item_id, item_type, result, completed, create_date)
			VALUES (fnCreateUUID(), @member_course_id, in_item_id, 'TASK', in_result, 1, CURRENT_TIMESTAMP);
    END IF;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateSchoolGroupById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateSchoolGroupById`(IN in_schoolgroup_id VARCHAR(36), IN in_name VARCHAR(100), IN in_admin_id VARCHAR(36), IN in_country VARCHAR(45))
BEGIN
UPDATE school_group
SET
school_group.name = COALESCE(in_name, school_group.name),
school_group.admin_id = COALESCE(in_admin_id, school_group.admin_id),
school_group.country = COALESCE(in_country, school_group.country)
WHERE school_group.id = in_schoolgroup_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateSchoolSiteById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateSchoolSiteById`(IN in_id VARCHAR(36), IN in_name VARCHAR(100), IN in_school_group_id VARCHAR(36), IN in_admin_id VARCHAR(36))
BEGIN
UPDATE school_site
SET
school_site.name = COALESCE(in_name, school_site.name),
school_site.school_group_id = COALESCE(in_school_group_id, school_site.school_group_id),
school_site.admin_id = COALESCE(in_admin_id, school_site.admin_id)
WHERE 
school_site.id = in_id;

/* assign the admin to the school site if its already not assigned */
SET @record_exist= (SELECT COUNT(*) FROM member_school_site WHERE school_site_id = in_id AND member_id = in_admin_id);

IF (@record_exist = 0) THEN
	SET @mss_pk = fnCreateUUID();
	INSERT INTO member_school_site (`id`, `school_site_id`, `member_id`) 
	VALUES (@mss_pk,in_id, in_admin_id);
END IF;


/* out put the school site */
SELECT *
FROM school_site
WHERE id = in_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateServerVersion` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateServerVersion`(IN in_server_version INT)
BEGIN
UPDATE system
SET server_version = in_server_version
WHERE id = 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateStartDateByCourseId` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateStartDateByCourseId`(IN in_course_id VARCHAR(36), IN in_member_id VARCHAR(36), IN in_start_date DATE)
BEGIN

	-- this is to update the course start date for the user. if the start date is set to null then it will change the date to the current date
	IF in_start_date IS NULL THEN 
		SET @start_date = CURDATE();
	ELSE 
		SET @start_date = in_start_date;
    END IF;
    
	UPDATE member_course
		SET start_date = @start_date
	WHERE member_course.course_script_id = in_course_id 
    AND member_course.member_id = in_member_id;
    
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateStudentLevel` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateStudentLevel`(IN in_student_id VARCHAR(36), IN in_level INT)
BEGIN
SELECT LEVEL INTO @level FROM progress_table WHERE member_id = in_student_id;
SET @books_per_week = 5;
IF @level <> in_level or true THEN
	UPDATE progress_table SET level = in_level WHERE member_id = in_student_id;
    -- get the current week
    SELECT course_id, FLOOR(DATEDIFF(CURDATE(),content_delivery.start_date)/7)+1 INTO @course_id, @current_week
    FROM content_delivery WHERE member_id = in_student_id AND course_id IS NOT NULL;
    -- getting the course_length
    SELECT course_length INTO @course_length FROM course WHERE id = @course_id;
    -- update the course_book
    
    -- delete books from 
    DELETE FROM course_book
    WHERE course_id = @course_id AND week_number > @current_week;
    
    -- select @course_length,@current_week;
    -- add new books base on new student level. 
    
    SET @row = -1;
	INSERT INTO course_book(id, course_id, book_id, week_number)
		SELECT temp_id, temp_course_id, book_id, ((@row:=@row+1) % (@course_length - @current_week))+ @current_week+1 as week_number FROM (
			SELECT fnCreateUUID() AS temp_id, @course_id AS temp_course_id, book.id AS book_id FROM book WHERE reading_level = in_level ORDER BY rand()) AS temp
		WHERE @row < ((@course_length - @current_week) * @books_per_week)-1;
END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateVideoProcessAction` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateVideoProcessAction`(IN in_record_id VARCHAR(100), IN in_process_action INT(11))
BEGIN
UPDATE media_content
SET media_content.process_action = in_process_action
WHERE media_content.record_id = in_record_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateVideoPublicStateById` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateVideoPublicStateById`(IN in_media_content_id VARCHAR(36), IN in_public_access BIT(1), IN in_approver_id VARCHAR(36))
BEGIN
UPDATE media_content
SET
public_access = in_public_access,
approver_id = in_approver_id
WHERE id = in_media_content_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateWechatMetadata` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateWechatMetadata`(IN in_unionid VARCHAR(50), IN in_openid VARCHAR(50), IN in_subscribe bit(1))
Update_WeChat: BEGIN
# check if unionid exists
SET @existance = 0;
SELECT COUNT(*)
INTO @existance
FROM wechat_metadata WHERE unionid = in_unionid;
IF @existance = 0 THEN	
	LEAVE Update_WeChat;
END IF;
# fill in openid if not filled yet
UPDATE wechat_metadata
SET
openid = COALESCE(in_openid, openid),
subscriber = COALESCE(in_subscribe, subscriber)
WHERE unionid = in_unionid;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `spUpdateWechatTradeStatus` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `spUpdateWechatTradeStatus`(IN in_out_trade_no VARCHAR(32), IN in_openid VARCHAR(128), IN in_trade_state VARCHAR(32), IN in_total_fee int(11), IN in_transaction_id VARCHAR(32), IN in_time_paid VARCHAR(15))
BEGIN
UPDATE wechat_traderecorde
SET
wechat_traderecorde.openid = COALESCE(in_openid, wechat_traderecorde.openid),
wechat_traderecorde.trade_state = COALESCE(in_trade_state, wechat_traderecorde.trade_state),
wechat_traderecorde.total_fee = COALESCE(in_total_fee, wechat_traderecorde.total_fee),
wechat_traderecorde.transaction_id = COALESCE(in_transaction_id, wechat_traderecorde.transaction_id),
wechat_traderecorde.time_paid = COALESCE(in_time_paid, wechat_traderecorde.time_paid)
WHERE out_trade_no = in_out_trade_no;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spAddCommonViewsScores` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spAddCommonViewsScores`(
    `member_id_` VARCHAR(36)
  )
BEGIN
    INSERT INTO `_unnormalized_scores`
      SELECT `tbe`.`book_id`, SUM(`sq`.`count`) AS `score`
        FROM `tracking_book_event` AS `tbe`
        LEFT JOIN `tracking_member_event` AS `tme`
          ON `tbe`.`tracking_member_event_id` = `tme`.`id`
        INNER JOIN (
            SELECT `tme`.`member_id`,
                   COUNT(DISTINCT `tbe`.`book_id`) AS `count`
              FROM `tracking_book_event` AS `tbe`
              LEFT JOIN `tracking_member_event` AS `tme`
                ON `tbe`.`tracking_member_event_id`=`tme`.`id`
              WHERE `tbe`.`book_id` IN (SELECT * FROM `_seed`)
                    AND `tme`.`member_id` <> `member_id_`
              GROUP BY `tme`.`member_id` ORDER BY NULL
          ) AS `sq` ON `tme`.`member_id` = `sq`.`member_id`
        WHERE `tbe`.`book_id` AND `tme`.`member_id` <> `member_id_`
        GROUP BY `tbe`.`book_id` ORDER BY NULL;

    CALL `_spAddUnnormalizedScores`(@`rec_engn_common_views_weight`);
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spAddDiversityScores` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spAddDiversityScores`()
BEGIN
    DECLARE `done` TINYINT(1) UNSIGNED DEFAULT FALSE;
    DECLARE `book_id_` BIGINT(20);
    DECLARE `min_book_id` BIGINT(20);
    DECLARE `min_book_count` FLOAT;
    DECLARE `origin_book_count` INT UNSIGNED;

    DECLARE `cur` CURSOR FOR
      SELECT `book_id` FROM `_scores` ORDER BY `score` DESC;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET `done` = TRUE;

    INSERT INTO `_origin_count` (`book_id`)
      SELECT DISTINCT `origin_book_id` AS `book_id` FROM `_candidates`;

    OPEN `cur`;
    `cur_loop`: LOOP
      FETCH `cur` INTO `book_id_`;
      IF `done` THEN
        LEAVE `cur_loop`;
      END IF;

      SELECT `oc`.`book_id`, `oc`.`count`
        INTO `min_book_id`, `min_book_count`
        FROM `_candidates` AS `c`
        LEFT JOIN `_origin_count` AS `oc`
          ON `c`.`origin_book_id` = `oc`.`book_id`
        WHERE `c`.`book_id` = `book_id_`
        ORDER BY `oc`.`count`
        LIMIT 1;

      SELECT COUNT(*) INTO `origin_book_count`
        FROM `_candidates`
        WHERE `book_id` = `book_id_`;

      INSERT INTO `_unnormalized_scores`
        VALUES (`book_id_`, 1 / `min_book_count`);

      UPDATE `_origin_count`
        SET `count` = `count` + 1 / `origin_book_count`
        WHERE `book_id` = `min_book_id`;

    END LOOP;

    CALL `_spAddUnnormalizedScores`(@`rec_engn_diversity_weight`);
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spAddExtrasScores` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spAddExtrasScores`()
BEGIN
    INSERT INTO `_unnormalized_scores`
      SELECT `s`.`book_id`, COUNT(*) AS `score` FROM `_scores` AS `s`
        INNER JOIN `media_content` AS `mc` USING (`book_id`)
        GROUP BY `s`.`book_id` ORDER BY NULL;

    CALL `_spAddUnnormalizedScores`(@`rec_engn_extras_weight`);
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spAddLevelScores` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spAddLevelScores`(
    `member_id` VARCHAR(36),
    `book_id_` BIGINT(20)
  )
BEGIN
    DECLARE `member_level`, `book_level` FLOAT;

    SELECT `reading_level` INTO `member_level` FROM `member`
      WHERE `id`=`member_id`;
    IF `book_id_` IS NOT NULL THEN
      SELECT `reading_level` INTO `book_level` FROM `book`
        WHERE `id`=`book_id_`;
    END IF;

    IF `member_level` IS NOT NULL OR `book_level` IS NOT NULL THEN
      INSERT INTO `_unnormalized_scores`
        SELECT `s`.`book_id`, `_sfReadingLevelGaussian`(
            CASE WHEN `b`.`reading_level` IS NULL
            THEN 15
            ELSE `_sfMinDistance`(`member_level`,
                                  `book_level`,
                                  `b`.`reading_level`)
            END)
          FROM `_scores` AS `s`
          LEFT JOIN `book` AS `b` ON `s`.`book_id`=`b`.`id`;

      CALL `_spAddUnnormalizedScores`(@`rec_engn_level_weight`);
    END IF;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spAddQualityScores` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spAddQualityScores`(
    `member_id_` VARCHAR(36)
  )
BEGIN
    INSERT INTO `_unnormalized_scores`
      SELECT `s`.`book_id`, COUNT(*) AS `score` FROM `_scores` AS `s`
        INNER JOIN `tracking_book_event` AS `tbe` USING (`book_id`)
        LEFT JOIN `tracking_member_event` AS `tme`
          ON `tbe`.`tracking_member_event_id` = `tme`.`id`
        WHERE `tme`.`member_id` <> `member_id_`
        GROUP BY `s`.`book_id` ORDER BY NULL;

    CALL `_spAddUnnormalizedScores`(@`rec_engn_quality_weight`);
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spAddSimilarVocabScores` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spAddSimilarVocabScores`()
BEGIN
    CALL `_spQueryLSHTablesTableIntoTable`();

    INSERT INTO `_unnormalized_scores`
      SELECT `book_id`, `similarity` AS `score`
        FROM `_lsh_multiple_query_results`;

    TRUNCATE TABLE `_lsh_multiple_query_results`;

    CALL `_spAddUnnormalizedScores`(@`rec_engn_similar_vocab_weight`);
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spAddUnnormalizedScores` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spAddUnnormalizedScores`(
    `weight` FLOAT
  )
BEGIN
    DECLARE `mean`, `standard_dev` FLOAT;

    INSERT IGNORE INTO `_unnormalized_scores`
      SELECT `book_id`, 0 AS `score` FROM `_scores`;

    SELECT AVG(`score`), STDDEV(`score`)
      INTO `mean`, `standard_dev`
      FROM `_unnormalized_scores`;


    IF `standard_dev` > 0 THEN
      UPDATE `_scores` AS `s`
        LEFT JOIN `_unnormalized_scores` AS `us` USING (`book_id`)
        SET `s`.`score` = `s`.`score`
                          + `weight`
                            * (`us`.`score` - `mean`)
                            / `standard_dev`;
    END IF;

    TRUNCATE TABLE `_unnormalized_scores`;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spComputeLSHAxes` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spComputeLSHAxes`()
BEGIN
    --  Workaround because we can't use @variables in LIMIT clauses...
    DECLARE `word_lsh_axes_count` SMALLINT UNSIGNED;
    SET `word_lsh_axes_count` = @`word_lsh_axes_count`;

    TRUNCATE TABLE `lsh_word_axes`;

    --  If we start having too many words, we can do this
    --  probabilistically by taking a random sample. Just make sure to
    --  take a large enough sample. For 500 most common words, a sample
    --  of 20 000 should do the trick (feel free to experiment).
    INSERT INTO `lsh_word_axes`(`word`)
      SELECT `stripped_content` AS `word` FROM `book_words`
        WHERE `stripped_content` <> ''
        GROUP BY `stripped_content`
        ORDER BY COUNT(*) DESC
        LIMIT `word_lsh_axes_count`;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spCreateReccEngnTables` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spCreateReccEngnTables`()
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS `_seed` (
        `book_id` BIGINT(20) NOT NULL,
        PRIMARY KEY (`book_id`) USING HASH
      ) ENGINE=MEMORY;
    TRUNCATE TABLE `_seed`;

    CREATE TEMPORARY TABLE IF NOT EXISTS `_explored` (
        `book_id` BIGINT(20) NOT NULL,
        `origin_book_id` BIGINT(20) NOT NULL,
        PRIMARY KEY (`book_id`, `origin_book_id`) USING HASH,
        INDEX (`book_id`) USING HASH
      ) ENGINE=MEMORY;
    TRUNCATE TABLE `_explored`;

    CREATE TEMPORARY TABLE IF NOT EXISTS `_unexplored` (
        `book_id` BIGINT(20) NOT NULL,
        `origin_book_id` BIGINT(20) NOT NULL,
        PRIMARY KEY (`book_id`, `origin_book_id`) USING HASH,
        INDEX (`book_id`) USING HASH
      ) ENGINE=MEMORY;
    TRUNCATE TABLE `_unexplored`;

    CREATE TEMPORARY TABLE IF NOT EXISTS `_exploring` (
        `book_id` BIGINT(20) NOT NULL,
        `origin_book_id` BIGINT(20) NOT NULL,
        PRIMARY KEY (`book_id`, `origin_book_id`) USING HASH,
        INDEX (`book_id`) USING HASH
      ) ENGINE=MEMORY;
    TRUNCATE TABLE `_exploring`;

    CREATE TEMPORARY TABLE IF NOT EXISTS `_candidates` (
        `book_id` BIGINT(20) NOT NULL,
        `origin_book_id` BIGINT(20) NOT NULL,
        PRIMARY KEY(`book_id`, `origin_book_id`) USING HASH,
        INDEX (`book_id`) USING HASH
      ) ENGINE=MEMORY;
    TRUNCATE TABLE `_candidates`;

    CREATE TEMPORARY TABLE IF NOT EXISTS `_scores` (
        `book_id` BIGINT(20) NOT NULL,
        `score` FLOAT NOT NULL DEFAULT 0,
        PRIMARY KEY (`book_id`) USING HASH
      ) ENGINE=MEMORY;
    TRUNCATE TABLE `_scores`;

    CREATE TEMPORARY TABLE IF NOT EXISTS `_unnormalized_scores` (
        `book_id` BIGINT(20) NOT NULL,
        `score` FLOAT NOT NULL DEFAULT 0,
        PRIMARY KEY (`book_id`) USING HASH
      ) ENGINE=MEMORY;
    TRUNCATE TABLE `_unnormalized_scores`;

    CREATE TEMPORARY TABLE IF NOT EXISTS `_origin_count` (
        `book_id` BIGINT(20) NOT NULL,
        `count` FLOAT NOT NULL DEFAULT 1,
        PRIMARY KEY (`book_id`) USING HASH,
        INDEX (`book_id`, `count`) USING BTREE
      ) ENGINE=MEMORY;
    TRUNCATE TABLE `_origin_count`;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spCreateVectorTableForBook` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spCreateVectorTableForBook`(
    `book_id_` BIGINT(20)
  )
BEGIN
    DECLARE `total_book_words` FLOAT;

    CREATE TEMPORARY TABLE IF NOT EXISTS `_book_vector` (
        `axis_id` SMALLINT UNSIGNED NOT NULL,
        `value` FLOAT NOT NULL,
        PRIMARY KEY (`axis_id`) USING HASH
      ) ENGINE=MEMORY;
    TRUNCATE TABLE `_book_vector`;

    --  Make table of word counts. Ignore words that are not axes.
    INSERT INTO `_book_vector`
            SELECT `lwa`.`id` AS `axis_id`, COUNT(*) AS `value`
              FROM `lsh_word_axes` AS `lwa`
              INNER JOIN `book_words` AS `bw`
                ON `lwa`.`word`=`bw`.`stripped_content`
                   AND `bw`.`book_id`=`book_id_`
              GROUP BY `lwa`.`word` ORDER BY NULL;

    --  Normalise so that all values add up to 1.
    SELECT SUM(`value`) INTO `total_book_words` FROM `_book_vector`;
    UPDATE `_book_vector` SET `value`=`value`/`total_book_words`;

    --  Make missing axes 0.
    INSERT IGNORE INTO `_book_vector` SELECT `id`, 0 FROM `lsh_word_axes`;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spGenerateHashFuns` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spGenerateHashFuns`()
BEGIN
    DECLARE `k` SMALLINT UNSIGNED DEFAULT 0;

    TRUNCATE TABLE `lsh_hash_funs`;

    WHILE `k` < @`word_lsh_k` DO
      INSERT INTO `lsh_hash_funs`
        SELECT `ht`.`id` AS `table`,
               `k` AS `id_in_table`,
               `wa`.`id` AS `axis_id`,
               RAND() * @`word_lsh_radius` AS `partition`
               -- ^The randomness goes here.
          FROM `lsh_word_axes` AS `wa`
          CROSS JOIN `lsh_hash_tables` AS `ht`;
      SET `k` = `k` + 1;
    END WHILE;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spGenerateHashTables` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spGenerateHashTables`()
BEGIN
    DECLARE `i` SMALLINT UNSIGNED;

    TRUNCATE TABLE `lsh_hash_tables`;

    SET `i` = 0;
    WHILE `i` < @`word_lsh_L` DO
      --  The table autoincrements, so we're just inserting integers.
      INSERT INTO `lsh_hash_tables` VALUES ();
      SET `i` = `i` + 1;
    END WHILE;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spGetCommonViewsCandidates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spGetCommonViewsCandidates`(
    `member_id_` VARCHAR(36)
  )
BEGIN
    DECLARE `i` INT UNSIGNED DEFAULT 0;

    INSERT INTO `_unexplored`
      SELECT `book_id`, `book_id` AS `origin_book_id` FROM `_seed`;

    WHILE `i` < @`rec_engn_common_views_cands_depth` DO
      INSERT INTO `_explored` SELECT * FROM `_unexplored`;
      INSERT INTO `_exploring` SELECT * FROM `_unexplored`;
      TRUNCATE TABLE `_unexplored`;

      INSERT INTO `_unexplored`
        SELECT DISTINCT `tbe`.`book_id`, `sqo`.`book_id` AS `origin_book_id`
          FROM (
              SELECT `sqi`.`book_id`, `tme`.`id`
                FROM (
                    SELECT `tbe`.`book_id`, `tme`.`member_id`
                      FROM `tracking_book_event` AS `tbe`

                      LEFT JOIN `tracking_member_event` AS `tme`
                        ON `tbe`.`tracking_member_event_id`=`tme`.`id`
                      WHERE `tbe`.`book_id` IN (SELECT `book_id`
                                                  FROM `_exploring`)
                            AND `tme`.`member_id` <> `member_id_`
                      GROUP BY `tme`.`member_id` ORDER BY NULL
                  ) AS `sqi`
                INNER JOIN `tracking_member_event` AS `tme` USING (`member_id`)
                GROUP BY `tme`.`id` ORDER BY NULL
            ) AS `sqo`
          INNER JOIN `tracking_book_event` AS `tbe`
            ON `sqo`.`id` = `tbe`.`tracking_member_event_id`
          WHERE `tbe`.`book_id` NOT IN (SELECT `book_id` FROM `_explored`)
          GROUP BY `tbe`.`book_id` ORDER BY NULL;

      SET `i` = `i` + 1;
    END WHILE;

    TRUNCATE TABLE `_exploring`;  -- Cleanup.

    INSERT INTO `_explored` SELECT DISTINCT * FROM `_unexplored`;
    TRUNCATE TABLE `_unexplored`;  -- Cleanup.

    INSERT IGNORE INTO `_candidates`
      SELECT * FROM `_explored`
        WHERE `book_id` NOT IN (SELECT * FROM `_seed`);
    TRUNCATE TABLE `_explored`;  -- Cleanup.
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spGetEmptyScoresFromCandidates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spGetEmptyScoresFromCandidates`()
INSERT INTO `_scores` (`book_id`)
    SELECT DISTINCT `book_id` FROM `_candidates` ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spGetSeed` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spGetSeed`(
    `member_id_` VARCHAR(36)
  )
INSERT INTO `_seed`  -- seed. https://www.youtube.com/watch?v=ZmcFLKV8mfg
    SELECT DISTINCT `tbe`.`book_id` FROM `tracking_book_event` AS `tbe`
      LEFT JOIN `tracking_member_event` AS `tme`
        ON `tbe`.`tracking_member_event_id`=`tme`.`id`
      WHERE `tme`.`member_id`=`member_id_` AND `tbe`.`book_id` IS NOT NULL ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spGetSimilarVocabCandidates` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spGetSimilarVocabCandidates`()
BEGIN
    DECLARE `done` TINYINT(1) UNSIGNED DEFAULT FALSE;
    DECLARE `book_id_` BIGINT(20);

    DECLARE `cur` CURSOR FOR SELECT `book_id` FROM `_seed`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET `done` = TRUE;

    OPEN `cur`;
    `cur_loop`: LOOP
      FETCH `cur` INTO `book_id_`;
      IF `done` THEN
        LEAVE `cur_loop`;
      END IF;

      CALL `_spQueryLSHTablesBookIntoTable`(
        `book_id_`, @`rec_engn_similar_vocab_cands_number`);
      INSERT IGNORE INTO `_candidates`
        SELECT `book_id`, `book_id_` FROM `_lsh_single_query_results`;
      TRUNCATE TABLE `_lsh_single_query_results`;
    END LOOP;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spGetUnexploredFromSeed` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spGetUnexploredFromSeed`()
INSERT INTO `_unexplored`
    SELECT `book_id`, `book_id` AS `origin_book_id` FROM `_seed` ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spIndexAll` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spIndexAll`()
BEGIN
    DECLARE `done` TINYINT(1) UNSIGNED DEFAULT FALSE;
    DECLARE `book_id_` BIGINT(20);

    DECLARE `cur` CURSOR FOR
      SELECT DISTINCT `book_id` FROM `book_words`;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET `done` = TRUE;

    TRUNCATE TABLE `lsh_hashes`;

    OPEN `cur`;
    `cur_loop`: LOOP
      FETCH `cur` INTO `book_id_`;
      IF `done` THEN
        LEAVE `cur_loop`;
      END IF;

      CALL `_spCreateVectorTableForBook`(`book_id_`);
      INSERT INTO `lsh_hashes`
        SELECT `id` AS `table_id`,
               `_sfHashVectorTable`(`id`) AS `hash`,
               `book_id_` AS `book_id`
          FROM `lsh_hash_tables`;
      TRUNCATE TABLE `_book_vector`;
    END LOOP;

  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spQueryLSHTablesBookIntoTable` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spQueryLSHTablesBookIntoTable`(
    `book_id_` BIGINT(20),
    `max_results` INT UNSIGNED
  )
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS `_lsh_single_query_results` (
        `book_id` BIGINT(20),
        PRIMARY KEY (`book_id`) USING HASH
      ) ENGINE=MEMORY;
    TRUNCATE TABLE `_lsh_single_query_results`;

    INSERT INTO `_lsh_single_query_results`
      SELECT `lh2`.`book_id`
        FROM `lsh_hashes` AS `lh1`
        INNER JOIN `lsh_hashes` AS `lh2` USING (`table_id`, `hash`)
        WHERE `lh1`.`book_id`=`book_id_` AND `lh2`.`book_id`<>`book_id_`
        GROUP BY `lh2`.`book_id`
        ORDER BY COUNT(*) DESC
        LIMIT `max_results`;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spQueryLSHTablesTableIntoTable` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spQueryLSHTablesTableIntoTable`()
BEGIN
    CREATE TEMPORARY TABLE IF NOT EXISTS `_lsh_multiple_query_results` (
        `book_id` BIGINT(20),
        `similarity` INT UNSIGNED,
        PRIMARY KEY (`book_id`) USING HASH,
        INDEX (`similarity`) USING BTREE
      ) ENGINE=MEMORY;
    TRUNCATE TABLE `_lsh_multiple_query_results`;

    INSERT INTO `_lsh_multiple_query_results`
      SELECT `lh2`.`book_id`, COUNT(*) AS `similarity`
        FROM `_scores` AS `s`
        INNER JOIN `lsh_hashes` AS `lh2` USING (`book_id`)
        INNER JOIN `lsh_hashes` AS `lh1` USING (`table_id`, `hash`)
        WHERE `lh1`.`book_id` IN (SELECT * FROM `_seed`)
        GROUP BY `lh2`.`book_id` ORDER BY NULL;

    -- INSERT INTO `_lsh_multiple_query_results`
    --   SELECT `lh2`.`book_id`, COUNT(*) AS `similarity`
    --     FROM `lsh_hashes` AS `lh1`
    --     INNER JOIN `lsh_hashes` AS `lh2` USING (`table_id`, `hash`)
    --     WHERE `lh1`.`book_id` IN (SELECT * FROM `_seed`)
    --           AND `lh2`.`book_id` IN (SELECT `book_id` FROM `_scores`)
    --     GROUP BY `lh2`.`book_id` ORDER BY NULL;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spSetLSHParameters` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spSetLSHParameters`()
BEGIN
    SET @`word_lsh_axes_count` = 500;
    SET @`word_lsh_k` = 1;
    SET @`word_lsh_L` = 128;
    SET @`word_lsh_radius` = 0.5;
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `_spSetReccEngnParameters` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`ckz_stage_au_v1`@`%` PROCEDURE `_spSetReccEngnParameters`()
BEGIN
    SET @`rec_engn_common_views_cands_depth` = 1;
    SET @`rec_engn_similar_vocab_cands_number` = 10;

    SET @`rec_engn_quality_weight` = 1;
    SET @`rec_engn_extras_weight` = 1;
    SET @`rec_engn_common_views_weight` = 2;
    SET @`rec_engn_similar_vocab_weight` = 6;
    SET @`rec_engn_level_weight` = 4;
    SET @`rec_engn_diversity_weight` = 2;

    SET @`rec_engn_level_preferred_range` = 2;  -- Std.dev. of bell curve.
  END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-03-07 16:51:13
