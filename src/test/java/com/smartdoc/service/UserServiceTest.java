package com.smartdoc.service;

import com.smartdoc.dto.request.LoginRequestDto;
import com.smartdoc.entity.Role;
import com.smartdoc.entity.User;
import com.smartdoc.entity.enums.RoleType;
import com.smartdoc.exception.UnauthorizedAccessException;
import com.smartdoc.repository.*;
import com.smartdoc.security.PasswordEncoderUtil;
import com.smartdoc.security.UserSession;
import com.smartdoc.service.impl.UserServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;
    @Mock
    private RoleRepository roleRepository;
    @Mock
    private StudentRepository studentRepository;
    @Mock
    private FacultyRepository facultyRepository;
    @Mock
    private LoginHistoryRepository loginHistoryRepository;
    @Mock
    private PasswordEncoderUtil passwordEncoder;
    @Mock
    private AuditLogService auditLogService;

    @InjectMocks
    private UserServiceImpl userService;

    private User sampleUser;

    @BeforeEach
    void setUp() {
        Role role = Role.builder().id(1L).roleName(RoleType.ROLE_ADMIN).build();
        sampleUser = User.builder()
                .id(1L)
                .username("admin")
                .passwordHash("hashedSecret")
                .email("admin@smartdoc.edu")
                .role(role)
                .isActive(true)
                .build();
    }

    @Test
    void testAuthenticate_Success() {
        LoginRequestDto dto = new LoginRequestDto("admin", "password123");
        when(userRepository.findByUsername("admin")).thenReturn(Optional.of(sampleUser));
        when(passwordEncoder.matches("password123", "hashedSecret")).thenReturn(true);

        UserSession session = userService.authenticate(dto, "127.0.0.1", "JUnit-Agent");

        assertNotNull(session);
        assertEquals("admin", session.getUsername());
        assertTrue(session.isAdmin());
        verify(loginHistoryRepository, times(1)).save(any());
    }

    @Test
    void testAuthenticate_InvalidPassword_ThrowsException() {
        LoginRequestDto dto = new LoginRequestDto("admin", "wrongPassword");
        when(userRepository.findByUsername("admin")).thenReturn(Optional.of(sampleUser));
        when(passwordEncoder.matches("wrongPassword", "hashedSecret")).thenReturn(false);

        assertThrows(UnauthorizedAccessException.class, () ->
                userService.authenticate(dto, "127.0.0.1", "JUnit-Agent")
        );
    }
}
