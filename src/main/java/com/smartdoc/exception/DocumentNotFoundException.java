package com.smartdoc.exception;

public class DocumentNotFoundException extends ResourceNotFoundException {
    public DocumentNotFoundException(String message) {
        super(message);
    }
}
