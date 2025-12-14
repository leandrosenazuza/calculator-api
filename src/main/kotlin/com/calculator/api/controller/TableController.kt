package com.calculator.api.controller

import com.calculator.api.entity.TaxTable
import com.calculator.api.service.TableService
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import org.springframework.web.multipart.MultipartFile

@RestController
@RequestMapping("/api")
@CrossOrigin(origins = ["*"])
class TableController(
    private val tableService: TableService
) {
    /**
     * Lista todas as tabelas de taxas ativas (apenas nomes)
     */
    @GetMapping("/tabelas")
    fun listTables(): ResponseEntity<List<String>> {
        return ResponseEntity.ok(tableService.listTables())
    }
    
    /**
     * Lista todas as tabelas de taxas com detalhes completos
     */
    @GetMapping("/tabelas/detalhes")
    fun listAllTables(): ResponseEntity<List<TaxTable>> {
        return ResponseEntity.ok(tableService.listAllTables())
    }
    
    /**
     * Busca uma tabela por nome
     */
    @GetMapping("/tabelas/{name}")
    fun getTableByName(@PathVariable name: String): ResponseEntity<TaxTable> {
        val table = tableService.getTableByName(name)
            ?: return ResponseEntity.notFound().build()
        return ResponseEntity.ok(table)
    }
    
    /**
     * Busca uma tabela por ID
     */
    @GetMapping("/tabelas/id/{id}")
    fun getTableById(@PathVariable id: Long): ResponseEntity<TaxTable> {
        val table = tableService.getTableById(id)
            ?: return ResponseEntity.notFound().build()
        return ResponseEntity.ok(table)
    }
    
    /**
     * Faz upload de uma tabela JSON
     */
    @PostMapping("/upload")
    fun uploadTable(@RequestParam("file") file: MultipartFile): ResponseEntity<Map<String, String>> {
        return try {
            val message = tableService.uploadFile(file)
            ResponseEntity.ok(mapOf("message" to message))
        } catch (e: IllegalArgumentException) {
            ResponseEntity.badRequest().body(mapOf("error" to (e.message ?: "Erro ao fazer upload")))
        } catch (e: Exception) {
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(mapOf("error" to (e.message ?: "Erro interno do servidor")))
        }
    }
    
    /**
     * Cria uma nova tabela de taxas
     */
    @PostMapping("/tabelas")
    fun createTable(@RequestBody request: Map<String, Any>): ResponseEntity<TaxTable> {
        return try {
            val name = request["name"] as? String ?: throw IllegalArgumentException("Nome é obrigatório")
            val description = request["description"] as? String
            @Suppress("UNCHECKED_CAST")
            val data = (request["data"] as? Map<*, *> 
                ?: throw IllegalArgumentException("Dados da tabela são obrigatórios")) as Map<String, Any>
            
            val table = tableService.createTable(name, description, data)
            ResponseEntity.status(HttpStatus.CREATED).body(table)
        } catch (e: IllegalArgumentException) {
            ResponseEntity.badRequest().build()
        }
    }
    
    /**
     * Atualiza uma tabela existente
     */
    @PutMapping("/tabelas/{id}")
    fun updateTable(
        @PathVariable id: Long,
        @RequestBody request: Map<String, Any>
    ): ResponseEntity<TaxTable> {
        return try {
            val name = request["name"] as? String
            val description = request["description"] as? String
            @Suppress("UNCHECKED_CAST")
            val data = request["data"] as? Map<String, Any>
            val active = request["active"] as? Boolean
            
            val table = tableService.updateTable(id, name, description, data, active)
            ResponseEntity.ok(table)
        } catch (e: IllegalArgumentException) {
            ResponseEntity.notFound().build()
        }
    }
    
    /**
     * Deleta uma tabela (soft delete)
     */
    @DeleteMapping("/tabelas/{id}")
    fun deleteTable(@PathVariable id: Long): ResponseEntity<Map<String, String>> {
        return try {
            tableService.deleteTable(id)
            ResponseEntity.ok(mapOf("message" to "Tabela deletada com sucesso"))
        } catch (e: IllegalArgumentException) {
            ResponseEntity.status(HttpStatus.NOT_FOUND).body(mapOf("error" to (e.message ?: "Tabela não encontrada")))
        }
    }
}
