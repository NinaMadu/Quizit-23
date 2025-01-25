package com.quiz.app.quizitapi.repositories;

import com.quiz.app.quizitapi.domain.Users;
import com.quiz.app.quizitapi.exceptions.EtAuthException;
import org.apache.catalina.User;

public interface UserRepository {
    Integer create(String firstName, String lastName, String email, String username, String password) throws EtAuthException;
    Users findByEmailAndPassword(String email, String password) throws EtAuthException;
    Integer getCountByEmail(String email);
    Users findById(Integer user_id);


}
