drop database quizitdb;
create user quizit with password 'password';
create database quizitdb with template=template0 owner=quizit;

\connect quizitdb;
alter default privileges grant all on tables to quizit;
alter default privileges grant all on sequences to quizit;

create table User(
user_id integer primary key DEFAULT nextval('user_id_seq'),
email varchar(30) unique not null,
username varchar(30) not null,
password varchar(20) not null,
first_name varchar(20),
last_name varchar(20),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create table Quiz(
quiz_id integer primary key DEFAULT nextval('quiz_id_seq'),
title varchar(225) not null,
description TEXT,
created_by integer not null references User(user_id),
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
total_marks integer,
duration interval not null default '10 minutes'
);

CREATE TABLE QuestionType(
type_id SERIAL PRIMARY KEY DEFAULT nextval('type_id_seq'),
type_name VARCHAR(20) UNIQUE NOT NULL
)

create table Question(
 question_id INTEGER PRIMARY KEY DEFAULT nextval('question_id_seq'),
 quiz_id INT NOT NULL REFERENCES Quizzes(quiz_id) ON DELETE CASCADE,
 question_text TEXT NOT NULL,
 question_type_id INT NOT NULL REFERENCES QuestionType(type_id), -- 'MCQ', 'TrueFalse', 'ShortAnswer', 'Matching'
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE MCQ_Questions (
    question_id INT PRIMARY KEY REFERENCES Questions(question_id) ON DELETE CASCADE,
    option_a TEXT NOT NULL,
    option_b TEXT NOT NULL,
    option_c TEXT NOT NULL,
    option_d TEXT NOT NULL,
    correct_option CHAR(1) NOT NULL CHECK (correct_option IN ('A', 'B', 'C', 'D'))
);

CREATE TABLE TrueFalse_Questions (
    question_id INT PRIMARY KEY REFERENCES Questions(question_id) ON DELETE CASCADE,
    correct_answer BOOLEAN NOT NULL
);

CREATE TABLE ShortAnswer_Questions (
    question_id INT PRIMARY KEY REFERENCES Questions(question_id) ON DELETE CASCADE,
    correct_answer TEXT NOT NULL
);

CREATE TABLE Matching_Questions (
    question_id INT NOT NULL REFERENCES Questions(question_id) ON DELETE CASCADE,
    pair_id SERIAL PRIMARY KEY,
    term TEXT NOT NULL,
    match TEXT NOT NULL
);

CREATE SEQUENCE user_id_seq START 1 INCREMENT BY 1 CACHE 1;
CREATE SEQUENCE quiz_id_seq START 1 INCREMENT BY 1 CACHE 1;
CREATE SEQUENCE type_id_seq START 1 INCREMENT BY 1 CACHE 1;
CREATE SEQUENCE question_id_seq START 1 INCREMENT BY 1 CACHE 1;





