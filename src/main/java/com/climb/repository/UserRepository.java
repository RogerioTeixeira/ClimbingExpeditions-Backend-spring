package com.climb.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.climb.domain.User;
import com.climb.domain.UserResponse;

public interface UserRepository extends JpaRepository<User, Integer> {
	@Query(value = "SELECT * FROM climb.users where email = :email or uid=:uid",nativeQuery = true) 
	User findByEmailOrUid(@Param("email") String email, @Param("uid") String uid);
	
	UserResponse findById(int id);

}
