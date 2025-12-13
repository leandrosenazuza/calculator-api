package com.calculator.api.service

import com.calculator.api.dto.UserRequest
import com.calculator.api.dto.UserUpdateRequest
import com.calculator.api.entity.User
import com.calculator.api.repository.UserRepository
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional

@Service
class UserService(
    private val userRepository: UserRepository
) {
    fun findAll(): List<User> {
        return userRepository.findAll()
    }
    
    fun findById(id: Long): User? {
        return userRepository.findById(id).orElse(null)
    }
    
    fun create(request: UserRequest): User {
        val user = User(
            name = request.name,
            username = request.username,
            password = request.password,
            type = request.type,
            tabela = request.tabela
        )
        return userRepository.save(user)
    }
    
    @Transactional
    fun update(id: Long, request: UserUpdateRequest): User? {
        val user = userRepository.findById(id).orElse(null) ?: return null
        
        val updatedUser = user.copy(
            tabela = request.tabela ?: user.tabela,
            password = request.password ?: user.password
        )
        
        return userRepository.save(updatedUser)
    }
    
    fun delete(id: Long): Boolean {
        return if (userRepository.existsById(id)) {
            userRepository.deleteById(id)
            true
        } else {
            false
        }
    }
    
    fun generateUsername(name: String): String {
        val parts = name.trim().lowercase().split(" ")
        return if (parts.size >= 2) {
            "${parts.first()}.${parts.last()}"
        } else {
            parts.first()
        }
    }
}

