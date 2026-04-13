package com.calculator.api.observability.config

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor

@Configuration
class AsyncLoggingConfig {

    @Bean(name = ["telemetryLogExecutor"])
    fun telemetryLogExecutor(): ThreadPoolTaskExecutor {
        val executor = ThreadPoolTaskExecutor()
        executor.setThreadNamePrefix("telemetry-log-")
        executor.setCorePoolSize(1)
        executor.setMaxPoolSize(2)
        executor.setQueueCapacity(500)
        executor.setWaitForTasksToCompleteOnShutdown(false)
        executor.initialize()
        return executor
    }
}
