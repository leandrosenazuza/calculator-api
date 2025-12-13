package com.calculator.api.service

import com.calculator.api.dto.LoginRequest
import com.calculator.api.entity.User
import com.calculator.api.repository.UserRepository
import org.springframework.stereotype.Service

@Service
class AuthService(
    private val userRepository: UserRepository
) {
    fun login(request: LoginRequest): User? {
        return userRepository.findByUsernameAndPassword(request.username, request.password)
    }
}

