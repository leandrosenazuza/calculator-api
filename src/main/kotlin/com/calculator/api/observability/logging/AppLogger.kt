package com.calculator.api.observability.logging

interface AppLogger {
    fun log(event: StructuredLogEvent, throwable: Throwable? = null)
}
