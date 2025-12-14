package com.calculator.api.service

import com.calculator.api.entity.TaxTable
import com.calculator.api.repository.TaxTableRepository
import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.stereotype.Service
import org.springframework.web.multipart.MultipartFile
import java.time.LocalDateTime

@Service
class TableService(
    private val taxTableRepository: TaxTableRepository,
    private val objectMapper: ObjectMapper
) {
    /**
     * Lista todas as tabelas de taxas ativas
     */
    fun listTables(): List<String> {
        return taxTableRepository.findByActiveTrue()
            .map { it.name }
    }
    
    /**
     * Lista todas as tabelas de taxas (incluindo inativas)
     */
    fun listAllTables(): List<TaxTable> {
        return taxTableRepository.findAll()
    }
    
    /**
     * Busca uma tabela por nome
     */
    fun getTableByName(name: String): TaxTable? {
        return taxTableRepository.findByName(name)
    }
    
    /**
     * Busca uma tabela por ID
     */
    fun getTableById(id: Long): TaxTable? {
        return taxTableRepository.findById(id).orElse(null)
    }
    
    /**
     * Faz upload de uma tabela JSON e salva no banco de dados
     */
    fun uploadFile(file: MultipartFile): String {
        val fileName = file.originalFilename?.replace(".json", "") ?: "file"
        
        // Verifica se já existe uma tabela com esse nome
        if (taxTableRepository.existsByName(fileName)) {
            throw IllegalArgumentException("Já existe uma tabela com o nome: $fileName")
        }
        
        // Converte o JSON do arquivo para Map
        val jsonContent = String(file.bytes)
        @Suppress("UNCHECKED_CAST")
        val data: Map<String, Any> = objectMapper.readValue(jsonContent, Map::class.java) as Map<String, Any>
        
        // Cria e salva a entidade
        val taxTable = TaxTable(
            name = fileName,
            description = "Tabela importada de arquivo",
            data = data,
            active = true,
            created_at = LocalDateTime.now(),
            updated_at = LocalDateTime.now()
        )
        
        taxTableRepository.save(taxTable)
        return "Tabela '$fileName' enviada e salva com sucesso!"
    }
    
    /**
     * Cria uma nova tabela de taxas
     */
    fun createTable(name: String, description: String?, data: Map<String, Any>): TaxTable {
        if (taxTableRepository.existsByName(name)) {
            throw IllegalArgumentException("Já existe uma tabela com o nome: $name")
        }
        
        val taxTable = TaxTable(
            name = name,
            description = description,
            data = data,
            active = true,
            created_at = LocalDateTime.now(),
            updated_at = LocalDateTime.now()
        )
        
        return taxTableRepository.save(taxTable)
    }
    
    /**
     * Atualiza uma tabela existente
     */
    fun updateTable(id: Long, name: String?, description: String?, data: Map<String, Any>?, active: Boolean?): TaxTable {
        val taxTable = taxTableRepository.findById(id)
            .orElseThrow { IllegalArgumentException("Tabela com ID $id não encontrada") }
        
        val updatedTable = taxTable.copy(
            name = name ?: taxTable.name,
            description = description ?: taxTable.description,
            data = data ?: taxTable.data,
            active = active ?: taxTable.active,
            updated_at = LocalDateTime.now()
        )
        
        return taxTableRepository.save(updatedTable)
    }
    
    /**
     * Deleta uma tabela (soft delete - marca como inativa)
     */
    fun deleteTable(id: Long) {
        val taxTable = taxTableRepository.findById(id)
            .orElseThrow { IllegalArgumentException("Tabela com ID $id não encontrada") }
        
        taxTableRepository.save(taxTable.copy(active = false, updated_at = LocalDateTime.now()))
    }
    
    /**
     * Deleta permanentemente uma tabela
     */
    fun deleteTablePermanently(id: Long) {
        taxTableRepository.deleteById(id)
    }
}

