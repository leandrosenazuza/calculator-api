package com.calculator.api.dto

data class UserRequest(
    val name: String,
    val username: String,
    val password: String,
    val type: String,
    val tabela: String?
)

data class UserUpdateRequest(
    val tabela: String?,
    val password: String?
)

