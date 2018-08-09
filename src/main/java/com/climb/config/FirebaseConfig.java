package com.climb.config;

import java.io.IOException;
import java.io.InputStream;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;


import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

@Configuration
public class FirebaseConfig {

	@Value("${cl.pscode.firebase.config.path}")
	private String configPath;

	@PostConstruct
	public void init() {
		try {
			InputStream input = new ClassPathResource(configPath).getInputStream();
			GoogleCredentials credential = GoogleCredentials.fromStream(input);
			FirebaseOptions options = new FirebaseOptions.Builder().setCredentials(credential).build();
			FirebaseApp.initializeApp(options);
		} catch (IOException e) {
			e.printStackTrace();
		}

	}
}
