package com.calculator.api.repository

import com.calculator.api.entity.User
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface UserRepository : JpaRepository<User, Long> {
    fun findByUsernameAndPassword(username: String, password: String): User?
    fun findByUsername(username: String): User?
}

