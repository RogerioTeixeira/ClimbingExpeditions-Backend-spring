package com.climb.domain;

import java.util.Set;

public interface UserResponse {
	public int getId();
	public String getUid();
	public String getName();
	public String getEmail();
	public Set<String> getRole(); 

}
