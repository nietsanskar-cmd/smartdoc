package com.smartdoc.security;

import com.smartdoc.entity.enums.RoleType;
import lombok.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserSession implements Serializable {
    private static final long serialVersionUID = 1L;

    private Long userId;
    private String username;
    private String email;
    private RoleType role;
    private Long studentId;
    private Long facultyId;
    private String fullName;
    private String departmentName;
    private LocalDateTime loginTime;

    public boolean isAdmin() {
        return RoleType.ROLE_ADMIN.equals(role);
    }

    public boolean isFaculty() {
        return RoleType.ROLE_FACULTY.equals(role);
    }

    public boolean isStudent() {
        return RoleType.ROLE_STUDENT.equals(role);
    }
}
