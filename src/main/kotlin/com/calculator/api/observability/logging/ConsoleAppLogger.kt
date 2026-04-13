package com.calculator.api.observability.logging

import com.fasterxml.jackson.databind.ObjectMapper
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.core.task.AsyncTaskExecutor
import org.springframework.stereotype.Component
import java.io.PrintWriter
import java.io.StringWriter

@Component
class ConsoleAppLogger(
    private val objectMapper: ObjectMapper,
    private val telemetrySinks: List<TelemetrySink>,
    @Qualifier("telemetryLogExecutor") private val telemetryExecutor: AsyncTaskExecutor
) : AppLogger {

    private val logger = LoggerFactory.getLogger(ConsoleAppLogger::class.java)

    override fun log(event: StructuredLogEvent, throwable: Throwable?) {
        val payload = mutableMapOf<String, Any?>(
            "timestamp" to event.timestamp.toString(),
            "level" to event.level.name,
            "type" to event.type,
            "message" to event.message
        )
        payload.putAll(event.fields)

        if (throwable != null) {
            payload["error"] = mapOf(
                "exception_type" to throwable::class.java.name,
                "exception_message" to throwable.message,
                "stack_trace" to stackTrace(throwable)
            )
        }

        val serialized = objectMapper.writeValueAsString(payload)
        when (event.level) {
            LogLevel.INFO -> logger.info(serialized)
            LogLevel.WARN -> logger.warn(serialized)
            LogLevel.ERROR -> logger.error(serialized)
        }

        val payloadSnapshot = payload.toMap()
        telemetrySinks.forEach { sink ->
            telemetryExecutor.execute {
                runCatching { sink.publish(payloadSnapshot) }
                    .onFailure { sinkError ->
                        logger.warn("Telemetry sink publish failed: {}", sinkError.message)
                    }
            }
        }
    }

    private fun stackTrace(throwable: Throwable): String {
        val writer = StringWriter()
        throwable.printStackTrace(PrintWriter(writer))
        return writer.toString()
    }
}
