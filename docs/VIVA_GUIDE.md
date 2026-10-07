# SMARTDOC — Academic Viva & Technical Defense Guide

## Core Architectural & Advanced Java Concepts

### 1. Why Spring Boot over Standard Spring / Servlets?
Spring Boot provides opinionated "starter" dependencies, auto-configuration of the servlet container (embedded Tomcat), automated transaction management, and eliminates complex `web.xml` and XML configuration files while retaining standard Java Enterprise capabilities.

### 2. Explain Inversion of Control (IoC) & Dependency Injection (DI)
* **IoC (Inversion of Control)**: The framework controls the lifecycle and flow of program execution rather than the developer manually instantiating objects with `new`.
* **DI (Dependency Injection)**: Objects receive their dependencies from the Spring IoC Container (e.g. `@Autowired` or constructor injection via `@RequiredArgsConstructor`), promoting loose coupling, testability, and separation of concerns.

### 3. Difference between JPA and Hibernate
* **JPA (Jakarta Persistence API)**: A standardized Java specification/interface that defines how Java objects map to relational database tables.
* **Hibernate**: The actual underlying Object-Relational Mapping (ORM) provider and implementation of the JPA specification.

### 4. How does the Student Document Completeness Score work?
The system calculates a dynamic percentage:
$$\text{Completeness Score} = \left( \frac{\sum \text{Verified Active Mandatory Documents}}{\sum \text{Required Mandatory Documents for Student's Course/Semester}} \right) \times 100$$
Whenever a document is uploaded, verified, rejected, or expired by the scheduler, the score recalculates in real-time and updates the student's institutional clearance tier (Critical, Incomplete, Good, Excellent).

### 5. How does Duplicate Document Detection work?
Upon file submission, before writing to disk, SMARTDOC computes a **SHA-256 Cryptographic Digest** over the file's raw byte stream (`MessageDigest.getInstance("SHA-256")`). If a document with the identical hash already exists in the institutional vault, a `DuplicateDocumentException` is thrown, preventing redundant storage and duplicate submissions.

### 6. How is QR Authenticity Verification implemented securely?
When a reviewer verifies a document, a unique random verification token (e.g., `VT-2026-X8912`) is generated and encoded into a QR code matrix using the Google ZXing library. When scanned, the QR code resolves to `/verify/document/{token}`, which renders non-sensitive, sanitized authenticity metadata (masked student name, issuing department, verification timestamp, SHA-256 fingerprint) without exposing private files or student data.

### 7. How does Time-Limited Secure Sharing work?
Students can generate ephemeral share tokens with configurable lifetimes (e.g., 24h, 48h), maximum access counters, and optional BCrypt-hashed passcodes. Every access is tracked with IP address and user-agent in `document_share_logs`. A Spring `@Scheduled` background job automatically cleans up expired tokens.
