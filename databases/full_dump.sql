-- MySQL dump 10.13  Distrib 9.2.0, for macos15.2 (arm64)
--
-- Host: localhost    Database: prinInfo_project
-- ------------------------------------------------------
-- Server version	9.2.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Aircraft`
--

DROP TABLE IF EXISTS `Aircraft`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Aircraft` (
  `aircraft_id` varchar(10) NOT NULL,
  `model` varchar(50) DEFAULT NULL,
  `num_of_seats` int NOT NULL,
  PRIMARY KEY (`aircraft_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Aircraft`
--

LOCK TABLES `Aircraft` WRITE;
/*!40000 ALTER TABLE `Aircraft` DISABLE KEYS */;
INSERT INTO `Aircraft` VALUES ('A319','Mclaughlin and Sons A319',245),('A320','West Ltd A320',350),('A321','Airbus A321',185),('A380','Johnson PLC A380',399),('B737','Smith-Ward B737',196),('B738','Boeing 737-800',160),('B739','Boeing 737-900',170),('B757','Boeing 757',200),('B767','Miller-Stevens B767',329),('B777','Davis-Harper B777',230),('B787','Alexander PLC B787',203),('CAP10','Airbus A321',1),('CRJ7','Hall, King and Harvey CRJ7',465),('E190','Fernandez, Holt and Brown E190',130),('MD80','Fisher, Bennett and Odonnell MD80',284);
/*!40000 ALTER TABLE `Aircraft` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Airline`
--

DROP TABLE IF EXISTS `Airline`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Airline` (
  `airline_id` char(2) NOT NULL,
  `airport_id` char(3) DEFAULT NULL,
  PRIMARY KEY (`airline_id`),
  KEY `airport_id` (`airport_id`),
  CONSTRAINT `airline_ibfk_1` FOREIGN KEY (`airport_id`) REFERENCES `Airport` (`airport_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Airline`
--

LOCK TABLES `Airline` WRITE;
/*!40000 ALTER TABLE `Airline` DISABLE KEYS */;
INSERT INTO `Airline` VALUES ('BA','ATL'),('LH','DEN'),('FR','DFW'),('AA','JFK'),('DL','LAX'),('SW','LHR'),('EK','MIA'),('UA','ORD'),('QR','SEA'),('AF','SFO');
/*!40000 ALTER TABLE `Airline` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Airport`
--

DROP TABLE IF EXISTS `Airport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Airport` (
  `airport_id` char(3) NOT NULL,
  `country_code` char(2) NOT NULL,
  PRIMARY KEY (`airport_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Airport`
--

LOCK TABLES `Airport` WRITE;
/*!40000 ALTER TABLE `Airport` DISABLE KEYS */;
INSERT INTO `Airport` VALUES ('ATL','US'),('DEN','US'),('DFW','US'),('JFK','US'),('LAX','US'),('LHR','GB'),('MIA','US'),('ORD','US'),('SEA','US'),('SFO','US');
/*!40000 ALTER TABLE `Airport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Answer`
--

DROP TABLE IF EXISTS `Answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Answer` (
  `answer_id` int NOT NULL AUTO_INCREMENT,
  `question_id` int DEFAULT NULL,
  `rep_id` int DEFAULT NULL,
  `response` text,
  `responded_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`answer_id`),
  KEY `question_id` (`question_id`),
  KEY `rep_id` (`rep_id`),
  CONSTRAINT `answer_ibfk_1` FOREIGN KEY (`question_id`) REFERENCES `Question` (`question_id`),
  CONSTRAINT `answer_ibfk_2` FOREIGN KEY (`rep_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Answer`
--

LOCK TABLES `Answer` WRITE;
/*!40000 ALTER TABLE `Answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `Answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Customer`
--

DROP TABLE IF EXISTS `Customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Customer` (
  `user_id` int NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customer`
--

LOCK TABLES `Customer` WRITE;
/*!40000 ALTER TABLE `Customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `Customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Flight`
--

DROP TABLE IF EXISTS `Flight`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Flight` (
  `flight_number` int NOT NULL AUTO_INCREMENT,
  `dep_airport` char(3) NOT NULL,
  `dest_airport` char(3) NOT NULL,
  `flight_type` enum('Domestic','International') DEFAULT NULL,
  `dep_time` timestamp NOT NULL,
  `arr_time` timestamp NOT NULL,
  `aircraft_id` varchar(10) NOT NULL,
  `price` decimal(8,2) DEFAULT NULL,
  `duration_minutes` int GENERATED ALWAYS AS (timestampdiff(MINUTE,`dep_time`,`arr_time`)) STORED,
  `airline_id` char(2) DEFAULT NULL,
  `atCapacity` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`flight_number`),
  KEY `dep_airport` (`dep_airport`),
  KEY `dest_airport` (`dest_airport`),
  KEY `aircraft_id` (`aircraft_id`),
  KEY `fk_airline_flight` (`airline_id`),
  CONSTRAINT `fk_airline_flight` FOREIGN KEY (`airline_id`) REFERENCES `Airline` (`airline_id`) ON DELETE CASCADE,
  CONSTRAINT `flight_ibfk_2` FOREIGN KEY (`dep_airport`) REFERENCES `Airport` (`airport_id`),
  CONSTRAINT `flight_ibfk_3` FOREIGN KEY (`dest_airport`) REFERENCES `Airport` (`airport_id`),
  CONSTRAINT `flight_ibfk_4` FOREIGN KEY (`aircraft_id`) REFERENCES `Aircraft` (`aircraft_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8002 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Flight`
--

LOCK TABLES `Flight` WRITE;
/*!40000 ALTER TABLE `Flight` DISABLE KEYS */;
INSERT INTO `Flight` (`flight_number`, `dep_airport`, `dest_airport`, `flight_type`, `dep_time`, `arr_time`, `aircraft_id`, `price`, `airline_id`, `atCapacity`) VALUES (1002,'JFK','ORD','Domestic','2025-05-01 11:00:00','2025-05-01 13:00:00','A320',180.00,'AA',0),(1003,'JFK','ATL','Domestic','2025-05-01 16:00:00','2025-05-01 18:15:00','B737',210.00,'AA',0),(1004,'LAX','ATL','Domestic','2025-05-04 17:00:00','2025-05-04 21:30:00','A320',290.00,'AA',0),(1005,'ORD','JFK','Domestic','2025-05-05 13:30:00','2025-05-05 15:45:00','B737',185.00,'AA',0),(2003,'ATL','JFK','Domestic','2025-05-01 19:00:00','2025-05-01 21:15:00','A320',195.00,'DL',0),(2004,'ATL','LAX','Domestic','2025-05-02 12:30:00','2025-05-02 15:30:00','B737',310.00,'DL',0),(2005,'ATL','ORD','Domestic','2025-05-03 14:00:00','2025-05-03 15:45:00','A320',200.00,'DL',0),(2006,'ATL','JFK','Domestic','2025-05-03 21:00:00','2025-05-03 23:00:00','B737',210.00,'DL',0),(3001,'LAX','MIA','Domestic','2025-05-01 10:00:00','2025-05-01 18:00:00','A320',220.00,'DL',0),(3002,'LAX','MIA','Domestic','2025-05-01 13:30:00','2025-05-01 21:15:00','B738',250.00,'DL',0),(3003,'LAX','MIA','Domestic','2025-05-01 16:00:00','2025-05-01 23:45:00','B739',260.00,'DL',0),(3004,'LAX','MIA','Domestic','2025-05-01 19:45:00','2025-05-02 03:30:00','A321',270.00,'DL',0),(3005,'LAX','MIA','Domestic','2025-05-02 02:30:00','2025-05-02 10:15:00','B757',210.00,'DL',0),(3006,'JFK','LHR','International','2025-05-04 01:00:00','2025-05-04 12:00:00','B777',890.00,'UA',0),(3007,'LHR','ATL','International','2025-05-04 20:00:00','2025-05-05 00:00:00','B777',920.00,'UA',0),(3008,'ORD','LHR','International','2025-05-01 22:00:00','2025-05-02 10:45:00','B777',870.00,'UA',0),(3009,'LHR','ORD','International','2025-05-02 14:00:00','2025-05-02 17:15:00','B777',880.00,'UA',0),(4001,'MIA','LAX','Domestic','2025-05-07 10:00:00','2025-05-07 12:30:00','A321',230.00,'AA',0),(4002,'MIA','LAX','Domestic','2025-05-07 13:00:00','2025-05-07 15:35:00','B738',240.00,'AA',0),(4003,'MIA','LAX','Domestic','2025-05-07 17:30:00','2025-05-07 20:05:00','B739',260.00,'AA',0),(4004,'MIA','LAX','Domestic','2025-05-07 21:00:00','2025-05-07 23:35:00','A320',265.00,'AA',0),(4005,'MIA','LAX','Domestic','2025-05-08 00:30:00','2025-05-08 03:05:00','B757',225.00,'AA',0),(4006,'LHR','ATL','International','2025-05-06 14:00:00','2025-05-06 17:45:00','A380',1020.00,'BA',0),(4007,'LHR','LAX','International','2025-05-06 21:00:00','2025-05-07 02:00:00','A380',1145.00,'BA',0),(4008,'LHR','ORD','International','2025-05-05 15:00:00','2025-05-05 18:30:00','A380',975.00,'BA',0),(5001,'ATL','ORD','Domestic','2025-05-08 12:00:00','2025-05-08 14:00:00','B738',215.00,'AA',0),(5002,'JFK','MIA','Domestic','2025-05-08 15:00:00','2025-05-08 18:00:00','A320',250.00,'DL',0),(5003,'LAX','LHR','International','2025-05-08 20:00:00','2025-05-09 12:00:00','A380',1180.00,'BA',0),(5004,'ATL','LHR','International','2025-05-08 21:00:00','2025-05-09 11:00:00','B777',945.00,'UA',0),(7001,'LAX','MIA','Domestic','2025-05-01 10:00:00','2025-05-01 18:00:00','A320',220.00,'DL',0),(8001,'LAX','MIA','Domestic','2025-05-01 10:00:00','2025-05-01 18:00:00','CAP10',220.00,'DL',1);
/*!40000 ALTER TABLE `Flight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Question`
--

DROP TABLE IF EXISTS `Question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Question` (
  `question_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `message` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`question_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `question_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `Customer` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Question`
--

LOCK TABLES `Question` WRITE;
/*!40000 ALTER TABLE `Question` DISABLE KEYS */;
/*!40000 ALTER TABLE `Question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Reservation`
--

DROP TABLE IF EXISTS `Reservation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Reservation` (
  `reservation_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `flight_number` int DEFAULT NULL,
  `total_fare` decimal(10,2) DEFAULT NULL,
  `booking_fee` decimal(10,2) DEFAULT NULL,
  `booked_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reservation_id`),
  KEY `fk_customer` (`customer_id`),
  KEY `fk_flight` (`flight_number`),
  CONSTRAINT `fk_customer` FOREIGN KEY (`customer_id`) REFERENCES `Users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_flight` FOREIGN KEY (`flight_number`) REFERENCES `Flight` (`flight_number`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reservation`
--

LOCK TABLES `Reservation` WRITE;
/*!40000 ALTER TABLE `Reservation` DISABLE KEYS */;
INSERT INTO `Reservation` VALUES (37,44,8001,220.00,33.00,'2025-05-11 20:59:31');
/*!40000 ALTER TABLE `Reservation` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_at_capacity_after_insert` AFTER INSERT ON `reservation` FOR EACH ROW BEGIN
  DECLARE seat_count INT;
  DECLARE reservation_count INT;

  SELECT a.num_of_seats INTO seat_count
  FROM Flight f
  JOIN Aircraft a ON f.aircraft_id = a.aircraft_id
  WHERE f.flight_number = NEW.flight_number;

  SELECT COUNT(*) INTO reservation_count
  FROM Reservation
  WHERE flight_number = NEW.flight_number;

  UPDATE Flight
  SET atCapacity = IF(reservation_count >= seat_count, TRUE, FALSE)
  WHERE flight_number = NEW.flight_number;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_at_capacity_after_delete` AFTER DELETE ON `reservation` FOR EACH ROW BEGIN
  DECLARE seat_count INT;
  DECLARE reservation_count INT;

  SELECT a.num_of_seats INTO seat_count
  FROM Flight f
  JOIN Aircraft a ON f.aircraft_id = a.aircraft_id
  WHERE f.flight_number = OLD.flight_number;

  SELECT COUNT(*) INTO reservation_count
  FROM Reservation
  WHERE flight_number = OLD.flight_number;

  UPDATE Flight
  SET atCapacity = IF(reservation_count >= seat_count, TRUE, FALSE)
  WHERE flight_number = OLD.flight_number;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Ticket`
--

DROP TABLE IF EXISTS `Ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ticket` (
  `ticket_number` int NOT NULL AUTO_INCREMENT,
  `travel_class` enum('Economy','Business','First') DEFAULT NULL,
  `departure_date` date DEFAULT NULL,
  `passenger_first_name` varchar(50) DEFAULT NULL,
  `passenger_last_name` varchar(50) DEFAULT NULL,
  `purchased_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `dep_flight_number` int DEFAULT NULL,
  `passenger_id` int DEFAULT NULL,
  `dep_reservation_id` int DEFAULT NULL,
  `return_date` date DEFAULT NULL,
  `return_reservation_id` int DEFAULT NULL,
  `dep_seat_number` int DEFAULT NULL,
  `ret_seat_number` int DEFAULT NULL,
  `ret_flight_number` int DEFAULT NULL,
  PRIMARY KEY (`ticket_number`),
  UNIQUE KEY `unique_user_dep` (`passenger_id`,`dep_flight_number`),
  UNIQUE KEY `unique_user_ret` (`passenger_id`,`ret_flight_number`),
  KEY `fk_ticket_flight` (`dep_flight_number`),
  KEY `fk_ticket_dep_reservation` (`dep_reservation_id`),
  KEY `fk_ticket_return_reservation` (`return_reservation_id`),
  KEY `fk_ticket_ret_flight` (`ret_flight_number`),
  CONSTRAINT `fk_ticket_dep_reservation` FOREIGN KEY (`dep_reservation_id`) REFERENCES `Reservation` (`reservation_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ticket_flight` FOREIGN KEY (`dep_flight_number`) REFERENCES `Flight` (`flight_number`) ON DELETE CASCADE,
  CONSTRAINT `fk_ticket_ret_flight` FOREIGN KEY (`ret_flight_number`) REFERENCES `Flight` (`flight_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ticket_return_reservation` FOREIGN KEY (`return_reservation_id`) REFERENCES `Reservation` (`reservation_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ticket_user` FOREIGN KEY (`passenger_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ticket`
--

LOCK TABLES `Ticket` WRITE;
/*!40000 ALTER TABLE `Ticket` DISABLE KEYS */;
INSERT INTO `Ticket` VALUES (25,NULL,'2025-05-01','A','D','2025-05-11 20:59:31',8001,44,37,NULL,NULL,1,NULL,NULL);
/*!40000 ALTER TABLE `Ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(20) NOT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('Customer','Rep','Admin') NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_id_UNIQUE` (`user_id`),
  UNIQUE KEY `email_UNIQUE` (`email`),
  UNIQUE KEY `username_UNIQUE` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'test',NULL,NULL,'test_email@email.com','test_password','Customer'),(2,'test2','A','D','test2@gmail.com','pass','Customer'),(4,'test3','A','D','test3@gmail.com','pass','Customer'),(6,'test4','A','D','test4@gmail.com','pass','Customer'),(15,'test6','A','D','test6@gmail.com','pass','Customer'),(16,'test7','A','D','test7@gmail.com','pass','Customer'),(17,'test8','A','D','test8@gmail.com','pass','Customer'),(18,'test9','A','D','test9@gmail.com','pass','Customer'),(19,'test10','A','D','test10@gmail.com','pass','Customer'),(20,'test11','A','D','test11@gmail.com','pass','Rep'),(21,'test_1','t','t','test_1@gmail.com','pass','Customer'),(22,'project2_deliverable','Project','Deliverable','project2_deliverable@gmail.com','password','Customer'),(24,'project','Project','2','project@gmail.com','password','Rep'),(25,'project_test','Project','Test','project_test@gmail.com','pass','Customer'),(26,'project_test2','Project','Test2','project_test2@gmail.com','pass','Admin'),(30,'testtestset','aa','a','testesttes@gmail.com','pass','Customer'),(31,'test_admin1','A','D','test_admin1@gmail.com','pass','Customer'),(32,'test_admin_1','A','D','test_admin_1@gmail.com','pass','Customer'),(33,'test_rep_1','A','D','test_rep_1@gmail.com','pass','Rep'),(35,'test_rep_2','A','D','test_rep_2@gmail.com','pass','Rep'),(37,'test_admin_2','A','D','test_admin_2@gmail.com','pass','Admin'),(38,'test_customer_1','A','D','test_customer_1@gmail.com','pass','Customer'),(39,'test_customer_2','A','D','test_customer_2@gmail.com','pass','Customer'),(40,'test_customer_3','A','D','test_customer_3@gmail.com','pass','Customer'),(42,'t1','A','D','t1','pass','Customer'),(43,'t2','A','','t2','pass','Customer'),(44,'t4','A','D','t4','pass','Customer'),(45,'t5','a','a','t5','oass','Customer'),(46,'t6','a','a','t6','pass','Customer');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WaitList`
--

DROP TABLE IF EXISTS `WaitList`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WaitList` (
  `flight_number` int DEFAULT NULL,
  `request_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `waitlist_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `notified` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`waitlist_id`),
  KEY `fk_waitlist_flight` (`flight_number`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `fk_waitlist_flight` FOREIGN KEY (`flight_number`) REFERENCES `Flight` (`flight_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `waitlist_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `Users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WaitList`
--

LOCK TABLES `WaitList` WRITE;
/*!40000 ALTER TABLE `WaitList` DISABLE KEYS */;
/*!40000 ALTER TABLE `WaitList` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-11 20:59:53
