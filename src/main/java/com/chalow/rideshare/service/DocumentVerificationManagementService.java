package com.chalow.rideshare.service;

import org.springframework.web.multipart.MultipartFile;

public interface DocumentVerificationManagementService {
    record DocumentVerificationResult(boolean success, String message, Object details, double score) {}
    DocumentVerificationResult retryUserDocumentVerification(Long userId, String documentType);
    DocumentVerificationResult updateUserDocumentAndRetry(Long userId, String documentType, MultipartFile file);
    DocumentVerificationStatusResponse getUserDocumentVerificationStatus(Long userId, String documentType);

    record DocumentVerificationStatusResponse(boolean verified, String message) {}
}
