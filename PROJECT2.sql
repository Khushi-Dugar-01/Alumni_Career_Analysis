CREATE SCHEMA alumni;
USE alumni;
DESC college_a_hs;
DESC college_a_se;
DESC college_a_sj;
DESC college_b_hs;
DESC college_b_se;
DESC college_b_sj;
CREATE VIEW college_A_HS_V AS 
(SELECT * FROM college_a_hs WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND FatherName IS NOT NULL AND 
MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND HSDegree IS NOT NULL AND 
EntranceExam IS NOT NULL AND Institute IS NOT NULL AND Location IS NOT NULL);
SELECT * FROM college_A_HS_V;
CREATE VIEW College_A_SE_V AS (SELECT * FROM college_a_se WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND 
FatherName IS NOT NULL AND MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND 
Organization IS NOT NULL AND Location IS NOT NULL);
SELECT * FROM College_A_SE_V;
CREATE VIEW College_A_SJ_V AS (SELECT * FROM college_a_sj WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND 
FatherName IS NOT NULL AND MotherName IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND PresentStatus IS NOT NULL AND 
Organization IS NOT NULL AND Designation IS NOT NULL AND Location IS NOT NULL);
SELECT * FROM College_A_SJ_V;
CREATE VIEW College_B_HS_V AS (SELECT * FROM college_b_hs WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND 
FatherName IS NOT NULL AND MotherName IS NOT NULL AND Branch IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND 
PresentStatus IS NOT NULL AND HSDegree IS NOT NULL AND EntranceExam IS NOT NULL AND Institute IS NOT NULL AND Location IS NOT NULL);
SELECT * FROM College_B_HS_V;
CREATE VIEW College_B_SE_V AS (SELECT * FROM college_b_se WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND 
FatherName IS NOT NULL AND MotherName IS NOT NULL AND Branch IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND 
PresentStatus IS NOT NULL AND Organization IS NOT NULL AND Location IS NOT NULL);
SELECT * FROM College_B_SE_V;
CREATE VIEW College_B_SJ_V AS (SELECT * FROM college_b_sj WHERE RollNo IS NOT NULL AND LastUpdate IS NOT NULL AND Name IS NOT NULL AND 
FatherName IS NOT NULL AND MotherName IS NOT NULL AND Branch IS NOT NULL AND Batch IS NOT NULL AND Degree IS NOT NULL AND 
PresentStatus IS NOT NULL AND Organization IS NOT NULL AND Designation IS NOT NULL AND Location IS NOT NULL);
SELECT * FROM College_B_SJ_V;
SELECT LOWER(Name), LOWER(FatherName), LOWER(MotherName) FROM College_A_HS_V;
SELECT LOWER(Name), LOWER(FatherName), LOWER(MotherName) FROM College_A_Se_V;
SELECT LOWER(Name), LOWER(FatherName), LOWER(MotherName) FROM College_A_Sj_V;
SELECT LOWER(Name), LOWER(FatherName), LOWER(MotherName) FROM College_B_HS_V;
SELECT LOWER(Name), LOWER(FatherName), LOWER(MotherName) FROM College_B_Se_V;
SELECT LOWER(Name), LOWER(FatherName), LOWER(MotherName) FROM College_B_Sj_V;
DELIMITER $$
CREATE PROCEDURE get_name_collegeA 
(
         INOUT name1 TEXT(40000)
)
BEGIN 
    DECLARE na INT DEFAULT 0;
    DECLARE namelist VARCHAR(16000) DEFAULT "";
    DECLARE namedetail 
           CURSOR FOR
				SELECT Name FROM college_a_hs UNION SELECT Name FROM college_a_se UNION SELECT Name FROM college_a_sj;
	DECLARE CONTINUE HANDLER 
            FOR NOT FOUND SET na =1;
	OPEN namedetail;
    getame :
         LOOP
         FETCH FROM namedetail INTO namelist;
         IF na = 1 THEN
              LEAVE getame;
		END IF;
        SET name1 = CONCAT(namelist," ; ",name1);
        END LOOP getame;
        CLOSE namedetail;
END $$
DELIMITER ;
SET @Name = "";
CALL get_name_collegeA(@Name);
SELECT @Name Name;
DROP PROCEDURE get_name_collegeB
DELIMITER $$
CREATE PROCEDURE get_name_collegeB 
(
         INOUT name1 TEXT(40000)
)
BEGIN 
    DECLARE na INT DEFAULT 0;
    DECLARE namelist VARCHAR(16000) DEFAULT "";
    DECLARE namedetail 
           CURSOR FOR
				SELECT Name FROM college_b_hs UNION SELECT Name FROM college_b_se UNION SELECT Name FROM college_b_sj;
	DECLARE CONTINUE HANDLER 
            FOR NOT FOUND SET na =1;
	OPEN namedetail;
    getame :
         LOOP
         FETCH FROM namedetail INTO namelist;
         IF na = 1 THEN
              LEAVE getame;
		END IF;
        SET name1 = CONCAT(namelist," ; ",name1);
        END LOOP getame;
        CLOSE namedetail;
END $$
DELIMITER ;
SET @Name = "";
CALL get_name_collegeB(@Name);
SELECT @Name Name;
SELECT "Higher Studies" Present_status, 
(COUNT(DISTINCT(college_a_hs.Degree)) / COUNT(college_a_hs.RollNo)) * 100 College_A_Percentage, 
(COUNT(college_b_hs.RollNo) / (college_b_hs.RollNo)) * 100 College_B_Percentage 
FROM college_a_hs CROSS JOIN college_b_hs UNION SELECT "Self Empolyment" Present_status, 
(COUNT(college_a_se.RollNo) / (college_a_se.RollNo)) * 100 College_A_Percentage, 
(COUNT(college_b_se.RollNo) / (college_b_se.RollNo)) * 100 College_B_Percentage 
FROM college_a_se CROSS JOIN college_b_se UNION SELECT "Service Job" Present_status, 
(COUNT(college_a_sj.RollNo) / (college_a_sj.RollNo)) * 100 College_A_Persentage, 
(COUNT(college_b_sj.RollNo) / (college_b_sj.RollNo))*100 College_B_Persentage 
FROM college_a_sj CROSS JOIN college_b_sj;
