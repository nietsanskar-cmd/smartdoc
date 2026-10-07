-- ====================================================================
-- SMARTDOC: Complete Realistic Institutional Seed Data
-- ====================================================================

USE `smartdoc_db`;

-- 1. INSERT ROLES
INSERT INTO `roles` (`id`, `role_name`, `description`) VALUES
(1, 'ROLE_ADMIN', 'Institutional Administrator with full system privileges'),
(2, 'ROLE_FACULTY', 'Academic Faculty Reviewer with document verification privileges'),
(3, 'ROLE_STUDENT', 'Enrolled Student with digital locker and sharing privileges');

-- 2. INSERT USERS
-- Password for all default accounts is: password123 ($2a$10$7Qk8p7IuQf0p9Lw6yC0EpeO/Qx4S3k4v1mF3j7n1f3p5t7q9s1u3u)
-- We will store standard BCrypt hash: $2a$10$7Qk8p7IuQf0p9Lw6yC0EpeO/Qx4S3k4v1mF3j7n1f3p5t7q9s1u3u or plain BCrypt matching
INSERT INTO `users` (`id`, `username`, `password_hash`, `email`, `role_id`, `is_active`) VALUES
(1, 'admin', '$2a$10$A61vQ0K8K7qY/uV7k0bMKeG7jG.qUjJ.n0P.x8R0oQ1u4h8k8u9eW', 'admin@smartdoc.edu', 1, 1),
(2, 'dr.sharma', '$2a$10$A61vQ0K8K7qY/uV7k0bMKeG7jG.qUjJ.n0P.x8R0oQ1u4h8k8u9eW', 'sharma@smartdoc.edu', 2, 1),
(3, 'prof.patel', '$2a$10$A61vQ0K8K7qY/uV7k0bMKeG7jG.qUjJ.n0P.x8R0oQ1u4h8k8u9eW', 'patel@smartdoc.edu', 2, 1),
(4, 'dr.ananya', '$2a$10$A61vQ0K8K7qY/uV7k0bMKeG7jG.qUjJ.n0P.x8R0oQ1u4h8k8u9eW', 'ananya@smartdoc.edu', 2, 1),
(5, 'student.aarav', '$2a$10$A61vQ0K8K7qY/uV7k0bMKeG7jG.qUjJ.n0P.x8R0oQ1u4h8k8u9eW', 'aarav.sharma@student.edu', 3, 1),
(6, 'student.diya', '$2a$10$A61vQ0K8K7qY/uV7k0bMKeG7jG.qUjJ.n0P.x8R0oQ1u4h8k8u9eW', 'diya.verma@student.edu', 3, 1),
(7, 'student.rohan', '$2a$10$A61vQ0K8K7qY/uV7k0bMKeG7jG.qUjJ.n0P.x8R0oQ1u4h8k8u9eW', 'rohan.mehta@student.edu', 3, 1),
(8, 'student.sneha', '$2a$10$A61vQ0K8K7qY/uV7k0bMKeG7jG.qUjJ.n0P.x8R0oQ1u4h8k8u9eW', 'sneha.reddy@student.edu', 3, 1);

-- 3. INSERT DEPARTMENTS
INSERT INTO `departments` (`id`, `dept_code`, `dept_name`, `description`, `is_active`) VALUES
(1, 'CSE', 'Computer Science and Engineering', 'Department of Computing, AI and Software Systems', 1),
(2, 'ECE', 'Electronics and Communication Engineering', 'Department of VLSI, Embedded Systems and IoT', 1),
(3, 'ME', 'Mechanical Engineering', 'Department of Thermal, Robotics and Design Engineering', 1),
(4, 'IT', 'Information Technology', 'Department of Web and Enterprise Computing', 1);

-- 4. INSERT COURSES
INSERT INTO `courses` (`id`, `course_code`, `course_name`, `department_id`, `total_semesters`, `degree_level`, `is_active`) VALUES
(1, 'BTECH_CSE', 'B.Tech in Computer Science and Engineering', 1, 8, 'Undergraduate', 1),
(2, 'BTECH_ECE', 'B.Tech in Electronics and Communication', 2, 8, 'Undergraduate', 1),
(3, 'MTECH_CSE', 'M.Tech in Advanced Computer Science', 1, 4, 'Postgraduate', 1),
(4, 'MCA', 'Master of Computer Applications', 4, 4, 'Postgraduate', 1),
(5, 'BTECH_ME', 'B.Tech in Mechanical Engineering', 3, 8, 'Undergraduate', 1);

-- 5. INSERT ACADEMIC YEARS
INSERT INTO `academic_years` (`id`, `year_name`, `start_date`, `end_date`, `is_current`) VALUES
(1, '2022-2023', '2022-07-01', '2023-06-30', 0),
(2, '2023-2024', '2023-07-01', '2024-06-30', 0),
(3, '2024-2025', '2024-07-01', '2025-06-30', 0),
(4, '2025-2026', '2025-07-01', '2026-06-30', 1);

-- 6. INSERT SEMESTERS
INSERT INTO `semesters` (`id`, `semester_number`, `semester_name`) VALUES
(1, 1, 'Semester 1'),
(2, 2, 'Semester 2'),
(3, 3, 'Semester 3'),
(4, 4, 'Semester 4'),
(5, 5, 'Semester 5'),
(6, 6, 'Semester 6'),
(7, 7, 'Semester 7'),
(8, 8, 'Semester 8');

-- 7. INSERT FACULTY
INSERT INTO `faculty` (`id`, `user_id`, `employee_code`, `first_name`, `last_name`, `phone`, `department_id`, `designation`, `qualification`) VALUES
(1, 2, 'FAC_CSE_001', 'Dr. Ramesh', 'Sharma', '+91 98765 43210', 1, 'Professor & HOD', 'Ph.D. in Computer Science (IIT Bombay)'),
(2, 3, 'FAC_ECE_002', 'Prof. Suresh', 'Patel', '+91 98765 43211', 2, 'Associate Professor', 'M.Tech in VLSI Systems'),
(3, 4, 'FAC_CSE_003', 'Dr. Ananya', 'Gupta', '+91 98765 43212', 1, 'Assistant Professor', 'Ph.D. in Cybersecurity');

-- 8. INSERT STUDENTS
INSERT INTO `students` (`id`, `user_id`, `enrollment_no`, `roll_no`, `first_name`, `last_name`, `dob`, `gender`, `phone`, `department_id`, `course_id`, `academic_year_id`, `current_semester_id`, `assigned_faculty_id`, `completeness_score`, `completeness_tier`) VALUES
(1, 5, 'EN2023CSE0101', '23CSE101', 'Aarav', 'Sharma', '2004-05-15', 'Male', '+91 91234 56780', 1, 1, 4, 5, 1, 80.00, 'GOOD'),
(2, 6, 'EN2023CSE0102', '23CSE102', 'Diya', 'Verma', '2004-08-22', 'Female', '+91 91234 56781', 1, 1, 4, 5, 1, 100.00, 'EXCELLENT'),
(3, 7, 'EN2023ECE0201', '23ECE201', 'Rohan', 'Mehta', '2003-11-10', 'Male', '+91 91234 56782', 2, 2, 4, 5, 2, 40.00, 'CRITICAL'),
(4, 8, 'EN2024MCA0301', '24MCA301', 'Sneha', 'Reddy', '2002-03-30', 'Female', '+91 91234 56783', 4, 4, 4, 3, 3, 60.00, 'INCOMPLETE');

-- 9. INSERT DOCUMENT CATEGORIES
INSERT INTO `document_categories` (`id`, `category_name`, `description`, `icon_class`) VALUES
(1, 'IDENTITY', 'Government and Institutional Identity Documents', 'bi-person-badge'),
(2, 'ACADEMIC', 'High School, Secondary and University Academic Marksheets', 'bi-mortarboard'),
(3, 'COLLEGE', 'Admission Letters, Fee Receipts and Campus IDs', 'bi-building'),
(4, 'CERTIFICATES', 'Internships, Training, Projects and Extra-curricular Certifications', 'bi-award'),
(5, 'OTHER', 'Medical, Domicile, Caste and Miscellaneous Certificates', 'bi-folder2-open');

-- 10. INSERT DOCUMENT TYPES
INSERT INTO `document_types` (`id`, `category_id`, `type_code`, `type_name`, `description`, `is_expiry_applicable`, `default_validity_months`, `is_active`) VALUES
(1, 1, 'AADHAAR_CARD', 'Aadhaar Card', 'Government of India National UID Card', 0, 0, 1),
(2, 1, 'PASSPORT', 'Passport', 'Official Government Issued International Passport', 1, 120, 1),
(3, 1, 'PAN_CARD', 'PAN Card', 'Income Tax Permanent Account Number Card', 0, 0, 1),
(4, 1, 'VOTER_ID', 'Voter ID Card', 'Election Commission of India Identity Card', 0, 0, 1),
(5, 2, 'MARKSHEET_10TH', '10th Standard Marksheet', 'Secondary School Examination (SSC / Matriculation)', 0, 0, 1),
(6, 2, 'MARKSHEET_12TH', '12th Standard Marksheet', 'Higher Secondary Certificate (HSC / Intermediate)', 0, 0, 1),
(7, 2, 'DIPLOMA_CERT', 'Diploma Certificate', 'Polytechnic or Technical Diploma Certificate', 0, 0, 1),
(8, 2, 'SEM_MARKSHEET', 'Semester Grade Sheet', 'University Official Semester Grade Transcript', 0, 0, 1),
(9, 2, 'PROVISIONAL_DEGREE', 'Provisional Degree Certificate', 'Provisional Graduation Certificate from Board/University', 0, 0, 1),
(10, 2, 'TRANSFER_CERT', 'Transfer Certificate (TC)', 'School / College Leaving and Transfer Certificate', 0, 0, 1),
(11, 3, 'COLLEGE_ID', 'Student College ID Card', 'Institutional Issued Student Smart ID Card', 1, 12, 1),
(12, 3, 'ADMISSION_LETTER', 'Admission Confirmation Letter', 'Official University Seat Allocation & Admission Letter', 0, 0, 1),
(13, 3, 'FEE_RECEIPT', 'Tuition Fee Receipt', 'Current Academic Year Fee Payment Proof', 1, 12, 1),
(14, 4, 'INTERNSHIP_CERT', 'Industry Internship Certificate', 'Authorized Company Internship Completion Letter', 0, 0, 1),
(15, 5, 'MEDICAL_CERT', 'Medical Fitness Certificate', 'Authorized Medical Practitioner Fitness Certificate', 1, 6, 1);

-- 11. INSERT REQUIRED DOCUMENTS (MANDATORY RULES)
INSERT INTO `required_documents` (`id`, `document_type_id`, `course_id`, `semester_id`, `is_mandatory`, `weightage`) VALUES
(1, 1, NULL, NULL, 1, 20),  -- Aadhaar Card is mandatory for all
(2, 5, NULL, NULL, 1, 20),  -- 10th Marksheet mandatory for all
(3, 6, NULL, NULL, 1, 20),  -- 12th Marksheet mandatory for all
(4, 11, NULL, NULL, 1, 20), -- College ID Card mandatory for all
(5, 12, NULL, NULL, 1, 20); -- Admission Letter mandatory for all

-- 12. INSERT SAMPLE DOCUMENTS
INSERT INTO `documents` (`id`, `document_code`, `student_id`, `document_type_id`, `title`, `current_version`, `status`, `file_name`, `stored_file_path`, `file_size_bytes`, `mime_type`, `sha256_hash`, `verification_token`, `qr_code_path`, `issue_date`, `expiry_date`, `verified_at`, `verified_by_user_id`, `created_at`) VALUES
(1, 'DOC-2026-CSE-001', 1, 1, 'Aadhaar Card - Aarav Sharma', 1, 'VERIFIED', 'aarav_aadhaar.pdf', 'storage/documents/2026/1/1/aarav_aadhaar.pdf', 1048576, 'application/pdf', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 'VT-AARAV-AADHAAR-8934', 'storage/qrcodes/VT-AARAV-AADHAAR-8934.png', '2020-01-10', NULL, '2026-08-01 10:30:00', 2, '2026-08-01 09:00:00'),
(2, 'DOC-2026-CSE-002', 1, 5, '10th Board Certificate', 1, 'VERIFIED', 'aarav_10th_marks.pdf', 'storage/documents/2026/1/5/aarav_10th_marks.pdf', 2048576, 'application/pdf', 'ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb', 'VT-AARAV-10TH-1192', 'storage/qrcodes/VT-AARAV-10TH-1192.png', '2020-06-15', NULL, '2026-08-02 11:15:00', 2, '2026-08-01 09:10:00'),
(3, 'DOC-2026-CSE-003', 1, 6, '12th Board Certificate', 1, 'VERIFIED', 'aarav_12th_marks.pdf', 'storage/documents/2026/1/6/aarav_12th_marks.pdf', 1848576, 'application/pdf', '3e23e8160039594a33894f6564e1b1348bbd7a0088d42c4acb73eeaed59c009d', 'VT-AARAV-12TH-4481', 'storage/qrcodes/VT-AARAV-12TH-4481.png', '2022-06-20', NULL, '2026-08-02 11:20:00', 2, '2026-08-01 09:15:00'),
(4, 'DOC-2026-CSE-004', 1, 11, 'College ID Card', 1, 'VERIFIED', 'aarav_college_id.jpg', 'storage/documents/2026/1/11/aarav_college_id.jpg', 512000, 'image/jpeg', '2e7d2c03a9507ae265ecf5b5356885a53393a2029d241394997265a1a25aefc6', 'VT-AARAV-COLLID-7731', 'storage/qrcodes/VT-AARAV-COLLID-7731.png', '2023-08-01', '2027-06-30', '2026-08-03 14:00:00', 2, '2026-08-01 09:20:00'),
(5, 'DOC-2026-CSE-005', 1, 12, 'Admission Offer Letter', 1, 'UNDER_REVIEW', 'aarav_admission.pdf', 'storage/documents/2026/1/12/aarav_admission.pdf', 1200000, 'application/pdf', '18ac3e7343f016890c510e93f935261169d9e3f565436429830faf093400544f', 'VT-AARAV-ADM-9921', NULL, '2023-07-15', NULL, NULL, NULL, '2026-08-10 15:30:00'),
(6, 'DOC-2026-CSE-006', 2, 1, 'Aadhaar Card - Diya Verma', 1, 'VERIFIED', 'diya_aadhaar.pdf', 'storage/documents/2026/2/1/diya_aadhaar.pdf', 950000, 'application/pdf', '4b227777d4dd1fc61c6f884f48641d02b4d121d3fd328cb08b5531fcacdabf8a', 'VT-DIYA-AADHAAR-3391', 'storage/qrcodes/VT-DIYA-AADHAAR-3391.png', '2020-02-12', NULL, '2026-08-05 10:00:00', 2, '2026-08-04 11:00:00'),
(7, 'DOC-2026-ECE-007', 3, 1, 'Aadhaar Card - Rohan Mehta', 1, 'REJECTED', 'rohan_aadhaar_blur.pdf', 'storage/documents/2026/3/1/rohan_aadhaar_blur.pdf', 450000, 'application/pdf', 'ef2d127de37b942baad06145e54b0c619a1f22327b2ebbcfbec78f5564afe39d', 'VT-ROHAN-AADHAAR-0012', NULL, '2020-04-01', NULL, NULL, 3, '2026-08-08 14:20:00');

-- Update rejection reasons for document #7
UPDATE `documents` SET `rejection_reason` = 'BLURRY_UNREADABLE', `rejection_remarks` = 'The uploaded Aadhaar scan is blurry and UID is obscured. Please upload a clear color PDF.' WHERE `id` = 7;

-- 13. INSERT DOCUMENT VERSIONS
INSERT INTO `document_versions` (`document_id`, `version_number`, `file_name`, `stored_file_path`, `file_size_bytes`, `mime_type`, `sha256_hash`, `uploaded_by_user_id`, `change_summary`, `created_at`) VALUES
(1, 1, 'aarav_aadhaar.pdf', 'storage/documents/2026/1/1/aarav_aadhaar.pdf', 1048576, 'application/pdf', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 5, 'Initial verified upload', '2026-08-01 09:00:00'),
(5, 1, 'aarav_admission.pdf', 'storage/documents/2026/1/12/aarav_admission.pdf', 1200000, 'application/pdf', '18ac3e7343f016890c510e93f935261169d9e3f565436429830faf093400544f', 5, 'Initial upload for review', '2026-08-10 15:30:00');

-- 14. INSERT DOCUMENT VERIFICATIONS
INSERT INTO `document_verifications` (`document_id`, `faculty_id`, `action`, `remarks`, `reason_code`, `decision_date`) VALUES
(1, 1, 'APPROVED', 'Verified with original government UIDAI repository.', NULL, '2026-08-01 10:30:00'),
(2, 1, 'APPROVED', 'Marksheet matches CBSE board database.', NULL, '2026-08-02 11:15:00'),
(3, 1, 'APPROVED', 'Verified 12th board marksheet.', NULL, '2026-08-02 11:20:00'),
(4, 1, 'APPROVED', 'Valid student college identity card.', NULL, '2026-08-03 14:00:00'),
(7, 2, 'REJECTED', 'The uploaded Aadhaar scan is blurry and UID is obscured. Please upload a clear color PDF.', 'BLURRY_UNREADABLE', '2026-08-08 14:20:00');

-- 15. INSERT DOCUMENT REQUESTS
INSERT INTO `document_requests` (`id`, `request_no`, `student_id`, `document_type_id`, `purpose`, `status`, `admin_remarks`, `requested_at`) VALUES
(1, 'REQ-2026-00101', 1, 9, 'Required for Higher Studies / GATE Exam Application', 'PROCESSING', 'Application under review by Registrar Office', '2026-08-15 10:00:00'),
(2, 'REQ-2026-00102', 2, 10, 'Required for Education Loan Subsidy Verification', 'APPROVED', 'Certificate generated and ready for download', '2026-08-16 11:30:00');

-- 16. INSERT DOCUMENT SHARES
INSERT INTO `document_shares` (`id`, `document_id`, `student_id`, `share_token`, `recipient_email`, `expires_at`, `max_access_count`, `current_access_count`, `is_revoked`, `created_at`) VALUES
(1, 1, 1, 'SH-AARAV-8891238491-SEC', 'recruiter@techcorp.com', DATE_ADD(NOW(), INTERVAL 7 DAY), 10, 2, 0, NOW());

-- 17. INSERT NOTIFICATIONS
INSERT INTO `notifications` (`user_id`, `title`, `message`, `type`, `link_url`, `is_read`, `created_at`) VALUES
(5, 'Document Verified', 'Your 10th Standard Marksheet has been successfully verified by Dr. Ramesh Sharma.', 'VERIFICATION', '/student/vault', 0, NOW()),
(5, 'Document Pending Review', 'Your Admission Offer Letter has been submitted and is currently in the faculty verification queue.', 'UPLOAD', '/student/vault', 1, NOW()),
(7, 'Document Rejected', 'Your Aadhaar Card was rejected. Reason: Scan is blurry. Please upload a fresh document.', 'REJECTION', '/student/upload', 0, NOW()),
(2, 'New Verification Task', 'Student Aarav Sharma has submitted Admission Offer Letter for verification.', 'UPLOAD', '/faculty/queue', 0, NOW());

-- 18. INSERT AUDIT LOGS
INSERT INTO `audit_logs` (`user_id`, `action`, `entity_type`, `entity_id`, `ip_address`, `details`, `created_at`) VALUES
(1, 'SYSTEM_INIT', 'SYSTEM', 1, '127.0.0.1', 'SMARTDOC System Initialization and Seed Data Setup', NOW()),
(5, 'UPLOAD_DOC', 'DOCUMENT', 1, '192.168.1.45', 'Uploaded Aadhaar Card (DOC-2026-CSE-001)', NOW()),
(2, 'VERIFY_DOC', 'DOCUMENT', 1, '192.168.1.10', 'Approved document DOC-2026-CSE-001 with QR code generation', NOW()),
(7, 'UPLOAD_DOC', 'DOCUMENT', 7, '192.168.1.88', 'Uploaded Aadhaar Card (DOC-2026-ECE-007)', NOW()),
(3, 'REJECT_DOC', 'DOCUMENT', 7, '192.168.1.12', 'Rejected document DOC-2026-ECE-007: Blurry scan', NOW());

-- 19. INSERT SYSTEM SETTINGS
INSERT INTO `system_settings` (`setting_key`, `setting_value`, `description`) VALUES
('INSTITUTE_NAME', 'National Institute of Engineering & Technology', 'Full Name of Higher Education Institution'),
('INSTITUTE_CODE', 'NIET-2026', 'Institutional Accreditation Code'),
('COMPLETENESS_CRITICAL_THRESHOLD', '50', 'Threshold below which student completeness is Critical'),
('COMPLETENESS_GOOD_THRESHOLD', '75', 'Threshold for Good completeness score'),
('COMPLETENESS_EXCELLENT_THRESHOLD', '90', 'Threshold for Excellent completeness score'),
('DEFAULT_SHARE_EXPIRY_HOURS', '48', 'Default duration for temporary secure sharing links in hours'),
('MAX_UPLOAD_SIZE_MB', '15', 'Maximum permissible file upload size in Megabytes');
