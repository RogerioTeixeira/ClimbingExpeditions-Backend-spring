package com.climb.repository;
import org.springframework.data.jpa.repository.JpaRepository;

import com.climb.domain.User;

public interface UserRepository extends JpaRepository<User, Integer> {

}
