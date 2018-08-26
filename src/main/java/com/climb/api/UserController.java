package com.climb.api;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import java.lang.reflect.Type;
import java.util.Set;
import java.util.stream.Collectors;

import com.climb.domain.Role;
import com.climb.domain.RoleDTO;
import com.climb.domain.User;
import com.climb.domain.UserDTO;
import com.climb.service.UserService;
import com.google.common.reflect.TypeToken;

@RestController
@RequestMapping("/user")
public class UserController {
	@Autowired
    private UserService userService;
	
	@Autowired
	private ModelMapper modelMapper;
		
	public UserController() {
        
}
	
	/*@CrossOrigin
	@RequestMapping(method = RequestMethod.GET)
	public int getUser() {
		return this.userRepository.findByEmailOrUid("rogerio.teixeira@hotmail.it","124");

	}*/
	
	@CrossOrigin
	@RequestMapping(value="/{id}" , method = RequestMethod.GET)
	public ResponseEntity<UserDTO> getUserById(@PathVariable(value = "id") int id) {
		User user = this.userService.getUserById(id);
		UserDTO userDto = modelMapper.map(user, UserDTO.class);
		Set<String> role = user.getRoles().stream().map(a -> a.getRole()).collect(Collectors.toSet());
		userDto.setRole(role);
		return new  ResponseEntity<UserDTO>(userDto, HttpStatus.OK);

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
		return new  ResponseEntity<User>(this.userService.createUser(user, "USER"), HttpStatus.OK);

	}
}
