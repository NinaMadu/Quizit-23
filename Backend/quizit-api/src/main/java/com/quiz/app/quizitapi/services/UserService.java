package com.quiz.app.quizitapi.services;

import com.quiz.app.quizitapi.domain.Users;
import com.quiz.app.quizitapi.exceptions.EtAuthException;

public interface UserService {

    Users validateUser(String email, String password) throws EtAuthException;

    Users registerUser(String firstName, String lastName, String email, String username, String password) throws EtAuthException;
}