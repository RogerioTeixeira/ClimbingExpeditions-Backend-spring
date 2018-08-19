package com.climb.domain;

import org.springframework.hateoas.ResourceSupport;

import lombok.Data;

@Data
public class UserResource extends ResourceSupport {

	private String uid;

	private String email;
}
