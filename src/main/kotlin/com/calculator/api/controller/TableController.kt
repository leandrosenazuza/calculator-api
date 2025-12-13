package com.calculator.api.controller

import com.calculator.api.service.TableService
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = ["*"])
class TableController(
    private val tableService: TableService
) {
    @GetMapping("/tabelas")
    fun listTables(): ResponseEntity<List<String>> {
        return ResponseEntity.ok(tableService.listTables())
    }
    
    @PostMapping("/upload")
    fun uploadTable(@RequestParam("file") file: MultipartFile): ResponseEntity<Map<String, String>> {
        val message = tableService.uploadFile(file)
        return ResponseEntity.ok(mapOf("message" to message))
    }
}

