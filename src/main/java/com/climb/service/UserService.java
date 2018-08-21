package com.climb.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.climb.domain.User;

public interface UserService {
	User getUserById(int id);

    User createUser(User user);

    User updateUser(User user);
    
    boolean isExistUser(User user);

    void deleteUser(Long id);
    
    Page<User> getAll(Pageable pageable);

}
