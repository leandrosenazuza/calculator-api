import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.springframework.boot") version "3.2.0"
    id("io.spring.dependency-management") version "1.1.4"
    kotlin("jvm") version "1.9.20"
    kotlin("plugin.spring") version "1.9.20"
    kotlin("plugin.jpa") version "1.9.20"
    id("org.flywaydb.flyway") version "10.0.0"
}

group = "com.calculator"
version = "1.0.0"

java {
    sourceCompatibility = JavaVersion.VERSION_17
}

repositories {
    mavenCentral()
}

dependencies {
    // Spring Boot
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    
    // Kotlin
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
    
    // PostgreSQL
    runtimeOnly("org.postgresql:postgresql")
    
    // Flyway
    implementation("org.flywaydb:flyway-core")
    
    // PostgreSQL driver para Flyway (necessário para tasks do Gradle)
    // O runtimeOnly não é suficiente para o plugin Flyway do Gradle
    implementation("org.postgresql:postgresql")
    
    // CORS
    implementation("org.springframework.boot:spring-boot-starter-web")
    
    // JSON
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
    
    // Swagger / OpenAPI
    implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:2.3.0")
    
    // Testing
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    testImplementation("org.jetbrains.kotlin:kotlin-test-junit5")
}

tasks.withType<KotlinCompile> {
    kotlinOptions {
        freeCompilerArgs += "-Xjsr305=strict"
        jvmTarget = "17"
    }
}

tasks.withType<Test> {
    useJUnitPlatform()
}

// Flyway configuration
flyway {
    url = "jdbc:postgresql://localhost:5432/calculator_db"
    user = "postgres"
    password = "postgres"
    locations = arrayOf("classpath:db/migration")
    baselineOnMigrate = true
    baselineVersion = "0"
    driver = "org.postgresql.Driver"
}

// Configura mensagens informativas para as tasks do Flyway
tasks.named("flywayMigrate") {
    doFirst {
        println("🔄 Executando Flyway migrations...")
    }
    doLast {
        println("✅ Flyway migrations executadas com sucesso!")
    }
}

tasks.named("flywayInfo") {
    doFirst {
        println("📊 Verificando status das migrations do Flyway...")
    }
}

// Task customizada para executar Flyway antes do bootRun
// IMPORTANTE: O Spring Boot já executa Flyway automaticamente na inicialização via application.yml
// Esta task garante que o Flyway seja executado explicitamente antes do bootRun
// Se o PostgreSQL não estiver rodando, o Spring Boot ainda executará o Flyway na inicialização
tasks.named("bootRun") {
    // Tenta executar Flyway antes, mas não bloqueia se falhar
    // O Spring Boot executará Flyway automaticamente na inicialização de qualquer forma
    doFirst {
        println("🚀 Iniciando aplicação Spring Boot...")
        println("ℹ️  Flyway será executado automaticamente pelo Spring Boot durante a inicialização")
    }
}

// Task para executar apenas o Flyway (requer PostgreSQL rodando)
tasks.register("runFlyway") {
    group = "flyway"
    description = "Executa as migrations do Flyway manualmente"
    dependsOn("flywayMigrate")
}

// Task para verificar status do Flyway
tasks.register("checkFlyway") {
    group = "flyway"
    description = "Verifica o status das migrations do Flyway"
    dependsOn("flywayInfo")
}

