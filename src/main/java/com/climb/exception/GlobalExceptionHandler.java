package com.climb.exception;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.HttpStatus;

@RestControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {

	@ExceptionHandler({ResourceNotFoundException.class})
    public ResponseEntity<Object> handleInvalidRequest(ResourceNotFoundException e, WebRequest request) {
		return this.makeResponse(HttpStatus.NOT_FOUND,"Risorsa non trovata");
    }
	
	@ExceptionHandler({UserAlreadyExistsException.class})
    public ResponseEntity<Object> handleInvalidRequest(UserAlreadyExistsException e, WebRequest request) {
         
         return this.makeResponse(HttpStatus.BAD_REQUEST,"Utente già registrato");
    }
	
	private ResponseEntity<Object> makeResponse(HttpStatus status , String msg){
		ErrorResource body = new  ErrorResource(status,msg);
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        return new ResponseEntity<>(body, headers, status);

	}
}
