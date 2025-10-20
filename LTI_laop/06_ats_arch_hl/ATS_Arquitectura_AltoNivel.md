
# ATS — Diseño de Sistema a Alto Nivel

Este documento describe la **arquitectura de alto nivel** de un Applicant Tracking System (ATS) alineado con las funcionalidades y artefactos previos (backlog, casos de uso, actividades y modelo de datos).

## Objetivos de arquitectura
- **Escalabilidad y desacoplamiento:** separar frontends, API y servicios de dominio (publicación, pipeline, notificaciones, integraciones).
- **Seguridad end-to-end:** autenticación OAuth2/OIDC, cifrado en tránsito (HTTPS/TLS) y en reposo (DB/Storage), controles RBAC.
- **Observabilidad y calidad:** métricas, logs centralizados, trazas distribuidas, alertas.
- **Integrabilidad:** conectores para Portales de Empleo, Calendarios, Firma electrónica y HRM/ERP.
- **Experiencia fluida:** portales dedicados (Candidato / Reclutador) y colas de mensajería para procesos asíncronos.

## Vista por contenedores (alto nivel)

- **Frontend Web (SPA)**
  - *Recruiter Console* (gestión de vacantes, pipeline, entrevistas, reportes).
  - *Candidate Portal* (búsqueda/aplicación, estatus, actualización de datos).
  - CDN + caché para activos estáticos.

- **API Gateway / BFF**
  - Termina TLS, aplica rate limiting y auth (JWT/OAuth2).
  - Expone endpoints REST/GraphQL para Frontend y Webhooks externos.

- **Servicios de Dominio (lógica de negocio)**
  - **Vacantes & Publicación**: CRUD de vacantes, publicación en portales, estados.
  - **Candidatos & Aplicaciones**: recepción de CV, parsing opcional, deduplicación, consentimiento.
  - **Pipeline & Entrevistas**: etapas, movimientos, agendas, feedback.
  - **Notificaciones**: plantillas, envíos (email/SMS/webhooks), reintentos.
  - **Integraciones**: Portales, Calendarios, Firma, HRM/ERP.
  - **Reportes/Analytics (operacional)**: KPIs básicos (tiempo de cobertura, embudo, fuentes).

- **Infra de Datos**
  - **DB relacional (SQL Server)**: entidades transaccionales (modelo ya definido).
  - **Almacenamiento de Objetos**: CV y documentos (S3-compatible).
  - **Motor de Búsqueda**: índice de candidatos/vacantes por texto completo.
  - **Data Lake/BI (opcional)**: replicación a almacén analítico (ETL/ELT).

- **Mensajería y Procesamiento asíncrono**
  - **Broker (RabbitMQ/Kafka)**: colas para eventos (postulación, cambio de etapa, publicación, notificación).
  - **Workers**: consumidores para envíos, parsers, integraciones y reintentos.

- **Seguridad, Gestión y Observabilidad**
  - **Auth**: OIDC (Keycloak/IdP), RBAC, MFA opcional.
  - **WAF/Firewall** y **Secret Manager**.
  - **Logs/Métricas/Trazas**: ELK/EFK, Prometheus, Grafana.
  - **CI/CD**: pipelines de build/test/deploy, IaC (Terraform/Ansible).

## Flujos clave (resumen)
1. **Publicar vacante** → Recruiter Console → API → Servicio Vacantes → Portales externos (async) → Notificaciones.
2. **Aplicar** → Candidate Portal → API → Servicio Candidatos → DB + Storage → Evento “Aplicación recibida” → Notificación.
3. **Mover de etapa** → Recruiter Console → API → Servicio Pipeline → DB → Evento “Cambio de etapa” → Notificación + Métricas.
4. **Agendar entrevista** → API → Conector Calendarios → IDs de evento → Notificaciones y feedback.
5. **Oferta y firma** → API → Servicio Ofertas → Conector Firma → Callback → Alta HRM/ERP.

## Tecnologías de referencia (sugeridas)
- **Frontend**: React + TypeScript, SPA; CDN.
- **Backend**: Java (Spring Boot); REST/GraphQL.
- **DB**: SQL Server; **Search**: Elasticsearch/OpenSearch; **Storage**: S3.
- **Mensajería**: RabbitMQ/Kafka; **Notificaciones**: SendGrid/Twilio.
- **Auth**: Keycloak/IdP OIDC; **CI/CD**: GitHub Actions/GitLab CI.
- **Observabilidad**: OpenTelemetry + Prometheus + Grafana + Loki/ELK.

## No funcionales (NFRs) mínimos
- **Disponibilidad** ≥ 99.5% (multi‑AZ).
- **Seguridad**: TLS 1.2+, cifrado en reposo (TDE/Field‑Level si aplica), OWASP ASVS nivel 2.
- **Rendimiento**: p95 < 300 ms en operaciones CRUD; colas para picos > 50 RPS.
- **Escalabilidad**: horizontal para API/Workers/Frontend.
- **Cumplimiento**: LFPDPPP/GDPR (consentimiento, retención, derecho al olvido).

---

**Diagrama adjunto:** ver `ATS_Arquitectura_AltoNivel.puml` (PlantUML, vista de componentes).
