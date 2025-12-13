package com.calculator.api.entity

import jakarta.persistence.*
import jakarta.validation.constraints.NotBlank

@Entity
@Table(name = "users")
data class User(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,
    
    @NotBlank
    @Column(nullable = false)
    val name: String,
    
    @NotBlank
    @Column(nullable = false, unique = true)
    val username: String,
    
    @NotBlank
    @Column(nullable = false)
    val password: String,
    
    @NotBlank
    @Column(nullable = false)
    val type: String, // "admin" ou "comum"
    
    @Column(nullable = true)
    val tabela: String? = null
)

