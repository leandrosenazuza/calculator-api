package com.calculator.api.entity

import jakarta.persistence.*
import jakarta.validation.constraints.NotBlank
import org.hibernate.annotations.JdbcTypeCode
import org.hibernate.type.SqlTypes

@Entity
@Table(name = "tax_tables")
data class TaxTable(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,
    
    @NotBlank
    @Column(nullable = false, unique = true)
    val name: String,
    
    @Column(nullable = true)
    val description: String? = null,
    
    @JdbcTypeCode(SqlTypes.JSON)
    @Column(nullable = false, columnDefinition = "jsonb")
    val data: Map<String, Any>,
    
    @Column(nullable = false)
    val active: Boolean = true,
    
    @Column(nullable = false)
    val created_at: java.time.LocalDateTime = java.time.LocalDateTime.now(),
    
    @Column(nullable = false)
    val updated_at: java.time.LocalDateTime = java.time.LocalDateTime.now()
)

