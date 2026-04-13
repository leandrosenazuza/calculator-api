package com.calculator.api.config

import io.swagger.v3.oas.models.OpenAPI
import io.swagger.v3.oas.models.info.Info
import io.swagger.v3.oas.models.info.Contact
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class OpenApiConfig {

    @Bean
    fun customOpenAPI(): OpenAPI {
        return OpenAPI()
            .info(
                Info()
                    .title("Calculator API")
                    .version("1.0.0")
                    .description("API para gerenciamento de tabelas de taxas e usuários da Calculadora Real na Mão")
                    .contact(
                        Contact()
                            .name("Calculator API")
                    )
            )
    }
}
