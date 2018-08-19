package com.climb.exception;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import org.springframework.http.HttpStatus;

@JsonIgnoreProperties(ignoreUnknown = true)

public class ErrorResource {
	private int code;
    private String text;
    private String message;
    
    public String getText() {
		return this.text;
	}

	public void setText(String text) {
		this.text = text;
	}
	
	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

    
    public ErrorResource(int code, String text, String message) {
        this.code = code;
        this.message = message;
        this.text = text;
    }
    
    public ErrorResource(HttpStatus status, String message) {
        this.code = status.value();
        this.text = status.name();
        this.message = message;
        
    }
}