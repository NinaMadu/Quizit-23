DROP DATABASE IF EXISTS quizitdb;
DROP ROLE IF EXISTS quizit;

CREATE ROLE quizit WITH LOGIN PASSWORD 'password';
CREATE DATABASE quizitdb WITH TEMPLATE=template0 OWNER=quizit;

\connect quizitdb;

ALTER DEFAULT PRIVILEGES FOR ROLE quizit GRANT ALL ON TABLES TO quizit;
ALTER DEFAULT PRIVILEGES FOR ROLE quizit GRANT ALL ON SEQUENCES TO quizit;

-- Create sequences
CREATE SEQUENCE user_id_seq START 1 INCREMENT BY 1 CACHE 1;
CREATE SEQUENCE quiz_id_seq START 1 INCREMENT BY 1 CACHE 1;
CREATE SEQUENCE type_id_seq START 1 INCREMENT BY 1 CACHE 1;
CREATE SEQUENCE question_id_seq START 1 INCREMENT BY 1 CACHE 1;

-- Users table
CREATE TABLE Users (
    user_id INTEGER PRIMARY KEY DEFAULT nextval('user_id_seq'),
    email VARCHAR(30) UNIQUE NOT NULL,
    username VARCHAR(30) NOT NULL,
    password VARCHAR(20) NOT NULL,
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Quiz table
CREATE TABLE Quiz (
    quiz_id INTEGER PRIMARY KEY DEFAULT nextval('quiz_id_seq'),
    title VARCHAR(225) NOT NULL,
    description TEXT,
    created_by INTEGER NOT NULL REFERENCES Users(user_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_marks INTEGER,
    duration INTERVAL NOT NULL DEFAULT '10 minutes'
);

-- QuestionType table
CREATE TABLE QuestionType (
    type_id INTEGER PRIMARY KEY DEFAULT nextval('type_id_seq'),
    type_name VARCHAR(20) UNIQUE NOT NULL
);

-- Question table
CREATE TABLE Question (
    question_id INTEGER PRIMARY KEY DEFAULT nextval('question_id_seq'),
    quiz_id INTEGER NOT NULL REFERENCES Quiz(quiz_id) ON DELETE CASCADE,
    question_text TEXT NOT NULL,
    question_type_id INTEGER NOT NULL REFERENCES QuestionType(type_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- MCQ Questions table
CREATE TABLE MCQ_Questions (
    question_id INTEGER PRIMARY KEY REFERENCES Question(question_id) ON DELETE CASCADE,
    option_a TEXT NOT NULL,
    option_b TEXT NOT NULL,
    option_c TEXT NOT NULL,
    option_d TEXT NOT NULL,
    correct_option CHAR(1) NOT NULL CHECK (correct_option IN ('A', 'B', 'C', 'D'))
);

-- True/False Questions table
CREATE TABLE TrueFalse_Questions (
    question_id INTEGER PRIMARY KEY REFERENCES Question(question_id) ON DELETE CASCADE,
    correct_answer BOOLEAN NOT NULL
);

-- Short Answer Questions table
CREATE TABLE ShortAnswer_Questions (
    question_id INTEGER PRIMARY KEY REFERENCES Question(question_id) ON DELETE CASCADE,
    correct_answer TEXT NOT NULL
);

-- Matching Questions table
CREATE TABLE Matching_Questions (
    question_id INTEGER NOT NULL REFERENCES Question(question_id) ON DELETE CASCADE,
    pair_id SERIAL PRIMARY KEY,
    term TEXT NOT NULL,
    match TEXT NOT NULL
);
