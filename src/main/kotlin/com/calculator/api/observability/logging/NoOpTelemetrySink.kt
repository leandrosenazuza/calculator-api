package com.calculator.api.observability.logging

import org.springframework.stereotype.Component

@Component
class NoOpTelemetrySink : TelemetrySink {
    override fun publish(payload: Map<String, Any?>) {
        // Intentionally empty: extension point for external telemetry backends.
    }
}
