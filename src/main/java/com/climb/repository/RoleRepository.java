package com.climb.repository;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.climb.domain.Role;
import com.climb.domain.User;

public interface RoleRepository extends JpaRepository<Role, Integer> {
	Role findById(int id);
	Role findByRole(String role);

}
