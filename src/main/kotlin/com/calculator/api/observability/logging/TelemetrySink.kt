package com.calculator.api.observability.logging

interface TelemetrySink {
    fun publish(payload: Map<String, Any?>)
}
