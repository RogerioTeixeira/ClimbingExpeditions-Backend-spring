package com.climb.domain;

import javax.persistence.*;
import javax.persistence.Id;


@Entity
@Table(name = "users")
public class User {
	@Id
	private int id;
	
	private String uid;
    
	public int getId() {
		return id;
	}


	public void setId(int id) {
		this.id = id;
	}


	public String getUid() {
		return uid;
	}


	public void setUid(String uid) {
		this.uid = uid;
	}

	private String email;
	


	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

}
