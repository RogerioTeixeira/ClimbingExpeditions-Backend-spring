package com.climb.assembler;

import org.springframework.hateoas.mvc.ResourceAssemblerSupport;
import org.springframework.stereotype.Component;

import com.climb.api.UserController;
import com.climb.domain.User;
import com.climb.domain.UserResource;
@Component
public class UserAssembler extends ResourceAssemblerSupport<User, UserResource> {
	 public UserAssembler() {
		 super(UserController.class,UserResource.class);
	 }

	@Override
	public UserResource toResource(User entity) {
		 UserResource resource = createResourceWithId(entity.getId(), entity);
		 resource.setEmail(entity.getEmail());
		 resource.setUid(entity.getUid());
		 return resource;
	}
}
