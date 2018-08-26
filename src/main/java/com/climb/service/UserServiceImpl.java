package com.climb.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.climb.domain.Role;
import com.climb.domain.User;
import com.climb.exception.UserAlreadyExistsException;
import com.climb.repository.RoleRepository;
import com.climb.repository.UserRepository;

@Service
public class UserServiceImpl implements UserService {
	@Autowired
    private UserRepository userRepository;
	
	@Autowired
    private RoleRepository roleRepository;
	
	@Override
	public User getUserById(int id) {
		// TODO Auto-generated method stub
		return this.userRepository.findById(id);
	}

	@Override
	public User createUser(User user , String roleName) {
		// TODO Auto-generated method stub
		if(this.isExistUser(user)) {
			throw new UserAlreadyExistsException();
		}
		
		Role role = this.roleRepository.findByRole(roleName);
		
		User newUser = new User();
		newUser.getRoles().add(role);
		newUser.setEmail(user.getEmail());
		newUser.setUid(user.getUid());
		newUser.setName(user.getName());
		return this.userRepository.save(newUser);
	}

	@Override
	public User updateUser(User user) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void deleteUser(Long id) {
		// TODO Auto-generated method stub

	}
	
	@Override
	public boolean isExistUser(User user) {
		return this.userRepository.findByEmailOrUid(user.getEmail() , user.getUid()) != null ? true : false;
	}

	@Override
	public Page<User> getAll(Pageable pageable) {
		return this.userRepository.findAll(pageable);
	}
	

}
