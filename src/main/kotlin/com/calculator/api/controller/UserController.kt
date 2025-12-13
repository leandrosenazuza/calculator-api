package com.calculator.api.controller

import com.calculator.api.dto.UserRequest
import com.calculator.api.dto.UserUpdateRequest
import com.calculator.api.service.UserService
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = ["*"])
class UserController(
    private val userService: UserService
) {
    @GetMapping("/users")
    fun getAllUsers(): ResponseEntity<List<com.calculator.api.entity.User>> {
        return ResponseEntity.ok(userService.findAll())
    }
    
    @PostMapping("/users")
    fun createUser(@RequestBody request: UserRequest): ResponseEntity<Any> {
        val username = userService.generateUsername(request.name)
        val userRequest = request.copy(username = username)
        val user = userService.create(userRequest)
        return ResponseEntity.ok(mapOf("id" to user.id))
    }
    
    @PutMapping("/users/{id}")
    fun updateUser(
        @PathVariable id: Long,
        @RequestBody request: UserUpdateRequest
    ): ResponseEntity<Any> {
        val user = userService.update(id, request)
        return if (user != null) {
            ResponseEntity.ok(mapOf("success" to true, "changes" to 1))
        } else {
            ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(mapOf("error" to "Usuário não encontrado"))
        }
    }
    
    @DeleteMapping("/users/{id}")
    fun deleteUser(@PathVariable id: Long): ResponseEntity<Any> {
        val deleted = userService.delete(id)
        return if (deleted) {
            ResponseEntity.ok(mapOf("success" to true))
        } else {
            ResponseEntity.status(HttpStatus.NOT_FOUND)
                .body(mapOf("error" to "Usuário não encontrado"))
        }
    }
}

