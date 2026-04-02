server:
  port: 8080
  ssl:
    enabled: ${SSL_ENABLED:false}
    trust-store: classpath:client.truststore.jks
    trust-store-password: changeit
    trust-store-type: ${SSL_TRUST_STORE_TYPE:JKS}
    trust-all-certs: ${SSL_TRUST_ALL_CERTS:false}

spring:
  profiles:
    active: local
  application:
    name: api-action-runner
  jackson:
    property-naming-strategy: SNAKE_CASE
    serialization:
      write-dates-as-timestamps: false
    deserialization:
      fail-on-unknown-properties: false

secret:
  api:
    url:
      base: https://genesis-secret-svc.apps.dv-p.ocp.fcbint.net
      secret-api: /api/secrets
service:
  accounts:
    db: dev_genesis_svc
    kafka: dv_genesis_kafka-svc

centrl:
  service:
    client-id-account: dv_genesis_kafka-svc
    client-secret-account: dv_genesis_kafka-svc
    username-account: dv_genesis_kafka-svc
    password-account: dv_genesis_kafka-svc

  kafka:
    bootstrap-servers: "10.5.16.102:9092"
  properties:
    security.protocol: SASL_PLAINTEXT
    sasl.mechanism: PLAIN
    sasl.jaas.config: org.apache.kafka.common.security.plain.PlainLoginModule required username="admin" password="admin-secret"

  main:
    web-application-type: reactive
kafka:
  sasl:
    jaas:
      config:
        username: admin
        password: admin-secret
auditalert:
  starter:
    kafka:
      topic:
        name: genesis.generic.notify-audit.in
# For JWT Resource Server mode (when action.security.mode=JWT_RESOURCE_SERVER)
#  security:
#    oauth2:
#      resourceserver:
#        jwt:
#          issuer-uri: https://your-auth-server.com

management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus,env,loggers,metrics
      base-path: /actuator
  endpoint:
    health:
      show-details: always
      probes:
        enabled: true
      validate-group-membership: false
      group:
        readiness:
         include: readinessState,db

action:
  security:
    mode: BASIC
    bearer-token: ${ACTION_BEARER_TOKEN:your-secret-token}
    basic-username: ${ACTION_BASIC_USER:admin}
    basic-password: ${ACTION_BASIC_PASSWORD:aj8U9*M)^s2kEi}
    jwt-issuer-uri: ${ACTION_JWT_ISSUER:}
    jwt-audience: ${ACTION_JWT_AUDIENCE:}
    allowed-hosts:
      - "*.example.com"
      - "api.github.com"
      - "api.stripe.com"
      - "jsonplaceholder.typicode.com"
      - "sandboxapp.oncentrl.net"
      - "sandboxauth.oncentrl.net"
      - "jw3frab4s4ghupkx.s3.us-west-2.amazonaws.com"
    allowed-methods:
      - GET
      - POST
      - PUT
      - PATCH
      - DELETE
      - HEAD
      - OPTIONS
    blocked-header-prefixes:
      - x-forwarded
      - x-real-ip

  oauth:
    cache-enabled: false
    cache-skew-seconds: 30
    default-timeout-sec: 30
    centrl:
      token-url: "https://sandboxauth.oncentrl.net/Authorization/oauth/token"
      client-id: ${action.oauth.centrl.client-id}
      client-secret: ${action.oauth.centrl.client-secret}
      grant-type: "password"
      username: ${action.oauth.centrl.username}
      password: ${action.oauth.centrl.password}


  limits:
    max-response-bytes: 104857600
    max-request-bytes: 104857600
    default-timeout-sec: 30
    max-timeout-sec: 300

  base-dirs:
    DATA_IN: "/files/Inbound"
    DATA_OUT: ${DATA_OUT_DIR:/data/output}
    TEMP: ${TEMP_DIR:/tmp}

  credentials:
    example-oauth:
      client-id: ${EXAMPLE_CLIENT_ID:}
      client-secret: ${EXAMPLE_CLIENT_SECRET:}
    example-basic:
      username: ${EXAMPLE_BASIC_USER:}
      password: ${EXAMPLE_BASIC_PASSWORD:}

logging:
  level:
    root: INFO
    com.novaflow.action: DEBUG
    org.springframework.web.reactive: DEBUG
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n"

