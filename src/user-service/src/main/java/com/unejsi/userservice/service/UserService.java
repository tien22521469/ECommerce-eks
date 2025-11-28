package com.unejsi.userservice.service;

import com.unejsi.userservice.entity.User;
import com.unejsi.userservice.repository.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    @Transactional
    public User register(User user) {
        return userRepository.save(user);
    }

    @Transactional(readOnly = true)
    public boolean userExists(String email) {
        return userRepository.existsByEmail(email);
    }
}

