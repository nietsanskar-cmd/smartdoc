package com.smartdoc.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "semesters")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Semester {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "semester_number", nullable = false, unique = true)
    private Integer semesterNumber;

    @Column(name = "semester_name", length = 50, nullable = false)
    private String semesterName;
}
