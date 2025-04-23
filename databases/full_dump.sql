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
INSERT INTO `Aircraft` VALUES ('A319','Mclaughlin and Sons A319',245),('A320','West Ltd A320',350),('A380','Johnson PLC A380',399),('B737','Smith-Ward B737',196),('B767','Miller-Stevens B767',329),('B777','Davis-Harper B777',230),('B787','Alexander PLC B787',203),('CRJ7','Hall, King and Harvey CRJ7',465),('E190','Fernandez, Holt and Brown E190',130),('MD80','Fisher, Bennett and Odonnell MD80',284);
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
  `flight_number` int NOT NULL,
  `airline_id` char(2) NOT NULL,
  `dep_airport` char(3) NOT NULL,
  `dest_airport` char(3) NOT NULL,
  `flight_type` enum('Domestic','International') DEFAULT NULL,
  `dep_time` timestamp NOT NULL,
  `arr_time` timestamp NOT NULL,
  `aircraft_id` varchar(10) NOT NULL,
  PRIMARY KEY (`flight_number`,`airline_id`),
  KEY `airline_id` (`airline_id`),
  KEY `dep_airport` (`dep_airport`),
  KEY `dest_airport` (`dest_airport`),
  KEY `aircraft_id` (`aircraft_id`),
  CONSTRAINT `flight_ibfk_1` FOREIGN KEY (`airline_id`) REFERENCES `Airline` (`airline_id`),
  CONSTRAINT `flight_ibfk_2` FOREIGN KEY (`dep_airport`) REFERENCES `Airport` (`airport_id`),
  CONSTRAINT `flight_ibfk_3` FOREIGN KEY (`dest_airport`) REFERENCES `Airport` (`airport_id`),
  CONSTRAINT `flight_ibfk_4` FOREIGN KEY (`aircraft_id`) REFERENCES `Aircraft` (`aircraft_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Flight`
--

LOCK TABLES `Flight` WRITE;
/*!40000 ALTER TABLE `Flight` DISABLE KEYS */;
INSERT INTO `Flight` VALUES (1000,'AA','ORD','JFK','Domestic','2025-05-13 15:00:00','2025-05-14 00:00:00','CRJ7'),(1001,'DL','DFW','ORD','International','2025-05-22 12:00:00','2025-05-22 19:00:00','A380'),(1002,'UA','MIA','LAX','Domestic','2025-05-09 12:00:00','2025-05-09 20:00:00','A320'),(1003,'BA','ORD','LAX','Domestic','2025-05-02 09:00:00','2025-05-02 19:00:00','MD80'),(1004,'SW','LAX','SFO','International','2025-05-14 17:00:00','2025-05-15 02:00:00','B777'),(1005,'FR','DEN','LHR','International','2025-05-05 19:00:00','2025-05-06 04:00:00','B767'),(1006,'LH','ATL','DEN','Domestic','2025-05-17 00:00:00','2025-05-17 07:00:00','A319'),(1007,'AF','JFK','SFO','Domestic','2025-05-04 22:00:00','2025-05-05 00:00:00','B787'),(1008,'EK','DFW','DEN','International','2025-05-20 19:00:00','2025-05-21 04:00:00','B737'),(1009,'QR','SEA','DEN','International','2025-05-01 22:00:00','2025-05-02 02:00:00','B737');
/*!40000 ALTER TABLE `Flight` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Operating_Days`
--

DROP TABLE IF EXISTS `Operating_Days`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Operating_Days` (
  `flight_number` int NOT NULL,
  `airline_id` char(2) NOT NULL,
  `day` enum('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
  PRIMARY KEY (`flight_number`,`airline_id`,`day`),
  CONSTRAINT `operating_days_ibfk_1` FOREIGN KEY (`flight_number`, `airline_id`) REFERENCES `Flight` (`flight_number`, `airline_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Operating_Days`
--

LOCK TABLES `Operating_Days` WRITE;
/*!40000 ALTER TABLE `Operating_Days` DISABLE KEYS */;
INSERT INTO `Operating_Days` VALUES (1000,'AA','Friday'),(1000,'AA','Saturday'),(1000,'AA','Sunday'),(1001,'DL','Tuesday'),(1001,'DL','Thursday'),(1001,'DL','Sunday'),(1002,'UA','Friday'),(1002,'UA','Saturday'),(1002,'UA','Sunday'),(1003,'BA','Tuesday'),(1003,'BA','Wednesday'),(1003,'BA','Sunday'),(1004,'SW','Monday'),(1004,'SW','Friday'),(1004,'SW','Saturday'),(1005,'FR','Monday'),(1005,'FR','Tuesday'),(1005,'FR','Thursday'),(1006,'LH','Monday'),(1006,'LH','Friday'),(1006,'LH','Saturday'),(1007,'AF','Monday'),(1007,'AF','Tuesday'),(1007,'AF','Sunday'),(1008,'EK','Tuesday'),(1008,'EK','Thursday'),(1008,'EK','Saturday'),(1009,'QR','Monday'),(1009,'QR','Thursday'),(1009,'QR','Sunday');
/*!40000 ALTER TABLE `Operating_Days` ENABLE KEYS */;
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
  `total_fare` decimal(10,2) DEFAULT NULL,
  `booking_fee` decimal(10,2) DEFAULT NULL,
  `booked_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`reservation_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `reservation_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `Customer` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Reservation`
--

LOCK TABLES `Reservation` WRITE;
/*!40000 ALTER TABLE `Reservation` DISABLE KEYS */;
/*!40000 ALTER TABLE `Reservation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Ticket`
--

DROP TABLE IF EXISTS `Ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Ticket` (
  `ticket_number` int NOT NULL AUTO_INCREMENT,
  `reservation_id` int DEFAULT NULL,
  `flight_number` int DEFAULT NULL,
  `airline_id` char(2) DEFAULT NULL,
  `seat_number` varchar(5) DEFAULT NULL,
  `travel_class` enum('Economy','Business','First') DEFAULT NULL,
  `departure_date` date DEFAULT NULL,
  `passenger_first_name` varchar(50) DEFAULT NULL,
  `passenger_last_name` varchar(50) DEFAULT NULL,
  `passenger_id_number` varchar(20) DEFAULT NULL,
  `purchased_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`ticket_number`),
  KEY `reservation_id` (`reservation_id`),
  KEY `flight_number` (`flight_number`,`airline_id`),
  CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `Reservation` (`reservation_id`),
  CONSTRAINT `ticket_ibfk_2` FOREIGN KEY (`flight_number`, `airline_id`) REFERENCES `Flight` (`flight_number`, `airline_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Ticket`
--

LOCK TABLES `Ticket` WRITE;
/*!40000 ALTER TABLE `Ticket` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Users`
--

LOCK TABLES `Users` WRITE;
/*!40000 ALTER TABLE `Users` DISABLE KEYS */;
INSERT INTO `Users` VALUES (1,'test',NULL,NULL,'test_email@email.com','test_password','Customer'),(2,'test2','A','D','test2@gmail.com','pass','Customer'),(4,'test3','A','D','test3@gmail.com','pass','Customer'),(6,'test4','A','D','test4@gmail.com','pass','Customer'),(15,'test6','A','D','test6@gmail.com','pass','Customer'),(16,'test7','A','D','test7@gmail.com','pass','Customer'),(17,'test8','A','D','test8@gmail.com','pass','Customer'),(18,'test9','A','D','test9@gmail.com','pass','Customer'),(19,'test10','A','D','test10@gmail.com','pass','Customer'),(20,'test11','A','D','test11@gmail.com','pass','Rep'),(21,'test_1','t','t','test_1@gmail.com','pass','Customer'),(22,'project2_deliverable','Project','Deliverable','project2_deliverable@gmail.com','password','Customer'),(24,'project','Project','2','project@gmail.com','password','Rep'),(25,'project_test','Project','Test','project_test@gmail.com','pass','Customer'),(26,'project_test2','Project','Test2','project_test2@gmail.com','pass','Admin'),(30,'testtestset','aa','a','testesttes@gmail.com','pass','Customer');
/*!40000 ALTER TABLE `Users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WaitingList`
--

DROP TABLE IF EXISTS `WaitingList`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WaitingList` (
  `flight_number` int NOT NULL,
  `airline_id` char(2) NOT NULL,
  `customer_id` int NOT NULL,
  `request_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`flight_number`,`airline_id`,`customer_id`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `waitinglist_ibfk_1` FOREIGN KEY (`flight_number`, `airline_id`) REFERENCES `Flight` (`flight_number`, `airline_id`),
  CONSTRAINT `waitinglist_ibfk_2` FOREIGN KEY (`customer_id`) REFERENCES `Customer` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WaitingList`
--

LOCK TABLES `WaitingList` WRITE;
/*!40000 ALTER TABLE `WaitingList` DISABLE KEYS */;
/*!40000 ALTER TABLE `WaitingList` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-23 16:14:55
