
#
#	Create the Tables the Database
#

DROP TABLE IF EXISTS Parents;

CREATE TABLE Parents
(
  phone_number    INT unsigned UNIQUE NOT NULL, 	# Unique ID for the record and phone number for contact
  forename        VARCHAR(100) NOT NULL,                 # Forename of the parent
  lastname        VARCHAR(100) NOT NULL,                 # Last Name of the parent
  email           VARCHAR(100) NOT NULL,                 # Email address of the parent
  PRIMARY KEY     (phone_number)                        # Make the phone number the primary key
);

#CREATE TABLE Parents( phone_number INT unsigned UNIQUE NOT NULL, forename VARCHAR(50) NOT NULL,lastname VARCHAR(50) NOT NULL,email VARCHAR(50) NOT NULL,PRIMARY KEY (phone_number));

DROP TABLE IF EXISTS Ninjas;

CREATE TABLE Ninjas
(
  id              INT(4) unsigned NOT NULL, 	# Unique ID for the record
  forename        VARCHAR(100) NOT NULL,                 	# Forename of the ninja
  lastname        VARCHAR(100) NOT NULL,                 	# Last Name of the ninja
  parent_id       INT unsigned NOT NULL,                	# ID to reference parent of the child
  group_id        INT(4) unsigned DEFAULT NULL,                 # ID to reference the group which the child is part of
  dob             DATE NOT NULL,                        	# Birthday of the ninja
  PRIMARY KEY     (id)                                  	# Make the id the primary key
);

#CREATE TABLE Ninjas(id INT(4) unsigned NOT NULL AUTO_INCREMENT,forename VARCHAR(50) NOT NULL, lastname VARCHAR(50) NOT NULL, parent_id INT unsigned NOT NULL, group_id INT(4) unsigned NOT NULL, dob DATE NOT NULL, PRIMARY KEY (id) );

DROP TABLE IF EXISTS Mentors;

CREATE TABLE Mentors
(
  id              INT(3) unsigned NOT NULL, 	# Unique ID for the record
  forename        VARCHAR(50) NOT NULL,                 	# Forename of the ninja
  lastname        VARCHAR(50) NOT NULL,                 	# Last Name of the ninja
  level           VARCHAR(50) NOT NULL,                	# Level of experience of mentor
  position        INT(1) unsigned DEFAULT NULL,                    # committee position that a mentor may hold
  PRIMARY KEY     (id)                                  	# Make the id the primary key
);

#CREATE TABLE Mentors(id INT unsigned NOT NULL AUTO_INCREMENT,forename VARCHAR(50) NOT NULL,lastname VARCHAR(50) NOT NULL, level VARCHAR(150) NOT NULL, position INT unsigned DEFAULT NULL, PRIMARY KEY (id) );

DROP TABLE IF EXISTS Committee_position;

CREATE TABLE Committee_position
(
  id              	INT(1) unsigned NOT NULL, 		# Unique ID for the record
  position        	VARCHAR(150) NOT NULL,                 # Name of the position
  responsibilities      VARCHAR(255),                 	      # Responsibilities of position
  PRIMARY KEY     (id)                                        # Make the id the primary key

);

#CREATE TABLE Committee_position (id INT unsigned NOT NULL, position VARCHAR(150) NOT NULL, responsibilities VARCHAR(255), PRIMARY KEY (id));

DROP TABLE IF EXISTS Topics;

CREATE TABLE Topics
(
  name            	VARCHAR(150) NOT NULL UNIQUE,  		# Unique ID for the record
  syllabus        	VARCHAR(150) DEFAULT NULL,              # Link to the syllabus
  syllabus_director     INT(3) unsigned,                	# Mentor in charge of syllabus
  PRIMARY KEY     (name)                                  	# Make the name the primary key
);

#CREATE TABLE Topics (name VARCHAR(150) NOT NULL UNIQUE, syllabus VARCHAR(150), syllabus_director INT unsigned, PRIMARY KEY (name) );

DROP TABLE IF EXISTS Meetings;

CREATE TABLE Meetings
(
  id              INT(5) unsigned NOT NULL, # Unique ID for the record
  date		  DATE NOT NULL,                	# Date and time of the meeting
  chairperson     INT unsigned NOT NULL,               	# Reference ID of mentor who chaired the meeting
  minute_taker    INT unsigned NOT NULL,                # Reference ID of mentor who took the minutes at the meeting
  PRIMARY KEY     (id)                                  # Make the id the primary key
);

#CREATE TABLE Meetings (id INT(5) unsigned NOT NULL AUTO_INCREMENT,date_and_time DATE, chairperson INT unsigned NOT NULL,  minute_taker INT unsigned NOT NULL, PRIMARY KEY (id) );

DROP TABLE IF EXISTS Events;

CREATE TABLE Events
(
  id              INT(6) unsigned NOT NULL, # Unique ID for the record
  name            VARCHAR(150),                		# Name of the event
  topic           VARCHAR(150),                		# topic of the event
  date		  DATE NOT NULL,                    	# date and time of the event
  location	  VARCHAR(150) NOT NULL,	        # location where the event is held
  group_id 	  INT (4) unsigned,			# id of group of ninjas that attend the session
  director        INT(3) unsigned NOT NULL,		#id of the mentor directing the session
  PRIMARY KEY     (id)                                  # Make the id the primary key
);

#CREATE TABLE Events (id INT(5) unsigned NOT NULL AUTO_INCREMENT,name VARCHAR(150), topic VARCHAR(150),  date_and_time   DATE, location VARCHAR(150) NOT NULL, group_id INT (4) unsigned, director        INT unsigned NOT NULL, PRIMARY KEY (id) );

DROP TABLE IF EXISTS Ninja_group;

CREATE TABLE Ninja_group
(
  id              INT(2) unsigned NOT NULL, 		# Unique ID for the record
  topic           VARCHAR(150) NOT NULL,                # Topic that the group covers
  level           VARCHAR(150) NOT NULL,                # Level of the group
  PRIMARY KEY     (id)                                  # Make the id the primary key
);

#CREATE TABLE Ninja_group ( id INT unsigned NOT NULL AUTO_INCREMENT, topic VARCHAR(150) NOT NULL, level VARCHAR(150) NOT NULL, PRIMARY KEY (id) );

#
#	Constraints (Checks)
#

ALTER TABLE Committee_position ADD CONSTRAINT committee_id CHECK (id<7 AND id>0);

ALTER TABLE Mentors ADD CONSTRAINT mentor_id CHECK (id<999 AND id>99);
ALTER TABLE Mentors ADD CONSTRAINT position_id CHECK (position<7 AND position>0);
ALTER TABLE Mentors ADD CONSTRAINT mentor_level CHECK(level IN ('White', 'Yellow', 'Green', 'Purple', 'Black'));

ALTER TABLE Committee_position ADD CONSTRAINT position_name CHECK(position IN ('Champion', 'IO', 'CPO', 'PRO', 'PRO', 'Treasurer', 'OCM'));
ALTER TABLE Committee_position ADD CONSTRAINT committee_id CHECK (id<7 AND id>0);

ALTER TABLE Topics ADD CONSTRAINT topic_director CHECK(level IN ('Creator', 'Builder', 'Maker', 'Developer'));

ALTER TABLE Ninjas ADD CONSTRAINT ninja_age CHECK (TIMESTAMPDIFF(YEAR, dob, '2019-11-06') > 5 AND TIMESTAMPDIFF(YEAR, dob, '2019-11-06') < 17);
ALTER TABLE Ninjas ADD CONSTRAINT ninja_id CHECK (id>999 && id<9999);

ALTER TABLE Ninja_group ADD CONSTRAINT ninja_group_id CHECK (id>9 && id<99);

ALTER TABLE Events ADD CONSTRAINT event_id CHECK (id>99999 && id<999999);

ALTER TABLE Meetings ADD CONSTRAINT meeting_id CHECK (id>9999 && id<99999);


#
#	Constraints (References)
#

ALTER TABLE Ninjas ADD CONSTRAINT parent_id FOREIGN KEY (parent_id) REFERENCES Parents(phone_number);
ALTER TABLE Ninjas ADD CONSTRAINT ninja_group_id FOREIGN KEY (group_id) REFERENCES Ninja_group(id);

ALTER TABLE Committee_position ADD CONSTRAINT mentor_position FOREIGN KEY (position) REFERENCES Committee_position(id);

ALTER TABLE Topics ADD CONSTRAINT topic_director FOREIGN KEY (syllabus_director) REFERENCES Mentors(id);

ALTER TABLE Meetings ADD CONSTRAINT meeting_chair FOREIGN KEY (chairperson) REFERENCES Mentors(id);
ALTER TABLE Meetings ADD CONSTRAINT meeting_minutes FOREIGN KEY (minute_taker) REFERENCES Mentors(id);

ALTER TABLE Events ADD CONSTRAINT event_director FOREIGN KEY (director) REFERENCES Mentors(id);
ALTER TABLE Events ADD CONSTRAINT event_topic FOREIGN KEY (topic) REFERENCES Topics(name);
ALTER TABLE Events ADD CONSTRAINT event_group FOREIGN KEY (group_id) REFERENCES Ninja_group(id);

ALTER TABLE Ninja_group ADD CONSTRAINT group_topic FOREIGN KEY (topic) REFERENCES Topics(name);

#
#	Populate the Database
#

#Populate table Parents
INSERT INTO Parents Values(0879619937, 'Sinead', 'Byrne', 'sineadbyrne99@gmail.com');INSERT INTO Parents Values(0879248761, 'Tom', 'Murphy', 'tommurphy77@gmail.com');
INSERT INTO Parents Values(0859318145, 'Neil', 'Diamond', 'sweetcaroline@gmail.com');
INSERT INTO Parents Values(0864919123, 'Nora', 'Russell', 'russell49@yahoo.com');
INSERT INTO Parents Values(0860854150, 'Bronagh', 'North', 'northsouth@yahoo.com');
INSERT INTO Parents Values(0870835715, 'Olivia', 'Gardiner', 'theGardiner@gmail.com');

#Populate table Ninjas
INSERT INTO Ninjas Values(1001, 'Rory', 'Murphy', 0879248761, 0010, '2006-01-03');
INSERT INTO Ninjas Values(1002, 'Tara', 'Murphy', 0879248761, 0010, '2008-05-09');
INSERT INTO Ninjas Values(1003, 'Sarah', 'Diamond', 0859318145, 0010, '2010-08-02');
INSERT INTO Ninjas Values(1004, 'Mary', 'Byrne', 0879619937, 0012, '2011-03-03');
INSERT INTO Ninjas Values(1005, 'Niall', 'Russell', 0864919123, 0012, '2012-12-12');
INSERT INTO Ninjas Values(1006, 'Nollaig', 'Russell', 0864919123, 0010, '2006-10-02');
INSERT INTO Ninjas Values(1007, 'Sophie', 'North', 0860854150, 0013, '2009-04-08');
INSERT INTO Ninjas Values(1008, 'Louise', 'Gardiner', 0870835715, 0013, '2009-06-12');

#Populate table Mentors
INSERT INTO Mentors Values(101, 'Ruth', 'Brennan','Black',1);
INSERT INTO Mentors Values(102, 'Mark', 'Boyle','Black',3);
INSERT INTO Mentors Values(103, 'Emily','Duncan','Black',2);
INSERT INTO Mentors Values(104, 'Sophie','Hamill','Purple',NULL);
INSERT INTO Mentors Values(105, 'Derek','Shepard','Yellow',NULL);
INSERT INTO Mentors Values(106, 'Conor','Lawerence','White',NULL);
INSERT INTO Mentors Values(107, 'Meabh','Dawson','Green',NULL);
INSERT INTO Mentors Values(108, 'Matt','Levy','White',NULL);
INSERT INTO Mentors Values(109, 'Niamh','Levy','Black',2);

#Populate table Committee_position
INSERT INTO Committee_position Values(1, 'Champion', 'Organise Mentors, Events and Meetings');
INSERT INTO Committee_position Values(2, 'IO', 'Organise Parents and Ninjas');
INSERT INTO Committee_position Values(3, 'CPO', 'Ensure that child protection rules are followed at events and to ensure all of the mentors are Garda vetted');
INSERT INTO Committee_position Values(4, 'PRO', 'Promotes the dojo to potential mentors and parents of ninjas');
INSERT INTO Committee_position Values(5, 'Treasurer', 'Handles finances, equipment and sponsorship');
INSERT INTO Committee_position Values(6, 'OCM', 'Attends meetings and contributes to running of the dojo');

#Populate table Topics
INSERT INTO Topics Values('Scratch', Null, 102 );
INSERT INTO Topics Values('P5JS', Null, 101 );
INSERT INTO Topics Values('Arduino', Null, 107 );
INSERT INTO Topics Values('Makey Makey', Null, 104 );
INSERT INTO Topics Values('Python', Null, 109 );

#Populate table Meetings
INSERT INTO Meetings Values(10001, '2019-10-10 ', 17329846, 19684123);
INSERT INTO Meetings Values(10002, '2019-11-8', 17329846, 19684123);
INSERT INTO Meetings Values(10003, '2019-12-3', 17329846, 19684123);

#Populate table Events
INSERT INTO Events Values(100001, 'GirlCode','Scratch', '2019-08-10','Room 1.07 Lloyd Institute',0013, 17329846);
INSERT INTO Events Values(100002, 'GirlCode','Scratch', '2018-08-07','Room 1.07 Lloyd Institute',0013, 17329846);
INSERT INTO Events Values(100003, 'Intro to Coderdojo','P5JS', '2019-11-03','Mac Lab, Hamilton Building',0010, 17334891);
#INSERT INTO Events Values(100004, 'Intro to Coderdojo','P5JS', '2019-11-03','Mac Lab, Hamilton Building',0013, 17334891);

#Populate Ninja Group
INSERT INTO Ninja_group Values(10, 'P5JS','Creator');
INSERT INTO Ninja_group Values(11, 'Arduino', 'Developer');
INSERT INTO Ninja_group Values(12, 'Python', 'Builder');
INSERT INTO Ninja_group Values(13, 'Scratch', 'Maker');


#
#	Trigger
#

#To delete parents when ninja is deleted if they don't have other children

DELIMITER $$
CREATE 
TRIGGER delete_parent AFTER DELETE
  ON Ninjas
FOR EACH ROW BEGIN
    IF (SELECT COUNT(*) FROM Ninjas WHERE parent_id = OLD.parent_id) = 0  THEN
      DELETE FROM PARENTS WHERE phone_number = OLD.parent_id;
    END IF;
  END$$
DELIMITER;


#
#	Views
#


#get the names of all committee members
CREATE VIEW black_belts AS SELECT forename, lastname FROM Mentors WHERE level = 'Black';

#Get all ninjas, parents and parents emails
CREATE VIEW parents_of_ninjas AS SELECT Ninjas.forename, Ninjas.lastname, Parents.forename as parent_forename, Parents.lastname as parent_lastname, Parents.email FROM Parents, Ninjas WHERE Ninjas.parent_id = Parents.phone_number;

#Get all Ninjas in a group
CREATE VIEW ninjas_in_group AS SELECT Ninjas.forename, Ninjas.lastname, Ninja_group.level, Ninja_group.topic FROM Ninja_group, Ninjas WHERE Ninjas.group_id = Ninja_group.id;
































