package com.calculator.api.observability.logging

import java.time.Instant

data class StructuredLogEvent(
    val timestamp: Instant = Instant.now(),
    val level: LogLevel,
    val type: String,
    val message: String,
    val fields: Map<String, Any?> = emptyMap()
)

enum class LogLevel {
    INFO,
    WARN,
    ERROR
}
