-- MySQL dump 10.13  Distrib 8.4.7, for Win64 (x86_64)
--
-- Host: mysql-156cf17-mkademimane18-eb6f.i.aivencloud.com    Database: chriwbie
-- ------------------------------------------------------
-- Server version	8.4.11

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
-- Temporary view structure for view `VueAnnoncesTanger`
--

DROP TABLE IF EXISTS `VueAnnoncesTanger`;
/*!50001 DROP VIEW IF EXISTS `VueAnnoncesTanger`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `VueAnnoncesTanger` AS SELECT 
 1 AS `id`,
 1 AS `titre`,
 1 AS `description`,
 1 AS `prix`,
 1 AS `ville`,
 1 AS `categorie`,
 1 AS `date_depot`,
 1 AS `statut`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `nom_utilisateur` varchar(100) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `date_creation` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nom_utilisateur` (`nom_utilisateur`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'Admin','Chriwbie','admin@chriwbie.ma','admin','$2y$12$BOo3UM10ju7cxyCR9JQHf.X9RL00TWvW2RtH8IbzZIyRj1NgVVzF6','2026-11-12 15:09:53');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `annonces`
--

DROP TABLE IF EXISTS `annonces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `annonces` (
  `id` int NOT NULL AUTO_INCREMENT,
  `titre` varchar(255) NOT NULL,
  `description` text,
  `prix` decimal(10,2) DEFAULT NULL,
  `ville` varchar(100) DEFAULT NULL,
  `categorie` varchar(100) DEFAULT NULL,
  `photo` varchar(500) DEFAULT NULL,
  `date_creation` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `date_depot` date NOT NULL DEFAULT (curdate()),
  `date_fin` date DEFAULT NULL,
  `annonceur_id` int DEFAULT NULL,
  `statut` varchar(20) NOT NULL DEFAULT 'Active',
  PRIMARY KEY (`id`),
  KEY `idx_annonces_date_depot` (`date_depot`),
  KEY `idx_annonces_date_fin` (`date_fin`),
  KEY `fk_annonces_annonceurs` (`annonceur_id`),
  KEY `idx_annonces_ville` (`ville`),
  CONSTRAINT `fk_annonces_annonceurs` FOREIGN KEY (`annonceur_id`) REFERENCES `annonceurs` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `annonces`
--

LOCK TABLES `annonces` WRITE;
/*!40000 ALTER TABLE `annonces` DISABLE KEYS */;
INSERT INTO `annonces` VALUES (1,'Velo test','Annonce pour tester Chriwbie',1501.00,'Tanger','Sport',NULL,'2026-10-21 22:30:55','2026-10-22','2026-11-22',NULL,'Active'),(2,'Fauteuil en rotin naturel','Fauteuil en rotin naturel avec coussin beige. Très bon état, confortable et élégant. À retirer à Tanger.',950.00,'Tanger · Marchan','Maison','','2026-10-21 22:48:33','2026-10-22','2026-11-22',NULL,'Active'),(3,'Fauteuil en rotin naturel','Fauteuil en rotin naturel avec coussin beige. Très bon état, confortable et élégant. À retirer à Tanger.',950.00,'Tanger · Marchan','Électronique','','2026-10-22 20:30:19','2026-10-22','2026-11-22',NULL,'Active'),(4,'Fauteuil en rotin naturel','Fauteuil en rotin naturel avec coussin beige. Très bon état, confortable et élégant. À retirer à Tanger.',950.00,'Tanger · Marchan','Électronique','','2026-10-22 20:36:19','2026-10-22','2026-11-22',NULL,'Active'),(5,'hhh','',0.00,'jjjjj','Électronique','https://res.cloudinary.com/cijkbt4w/image/upload/v1792843942/chriwbie/kci3e17nwl6k2jz1gu2e.png','2026-10-24 12:12:23','2026-10-24','2026-11-23',1,'Active'),(6,'Something','',250.00,'Tanger','Immobilier','https://res.cloudinary.com/cijkbt4w/image/upload/v1792844091/chriwbie/sxkpljgjx2ecpcijrwbx.png','2026-10-24 12:14:53','2026-10-24','2026-11-23',1,'Active'),(7,'nh','hjjm',7.00,'ghnn','Maison','https://res.cloudinary.com/cijkbt4w/image/upload/v1792865820/chriwbie/t0q7maigc1fjq1qigjm4.jpg','2026-10-24 18:17:03','2026-10-24','2026-11-11',1,'Expirée'),(8,'Iphone 15','',5600.00,'Tanger','Électronique','','2026-11-15 14:44:22','2026-11-15','2026-12-15',1,'Refusée'),(9,'Villa','',NULL,'tanger','Maison','','2026-11-15 14:49:53','2026-11-15','2026-12-15',1,'Active'),(10,'maison','',NULL,'tanger','Maison','','2026-11-16 11:42:54','2026-11-16','2026-12-16',1,'En attente'),(11,'some','',NULL,'','Maison','','2026-11-18 17:35:36','2026-11-18',NULL,1,'Active'),(12,'m','',0.01,'','Maison','https://res.cloudinary.com/cijkbt4w/image/upload/v1795023688/chriwbie/gxetwrtrq3ab83yyeopy.png','2026-11-18 17:41:31','2026-11-18',NULL,1,'Active');
/*!40000 ALTER TABLE `annonces` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`avnadmin`@`%`*/ /*!50003 TRIGGER `verifier_annonceur_avant_ajout` BEFORE INSERT ON `annonces` FOR EACH ROW BEGIN
    IF NEW.annonceur_id IS NULL
       OR NOT EXISTS (
           SELECT 1
           FROM annonceurs
           WHERE id = NEW.annonceur_id
       )
    THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Erreur : annonceur inexistant';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`avnadmin`@`%`*/ /*!50003 TRIGGER `copier_annonce_apres_ajout` AFTER INSERT ON `annonces` FOR EACH ROW BEGIN
    INSERT INTO copie_annonces (
        id, titre, description, prix, ville,
        categorie, photo, date_creation
    )
    VALUES (
        NEW.id, NEW.titre, NEW.description, NEW.prix,
        NEW.ville, NEW.categorie, NEW.photo, NEW.date_creation
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`avnadmin`@`%`*/ /*!50003 TRIGGER `enregistrer_modification_annonce` AFTER UPDATE ON `annonces` FOR EACH ROW BEGIN
    IF NOT (OLD.prix <=> NEW.prix)
       OR NOT (OLD.statut <=> NEW.statut) THEN

        INSERT INTO historique_annonces (
            annonce_id,
            ancienne_valeur,
            nouvelle_valeur,
            type_modification
        )
        VALUES (
            NEW.id,
            CONCAT('Prix: ', OLD.prix, ' | Statut: ', OLD.statut),
            CONCAT('Prix: ', NEW.prix, ' | Statut: ', NEW.statut),
            'Modification annonce'
        );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `annonces_backup`
--

DROP TABLE IF EXISTS `annonces_backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `annonces_backup` (
  `id` int NOT NULL,
  `titre` varchar(255) NOT NULL,
  `description` text,
  `prix` decimal(10,2) DEFAULT NULL,
  `ville` varchar(100) DEFAULT NULL,
  `categorie` varchar(100) DEFAULT NULL,
  `photo` varchar(500) DEFAULT NULL,
  `date_creation` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `annonces_backup`
--

LOCK TABLES `annonces_backup` WRITE;
/*!40000 ALTER TABLE `annonces_backup` DISABLE KEYS */;
INSERT INTO `annonces_backup` VALUES (1,'Velo test','Annonce pour tester Chriwbie',1500.00,'Tanger','Sport',NULL,'2026-10-21 22:30:55'),(2,'Fauteuil en rotin naturel','Fauteuil en rotin naturel avec coussin beige. Très bon état, confortable et élégant. À retirer à Tanger.',950.00,'Tanger · Marchan','Maison','','2026-10-21 22:48:33'),(3,'Fauteuil en rotin naturel','Fauteuil en rotin naturel avec coussin beige. Très bon état, confortable et élégant. À retirer à Tanger.',950.00,'Tanger · Marchan','Électronique','','2026-10-22 20:30:19'),(4,'Fauteuil en rotin naturel','Fauteuil en rotin naturel avec coussin beige. Très bon état, confortable et élégant. À retirer à Tanger.',950.00,'Tanger · Marchan','Électronique','','2026-10-22 20:36:19');
/*!40000 ALTER TABLE `annonces_backup` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `annonceurs`
--

DROP TABLE IF EXISTS `annonceurs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `annonceurs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `prenom` varchar(100) NOT NULL,
  `type_annonceur` enum('particulier','professionnel') NOT NULL,
  `nom_entreprise` varchar(150) DEFAULT NULL,
  `adresse` varchar(255) DEFAULT NULL,
  `ville` varchar(100) DEFAULT NULL,
  `telephone` varchar(10) DEFAULT NULL,
  `fax` varchar(10) DEFAULT NULL,
  `email` varchar(150) NOT NULL,
  `site_web` varchar(255) DEFAULT NULL,
  `nom_utilisateur` varchar(100) NOT NULL,
  `mot_de_passe` varchar(255) NOT NULL,
  `date_inscription` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `nom_utilisateur` (`nom_utilisateur`),
  KEY `idx_annonceurs_nom` (`nom`),
  KEY `idx_annonceurs_prenom` (`prenom`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `annonceurs`
--

LOCK TABLES `annonceurs` WRITE;
/*!40000 ALTER TABLE `annonceurs` DISABLE KEYS */;
INSERT INTO `annonceurs` VALUES (1,'Chriwbie','Demo','particulier',NULL,NULL,NULL,NULL,NULL,'annonce-demo@chriwbie.ma',NULL,'chriwbie_demo','$2y$10$EOkqFYqxZ5YFnUM0HCvRD.SQ8JVv/7Z2/fkFtbGNJtAryaS8BfU9q','2026-10-24 12:04:41');
/*!40000 ALTER TABLE `annonceurs` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`avnadmin`@`%`*/ /*!50003 TRIGGER `verifier_annonces_avant_suppression` BEFORE DELETE ON `annonceurs` FOR EACH ROW BEGIN
    IF EXISTS (
        SELECT 1
        FROM annonces
        WHERE annonceur_id = OLD.id
          AND date_fin >= CURDATE()
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Impossible de supprimer cet annonceur : annonces encore valides';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nom` (`nom`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Véhicule','Voitures, motos et vélos'),(2,'Multimédia','Smartphones, tablettes et ordinateurs'),(3,'Immobilier','Maisons, appartements et terrains'),(4,'Emploi','Offres et demandes d?emploi'),(5,'Formation','Cours et formations'),(6,'Maison','Meubles et décoration'),(7,'Services','Services proposés'),(8,'Sport','Matériel et équipements sportifs');
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `copie_annonces`
--

DROP TABLE IF EXISTS `copie_annonces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `copie_annonces` (
  `id` int NOT NULL,
  `titre` varchar(255) NOT NULL,
  `description` text,
  `prix` decimal(10,2) DEFAULT NULL,
  `ville` varchar(100) DEFAULT NULL,
  `categorie` varchar(100) DEFAULT NULL,
  `photo` varchar(500) DEFAULT NULL,
  `date_creation` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `copie_annonces`
--

LOCK TABLES `copie_annonces` WRITE;
/*!40000 ALTER TABLE `copie_annonces` DISABLE KEYS */;
INSERT INTO `copie_annonces` VALUES (1,'Velo test','Annonce pour tester Chriwbie',1500.00,'Tanger','Sport',NULL,'2026-10-21 22:30:55'),(2,'Fauteuil en rotin naturel','Fauteuil en rotin naturel avec coussin beige. Très bon état, confortable et élégant. À retirer à Tanger.',950.00,'Tanger · Marchan','Maison','','2026-10-21 22:48:33'),(3,'Fauteuil en rotin naturel','Fauteuil en rotin naturel avec coussin beige. Très bon état, confortable et élégant. À retirer à Tanger.',950.00,'Tanger · Marchan','Électronique','','2026-10-22 20:30:19'),(4,'Fauteuil en rotin naturel','Fauteuil en rotin naturel avec coussin beige. Très bon état, confortable et élégant. À retirer à Tanger.',950.00,'Tanger · Marchan','Électronique','','2026-10-22 20:36:19'),(5,'hhh','',0.00,'jjjjj','Électronique','https://res.cloudinary.com/cijkbt4w/image/upload/v1792843942/chriwbie/kci3e17nwl6k2jz1gu2e.png','2026-10-24 12:12:23'),(6,'Something','',250.00,'Tanger','Immobilier','https://res.cloudinary.com/cijkbt4w/image/upload/v1792844091/chriwbie/sxkpljgjx2ecpcijrwbx.png','2026-10-24 12:14:53'),(7,'nh','hjjm',7.00,'ghnn','Maison','https://res.cloudinary.com/cijkbt4w/image/upload/v1792865820/chriwbie/t0q7maigc1fjq1qigjm4.jpg','2026-10-24 18:17:03'),(8,'Iphone 15','',5600.00,'Tanger','Électronique','','2026-11-15 14:44:22'),(9,'Villa','',NULL,'tanger','Maison','','2026-11-15 14:49:53'),(10,'maison','',NULL,'tanger','Maison','','2026-11-16 11:42:54'),(11,'some','',NULL,'','Maison','','2026-11-18 17:35:36'),(12,'m','',0.01,'','Maison','https://res.cloudinary.com/cijkbt4w/image/upload/v1795023688/chriwbie/gxetwrtrq3ab83yyeopy.png','2026-11-18 17:41:31');
/*!40000 ALTER TABLE `copie_annonces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `favoris`
--

DROP TABLE IF EXISTS `favoris`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `favoris` (
  `id` int NOT NULL AUTO_INCREMENT,
  `annonceur_id` int NOT NULL,
  `annonce_id` int NOT NULL,
  `date_ajout` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `annonceur_id` (`annonceur_id`,`annonce_id`),
  KEY `annonce_id` (`annonce_id`),
  CONSTRAINT `favoris_ibfk_1` FOREIGN KEY (`annonceur_id`) REFERENCES `annonceurs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `favoris_ibfk_2` FOREIGN KEY (`annonce_id`) REFERENCES `annonces` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `favoris`
--

LOCK TABLES `favoris` WRITE;
/*!40000 ALTER TABLE `favoris` DISABLE KEYS */;
/*!40000 ALTER TABLE `favoris` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historique_annonces`
--

DROP TABLE IF EXISTS `historique_annonces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historique_annonces` (
  `id` int NOT NULL AUTO_INCREMENT,
  `annonce_id` int NOT NULL,
  `ancienne_valeur` text,
  `nouvelle_valeur` text,
  `type_modification` varchar(100) NOT NULL,
  `date_modification` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `annonce_id` (`annonce_id`),
  CONSTRAINT `historique_annonces_ibfk_1` FOREIGN KEY (`annonce_id`) REFERENCES `annonces` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historique_annonces`
--

LOCK TABLES `historique_annonces` WRITE;
/*!40000 ALTER TABLE `historique_annonces` DISABLE KEYS */;
INSERT INTO `historique_annonces` VALUES (1,1,'Prix: 1500.00 | Statut: Active','Prix: 1501.00 | Statut: Active','Modification annonce','2026-11-19 14:17:30');
/*!40000 ALTER TABLE `historique_annonces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `annonce_id` int NOT NULL,
  `expediteur_id` int NOT NULL,
  `destinataire_id` int NOT NULL,
  `sujet` varchar(150) DEFAULT NULL,
  `contenu` text NOT NULL,
  `date_envoi` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `lu` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `annonce_id` (`annonce_id`),
  KEY `expediteur_id` (`expediteur_id`),
  KEY `destinataire_id` (`destinataire_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`annonce_id`) REFERENCES `annonces` (`id`),
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`expediteur_id`) REFERENCES `annonceurs` (`id`),
  CONSTRAINT `messages_ibfk_3` FOREIGN KEY (`destinataire_id`) REFERENCES `annonceurs` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `photos_annonces`
--

DROP TABLE IF EXISTS `photos_annonces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `photos_annonces` (
  `id` int NOT NULL AUTO_INCREMENT,
  `annonce_id` int NOT NULL,
  `chemin_photo` varchar(500) NOT NULL,
  `format_photo` varchar(10) DEFAULT 'JPG',
  `taille_ko` decimal(8,2) DEFAULT NULL,
  `date_ajout` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `annonce_id` (`annonce_id`),
  CONSTRAINT `photos_annonces_ibfk_1` FOREIGN KEY (`annonce_id`) REFERENCES `annonces` (`id`) ON DELETE CASCADE,
  CONSTRAINT `chk_taille_photo` CHECK (((`taille_ko` is null) or (`taille_ko` <= 100)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `photos_annonces`
--

LOCK TABLES `photos_annonces` WRITE;
/*!40000 ALTER TABLE `photos_annonces` DISABLE KEYS */;
/*!40000 ALTER TABLE `photos_annonces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `prolongations_annonces`
--

DROP TABLE IF EXISTS `prolongations_annonces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prolongations_annonces` (
  `id` int NOT NULL AUTO_INCREMENT,
  `annonce_id` int NOT NULL,
  `date_demande` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `nouvelle_date_fin` date NOT NULL,
  `statut` enum('en_attente','acceptee','refusee') NOT NULL DEFAULT 'en_attente',
  PRIMARY KEY (`id`),
  KEY `annonce_id` (`annonce_id`),
  CONSTRAINT `prolongations_annonces_ibfk_1` FOREIGN KEY (`annonce_id`) REFERENCES `annonces` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `prolongations_annonces`
--

LOCK TABLES `prolongations_annonces` WRITE;
/*!40000 ALTER TABLE `prolongations_annonces` DISABLE KEYS */;
/*!40000 ALTER TABLE `prolongations_annonces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `signalements`
--

DROP TABLE IF EXISTS `signalements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `signalements` (
  `id` int NOT NULL AUTO_INCREMENT,
  `annonce_id` int NOT NULL,
  `annonceur_id` int NOT NULL,
  `motif` varchar(255) NOT NULL,
  `description` text,
  `statut` enum('en_attente','traite','rejete') NOT NULL DEFAULT 'en_attente',
  `date_signalement` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `annonce_id` (`annonce_id`),
  KEY `annonceur_id` (`annonceur_id`),
  CONSTRAINT `signalements_ibfk_1` FOREIGN KEY (`annonce_id`) REFERENCES `annonces` (`id`) ON DELETE CASCADE,
  CONSTRAINT `signalements_ibfk_2` FOREIGN KEY (`annonceur_id`) REFERENCES `annonceurs` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `signalements`
--

LOCK TABLES `signalements` WRITE;
/*!40000 ALTER TABLE `signalements` DISABLE KEYS */;
/*!40000 ALTER TABLE `signalements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sous_categories`
--

DROP TABLE IF EXISTS `sous_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sous_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  `categorie_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nom` (`nom`,`categorie_id`),
  KEY `categorie_id` (`categorie_id`),
  CONSTRAINT `sous_categories_ibfk_1` FOREIGN KEY (`categorie_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sous_categories`
--

LOCK TABLES `sous_categories` WRITE;
/*!40000 ALTER TABLE `sous_categories` DISABLE KEYS */;
INSERT INTO `sous_categories` VALUES (8,'Appartement',3),(7,'Maison',3),(2,'Moto',1),(6,'Ordinateur',2),(4,'Smartphone',2),(5,'Tablette',2),(3,'Vélo',1),(1,'Voiture',1);
/*!40000 ALTER TABLE `sous_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `validation_annonces`
--

DROP TABLE IF EXISTS `validation_annonces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `validation_annonces` (
  `id` int NOT NULL AUTO_INCREMENT,
  `annonce_id` int NOT NULL,
  `statut` enum('en_attente','acceptee','refusee') NOT NULL DEFAULT 'en_attente',
  `commentaire_admin` text,
  `date_validation` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `annonce_id` (`annonce_id`),
  CONSTRAINT `validation_annonces_ibfk_1` FOREIGN KEY (`annonce_id`) REFERENCES `annonces` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `validation_annonces`
--

LOCK TABLES `validation_annonces` WRITE;
/*!40000 ALTER TABLE `validation_annonces` DISABLE KEYS */;
/*!40000 ALTER TABLE `validation_annonces` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `villes`
--

DROP TABLE IF EXISTS `villes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `villes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nom` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `nom` (`nom`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `villes`
--

LOCK TABLES `villes` WRITE;
/*!40000 ALTER TABLE `villes` DISABLE KEYS */;
INSERT INTO `villes` VALUES (7,'Agadir'),(4,'Casablanca'),(5,'Fès'),(10,'Kénitra'),(6,'Marrakech'),(8,'Meknès'),(9,'Oujda'),(3,'Rabat'),(1,'Tanger'),(2,'Tétouan');
/*!40000 ALTER TABLE `villes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'chriwbie'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `event_desactiver_annonces_expirees` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = cp850 */ ;;
/*!50003 SET character_set_results = cp850 */ ;;
/*!50003 SET collation_connection  = cp850_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE*/ /*!50117 DEFINER=`avnadmin`@`%`*/ /*!50106 EVENT `event_desactiver_annonces_expirees` ON SCHEDULE EVERY 1 DAY STARTS '2026-11-13 14:48:14' ON COMPLETION NOT PRESERVE ENABLE DO CALL desactiver_annonces_expirees() */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'chriwbie'
--
/*!50003 DROP FUNCTION IF EXISTS `calculer_date_expiration` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" FUNCTION "calculer_date_expiration"(p_date_publication DATE) RETURNS date
    DETERMINISTIC
BEGIN
    RETURN DATE_ADD(p_date_publication, INTERVAL 30 DAY);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `compter_annonces` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" FUNCTION "compter_annonces"(
    p_titre VARCHAR(255),
    p_ville VARCHAR(100)
) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM annonces
    WHERE titre LIKE CONCAT('%', p_titre, '%')
      AND ville = p_ville;

    RETURN total;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `compter_annonceurs_ville` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" FUNCTION "compter_annonceurs_ville"(
    p_ville VARCHAR(100),
    p_type VARCHAR(20)
) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE total INT;

    SELECT COUNT(DISTINCT a.id) INTO total
    FROM annonces a
    JOIN annonceurs an ON a.annonceur_id = an.id
    WHERE an.ville = p_ville
      AND an.type_annonceur = p_type;

    RETURN total;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `NombreAnnoncesParStatut` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" FUNCTION "NombreAnnoncesParStatut"(
    p_statut VARCHAR(20)
) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM annonces
    WHERE statut = p_statut;

    RETURN total;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `NombreAnnoncesParVille` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" FUNCTION "NombreAnnoncesParVille"(
    p_ville VARCHAR(100)
) RETURNS int
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*)
    INTO total
    FROM annonces
    WHERE ville LIKE CONCAT('%', p_ville, '%');

    RETURN total;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `PrixMoyenAnnonces` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" FUNCTION "PrixMoyenAnnonces"() RETURNS decimal(10,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE moyenne DECIMAL(10,2);

    SELECT AVG(prix)
    INTO moyenne
    FROM annonces
    WHERE prix IS NOT NULL;

    RETURN moyenne;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AfficherAnnonceMoinsChere` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "AfficherAnnonceMoinsChere"()
BEGIN
    SELECT *
    FROM annonces
    WHERE prix IS NOT NULL
    ORDER BY prix ASC
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AfficherAnnoncesParCategorie` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "AfficherAnnoncesParCategorie"(
    IN p_categorie VARCHAR(100)
)
BEGIN
    SELECT *
    FROM annonces
    WHERE categorie = p_categorie;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AfficherAnnoncesParVille` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "AfficherAnnoncesParVille"(
    IN p_ville VARCHAR(100)
)
BEGIN
    SELECT *
    FROM annonces
    WHERE ville LIKE CONCAT('%', p_ville, '%');
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `afficher_dates_annonces` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "afficher_dates_annonces"()
BEGIN
    DECLARE fini INT DEFAULT 0;
    DECLARE v_id INT;
    DECLARE v_titre VARCHAR(255);
    DECLARE v_depot DATE;
    DECLARE v_fin DATE;

    DECLARE curseur CURSOR FOR
        SELECT id, titre, date_depot, date_fin
        FROM annonces;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fini = 1;

    CREATE TEMPORARY TABLE IF NOT EXISTS resultat_dates (
        id INT,
        titre VARCHAR(255),
        date_depot DATE,
        date_fin DATE
    );

    TRUNCATE TABLE resultat_dates;

    OPEN curseur;

    boucle: LOOP
        FETCH curseur INTO v_id, v_titre, v_depot, v_fin;

        IF fini = 1 THEN
            LEAVE boucle;
        END IF;

        INSERT INTO resultat_dates
        VALUES (v_id, v_titre, v_depot, v_fin);
    END LOOP;

    CLOSE curseur;

    SELECT * FROM resultat_dates;
    DROP TEMPORARY TABLE resultat_dates;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `annonces_vtt_particuliers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "annonces_vtt_particuliers"()
BEGIN
    SELECT a.*
    FROM annonces a
    JOIN annonceurs an ON a.annonceur_id = an.id
    WHERE a.titre LIKE '%VTT%'
      AND an.type_annonceur = 'particulier';
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `desactiver_annonces_expirees` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "desactiver_annonces_expirees"()
BEGIN
    UPDATE annonces
    SET statut = 'Expir�e'
    WHERE date_fin < CURDATE()
      AND statut = 'Active';

    SELECT ROW_COUNT() AS nombre_annonces_desactivees;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `prix_pc_moins_cher` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "prix_pc_moins_cher"()
BEGIN
    SELECT *
    FROM annonces
    WHERE titre LIKE '%PC%'
       OR titre LIKE '%ordinateur%'
       OR categorie = 'Multim�dia'
    ORDER BY prix ASC
    LIMIT 1;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `statistiques_annonceurs_ville` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "statistiques_annonceurs_ville"(
    IN p_ville VARCHAR(100)
)
BEGIN
    SELECT
        p_ville AS ville,
        SUM(CASE WHEN type_annonceur = 'particulier'
            THEN 1 ELSE 0 END) AS particuliers,
        SUM(CASE WHEN type_annonceur = 'professionnel'
            THEN 1 ELSE 0 END) AS professionnels,
        COUNT(*) AS total
    FROM annonceurs
    WHERE ville = p_ville;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `VueAnnoncesTanger`
--

/*!50001 DROP VIEW IF EXISTS `VueAnnoncesTanger`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = cp850 */;
/*!50001 SET character_set_results     = cp850 */;
/*!50001 SET collation_connection      = cp850_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`avnadmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `VueAnnoncesTanger` AS select `annonces`.`id` AS `id`,`annonces`.`titre` AS `titre`,`annonces`.`description` AS `description`,`annonces`.`prix` AS `prix`,`annonces`.`ville` AS `ville`,`annonces`.`categorie` AS `categorie`,`annonces`.`date_depot` AS `date_depot`,`annonces`.`statut` AS `statut` from `annonces` where (`annonces`.`ville` like 'Tanger%') */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-19 14:23:34
