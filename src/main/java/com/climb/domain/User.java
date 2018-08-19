package com.climb.domain;

import java.util.Date;

import javax.persistence.*;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Entity
@Table(name = "users")
@Getter @Setter @NoArgsConstructor
public class User extends AuditModel {
	@Id
	@GeneratedValue(generator = "user_generator")
	@SequenceGenerator(
            name = "user_generator",
            sequenceName = "seq_users",
            allocationSize=1,
            initialValue = 1
    )
	@Column(name = "id")
	private int id;
	
    private String uid;
    
	private String email;
	
    @Column(name = "logged_at", nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private Date loggedAt = new Date();
	
	
	public User(String uid, String email) {
		this.uid = uid;
		this.email = email;
	}


}
