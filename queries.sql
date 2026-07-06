#List every student withh the respective courses they are enrolled in

SELECT s.StudentID, s.StudentFirstName || ' ' || s.StudentLastName AS StudentName,
       c.CourseName, e.EnrolmentStatus
FROM STUDENT s
JOIN ENROLMENT e ON s.StudentID = e.StudentID
JOIN COURSE c    ON e.CourseID  = c.CourseID
ORDER BY s.StudentID;

# It joins tables to show which lecturer teaches which module, and when/where

SELECT m.ModuleName, l.LecturerFirstName || ' ' || l.LecturerLastName AS Lecturer,
       sch.DayOfWeek, TO_CHAR(sch.StartTime,'HH24:MI') AS Starts,
       TO_CHAR(sch.EndTime,'HH24:MI') AS Ends, sch.RoomNumber, sch.BuildingName
FROM SCHEDULE sch
JOIN MODULE m    ON sch.ModuleID   = m.ModuleID
JOIN LECTURER l  ON sch.LecturerID = l.LecturerID
ORDER BY sch.DayOfWeek;

#Calculates average mark per module, and display averages above 50 for each module and arranging them from highest to lowest 

SELECT m.ModuleName,
       ROUND(AVG(a.MarksObtained),1) AS AvgMark,
       COUNT(a.AssessmentID) AS NumAssessments
FROM ASSESSMENT a
JOIN STUDENT_MODULE sm ON a.StudentModuleID = sm.StudentModuleID
JOIN MODULE m           ON sm.ModuleID       = m.ModuleID
GROUP BY m.ModuleName
HAVING AVG(a.MarksObtained) > 50
ORDER BY AvgMark DESC;

#displays students who scored higher than the average of their own module

SELECT s.StudentFirstName || ' ' || s.StudentLastName AS StudentName,
       m.ModuleName, a.MarksObtained
FROM ASSESSMENT a
JOIN STUDENT_MODULE sm ON a.StudentModuleID = sm.StudentModuleID
JOIN ENROLMENT e        ON sm.EnrolmentID    = e.EnrolmentID
JOIN STUDENT s          ON e.StudentID       = s.StudentID
JOIN MODULE m           ON sm.ModuleID       = m.ModuleID
WHERE a.MarksObtained > (
    SELECT AVG(a2.MarksObtained)
    FROM ASSESSMENT a2
    JOIN STUDENT_MODULE sm2 ON a2.StudentModuleID = sm2.StudentModuleID
    WHERE sm2.ModuleID = sm.ModuleID

#displays students who have not failed any assessment

SELECT DISTINCT s.StudentID, s.StudentFirstName || ' ' || s.StudentLastName AS StudentName
FROM STUDENT s
JOIN ENROLMENT e ON s.StudentID = e.StudentID
WHERE s.StudentID NOT IN (
    SELECT e2.StudentID
    FROM ENROLMENT e2
    JOIN STUDENT_MODULE sm ON e2.EnrolmentID = sm.EnrolmentID
    JOIN ASSESSMENT a       ON sm.StudentModuleID = a.StudentModuleID
    WHERE ROUND(a.MarksObtained / a.AssessmentMaxMark * 100) < 40   -- F boundary
);