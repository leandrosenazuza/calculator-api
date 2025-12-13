package com.calculator.api.service

import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile
import java.io.File
import java.nio.file.Files
import java.nio.file.Paths

@Service
class TableService(
    @Value("\${app.upload.directory}") private val uploadDirectory: String
) {
    init {
        val dir = File(uploadDirectory)
        if (!dir.exists()) {
            dir.mkdirs()
        }
    }
    
    fun listTables(): List<String> {
        val dir = File(uploadDirectory)
        return if (dir.exists() && dir.isDirectory) {
            dir.listFiles { _, name -> name.endsWith(".json") }
                ?.map { it.name }
                ?: emptyList()
        } else {
            emptyList()
        }
    }
    
    fun uploadFile(file: MultipartFile): String {
        val filePath = Paths.get(uploadDirectory, file.originalFilename ?: "file.json")
        Files.write(filePath, file.bytes)
        return "Arquivo enviado com sucesso!"
    }
}

