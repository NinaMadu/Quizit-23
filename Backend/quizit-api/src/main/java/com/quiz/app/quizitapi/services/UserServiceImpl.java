package com.quiz.app.quizitapi.services;

import com.quiz.app.quizitapi.domain.Users;
import com.quiz.app.quizitapi.exceptions.EtAuthException;
import com.quiz.app.quizitapi.repositories.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.regex.Pattern;

@Service
@Transactional
public class UserServiceImpl implements UserService{

    @Autowired
    UserRepository userRepository;

    @Override
    public Users validateUser(String email, String password) throws EtAuthException {
        return null;
    }

    @Override
    public Users registerUser(String firstName, String lastName, String email, String username, String password) throws EtAuthException {
        Pattern pattern = Pattern.compile("^(.+)@(.+)$");
        if(email != null) email = email.toLowerCase();
        if(!pattern.matcher(email).matches())
            throw new EtAuthException("Invalied email format");
        Integer count = userRepository.getCountByEmail(email);
        if(count > 0)
            throw new EtAuthException("Email already in use");
        Integer user_id = userRepository.create(firstName, lastName, email, username, password);
        return userRepository.findById(user_id);
    }
}
