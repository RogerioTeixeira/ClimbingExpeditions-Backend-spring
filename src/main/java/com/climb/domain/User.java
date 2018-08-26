package com.climb.domain;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.*;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonManagedReference;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;



@Entity
@Table(name = "user")
@SequenceGenerator(
        name = AbstractEntity.GENERATOR,
        sequenceName = "seq_users",
        allocationSize=1,
        initialValue = 1
)
@Getter
@Setter
@NoArgsConstructor
public class User extends AbstractEntity {
	
	private static final long serialVersionUID = -5787038919803479057L;

    private String uid;
    
	private String email;
	
	private String name;
	
	@ManyToMany(fetch = FetchType.LAZY,
            cascade = {CascadeType.PERSIST,CascadeType.MERGE})
	@JoinTable(name = "user_role",
            joinColumns = { @JoinColumn(name = "id_user") },
            inverseJoinColumns = { @JoinColumn(name = "id_role") })
	Set<Role> roles = new HashSet<>();
	
	
	public User(String uid, String email) {
		this.uid = uid;
		this.email = email;
	}


}
