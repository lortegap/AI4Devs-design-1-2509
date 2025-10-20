
# Modelo de Datos ATS — Diccionario de Entidades, Atributos y Relaciones

> **Motor objetivo:** SQL Server (tipos sugeridos).<br>
> **Convenciones:** PK = Primary Key, FK = Foreign Key, NN = Not Null, UQ = Unique, DF = Default.

---

## 1. Seguridad y Organización

### 1.1 `roles`
- `rol_id` **BIGINT IDENTITY PK**
- `nombre` **NVARCHAR(100) NN UQ**
- `descripcion` **NVARCHAR(250) NULL**
- `activo` **BIT NN DF(1)**
- `creado_en` **DATETIME2(0) NN DF(SYSDATETIME())**

### 1.2 `usuarios`
- `usuario_id` **BIGINT IDENTITY PK**
- `nombre_completo` **NVARCHAR(150) NN**
- `email` **NVARCHAR(255) NN UQ**
- `telefono` **NVARCHAR(30) NULL**
- `rol_id` **BIGINT NN FK → roles(rol_id)**
- `activo` **BIT NN DF(1)**
- `creado_en` **DATETIME2(0) NN DF(SYSDATETIME())**

### 1.3 `departamentos`
- `departamento_id` **BIGINT IDENTITY PK**
- `nombre` **NVARCHAR(120) NN UQ**
- `descripcion` **NVARCHAR(250) NULL**
- `creado_en` **DATETIME2(0) NN DF(SYSDATETIME())**

### 1.4 `puestos`
- `puesto_id` **BIGINT IDENTITY PK**
- `nombre` **NVARCHAR(120) NN**
- `departamento_id` **BIGINT NULL FK → departamentos(departamento_id)**
- `descripcion` **NVARCHAR(250) NULL**

### 1.5 `ubicaciones`
- `ubicacion_id` **BIGINT IDENTITY PK**
- `pais` **NVARCHAR(100) NN**
- `estado` **NVARCHAR(100) NULL**
- `ciudad` **NVARCHAR(120) NULL**

---

## 2. Reclutamiento — Vacantes y Requisiciones

### 2.1 `vacantes`
- `vacante_id` **BIGINT IDENTITY PK**
- `codigo` **NVARCHAR(30) NN UQ**
- `titulo` **NVARCHAR(150) NN**
- `descripcion` **NVARCHAR(MAX) NN**
- `requisitos` **NVARCHAR(MAX) NULL**
- `tipo_contrato` **NVARCHAR(50) NULL**  (p.ej., tiempo completo)
- `jornada` **NVARCHAR(50) NULL**        (p.ej., híbrido, remoto)
- `salario_min` **DECIMAL(12,2) NULL**
- `salario_max` **DECIMAL(12,2) NULL**
- `moneda` **NVARCHAR(10) NULL**
- `ubicacion_id` **BIGINT NULL FK → ubicaciones(ubicacion_id)**
- `departamento_id` **BIGINT NULL FK → departamentos(departamento_id)**
- `puesto_id` **BIGINT NULL FK → puestos(puesto_id)**
- `reclutador_id` **BIGINT NN FK → usuarios(usuario_id)**
- `fecha_apertura` **DATE NN**
- `fecha_cierre` **DATE NULL**
- `estado` **NVARCHAR(30) NN** (borrador, aprobada, publicada, cerrada)
- `creado_en` **DATETIME2(0) NN DF(SYSDATETIME())**

### 2.2 `requisiciones`
- `requisicion_id` **BIGINT IDENTITY PK**
- `vacante_id` **BIGINT NN UQ FK → vacantes(vacante_id)**
- `solicitante_id` **BIGINT NN FK → usuarios(usuario_id)**
- `justificacion` **NVARCHAR(MAX) NN**
- `estatus` **NVARCHAR(30) NN** (pendiente, aprobada, rechazada)
- `aprobado_por` **BIGINT NULL FK → usuarios(usuario_id)**
- `fecha_solicitud` **DATETIME2(0) NN DF(SYSDATETIME())**
- `fecha_aprobacion` **DATETIME2(0) NULL**

---

## 3. Candidatos, Consentimiento y Fuentes

### 3.1 `candidatos`
- `candidato_id` **BIGINT IDENTITY PK**
- `nombre` **NVARCHAR(120) NN**
- `apellidos` **NVARCHAR(150) NN**
- `email` **NVARCHAR(255) NN**
- `telefono` **NVARCHAR(30) NULL**
- `ubicacion_id` **BIGINT NULL FK → ubicaciones(ubicacion_id)**
- `linkedin_url` **NVARCHAR(255) NULL**
- `fuente_id` **BIGINT NULL FK → fuentes(fuente_id)**
- `activo` **BIT NN DF(1)**
- `creado_en` **DATETIME2(0) NN DF(SYSDATETIME())**

**Índices sugeridos:** UQ(email); IX(nombre, apellidos)

### 3.2 `consentimientos`
- `consentimiento_id` **BIGINT IDENTITY PK**
- `candidato_id` **BIGINT NN FK → candidatos(candidato_id)**
- `version_aviso` **NVARCHAR(20) NN**
- `fecha_otorgado` **DATETIME2(0) NN**
- `ip_origen` **NVARCHAR(45) NULL**
- `acepta_tratamiento` **BIT NN**
- `acepta_comunicaciones` **BIT NN**
- `fecha_revocacion` **DATETIME2(0) NULL**

### 3.3 `fuentes`
- `fuente_id` **BIGINT IDENTITY PK**
- `nombre` **NVARCHAR(80) NN UQ** (portal, referido, LinkedIn, etc.)

### 3.4 `documentos`
- `documento_id` **BIGINT IDENTITY PK**
- `candidato_id` **BIGINT NN FK → candidatos(candidato_id)**
- `tipo` **NVARCHAR(50) NN** (CV, identificación, etc.)
- `nombre_archivo` **NVARCHAR(255) NN**
- `ruta` **NVARCHAR(500) NN**
- `mime` **NVARCHAR(100) NN**
- `tamano_bytes` **BIGINT NN**
- `hash_sha256` **VARBINARY(32) NULL**
- `cargado_en` **DATETIME2(0) NN DF(SYSDATETIME())**

### 3.5 `habilidades` y `candidato_habilidad`
- `habilidad_id` **BIGINT IDENTITY PK**
- `nombre` **NVARCHAR(80) NN UQ**

`candidato_habilidad` (tabla puente)
- `candidato_id` **BIGINT NN FK → candidatos**
- `habilidad_id` **BIGINT NN FK → habilidades**
- `nivel` **TINYINT NULL** (1–5)
**PK compuesta:** (candidato_id, habilidad_id)

### 3.6 `idiomas` y `candidato_idioma`
- `idioma_id` **BIGINT IDENTITY PK**
- `nombre` **NVARCHAR(80) NN UQ**

`candidato_idioma`
- `candidato_id` **BIGINT NN FK → candidatos**
- `idioma_id` **BIGINT NN FK → idiomas**
- `nivel` **NVARCHAR(10) NULL** (A1–C2)
**PK compuesta:** (candidato_id, idioma_id)

---

## 4. Aplicaciones, Pipeline y Entrevistas

### 4.1 `aplicaciones`
- `aplicacion_id` **BIGINT IDENTITY PK**
- `vacante_id` **BIGINT NN FK → vacantes(vacante_id)**
- `candidato_id` **BIGINT NN FK → candidatos(candidato_id)**
- `fecha_aplicacion` **DATETIME2(0) NN DF(SYSDATETIME())**
- `estado` **NVARCHAR(30) NN** (recibida, en_proceso, descartada, contratada)

**UQ:** (vacante_id, candidato_id)

### 4.2 `etapas`
- `etapa_id` **BIGINT IDENTITY PK**
- `nombre` **NVARCHAR(60) NN**
- `orden` **INT NN**
- `vacante_id` **BIGINT NULL FK → vacantes(vacante_id)** (nulas = globales)

### 4.3 `pipeline_candidato`
- `pipeline_id` **BIGINT IDENTITY PK**
- `aplicacion_id` **BIGINT NN FK → aplicaciones(aplicacion_id) UQ**
- `etapa_actual_id` **BIGINT NN FK → etapas(etapa_id)**
- `actualizado_en` **DATETIME2(0) NN DF(SYSDATETIME())**

### 4.4 `movimientos_pipeline`
- `movimiento_id` **BIGINT IDENTITY PK**
- `pipeline_id` **BIGINT NN FK → pipeline_candidato(pipeline_id)**
- `etapa_origen_id` **BIGINT NULL FK → etapas(etapa_id)**
- `etapa_destino_id` **BIGINT NN FK → etapas(etapa_id)**
- `cambiado_por` **BIGINT NN FK → usuarios(usuario_id)**
- `comentario` **NVARCHAR(500) NULL**
- `cambiado_en` **DATETIME2(0) NN DF(SYSDATETIME())**

### 4.5 `entrevistas`
- `entrevista_id` **BIGINT IDENTITY PK**
- `aplicacion_id` **BIGINT NN FK → aplicaciones(aplicacion_id)**
- `fecha_hora_inicio` **DATETIME2(0) NN**
- `fecha_hora_fin` **DATETIME2(0) NN**
- `tipo` **NVARCHAR(30) NN** (presencial, remota)
- `ubicacion` **NVARCHAR(255) NULL**
- `cal_evento_id` **NVARCHAR(120) NULL** (ID externo)
- `estado` **NVARCHAR(30) NN** (programada, confirmada, realizada, cancelada)

### 4.6 `entrevistadores`
- `entrevista_id` **BIGINT NN FK → entrevistas(entrevista_id)**
- `usuario_id` **BIGINT NN FK → usuarios(usuario_id)**
**PK compuesta:** (entrevista_id, usuario_id)

### 4.7 `feedback_entrevista`
- `feedback_id` **BIGINT IDENTITY PK**
- `entrevista_id` **BIGINT NN FK → entrevistas(entrevista_id)**
- `evaluador_id` **BIGINT NN FK → usuarios(usuario_id)**
- `calificacion` **TINYINT NULL**
- `comentarios` **NVARCHAR(1000) NULL**
- `capturado_en` **DATETIME2(0) NN DF(SYSDATETIME())**

### 4.8 `pruebas`
- `prueba_id` **BIGINT IDENTITY PK**
- `aplicacion_id` **BIGINT NN FK → aplicaciones(aplicacion_id)**
- `proveedor` **NVARCHAR(80) NN**
- `tipo` **NVARCHAR(60) NN**
- `estatus` **NVARCHAR(30) NN**
- `puntaje` **DECIMAL(6,2) NULL**
- `fecha_envio` **DATETIME2(0) NULL**
- `fecha_resultado` **DATETIME2(0) NULL**
- `referencia_externa` **NVARCHAR(120) NULL**

---

## 5. Ofertas, Firma y Altas

### 5.1 `ofertas`
- `oferta_id` **BIGINT IDENTITY PK**
- `aplicacion_id` **BIGINT NN FK → aplicaciones(aplicacion_id) UQ**
- `salario` **DECIMAL(12,2) NN**
- `moneda` **NVARCHAR(10) NN**
- `fecha_inicio` **DATE NN**
- `tipo_contrato` **NVARCHAR(50) NN**
- `estatus` **NVARCHAR(30) NN** (borrador, enviada, firmada, expirada, rechazada)
- `emitida_en` **DATETIME2(0) NN DF(SYSDATETIME())**

### 5.2 `firmas`
- `firma_id` **BIGINT IDENTITY PK**
- `oferta_id` **BIGINT NN FK → ofertas(oferta_id) UQ**
- `proveedor` **NVARCHAR(60) NN** (DocuSign, etc.)
- `sobre_id` **NVARCHAR(120) NULL**
- `estatus` **NVARCHAR(30) NN** (enviada, firmada, expirada)
- `fecha_envio` **DATETIME2(0) NULL**
- `fecha_firma` **DATETIME2(0) NULL**
- `url_documento` **NVARCHAR(500) NULL**

---

## 6. Publicaciones, Integraciones y Notificaciones

### 6.1 `portales`
- `portal_id` **BIGINT IDENTITY PK**
- `nombre` **NVARCHAR(120) NN UQ**

### 6.2 `publicaciones`
- `publicacion_id` **BIGINT IDENTITY PK**
- `vacante_id` **BIGINT NN FK → vacantes(vacante_id)**
- `portal_id` **BIGINT NN FK → portales(portal_id)**
- `url` **NVARCHAR(500) NULL**
- `estado` **NVARCHAR(30) NN** (publicada, despublicada, error)
- `fecha_publicacion` **DATETIME2(0) NN DF(SYSDATETIME())**
- `fecha_retiro` **DATETIME2(0) NULL**
- `id_remoto` **NVARCHAR(120) NULL**

### 6.3 `notificaciones`
- `notificacion_id` **BIGINT IDENTITY PK**
- `tipo` **NVARCHAR(40) NN** (email, sms, webhook)
- `destinatario_email` **NVARCHAR(255) NULL**
- `asunto` **NVARCHAR(255) NULL**
- `cuerpo` **NVARCHAR(MAX) NULL**
- `estado_envio` **NVARCHAR(30) NN** (pendiente, enviado, error)
- `referencia_tipo` **NVARCHAR(40) NULL** (aplicacion, entrevista, oferta)
- `referencia_id` **BIGINT NULL**
- `enviado_en` **DATETIME2(0) NULL**

### 6.4 `auditoria`
- `auditoria_id` **BIGINT IDENTITY PK**
- `usuario_id` **BIGINT NULL FK → usuarios(usuario_id)**
- `accion` **NVARCHAR(40) NN**
- `entidad` **NVARCHAR(60) NN**
- `entidad_id` **BIGINT NULL**
- `datos_previos` **NVARCHAR(MAX) NULL**
- `datos_nuevos` **NVARCHAR(MAX) NULL**
- `creado_en` **DATETIME2(0) NN DF(SYSDATETIME())**

---

## 7. Relaciones clave (resumen)
- **usuarios(rol_id)** → roles(rol_id) **[N:1]**
- **vacantes(reclutador_id)** → usuarios(usuario_id) **[N:1]**
- **requisiciones(vacante_id)** ↔ vacantes(vacante_id) **[1:1]**
- **aplicaciones(candidato_id, vacante_id)** → candidatos & vacantes **[N:1 + N:1]** (UQ por pareja)
- **pipeline_candidato(aplicacion_id)** ↔ aplicaciones(aplicacion_id) **[1:1]**
- **movimientos_pipeline(pipeline_id)** → pipeline_candidato **[N:1]**
- **entrevistas(aplicacion_id)** → aplicaciones **[N:1]**, **entrevistadores** **[N:M]** via tabla puente
- **feedback_entrevista(entrevista_id, evaluador_id)** → entrevistas & usuarios **[N:1 + N:1]**
- **pruebas(aplicacion_id)** → aplicaciones **[N:1]**
- **ofertas(aplicacion_id)** ↔ aplicaciones **[1:1]**
- **firmas(oferta_id)** ↔ ofertas **[1:1]**
- **publicaciones(vacante_id, portal_id)** → vacantes & portales **[N:1 + N:1]**
- **consentimientos(candidato_id)** → candidatos **[N:1]**
