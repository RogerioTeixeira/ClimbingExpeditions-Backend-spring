package com.climb;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.hateoas.config.EnableHypermediaSupport;

@SpringBootApplication
@EnableJpaAuditing
public class ClimbingExpeditionsApplication {

	public static void main(String[] args) {
		SpringApplication.run(ClimbingExpeditionsApplication.class, args);
	}
}
