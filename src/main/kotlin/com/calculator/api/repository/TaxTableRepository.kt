package com.calculator.api.repository

import com.calculator.api.entity.TaxTable
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.stereotype.Repository

@Repository
interface TaxTableRepository : JpaRepository<TaxTable, Long> {
    fun findByName(name: String): TaxTable?
    fun findByActiveTrue(): List<TaxTable>
    fun existsByName(name: String): Boolean
}

