
-- ATS - Esquema lógico para SQL Server
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

CREATE SCHEMA ats AUTHORIZATION dbo;
GO

-- 1. Seguridad y Organización
CREATE TABLE ats.roles (
  rol_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(100) NOT NULL UNIQUE,
  descripcion NVARCHAR(250) NULL,
  activo BIT NOT NULL CONSTRAINT DF_roles_activo DEFAULT(1),
  creado_en DATETIME2(0) NOT NULL CONSTRAINT DF_roles_creado DEFAULT(SYSDATETIME())
);

CREATE TABLE ats.usuarios (
  usuario_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  nombre_completo NVARCHAR(150) NOT NULL,
  email NVARCHAR(255) NOT NULL UNIQUE,
  telefono NVARCHAR(30) NULL,
  rol_id BIGINT NOT NULL,
  activo BIT NOT NULL CONSTRAINT DF_usuarios_activo DEFAULT(1),
  creado_en DATETIME2(0) NOT NULL CONSTRAINT DF_usuarios_creado DEFAULT(SYSDATETIME()),
  CONSTRAINT FK_usuarios_roles FOREIGN KEY (rol_id) REFERENCES ats.roles(rol_id)
);

CREATE TABLE ats.departamentos (
  departamento_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(120) NOT NULL UNIQUE,
  descripcion NVARCHAR(250) NULL,
  creado_en DATETIME2(0) NOT NULL CONSTRAINT DF_dept_creado DEFAULT(SYSDATETIME())
);

CREATE TABLE ats.puestos (
  puesto_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(120) NOT NULL,
  departamento_id BIGINT NULL,
  descripcion NVARCHAR(250) NULL,
  CONSTRAINT FK_puestos_dept FOREIGN KEY (departamento_id) REFERENCES ats.departamentos(departamento_id)
);

CREATE TABLE ats.ubicaciones (
  ubicacion_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  pais NVARCHAR(100) NOT NULL,
  estado NVARCHAR(100) NULL,
  ciudad NVARCHAR(120) NULL
);

-- 2. Vacantes y Requisiciones
CREATE TABLE ats.vacantes (
  vacante_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  codigo NVARCHAR(30) NOT NULL UNIQUE,
  titulo NVARCHAR(150) NOT NULL,
  descripcion NVARCHAR(MAX) NOT NULL,
  requisitos NVARCHAR(MAX) NULL,
  tipo_contrato NVARCHAR(50) NULL,
  jornada NVARCHAR(50) NULL,
  salario_min DECIMAL(12,2) NULL,
  salario_max DECIMAL(12,2) NULL,
  moneda NVARCHAR(10) NULL,
  ubicacion_id BIGINT NULL,
  departamento_id BIGINT NULL,
  puesto_id BIGINT NULL,
  reclutador_id BIGINT NOT NULL,
  fecha_apertura DATE NOT NULL,
  fecha_cierre DATE NULL,
  estado NVARCHAR(30) NOT NULL,
  creado_en DATETIME2(0) NOT NULL CONSTRAINT DF_vacantes_creado DEFAULT(SYSDATETIME()),
  CONSTRAINT FK_vac_ubic FOREIGN KEY (ubicacion_id) REFERENCES ats.ubicaciones(ubicacion_id),
  CONSTRAINT FK_vac_dept FOREIGN KEY (departamento_id) REFERENCES ats.departamentos(departamento_id),
  CONSTRAINT FK_vac_puesto FOREIGN KEY (puesto_id) REFERENCES ats.puestos(puesto_id),
  CONSTRAINT FK_vac_reclutador FOREIGN KEY (reclutador_id) REFERENCES ats.usuarios(usuario_id)
);

CREATE TABLE ats.requisiciones (
  requisicion_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  vacante_id BIGINT NOT NULL UNIQUE,
  solicitante_id BIGINT NOT NULL,
  justificacion NVARCHAR(MAX) NOT NULL,
  estatus NVARCHAR(30) NOT NULL,
  aprobado_por BIGINT NULL,
  fecha_solicitud DATETIME2(0) NOT NULL CONSTRAINT DF_req_solic DEFAULT(SYSDATETIME()),
  fecha_aprobacion DATETIME2(0) NULL,
  CONSTRAINT FK_req_vac FOREIGN KEY (vacante_id) REFERENCES ats.vacantes(vacante_id),
  CONSTRAINT FK_req_solic FOREIGN KEY (solicitante_id) REFERENCES ats.usuarios(usuario_id),
  CONSTRAINT FK_req_aprob FOREIGN KEY (aprobado_por) REFERENCES ats.usuarios(usuario_id)
);

-- 3. Candidatos y Consentimientos
CREATE TABLE ats.candidatos (
  candidato_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(120) NOT NULL,
  apellidos NVARCHAR(150) NOT NULL,
  email NVARCHAR(255) NOT NULL,
  telefono NVARCHAR(30) NULL,
  ubicacion_id BIGINT NULL,
  linkedin_url NVARCHAR(255) NULL,
  fuente_id BIGINT NULL,
  activo BIT NOT NULL CONSTRAINT DF_cand_activo DEFAULT(1),
  creado_en DATETIME2(0) NOT NULL CONSTRAINT DF_cand_creado DEFAULT(SYSDATETIME()),
  CONSTRAINT UQ_candidatos_email UNIQUE(email),
  CONSTRAINT FK_cand_ubic FOREIGN KEY (ubicacion_id) REFERENCES ats.ubicaciones(ubicacion_id)
);

CREATE TABLE ats.fuentes (
  fuente_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(80) NOT NULL UNIQUE
);

ALTER TABLE ats.candidatos
  ADD CONSTRAINT FK_cand_fuente FOREIGN KEY (fuente_id) REFERENCES ats.fuentes(fuente_id);

CREATE TABLE ats.consentimientos (
  consentimiento_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  candidato_id BIGINT NOT NULL,
  version_aviso NVARCHAR(20) NOT NULL,
  fecha_otorgado DATETIME2(0) NOT NULL,
  ip_origen NVARCHAR(45) NULL,
  acepta_tratamiento BIT NOT NULL,
  acepta_comunicaciones BIT NOT NULL,
  fecha_revocacion DATETIME2(0) NULL,
  CONSTRAINT FK_cons_cand FOREIGN KEY (candidato_id) REFERENCES ats.candidatos(candidato_id)
);

CREATE TABLE ats.documentos (
  documento_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  candidato_id BIGINT NOT NULL,
  tipo NVARCHAR(50) NOT NULL,
  nombre_archivo NVARCHAR(255) NOT NULL,
  ruta NVARCHAR(500) NOT NULL,
  mime NVARCHAR(100) NOT NULL,
  tamano_bytes BIGINT NOT NULL,
  hash_sha256 VARBINARY(32) NULL,
  cargado_en DATETIME2(0) NOT NULL CONSTRAINT DF_doc_cargado DEFAULT(SYSDATETIME()),
  CONSTRAINT FK_doc_cand FOREIGN KEY (candidato_id) REFERENCES ats.candidatos(candidato_id)
);

CREATE TABLE ats.habilidades (
  habilidad_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE ats.candidato_habilidad (
  candidato_id BIGINT NOT NULL,
  habilidad_id BIGINT NOT NULL,
  nivel TINYINT NULL,
  CONSTRAINT PK_cand_hab PRIMARY KEY (candidato_id, habilidad_id),
  CONSTRAINT FK_ch_cand FOREIGN KEY (candidato_id) REFERENCES ats.candidatos(candidato_id),
  CONSTRAINT FK_ch_hab FOREIGN KEY (habilidad_id) REFERENCES ats.habilidades(habilidad_id)
);

CREATE TABLE ats.idiomas (
  idioma_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE ats.candidato_idioma (
  candidato_id BIGINT NOT NULL,
  idioma_id BIGINT NOT NULL,
  nivel NVARCHAR(10) NULL,
  CONSTRAINT PK_cand_idi PRIMARY KEY (candidato_id, idioma_id),
  CONSTRAINT FK_ci_cand FOREIGN KEY (candidato_id) REFERENCES ats.candidatos(candidato_id),
  CONSTRAINT FK_ci_idi FOREIGN KEY (idioma_id) REFERENCES ats.idiomas(idioma_id)
);

-- 4. Aplicaciones, Pipeline y Entrevistas
CREATE TABLE ats.aplicaciones (
  aplicacion_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  vacante_id BIGINT NOT NULL,
  candidato_id BIGINT NOT NULL,
  fecha_aplicacion DATETIME2(0) NOT NULL CONSTRAINT DF_apl_fecha DEFAULT(SYSDATETIME()),
  estado NVARCHAR(30) NOT NULL,
  CONSTRAINT UQ_aplicacion UNIQUE (vacante_id, candidato_id),
  CONSTRAINT FK_apl_vac FOREIGN KEY (vacante_id) REFERENCES ats.vacantes(vacante_id),
  CONSTRAINT FK_apl_cand FOREIGN KEY (candidato_id) REFERENCES ats.candidatos(candidato_id)
);

CREATE TABLE ats.etapas (
  etapa_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(60) NOT NULL,
  orden INT NOT NULL,
  vacante_id BIGINT NULL,
  CONSTRAINT FK_etp_vac FOREIGN KEY (vacante_id) REFERENCES ats.vacantes(vacante_id)
);

CREATE TABLE ats.pipeline_candidato (
  pipeline_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  aplicacion_id BIGINT NOT NULL UNIQUE,
  etapa_actual_id BIGINT NOT NULL,
  actualizado_en DATETIME2(0) NOT NULL CONSTRAINT DF_pipe_upd DEFAULT(SYSDATETIME()),
  CONSTRAINT FK_pipe_apl FOREIGN KEY (aplicacion_id) REFERENCES ats.aplicaciones(aplicacion_id),
  CONSTRAINT FK_pipe_etp FOREIGN KEY (etapa_actual_id) REFERENCES ats.etapas(etapa_id)
);

CREATE TABLE ats.movimientos_pipeline (
  movimiento_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  pipeline_id BIGINT NOT NULL,
  etapa_origen_id BIGINT NULL,
  etapa_destino_id BIGINT NOT NULL,
  cambiado_por BIGINT NOT NULL,
  comentario NVARCHAR(500) NULL,
  cambiado_en DATETIME2(0) NOT NULL CONSTRAINT DF_mov_fecha DEFAULT(SYSDATETIME()),
  CONSTRAINT FK_mov_pipe FOREIGN KEY (pipeline_id) REFERENCES ats.pipeline_candidato(pipeline_id),
  CONSTRAINT FK_mov_etp_o FOREIGN KEY (etapa_origen_id) REFERENCES ats.etapas(etapa_id),
  CONSTRAINT FK_mov_etp_d FOREIGN KEY (etapa_destino_id) REFERENCES ats.etapas(etapa_id),
  CONSTRAINT FK_mov_user FOREIGN KEY (cambiado_por) REFERENCES ats.usuarios(usuario_id)
);

CREATE TABLE ats.entrevistas (
  entrevista_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  aplicacion_id BIGINT NOT NULL,
  fecha_hora_inicio DATETIME2(0) NOT NULL,
  fecha_hora_fin DATETIME2(0) NOT NULL,
  tipo NVARCHAR(30) NOT NULL,
  ubicacion NVARCHAR(255) NULL,
  cal_evento_id NVARCHAR(120) NULL,
  estado NVARCHAR(30) NOT NULL,
  CONSTRAINT FK_ent_apl FOREIGN KEY (aplicacion_id) REFERENCES ats.aplicaciones(aplicacion_id)
);

CREATE TABLE ats.entrevistadores (
  entrevista_id BIGINT NOT NULL,
  usuario_id BIGINT NOT NULL,
  CONSTRAINT PK_entrevistadores PRIMARY KEY (entrevista_id, usuario_id),
  CONSTRAINT FK_entrv_user FOREIGN KEY (usuario_id) REFERENCES ats.usuarios(usuario_id),
  CONSTRAINT FK_entrv_ent FOREIGN KEY (entrevista_id) REFERENCES ats.entrevistas(entrevista_id)
);

CREATE TABLE ats.feedback_entrevista (
  feedback_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  entrevista_id BIGINT NOT NULL,
  evaluador_id BIGINT NOT NULL,
  calificacion TINYINT NULL,
  comentarios NVARCHAR(1000) NULL,
  capturado_en DATETIME2(0) NOT NULL CONSTRAINT DF_fb_fecha DEFAULT(SYSDATETIME()),
  CONSTRAINT FK_fb_ent FOREIGN KEY (entrevista_id) REFERENCES ats.entrevistas(entrevista_id),
  CONSTRAINT FK_fb_eval FOREIGN KEY (evaluador_id) REFERENCES ats.usuarios(usuario_id)
);

CREATE TABLE ats.pruebas (
  prueba_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  aplicacion_id BIGINT NOT NULL,
  proveedor NVARCHAR(80) NOT NULL,
  tipo NVARCHAR(60) NOT NULL,
  estatus NVARCHAR(30) NOT NULL,
  puntaje DECIMAL(6,2) NULL,
  fecha_envio DATETIME2(0) NULL,
  fecha_resultado DATETIME2(0) NULL,
  referencia_externa NVARCHAR(120) NULL,
  CONSTRAINT FK_pru_apl FOREIGN KEY (aplicacion_id) REFERENCES ats.aplicaciones(aplicacion_id)
);

-- 5. Ofertas y Firma
CREATE TABLE ats.ofertas (
  oferta_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  aplicacion_id BIGINT NOT NULL UNIQUE,
  salario DECIMAL(12,2) NOT NULL,
  moneda NVARCHAR(10) NOT NULL,
  fecha_inicio DATE NOT NULL,
  tipo_contrato NVARCHAR(50) NOT NULL,
  estatus NVARCHAR(30) NOT NULL,
  emitida_en DATETIME2(0) NOT NULL CONSTRAINT DF_ofe_emit DEFAULT(SYSDATETIME()),
  CONSTRAINT FK_ofe_apl FOREIGN KEY (aplicacion_id) REFERENCES ats.aplicaciones(aplicacion_id)
);

CREATE TABLE ats.firmas (
  firma_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  oferta_id BIGINT NOT NULL UNIQUE,
  proveedor NVARCHAR(60) NOT NULL,
  sobre_id NVARCHAR(120) NULL,
  estatus NVARCHAR(30) NOT NULL,
  fecha_envio DATETIME2(0) NULL,
  fecha_firma DATETIME2(0) NULL,
  url_documento NVARCHAR(500) NULL,
  CONSTRAINT FK_fir_ofe FOREIGN KEY (oferta_id) REFERENCES ats.ofertas(oferta_id)
);

-- 6. Publicaciones, Integraciones y Notificaciones
CREATE TABLE ats.portales (
  portal_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  nombre NVARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE ats.publicaciones (
  publicacion_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  vacante_id BIGINT NOT NULL,
  portal_id BIGINT NOT NULL,
  url NVARCHAR(500) NULL,
  estado NVARCHAR(30) NOT NULL,
  fecha_publicacion DATETIME2(0) NOT NULL CONSTRAINT DF_pub_fecha DEFAULT(SYSDATETIME()),
  fecha_retiro DATETIME2(0) NULL,
  id_remoto NVARCHAR(120) NULL,
  CONSTRAINT FK_pub_vac FOREIGN KEY (vacante_id) REFERENCES ats.vacantes(vacante_id),
  CONSTRAINT FK_pub_portal FOREIGN KEY (portal_id) REFERENCES ats.portales(portal_id)
);

CREATE TABLE ats.notificaciones (
  notificacion_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  tipo NVARCHAR(40) NOT NULL,
  destinatario_email NVARCHAR(255) NULL,
  asunto NVARCHAR(255) NULL,
  cuerpo NVARCHAR(MAX) NULL,
  estado_envio NVARCHAR(30) NOT NULL,
  referencia_tipo NVARCHAR(40) NULL,
  referencia_id BIGINT NULL,
  enviado_en DATETIME2(0) NULL
);

CREATE TABLE ats.auditoria (
  auditoria_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  usuario_id BIGINT NULL,
  accion NVARCHAR(40) NOT NULL,
  entidad NVARCHAR(60) NOT NULL,
  entidad_id BIGINT NULL,
  datos_previos NVARCHAR(MAX) NULL,
  datos_nuevos NVARCHAR(MAX) NULL,
  creado_en DATETIME2(0) NOT NULL CONSTRAINT DF_aud_creado DEFAULT(SYSDATETIME()),
  CONSTRAINT FK_aud_user FOREIGN KEY (usuario_id) REFERENCES ats.usuarios(usuario_id)
);

-- Índices sugeridos
CREATE INDEX IX_candidatos_nombre ON ats.candidatos(nombre, apellidos);
CREATE INDEX IX_aplicaciones_estado ON ats.aplicaciones(estado);
CREATE INDEX IX_movimientos_pipeline_fecha ON ats.movimientos_pipeline(cambiado_en);
CREATE INDEX IX_entrevistas_fecha ON ats.entrevistas(fecha_hora_inicio);
GO
