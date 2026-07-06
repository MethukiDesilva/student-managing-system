CREATE TABLE FACULTY (
FacultyID VARCHAR (4)    NOT NULL,
FacultyName VARCHAR2(60) NOT NULL,
CONSTRAINT pk_faculty PRIMARY KEY( FacultyID)
);

CREATE TABLE DEPARTMENT (
    DepartmentID    VARCHAR2(4)  NOT NULL,
    FacultyID       VARCHAR2(4)  NOT NULL,
    DepartmentName  VARCHAR2(60) NOT NULL,
    DepartmentHead  VARCHAR2(60),
    CONSTRAINT pk_department PRIMARY KEY (DepartmentID),
    CONSTRAINT fk_department_faculty FOREIGN KEY (FacultyID)
        REFERENCES FACULTY (FacultyID)
);
CREATE TABLE COURSE (
    CourseID           VARCHAR2(4)   NOT NULL,
    DepartmentID       VARCHAR2(4)   NOT NULL,
    CourseName         VARCHAR2(80)  NOT NULL,
    CourseCode         VARCHAR2(8)   NOT NULL,
    CourseDescription  VARCHAR2(255),
    CourseDuration     NUMBER(2)     NOT NULL,
    CourseLevel        CHAR(2)       NOT NULL,
    CourseFee          NUMBER(8,2)   NOT NULL,
    CourseMaxCapacity  NUMBER(4)     NOT NULL,
    CONSTRAINT pk_course PRIMARY KEY (CourseID),
    CONSTRAINT uq_course_code UNIQUE (CourseCode),
    CONSTRAINT fk_course_department FOREIGN KEY (DepartmentID)
        REFERENCES DEPARTMENT (DepartmentID),
    CONSTRAINT chk_course_duration CHECK (CourseDuration > 0),
    CONSTRAINT chk_course_level CHECK (CourseLevel IN ('UG','PG')),
    CONSTRAINT chk_course_fee CHECK (CourseFee >= 0),
    CONSTRAINT chk_course_capacity CHECK (CourseMaxCapacity >= 1)
);

  

CREATE TABLE MODULE (
    ModuleID           NUMBER(4)     NOT NULL,
    ModuleCode         VARCHAR2(6)   NOT NULL,
    ModuleName         VARCHAR2(80)  NOT NULL,
    ModuleCredits      NUMBER(2)     NOT NULL,
    ModuleSemester     VARCHAR2(20),
    ModuleDescription  VARCHAR2(255),
    ModuleType         VARCHAR2(8)   NOT NULL,
    CONSTRAINT pk_module PRIMARY KEY (ModuleID),
    CONSTRAINT uq_module_code UNIQUE (ModuleCode),
    CONSTRAINT chk_module_credits CHECK (ModuleCredits > 0),
    CONSTRAINT chk_module_type CHECK (ModuleType IN ('Core','Elective'))
);


CREATE TABLE COURSE_MODULE (
    CourseID  VARCHAR2(4) NOT NULL,
    ModuleID  NUMBER(4)   NOT NULL,
    CONSTRAINT pk_course_module PRIMARY KEY (CourseID, ModuleID),
    CONSTRAINT fk_cm_course FOREIGN KEY (CourseID) REFERENCES COURSE (CourseID),
    CONSTRAINT fk_cm_module FOREIGN KEY (ModuleID) REFERENCES MODULE (ModuleID)
);   

CREATE TABLE LECTURER (
    LecturerID              NUMBER(4)    NOT NULL,
    LecturerFirstName       VARCHAR2(35) NOT NULL,
    LecturerLastName        VARCHAR2(35) NOT NULL,
    LecturerEmail           VARCHAR2(60) NOT NULL,
    LecturerPhone           VARCHAR2(20),
    LecturerSpecialisation  VARCHAR2(60),
    LecturerOffice          VARCHAR2(10),
    LecturerHireDate        DATE,
    CONSTRAINT pk_lecturer PRIMARY KEY (LecturerID),
    CONSTRAINT uq_lecturer_email UNIQUE (LecturerEmail),
    CONSTRAINT chk_lecturer_fname CHECK (REGEXP_LIKE(LecturerFirstName, '^[A-Za-z '' -]+$')),
    CONSTRAINT chk_lecturer_lname CHECK (REGEXP_LIKE(LecturerLastName, '^[A-Za-z '' -]+$')),
    CONSTRAINT chk_lecturer_email CHECK (LecturerEmail LIKE '%@%')
);


CREATE TABLE MODULE_LECTURER (
    ModuleID    NUMBER(4) NOT NULL,
    LecturerID  NUMBER(4) NOT NULL,
    CONSTRAINT pk_module_lecturer PRIMARY KEY (ModuleID, LecturerID),
    CONSTRAINT fk_ml_module FOREIGN KEY (ModuleID) REFERENCES MODULE (ModuleID),
    CONSTRAINT fk_ml_lecturer FOREIGN KEY (LecturerID) REFERENCES LECTURER (LecturerID)
);

CREATE TABLE SCHEDULE (
    ScheduleID    VARCHAR2(4) NOT NULL,
    ModuleID      NUMBER(4)   NOT NULL,
    LecturerID    NUMBER(4)   NOT NULL,
    DayOfWeek     VARCHAR2(10) NOT NULL,
    StartTime     DATE NOT NULL,
    EndTime       DATE NOT NULL,
    RoomNumber    VARCHAR2(10),
    BuildingName  VARCHAR2(50),
    CONSTRAINT pk_schedule PRIMARY KEY (ScheduleID),
    CONSTRAINT fk_schedule_module FOREIGN KEY (ModuleID) REFERENCES MODULE (ModuleID),
    CONSTRAINT fk_schedule_lecturer FOREIGN KEY (LecturerID) REFERENCES LECTURER (LecturerID),
    CONSTRAINT chk_schedule_day CHECK (DayOfWeek IN ('Monday','Tuesday','Wednesday','Thursday','Friday')),
    CONSTRAINT chk_schedule_times CHECK (EndTime > StartTime)
);

CREATE TABLE STUDENT (
    StudentID             VARCHAR2(4)  NOT NULL,
    StudentFirstName      VARCHAR2(35) NOT NULL,
    StudentLastName       VARCHAR2(35) NOT NULL,
    StudentDateOfBirth    DATE         NOT NULL,
    StudentGender         VARCHAR2(20),
    StudentEmail          VARCHAR2(60) NOT NULL,
    StudentPhone          VARCHAR2(20),
    StudentAddress        VARCHAR2(80),
    StudentCity           VARCHAR2(40),
    StudentPostcode       VARCHAR2(10),
    StudentCountry        VARCHAR2(40),
    StudentNationality    VARCHAR2(40),
    StudentEnrolmentDate  DATE DEFAULT SYSDATE,
    CONSTRAINT pk_student PRIMARY KEY (StudentID),
    CONSTRAINT uq_student_email UNIQUE (StudentEmail),
    CONSTRAINT chk_student_fname CHECK (REGEXP_LIKE(StudentFirstName, '^[A-Za-z '' -]+$')),
    CONSTRAINT chk_student_lname CHECK (REGEXP_LIKE(StudentLastName, '^[A-Za-z '' -]+$')),
    CONSTRAINT chk_student_email CHECK (StudentEmail LIKE '%@%')
);
CREATE TABLE ENROLMENT (
    EnrolmentID        VARCHAR2(4) NOT NULL,
    StudentID          VARCHAR2(4) NOT NULL,
    CourseID           VARCHAR2(4) NOT NULL,
    EnrolmentDate      DATE DEFAULT SYSDATE,
    EnrolmentYear      NUMBER(4)   NOT NULL,
    EnrolmentSemester  VARCHAR2(20) NOT NULL,
    EnrolmentStatus    VARCHAR2(15) NOT NULL,
    CONSTRAINT pk_enrolment PRIMARY KEY (EnrolmentID),
    CONSTRAINT fk_enrolment_student FOREIGN KEY (StudentID) REFERENCES STUDENT (StudentID),
    CONSTRAINT fk_enrolment_course FOREIGN KEY (CourseID) REFERENCES COURSE (CourseID),
    CONSTRAINT chk_enrolment_year CHECK (EnrolmentYear BETWEEN 2000 AND 2100),
    CONSTRAINT chk_enrolment_semester CHECK (EnrolmentSemester IN ('Semester 1','Semester 2')),
    CONSTRAINT chk_enrolment_status CHECK (EnrolmentStatus IN ('Active','Completed','Withdrawn'))
);


CREATE TABLE STUDENT_MODULE (
    StudentModuleID  VARCHAR2(4) NOT NULL,
    EnrolmentID      VARCHAR2(4) NOT NULL,
    ModuleID         NUMBER(4)   NOT NULL,
    CONSTRAINT pk_student_module PRIMARY KEY (StudentModuleID),
    CONSTRAINT uq_student_module UNIQUE (EnrolmentID, ModuleID),
    CONSTRAINT fk_sm_enrolment FOREIGN KEY (EnrolmentID) REFERENCES ENROLMENT (EnrolmentID),
    CONSTRAINT fk_sm_module FOREIGN KEY (ModuleID) REFERENCES MODULE (ModuleID)
);

CREATE TABLE ASSESSMENT (
    AssessmentID       VARCHAR2(4)  NOT NULL,
    StudentModuleID    VARCHAR2(4)  NOT NULL,
    AssessmentType     VARCHAR2(10) NOT NULL,
    AssessmentDate     DATE,
    AssessmentMaxMark  NUMBER(3)    NOT NULL,
    MarksObtained      NUMBER(3)    NOT NULL,
    CONSTRAINT pk_assessment PRIMARY KEY (AssessmentID),
    CONSTRAINT fk_assessment_sm FOREIGN KEY (StudentModuleID) REFERENCES STUDENT_MODULE (StudentModuleID),
    CONSTRAINT chk_assessment_type CHECK (AssessmentType IN ('Exam','Coursework','Lab')),
    CONSTRAINT chk_assessment_maxmark CHECK (AssessmentMaxMark > 0 AND AssessmentMaxMark <= 100),
    CONSTRAINT chk_assessment_marks CHECK (MarksObtained >= 0 AND MarksObtained <= AssessmentMaxMark)
);

CREATE TABLE PAYMENT (
    PaymentID           VARCHAR2(4) NOT NULL,
    StudentID           VARCHAR2(4) NOT NULL,
    EnrolmentID         VARCHAR2(4) NOT NULL,
    PaymentDate         DATE DEFAULT SYSDATE,
    AmountPaid          NUMBER(8,2) NOT NULL,
    PaymentMethod       VARCHAR2(12) NOT NULL,
    PaymentStatus       VARCHAR2(10) NOT NULL,
    CONSTRAINT pk_payment PRIMARY KEY (PaymentID),
    CONSTRAINT fk_payment_student FOREIGN KEY (StudentID) REFERENCES STUDENT (StudentID),
    CONSTRAINT fk_payment_enrolment FOREIGN KEY (EnrolmentID) REFERENCES ENROLMENT (EnrolmentID),
    CONSTRAINT chk_payment_amount CHECK (AmountPaid > 0),
    CONSTRAINT chk_payment_method CHECK (PaymentMethod IN ('Cash','Card','BankTransfer')),
    CONSTRAINT chk_payment_status CHECK (PaymentStatus IN ('Paid','Partial'))
   
);   
