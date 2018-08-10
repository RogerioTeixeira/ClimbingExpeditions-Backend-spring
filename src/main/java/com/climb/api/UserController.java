package com.climb.api;

import java.util.ArrayList;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.climb.domain.User;
import com.climb.repository.UserRepository;

@RestController
@RequestMapping("/user")
public class UserController {
	private UserRepository userRepository;
	
	public UserController(UserRepository userRepository) {
        this.userRepository = userRepository;
}
	
	@CrossOrigin
	@RequestMapping(method = RequestMethod.GET)
	public ResponseEntity<User> getUser() {
		User user = new User("1234", "Rogerio", "Rogerio.teixeira@hotmail.it");
		this.userRepository.save(user);
		return new ResponseEntity<>(new User("1234", "Rogerio", "Rogerio.teixeira@hotmail.it"), HttpStatus.OK);

	}
	
	@CrossOrigin
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public ResponseEntity<ArrayList<User>> getUserList() {
		ArrayList<User> list = new ArrayList<>();
		list.add(new User("1234", "Rogerio", "Rogerio.teixeira@hotmail.it"));
		list.add(new User("7448", "Mario", "Mario.teixeira@hotmail.it"));
		return new ResponseEntity<>(list , HttpStatus.OK);

	}
}
