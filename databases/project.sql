CREATE DATABASE Project;
USE Project;
DROP TABLE IF EXISTS Answer, Question, WaitingList, Ticket, Reservation,
                     Customer, User, Operating_Days,
                     InternationalFlight, DomesticFlight,
                     Flight, Aircraft, Airline, Airport;

CREATE TABLE Airport (
    airport_id CHAR(3) PRIMARY KEY
);

CREATE TABLE Airline (
    airline_id CHAR(2) PRIMARY KEY,
    airport_id CHAR(3),
    CONSTRAINT fk_airline FOREIGN KEY (airport_id) REFERENCES Airport(airport_id)
);

CREATE TABLE Aircraft (
    aircraft_id VARCHAR(10) PRIMARY KEY,
    model        VARCHAR(50),
    num_of_seats INT NOT NULL            
);

CREATE TABLE Flight (
    flight_number INT,
    airline_id    CHAR(2),
    dep_airport   CHAR(3) NOT NULL,
    dest_airport  CHAR(3) NOT NULL,
    flight_type   ENUM('Domestic','International') NOT NULL,
    dep_time      TIMESTAMP NOT NULL,
    arr_time      TIMESTAMP NOT NULL,
    aircraft_id   VARCHAR(10) NOT NULL,
    PRIMARY KEY (flight_number, airline_id),
    FOREIGN KEY (airline_id)   REFERENCES Airline(airline_id),
    FOREIGN KEY (dep_airport)  REFERENCES Airport(airport_id),
    FOREIGN KEY (dest_airport) REFERENCES Airport(airport_id),
    FOREIGN KEY (aircraft_id)  REFERENCES Aircraft(aircraft_id),
    CHECK (dep_airport <> dest_airport)
);

CREATE TABLE DomesticFlight (
    flight_number INT,
    airline_id    CHAR(2),
    PRIMARY KEY (flight_number, airline_id),
    FOREIGN KEY (flight_number, airline_id) REFERENCES Flight(flight_number, airline_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE InternationalFlight (
    flight_number INT,
    airline_id    CHAR(2),
    PRIMARY KEY (flight_number, airline_id),
    FOREIGN KEY (flight_number, airline_id) REFERENCES Flight(flight_number, airline_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Operating_Days (
    flight_number INT,
    airline_id    CHAR(2),
    day ENUM('Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday') NOT NULL,
    PRIMARY KEY (flight_number, airline_id, day),
    FOREIGN KEY (flight_number, airline_id) REFERENCES Flight(flight_number, airline_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE User (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    first_name    VARCHAR(100),
    last_name     VARCHAR(100),
    email         VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role          ENUM('Customer','Rep','Admin') NOT NULL
);

CREATE TABLE Customer (
    user_id INT PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Reservation (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id    INT NOT NULL,
    total_fare     DECIMAL(10,2),
    booking_fee    DECIMAL(10,2),
    booked_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Ticket (
    ticket_number  INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT NOT NULL,
    flight_number  INT NOT NULL,
    airline_id     CHAR(2) NOT NULL,
    seat_number    VARCHAR(5),
    travel_class   ENUM('Economy','Business','First') DEFAULT 'Economy',
    departure_date DATE NOT NULL,
    passenger_first_name VARCHAR(50),
    passenger_last_name  VARCHAR(50),
    passenger_id_number  VARCHAR(20),
    purchased_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (flight_number, airline_id) REFERENCES Flight(flight_number, airline_id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE (flight_number, airline_id, departure_date, seat_number)
);

CREATE TABLE WaitingList (
    flight_number INT,
    airline_id    CHAR(2),
    customer_id   INT,
    request_time  DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (flight_number, airline_id, customer_id),
    FOREIGN KEY (flight_number, airline_id) REFERENCES Flight(flight_number, airline_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customer(user_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Question (
    question_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,             
    message     TEXT,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(user_id) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE Answer (
    answer_id   INT AUTO_INCREMENT PRIMARY KEY,
    question_id INT NOT NULL,
    rep_id      INT,              
    response    TEXT,
    responded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (question_id) REFERENCES Question(question_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (rep_id) REFERENCES User(user_id) ON DELETE SET NULL ON UPDATE CASCADE
);

/*Test part
INSERT INTO Airport(airport_id) VALUES
 ('JFK'), ('LAX'), ('ORD'), ('SFO'), ('NRT');

INSERT INTO Airline(airline_id, airport_id) VALUES
 ('AA','JFK'),   -- American Airlines
 ('UA','ORD');   -- United Airlines

INSERT INTO Aircraft(aircraft_id, model, num_of_seats) VALUES
 ('N123AA','B737‑800',160),
 ('N456UA','A320‑200',150),
 ('N789AA','B777‑300',300),
 ('N987UA','B787‑9'  ,280);

INSERT INTO Flight VALUES
 -- flight_number, airline_id, dep_airport, dest_airport, type, dep, arr, aircraft
 (1001,'AA','JFK','LAX','Domestic','2025-05-01 08:00','2025-05-01 11:15','N123AA'),
 (1002,'AA','JFK','SFO','Domestic','2025-05-01 09:00','2025-05-01 12:20','N123AA'),
 (2001,'UA','ORD','LAX','Domestic','2025-05-01 07:30','2025-05-01 10:00','N456UA'),
 (3001,'UA','LAX','NRT','International','2025-05-02 12:00','2025-05-03 15:50','N987UA'),
 (4001,'AA','JFK','NRT','International','2025-05-02 13:00','2025-05-03 16:10','N789AA');

INSERT INTO DomesticFlight  VALUES (1001,'AA'),(1002,'AA'),(2001,'UA');
INSERT INTO InternationalFlight VALUES (3001,'UA'),(4001,'AA');

INSERT INTO Operating_Days VALUES
 (1001,'AA','Monday'), (1001,'AA','Wednesday'), (1001,'AA','Friday'),
 (1002,'AA','Tuesday'),(1002,'AA','Thursday'),
 (2001,'UA','Monday'), (2001,'UA','Tuesday'),(2001,'UA','Wednesday'),
 (3001,'UA','Saturday'),(3001,'UA','Sunday'),
 (4001,'AA','Saturday'),(4001,'AA','Sunday');

INSERT INTO User(user_id,first_name,last_name,email,password_hash,role) VALUES
 (1,'Alice','Smith','alice@example.com','x', 'Customer'),
 (2,'Bob','Chen'  ,'bob@example.com'  ,'x', 'Customer'),
 (3,'Carol','Lee' ,'carol@example.com','x', 'Rep'),
 (4,'Dave','Zhang','dave@example.com' ,'x', 'Admin');

INSERT INTO Customer VALUES (1),(2);

INSERT INTO Reservation(reservation_id,customer_id,total_fare,booking_fee,booked_at) VALUES
 (1,1,500.00,30.00,'2025-04-20 10:00'),
 (2,2,1350.00,50.00,'2025-04-21 14:00');

INSERT INTO Ticket(reservation_id,flight_number,airline_id,seat_number,
                   travel_class,departure_date,
                   passenger_first_name,passenger_last_name,passenger_id_number)
VALUES
 -- Alice JFK ↔ LAX
 (1,1001,'AA','12A','Economy','2025-05-01','Alice','Smith','P1234567'),
 (1,1001,'AA','12B','Economy','2025-05-08','Alice','Smith','P1234567'),
 -- Bob Tokyo
 (2,3001,'UA','02D','Business','2025-05-02','Bob','Chen','P7654321');

INSERT INTO WaitingList VALUES
 (4001,'AA',1,'2025-04-22 09:30');

INSERT INTO Question (question_id, customer_id, message, created_at) VALUES
  (1, 1, 'Can I upgrade from Economy to Business class?', '2025-04-22 10:00');

INSERT INTO Answer (answer_id, question_id, rep_id, response) VALUES
  (1, 1, 3, 'Hello! You can upgrade by paying the fare difference up to 24 hours before departure.');

*/
/* A. Flights departing JFK on 20250501 and remaining seat count */

SELECT F.flight_number,
       F.airline_id,
       F.dest_airport,
       F.dep_time,
       A.model,
       A.num_of_seats,
       (A.num_of_seats - COUNT(T.ticket_number)) AS seats_left
FROM   Flight   AS F
JOIN   Aircraft AS A ON A.aircraft_id = F.aircraft_id
LEFT JOIN Ticket  AS T
       ON  T.flight_number   = F.flight_number
       AND T.airline_id      = F.airline_id
       AND T.departure_date  = '2025-05-01'
WHERE  F.dep_airport = 'JFK'
  AND  DATE(F.dep_time) = '2025-05-01'
GROUP  BY F.flight_number,
         F.airline_id,
         F.dest_airport,
         F.dep_time,
         A.model,
         A.num_of_seats;


/* B. All reservations and flight segments for Bob (customer_id = 2) */
SELECT R.reservation_id,
       R.total_fare,
       T.flight_number,
       T.airline_id,
       T.seat_number,
       T.travel_class
FROM   Reservation AS R
JOIN   Ticket      AS T ON T.reservation_id = R.reservation_id
WHERE  R.customer_id = 2;


/* C. Operating days for flight AA 1001 */
SELECT day
FROM   Operating_Days
WHERE  flight_number = 1001
  AND  airline_id    = 'AA';


/* D. Wait‑list entries for flight AA 4001 */
SELECT W.customer_id,
       U.first_name,
       U.last_name,
       W.request_time
FROM   WaitingList AS W
JOIN   User        AS U ON U.user_id = W.customer_id
WHERE  flight_number = 4001
  AND  airline_id    = 'AA';


/* E. Number of flights operated by each airline */
SELECT airline_id,
       COUNT(*) AS flight_cnt
FROM   Flight
GROUP  BY airline_id;

