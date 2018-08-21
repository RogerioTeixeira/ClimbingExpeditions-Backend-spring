package com.climb.domain;

import java.util.Date;

import javax.persistence.*;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Entity
@Table(name = "users")
@SequenceGenerator(
        name = AbstractEntity.GENERATOR,
        sequenceName = "seq_users",
        allocationSize=1,
        initialValue = 1
)
@Getter @Setter @NoArgsConstructor
public class User extends AbstractEntity {
	
	private static final long serialVersionUID = -5787038919803479057L;

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
