package com.quiz.app.quizitapi.repositories;

import com.quiz.app.quizitapi.domain.Users;
import com.quiz.app.quizitapi.exceptions.EtAuthException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;

@Repository
public class UserRepositoryImpl implements UserRepository{

    private static final String SQL_CREATE = "INSERT INTO users(USER_ID, FIRST_NAME, LAST_NAME, EMAIL, USERNAME, PASSWORD) VALUES(NEXTVAL('USER_ID_SEQ'), ?, ?, ?, ?, ?) ";
    private static final String SQL_COUNT_BY_EMAIL = "SELECT COUNT(*) FROM users WHERE EMAIL = ?";
    private static final String SQL_FIND_BY_ID = "SELECT USER_ID, FIRST_NAME, LAST_NAME, EMAIL, USERNAME, PASSWORD " + "FROM users WHERE USER_ID = ?";

    @Autowired
    JdbcTemplate jdbcTemplate;

    @Override
    public Integer create(String firstName, String lastName, String email, String username, String password) throws EtAuthException {
       try {
            KeyHolder keyHolder = new GeneratedKeyHolder();
            jdbcTemplate.update(connection -> {
                PreparedStatement ps = connection.prepareStatement(SQL_CREATE, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, firstName);
                ps.setString(2, lastName);
                ps.setString(3, email);
                ps.setString(4, username);
                ps.setString(5, password);
                return ps;

            }, keyHolder);
            return (Integer)  keyHolder.getKeys().get("USER_ID");
       }catch (Exception e) {
           throw new EtAuthException(("Invalied details. Failed to create account"));
       }
    }

    @Override
    public Users findByEmailAndPassword(String email, String password) throws EtAuthException {
        return null;
    }

    @Override
    public Integer getCountByEmail(String email) {
        return jdbcTemplate.queryForObject(SQL_COUNT_BY_EMAIL, new Object[]{email}, Integer.class );
    }

    @Override
    public Users findById(Integer user_id) {
        return jdbcTemplate.queryForObject(SQL_FIND_BY_ID, new Object[]{user_id}, userRowMapper);
    }

    private RowMapper<Users> userRowMapper = ((rs, rowNum) -> {
        return new Users(rs.getInt("USER_ID"),
                rs.getString("FIRST_NAME"),
                rs.getString("LAST_NAME"),
                rs.getString("EMAIL"),
                rs.getString("USERNAME"),
                rs.getString("PASSWORD"));
    });
}
