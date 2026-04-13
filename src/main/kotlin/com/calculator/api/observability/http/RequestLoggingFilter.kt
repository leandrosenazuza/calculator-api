package com.calculator.api.observability.http

import com.calculator.api.observability.logging.AppLogger
import com.calculator.api.observability.logging.LogLevel
import com.calculator.api.observability.logging.StructuredLogEvent
import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import jakarta.servlet.http.HttpServletResponseWrapper
import org.springframework.core.Ordered
import org.springframework.core.annotation.Order
import org.springframework.stereotype.Component
import org.springframework.web.filter.OncePerRequestFilter
import java.util.concurrent.TimeUnit

@Component
@Order(Ordered.HIGHEST_PRECEDENCE + 1)
class RequestLoggingFilter(
    private val appLogger: AppLogger
) : OncePerRequestFilter() {

    override fun doFilterInternal(
        request: HttpServletRequest,
        response: HttpServletResponse,
        filterChain: FilterChain
    ) {
        val startedAt = System.nanoTime()
        val correlationId = resolveCorrelationId(request)
        val path = request.requestURI
        val method = request.method
        val clientIp = resolveClientIp(request)
        val userAgent = request.getHeader("User-Agent")?.take(MAX_USER_AGENT_LENGTH)

        appLogger.log(
            StructuredLogEvent(
                level = LogLevel.INFO,
                type = "HTTP_REQUEST",
                message = "Request received",
                fields = mapOf(
                    "method" to method,
                    "path" to path,
                    "correlation_id" to correlationId,
                    "client_ip" to clientIp,
                    "user_agent" to userAgent
                )
            )
        )

        val wrappedResponse = StatusCaptureResponseWrapper(response)

        try {
            filterChain.doFilter(request, wrappedResponse)
            logCompletion(
                request = request,
                correlationId = correlationId,
                clientIp = clientIp,
                userAgent = userAgent,
                status = wrappedResponse.httpStatus,
                latencyMs = latencyMs(startedAt),
                throwable = null
            )
        } catch (exception: Exception) {
            logCompletion(
                request = request,
                correlationId = correlationId,
                clientIp = clientIp,
                userAgent = userAgent,
                status = HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                latencyMs = latencyMs(startedAt),
                throwable = exception
            )
            throw exception
        }
    }

    override fun shouldNotFilter(request: HttpServletRequest): Boolean {
        return request.requestURI.startsWith("/actuator")
    }

    private fun logCompletion(
        request: HttpServletRequest,
        correlationId: String,
        clientIp: String,
        userAgent: String?,
        status: Int,
        latencyMs: Long,
        throwable: Throwable?
    ) {
        val outcome = if (status in 200..299) "SUCCESS" else "FAILURE"
        val level = when {
            throwable != null || status >= 500 -> LogLevel.ERROR
            status >= 400 -> LogLevel.WARN
            else -> LogLevel.INFO
        }

        appLogger.log(
            event = StructuredLogEvent(
                level = level,
                type = "HTTP_REQUEST",
                message = if (outcome == "SUCCESS") {
                    "Request completed successfully"
                } else {
                    "Request completed with failure"
                },
                fields = mapOf(
                    "method" to request.method,
                    "path" to request.requestURI,
                    "status" to status,
                    "latency_ms" to latencyMs,
                    "outcome" to outcome,
                    "correlation_id" to correlationId,
                    "client_ip" to clientIp,
                    "user_agent" to userAgent
                )
            ),
            throwable = throwable
        )
    }

    private fun resolveCorrelationId(request: HttpServletRequest): String {
        return request.getAttribute(CorrelationIdFilter.CORRELATION_ID_ATTRIBUTE)?.toString()
            ?: request.getHeader(CorrelationIdFilter.CORRELATION_ID_HEADER)
            ?: "unknown"
    }

    private fun resolveClientIp(request: HttpServletRequest): String {
        val forwarded = request.getHeader("X-Forwarded-For")
            ?.split(",")
            ?.firstOrNull()
            ?.trim()
            ?.takeIf { it.isNotBlank() }

        return forwarded ?: request.remoteAddr.orEmpty()
    }

    private fun latencyMs(startedAtNanos: Long): Long {
        return TimeUnit.NANOSECONDS.toMillis(System.nanoTime() - startedAtNanos)
    }

    private class StatusCaptureResponseWrapper(response: HttpServletResponse) :
        HttpServletResponseWrapper(response) {

        var httpStatus: Int = HttpServletResponse.SC_OK
            private set

        override fun setStatus(sc: Int) {
            httpStatus = sc
            super.setStatus(sc)
        }

        override fun sendError(sc: Int) {
            httpStatus = sc
            super.sendError(sc)
        }

        override fun sendError(sc: Int, msg: String?) {
            httpStatus = sc
            super.sendError(sc, msg)
        }

        override fun sendRedirect(location: String?) {
            httpStatus = HttpServletResponse.SC_FOUND
            super.sendRedirect(location)
        }
    }

    companion object {
        private const val MAX_USER_AGENT_LENGTH = 256
    }
}
