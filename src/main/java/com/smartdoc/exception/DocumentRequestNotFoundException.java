package com.smartdoc.exception;

public class DocumentRequestNotFoundException extends ResourceNotFoundException {
    public DocumentRequestNotFoundException(String message) {
        super(message);
    }
}
