package com.climb.domain;

import java.util.HashSet;
import java.util.Set;

import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class UserDTO {
	private int id;
	private String uid;
	private String name;
	private String email;
	private Set<String> role = new HashSet<>();

}
