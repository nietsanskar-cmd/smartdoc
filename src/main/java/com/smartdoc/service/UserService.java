package com.smartdoc.service;

import com.smartdoc.dto.request.FacultyRegistrationDto;
import com.smartdoc.dto.request.LoginRequestDto;
import com.smartdoc.dto.request.StudentRegistrationDto;
import com.smartdoc.entity.User;
import com.smartdoc.security.UserSession;
import java.util.List;

public interface UserService {
    UserSession authenticate(LoginRequestDto loginDto, String ipAddress, String userAgent);
    User registerStudent(StudentRegistrationDto registrationDto);
    User registerStudentWithVerifiedEmail(com.smartdoc.dto.request.CreatePasswordDto dto);
    User registerFaculty(FacultyRegistrationDto registrationDto);
    void toggleUserStatus(Long userId);
    void resetPassword(Long userId, String newPassword);
    void resetPasswordWithVerifiedEmail(com.smartdoc.dto.request.ResetPasswordDto dto);
    void updatePassword(Long userId, String oldPassword, String newPassword);
    User findById(Long id);
    User findByUsername(String username);
    User findByEmail(String email);
    List<User> findAllUsers();
    void recordLogout(Long userId);
}
