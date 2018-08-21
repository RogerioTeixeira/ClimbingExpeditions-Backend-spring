package com.climb.api;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;


import com.climb.domain.User;

import com.climb.service.UserService;

@RestController
@RequestMapping("/user")
public class UserController {
	@Autowired
    private UserService userService;
		
	public UserController() {
        
}
	
	/*@CrossOrigin
	@RequestMapping(method = RequestMethod.GET)
	public int getUser() {
		return this.userRepository.findByEmailOrUid("rogerio.teixeira@hotmail.it","124");

	}*/
	
	@CrossOrigin
	@RequestMapping(value="/{id}" , method = RequestMethod.GET)
	public ResponseEntity<User> getUserById(@PathVariable(value = "id") int id) {
		User user = this.userService.getUserById(id);
		return new  ResponseEntity<User>(user, HttpStatus.OK);

	}
	
	@CrossOrigin
	@RequestMapping(method = RequestMethod.GET)
	public Page<User> getUserList(Pageable pageable) {
		Page<User> pg = this.userService.getAll(pageable);
		return pg;
       // PagedResources<UserResource> pagedResources = pageAssembler.toResource(pg,this.userAssemble);
		//return new ResponseEntity<PagedResources<UserResource>>(pagedResources, HttpStatus.OK);

	}
	
	@CrossOrigin
	@RequestMapping(method = RequestMethod.POST)
	public ResponseEntity<User> createUser(@RequestBody User user) {  
		return new  ResponseEntity<User>(this.userService.createUser(user), HttpStatus.OK);

	}
}
