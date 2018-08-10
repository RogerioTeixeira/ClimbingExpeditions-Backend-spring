package com.climb.repository;
import org.springframework.data.mongodb.repository.MongoRepository;

import com.climb.domain.User;

public interface UserRepository extends MongoRepository<User, Integer> {

}
