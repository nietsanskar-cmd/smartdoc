# SMARTDOC — Intelligent Digital Student Document Management & Verification System

SMARTDOC is an enterprise-grade academic document lifecycle management, digital vault, and verification platform designed for higher education institutions (Colleges and Universities).

---

## 🌟 Key Innovations

1. **Smart Document Completeness Score Engine**: Dynamic weighted percentage calculation based on institutional requirements, verification status, and expiry validity ($0-100\%$, categorized into Critical, Incomplete, Good, and Excellent tiers).
2. **Document Lifecycle State Machine**: Full discrete state tracking (`UPLOADED` $\rightarrow$ `UNDER_REVIEW` $\rightarrow$ `VERIFIED`/`REJECTED` $\rightarrow$ `ACTIVE` $\rightarrow$ `EXPIRING` $\rightarrow$ `EXPIRED` $\rightarrow$ `RENEWED`/`REPLACED`).
3. **SHA-256 Cryptographic File Fingerprinting**: Byte-level duplicate detection preventing redundant or falsified uploads.
4. **QR-Based Public Authenticity Verification Engine**: Tamper-proof public verification tokens with QR code rendering for third-party validation (employers, embassies, visa councils).
5. **Time-Limited & Protected Document Sharing**: Ephemeral share links with custom expiration, access counters, passkeys, and real-time revocation.
6. **Institutional Document Request Workflow**: Streamlined issuance of Bonafide, Transcripts, NOCs, and Provisional Certificates.
7. **Forensic Audit Trail & Download Ledger**: Granular recording of all mutations, reads, shares, and downloads.

---

## 🛠️ Technology Stack

* **Backend**: Java (JDK 17+), Spring Boot 3.2.5, Spring MVC, Spring Data JPA, Hibernate ORM
* **Frontend**: Server-Side JSP 2.3, JSTL 1.2, Expression Language (EL), Bootstrap 5, Chart.js, Fetch API
* **Security**: BCrypt Password Hashing, Session Management, Role-Based Interceptors, XSS Request Sanitization
* **Database**: MySQL 8.x (InnoDB Engine, 22 Normalized Tables)
* **File & Crypto**: Java NIO, `MessageDigest` (SHA-256), ZXing 3.5.3 (QR Code Generation)

---

## 🚀 Quickstart & Setup Guide

### 1. Database Setup in MySQL Workbench
1. Open MySQL Workbench or MySQL CLI.
2. Execute the DDL Schema script:
   ```sql
   source database/smartdoc_schema.sql;
   ```
3. Execute the Seed Demo data script:
   ```sql
   source database/smartdoc_data.sql;
   ```

### 2. Configure Database Connection
Update `src/main/resources/application.properties` with your MySQL credentials:
```properties
spring.datasource.url=jdbc:mysql://localhost:3306/smartdoc_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true
spring.datasource.username=root
spring.datasource.password=root
```

### 3. Build & Run Application
From the project root:
```bash
mvn clean package
mvn spring-boot:run
```

Access the application in your browser at:
`http://localhost:8080`

---

## 🔑 Default Institutional Credentials

| Role | Username | Password | Dashboard URL |
| :--- | :--- | :--- | :--- |
| **Administrator** | `admin` | `password123` | `/admin/dashboard` |
| **Faculty Reviewer** | `dr.sharma` | `password123` | `/faculty/dashboard` |
| **Faculty Reviewer** | `prof.patel` | `password123` | `/faculty/dashboard` |
| **Student** | `student.aarav` | `password123` | `/student/dashboard` |
| **Student** | `student.diya` | `password123` | `/student/dashboard` |
| **Student** | `student.rohan` | `password123` | `/student/dashboard` |

---

## 📡 REST API Endpoints Summary

* `POST /api/auth/login` - User authentication
* `POST /api/auth/register` - Student self-registration
* `GET /api/students` - List / search enrolled students
* `GET /api/students/{id}/completeness` - Student completeness score
* `GET /api/documents` - Search documents across institution
* `POST /api/verification/{id}/verify` - Reviewer approval/rejection endpoint
* `GET /api/analytics/dashboard` - Global institutional analytics
* `GET /verify/document/{token}` - Public QR code verification landing page
* `GET /shared/{token}` - Public time-limited shared document access
