package com.climb.domain;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.ManyToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Entity
@Table(name = "role")
@SequenceGenerator(
        name = AbstractEntity.GENERATOR,
        sequenceName = "seq_users",
        allocationSize=1,
        initialValue = 1
)
@Getter
@Setter
@NoArgsConstructor
public class Role extends AbstractEntity {
	
	private static final long serialVersionUID = -5787038919803479057L;

    private String role;
    
    @ManyToMany(fetch = FetchType.LAZY, mappedBy="roles")
    private Set<User> users = new HashSet<>();;

}
