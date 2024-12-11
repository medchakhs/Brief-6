-- name : Mohammed Ech.Chakhs
-- email : mohachakhs0@gmail.com

-- creation d'un table testMoveie

CREATE DATABASE testMoveie;
USE testMoveie;
CREATE TABLE subscription(
    SubscriptionID INT AUTO_INCREMENT PRIMARY KEY,
    SubscriptionType VARCHAR(50) CHECK (SubscriptionType IN ('Basic', 'Premium')) NOT NULL,
    MonthlyFee DECIMAL(10,2) NOT NULL
);

-- creation d'un table subscription

CREATE TABLE Users(
    UserId INT AUTO_INCREMENT PRIMARY key,
    FirstName VARCHAR(100) NOT NULL,
    LastName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    RegistrationDate DATE NOT NULL,
    SubscriptionID INT NOT NULL,
    FOREIGN KEY (SubscriptionID) REFERENCES Subscription(SubscriptionID)
);

-- Creation d'un table movei

CREATE TABLE movei(
    MoveiID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Genre VARCHAR(100) NOT NULL,
    ReleaseYear INT NOT NULL,
    Duration INT NOT NULL,
    Rating VARCHAR(10) NOT NULL
);
-- -- Creation d'un table review

CREATE TABLE Review(
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT NOT NULL,
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    MoveiID INT NOT NULL,
    FOREIGN KEY (MoveiID) REFERENCES movei(MoveiID),
    Rating INT  NOT NULL,
    ReviewText TEXT NULL,
    ReviewDate DATE NOT NULL
);

-- Creation d'un table watchhistory

CREATE TABLE WatchHistory(
    WatchHistoryID INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT NOT NULL,
    FOREIGN KEY (UserId) REFERENCES Users(UserId),
    MoveiID INT NOT NULL,
    FOREIGN KEY (MoveiID) REFERENCES movei(MoveiID),
    WatchDate DATE NOT NULL,
    CompletionPercentage INT DEFAULT 0 NOT NULL
);


-- 1-Insérer un film : Ajouter un nouveau film intitulé Data Science Adventures dans le genre "Documentary".
INSERT INTO movei (Title, Genre, ReleaseYear, Duration, Rating)
VALUES ('Data Science Adventures', 'Documentary', 2023, 20, 1);

-- 2-Rechercher des films : Lister tous les films du genre "Comedy" sortis après 2020

SELECT Title, ReleaseYear, Genre
FROM movei
WHERE Genre = 'Comedy'
  AND ReleaseYear > 2020;

-- 3-Mise à jour des abonnements : Passer tous les utilisateurs de "Basic" à "Premium"..

UPDATE Users
INNER JOIN subscription AS s1 ON Users.SubscriptionID = s1.SubscriptionID
INNER JOIN subscription AS s2 ON s2.SubscriptionType = 'Premium'
SET Users.SubscriptionID = s2.SubscriptionID
WHERE s1.SubscriptionType = 'Basic';

-- 4-Afficher les abonnements : Joindre les utilisateurs à leurs types d'abonnements.

SELECT 
    U.UserId,
    U.FirstName,
    U.LastName,
    U.Email,
    U.RegistrationDate,
    S.SubscriptionType,
    S.MonthlyFee
FROM 
    Users U
INNER JOIN 
    subscription S
ON 
    U.SubscriptionID = S.SubscriptionID;

-- 5-Filtrer les visionnages : Trouver tous les utilisateurs ayant terminé de regarder un film.

SELECT UserId, MoveiID
FROM WatchHistory
WHERE CompletionPercentage = 100;

-- 6-Trier et limiter : Afficher les 5 films les plus longs, triés par durée

SELECT MoveiID, Title, Genre, ReleaseYear, Duration , Rating
FROM movei
ORDER BY Duration DESC LIMIT 5;

-- 7-Agrégation : Calculer le pourcentage moyen de complétion pour chaque film.

SELECT M.Title, 
case
    WHEN FLOOR(AVG(W.CompletionPercentage)) IS NULL
    THEN 0
    ELSE FLOOR(AVG(W.CompletionPercentage))
end
FROM watchhistory W
RIGHT JOIN movei M
ON M.MoveiID = W.WatchHistoryID 
GROUP BY M.Title;

-- 8-Group By : Grouper les utilisateurs par type d’abonnement et compter le nombre total d’utilisateurs par groupe.


SELECT S.SubscriptionType, COUNT(U.UserId) AS TotalUsers
FROM subscription S
LEFT JOIN Users U ON S.SubscriptionID = U.SubscriptionID
GROUP BY S.SubscriptionType;

