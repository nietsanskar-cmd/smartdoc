-- ====================================================================
-- SMARTDOC: Intelligent Digital Student Document Management System
-- Complete MySQL 8.x Database Schema (DDL)
-- ====================================================================

CREATE DATABASE IF NOT EXISTS `smartdoc_db` 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `smartdoc_db`;

-- Drop tables in reverse order of foreign keys for clean recreate
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS `system_settings`;
DROP TABLE IF EXISTS `download_history`;
DROP TABLE IF EXISTS `login_history`;
DROP TABLE IF EXISTS `audit_logs`;
DROP TABLE IF EXISTS `notifications`;
DROP TABLE IF EXISTS `document_share_logs`;
DROP TABLE IF EXISTS `document_shares`;
DROP TABLE IF EXISTS `document_requests`;
DROP TABLE IF EXISTS `document_verifications`;
DROP TABLE IF EXISTS `document_versions`;
DROP TABLE IF EXISTS `documents`;
DROP TABLE IF EXISTS `required_documents`;
DROP TABLE IF EXISTS `document_types`;
DROP TABLE IF EXISTS `document_categories`;
DROP TABLE IF EXISTS `faculty`;
DROP TABLE IF EXISTS `students`;
DROP TABLE IF EXISTS `semesters`;
DROP TABLE IF EXISTS `academic_years`;
DROP TABLE IF EXISTS `courses`;
DROP TABLE IF EXISTS `departments`;
DROP TABLE IF EXISTS `users`;
DROP TABLE IF EXISTS `roles`;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. ROLES TABLE
CREATE TABLE `roles` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `role_name` VARCHAR(50) NOT NULL UNIQUE,
    `description` VARCHAR(255) NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. USERS TABLE
CREATE TABLE `users` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `username` VARCHAR(100) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,
    `email` VARCHAR(150) NOT NULL UNIQUE,
    `role_id` BIGINT NOT NULL,
    `is_active` BOOLEAN DEFAULT TRUE,
    `email_verified` BOOLEAN DEFAULT TRUE,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2.1 OTP_VERIFICATIONS TABLE
CREATE TABLE `otp_verifications` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `email` VARCHAR(150) NOT NULL,
    `otp_hash` VARCHAR(255) NOT NULL,
    `purpose` VARCHAR(50) NOT NULL,
    `expires_at` DATETIME NOT NULL,
    `verified` BOOLEAN DEFAULT FALSE,
    `attempt_count` INT DEFAULT 0,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX `idx_otp_email_purpose` (`email`, `purpose`),
    INDEX `idx_otp_expires_at` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. DEPARTMENTS TABLE
CREATE TABLE `departments` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `dept_code` VARCHAR(20) NOT NULL UNIQUE,
    `dept_name` VARCHAR(150) NOT NULL,
    `description` TEXT NULL,
    `is_active` BOOLEAN DEFAULT TRUE,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. COURSES TABLE
CREATE TABLE `courses` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `course_code` VARCHAR(20) NOT NULL UNIQUE,
    `course_name` VARCHAR(150) NOT NULL,
    `department_id` BIGINT NOT NULL,
    `total_semesters` INT NOT NULL DEFAULT 8,
    `degree_level` VARCHAR(50) DEFAULT 'Undergraduate',
    `is_active` BOOLEAN DEFAULT TRUE,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_courses_department` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. ACADEMIC_YEARS TABLE
CREATE TABLE `academic_years` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `year_name` VARCHAR(50) NOT NULL UNIQUE,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `is_current` BOOLEAN DEFAULT FALSE,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. SEMESTERS TABLE
CREATE TABLE `semesters` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `semester_number` INT NOT NULL UNIQUE,
    `semester_name` VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. FACULTY TABLE
CREATE TABLE `faculty` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL UNIQUE,
    `employee_code` VARCHAR(50) NOT NULL UNIQUE,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `phone` VARCHAR(20) NULL,
    `department_id` BIGINT NOT NULL,
    `designation` VARCHAR(100) NOT NULL,
    `qualification` VARCHAR(100) NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_faculty_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_faculty_dept` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. STUDENTS TABLE
CREATE TABLE `students` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL UNIQUE,
    `enrollment_no` VARCHAR(50) NOT NULL UNIQUE,
    `roll_no` VARCHAR(50) NOT NULL UNIQUE,
    `first_name` VARCHAR(100) NOT NULL,
    `last_name` VARCHAR(100) NOT NULL,
    `dob` DATE NULL,
    `gender` VARCHAR(20) NULL,
    `phone` VARCHAR(20) NULL,
    `department_id` BIGINT NOT NULL,
    `course_id` BIGINT NOT NULL,
    `academic_year_id` BIGINT NOT NULL,
    `current_semester_id` BIGINT NOT NULL,
    `assigned_faculty_id` BIGINT NULL,
    `completeness_score` DECIMAL(5,2) DEFAULT 0.00,
    `completeness_tier` VARCHAR(30) DEFAULT 'CRITICAL',
    `profile_image_path` VARCHAR(255) NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_students_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_students_dept` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_students_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_students_year` FOREIGN KEY (`academic_year_id`) REFERENCES `academic_years` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_students_sem` FOREIGN KEY (`current_semester_id`) REFERENCES `semesters` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_students_faculty` FOREIGN KEY (`assigned_faculty_id`) REFERENCES `faculty` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. DOCUMENT_CATEGORIES TABLE
CREATE TABLE `document_categories` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `category_name` VARCHAR(100) NOT NULL UNIQUE,
    `description` VARCHAR(255) NULL,
    `icon_class` VARCHAR(50) DEFAULT 'bi-folder',
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 10. DOCUMENT_TYPES TABLE
CREATE TABLE `document_types` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `category_id` BIGINT NOT NULL,
    `type_code` VARCHAR(50) NOT NULL UNIQUE,
    `type_name` VARCHAR(150) NOT NULL,
    `description` VARCHAR(255) NULL,
    `is_expiry_applicable` BOOLEAN DEFAULT FALSE,
    `default_validity_months` INT DEFAULT 0,
    `is_active` BOOLEAN DEFAULT TRUE,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_doc_types_category` FOREIGN KEY (`category_id`) REFERENCES `document_categories` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 11. REQUIRED_DOCUMENTS TABLE
CREATE TABLE `required_documents` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `document_type_id` BIGINT NOT NULL,
    `course_id` BIGINT NULL,
    `semester_id` BIGINT NULL,
    `is_mandatory` BOOLEAN DEFAULT TRUE,
    `weightage` INT DEFAULT 10,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_req_docs_type` FOREIGN KEY (`document_type_id`) REFERENCES `document_types` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_req_docs_course` FOREIGN KEY (`course_id`) REFERENCES `courses` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_req_docs_semester` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 12. DOCUMENTS TABLE
CREATE TABLE `documents` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `document_code` VARCHAR(60) NOT NULL UNIQUE,
    `student_id` BIGINT NOT NULL,
    `document_type_id` BIGINT NOT NULL,
    `title` VARCHAR(200) NOT NULL,
    `current_version` INT DEFAULT 1,
    `status` VARCHAR(50) NOT NULL DEFAULT 'UPLOADED',
    `file_name` VARCHAR(255) NOT NULL,
    `stored_file_path` VARCHAR(500) NOT NULL,
    `file_size_bytes` BIGINT NOT NULL,
    `mime_type` VARCHAR(100) NOT NULL,
    `sha256_hash` VARCHAR(64) NOT NULL,
    `verification_token` VARCHAR(100) UNIQUE NOT NULL,
    `qr_code_path` VARCHAR(500) NULL,
    `issue_date` DATE NULL,
    `expiry_date` DATE NULL,
    `verified_at` DATETIME NULL,
    `verified_by_user_id` BIGINT NULL,
    `rejection_reason` VARCHAR(100) NULL,
    `rejection_remarks` TEXT NULL,
    `is_archived` BOOLEAN DEFAULT FALSE,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_docs_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_docs_type` FOREIGN KEY (`document_type_id`) REFERENCES `document_types` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_docs_verifier` FOREIGN KEY (`verified_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL,
    INDEX `idx_doc_hash` (`sha256_hash`),
    INDEX `idx_doc_status` (`status`),
    INDEX `idx_doc_token` (`verification_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 13. DOCUMENT_VERSIONS TABLE
CREATE TABLE `document_versions` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `document_id` BIGINT NOT NULL,
    `version_number` INT NOT NULL,
    `file_name` VARCHAR(255) NOT NULL,
    `stored_file_path` VARCHAR(500) NOT NULL,
    `file_size_bytes` BIGINT NOT NULL,
    `mime_type` VARCHAR(100) NOT NULL,
    `sha256_hash` VARCHAR(64) NOT NULL,
    `uploaded_by_user_id` BIGINT NOT NULL,
    `change_summary` VARCHAR(255) NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_doc_versions_doc` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_doc_versions_uploader` FOREIGN KEY (`uploaded_by_user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
    UNIQUE KEY `uk_doc_version` (`document_id`, `version_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 14. DOCUMENT_VERIFICATIONS TABLE
CREATE TABLE `document_verifications` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `document_id` BIGINT NOT NULL,
    `faculty_id` BIGINT NULL,
    `action` VARCHAR(50) NOT NULL,
    `remarks` TEXT NULL,
    `reason_code` VARCHAR(100) NULL,
    `decision_date` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_doc_verif_doc` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_doc_verif_faculty` FOREIGN KEY (`faculty_id`) REFERENCES `faculty` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 15. DOCUMENT_REQUESTS TABLE
CREATE TABLE `document_requests` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `request_no` VARCHAR(60) NOT NULL UNIQUE,
    `student_id` BIGINT NOT NULL,
    `document_type_id` BIGINT NOT NULL,
    `purpose` VARCHAR(255) NOT NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'REQUESTED',
    `admin_remarks` TEXT NULL,
    `generated_document_id` BIGINT NULL,
    `requested_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `completed_at` DATETIME NULL,
    CONSTRAINT `fk_doc_req_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_doc_req_type` FOREIGN KEY (`document_type_id`) REFERENCES `document_types` (`id`) ON DELETE RESTRICT,
    CONSTRAINT `fk_doc_req_gendoc` FOREIGN KEY (`generated_document_id`) REFERENCES `documents` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 16. DOCUMENT_SHARES TABLE
CREATE TABLE `document_shares` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `document_id` BIGINT NOT NULL,
    `student_id` BIGINT NOT NULL,
    `share_token` VARCHAR(100) NOT NULL UNIQUE,
    `recipient_email` VARCHAR(150) NULL,
    `access_passcode_hash` VARCHAR(255) NULL,
    `expires_at` DATETIME NOT NULL,
    `max_access_count` INT DEFAULT 10,
    `current_access_count` INT DEFAULT 0,
    `is_revoked` BOOLEAN DEFAULT FALSE,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_doc_shares_doc` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_doc_shares_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
    INDEX `idx_share_token` (`share_token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 17. DOCUMENT_SHARE_LOGS TABLE
CREATE TABLE `document_share_logs` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `share_id` BIGINT NOT NULL,
    `accessed_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `ip_address` VARCHAR(50) NULL,
    `user_agent` VARCHAR(255) NULL,
    `access_status` VARCHAR(50) NOT NULL,
    CONSTRAINT `fk_share_logs_share` FOREIGN KEY (`share_id`) REFERENCES `document_shares` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 18. NOTIFICATIONS TABLE
CREATE TABLE `notifications` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL,
    `title` VARCHAR(200) NOT NULL,
    `message` TEXT NOT NULL,
    `type` VARCHAR(50) NOT NULL DEFAULT 'SYSTEM',
    `link_url` VARCHAR(255) NULL,
    `is_read` BOOLEAN DEFAULT FALSE,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_notif_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 19. AUDIT_LOGS TABLE
CREATE TABLE `audit_logs` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NULL,
    `action` VARCHAR(100) NOT NULL,
    `entity_type` VARCHAR(100) NOT NULL,
    `entity_id` BIGINT NULL,
    `ip_address` VARCHAR(50) NULL,
    `details` TEXT NULL,
    `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_audit_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 20. LOGIN_HISTORY TABLE
CREATE TABLE `login_history` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `user_id` BIGINT NOT NULL,
    `login_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `logout_time` DATETIME NULL,
    `ip_address` VARCHAR(50) NULL,
    `user_agent` VARCHAR(255) NULL,
    `status` VARCHAR(50) NOT NULL DEFAULT 'SUCCESS',
    CONSTRAINT `fk_login_hist_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 21. DOWNLOAD_HISTORY TABLE
CREATE TABLE `download_history` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `document_id` BIGINT NOT NULL,
    `downloaded_by_user_id` BIGINT NULL,
    `download_type` VARCHAR(50) NOT NULL,
    `ip_address` VARCHAR(50) NULL,
    `downloaded_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_dl_hist_doc` FOREIGN KEY (`document_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_dl_hist_user` FOREIGN KEY (`downloaded_by_user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 22. SYSTEM_SETTINGS TABLE
CREATE TABLE `system_settings` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `setting_key` VARCHAR(100) NOT NULL UNIQUE,
    `setting_value` TEXT NOT NULL,
    `description` VARCHAR(255) NULL,
    `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
