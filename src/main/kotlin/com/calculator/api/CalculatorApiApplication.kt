package com.calculator.api

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class CalculatorApiApplication

fun main(args: Array<String>) {
    runApplication<CalculatorApiApplication>(*args)
}

