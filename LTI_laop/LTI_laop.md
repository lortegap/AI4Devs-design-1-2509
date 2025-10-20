
# 📘 ATS — Documentación del Sistema

Este repositorio contiene la definición funcional y técnica del **Applicant Tracking System (ATS)**, incluyendo backlog, modelo de datos, diagramas UML, arquitectura y diseño C4.

---

## 📑 1. Funcionalidad y Estrategia
- `funcionalidades_ATS.md` — listado priorizado de funcionalidades clave.  
- `entregables_ATS.md` — backlog inicial, roadmap y Lean Canvas.  

---

## 🎭 2. Casos de Uso (UML)
- `01_ats_usecases_general.puml` — vista general.  
- `02_ats_usecases_vacantes.puml` — gestión de vacantes.  
- `03_ats_usecases_proceso.puml` — pipeline y selección.  
- `04_ats_usecases_comunicacion_portal.puml` — comunicación y portal candidato.  
- `05_ats_usecases_reportes_cumplimiento.puml` — reportes y cumplimiento.  
- `06_ats_usecases_integraciones.puml` — integraciones.  
- `README_plantuml_ATS.md` — guía de uso.

---

## 🔄 3. Actividades (UML)
- `01_actividad_publicar_vacante.puml` — Publicar vacante.  
- `02_actividad_aplicar_vacante.puml` — Aplicar a vacante.  
- `03_actividad_mover_etapa.puml` — Mover de etapa con notificaciones.  
- `04_actividad_agendar_entrevista.puml` — Agendar entrevista y feedback.  
- `05_actividad_oferta_firma_alta.puml` — Oferta → firma → alta HRM.  
- `06_actividad_reportes_kpis.puml` — KPIs y reportes.  
- `README_actividades_ATS.md`

---

## 📬 4. Secuencias (UML)
- `01_seq_aplicar_vacante.puml` — Aplicación candidato.  
- `02_seq_agendar_entrevista.puml` — Agendar entrevista.  
- `03_seq_oferta_firma_alta.puml` — Oferta, firma y alta en HRM.  
- `README_secuencia_ATS.md`

---

## 🗄️ 5. Modelo de Datos
- `ATS_Diccionario_Datos.md` — diccionario de entidades, atributos y relaciones.  
- `ATS_DDL_SQLServer.sql` — definición en SQL Server.  
- `ATS_ERD.puml` — diagrama entidad–relación.  

---

## 🏗️ 6. Arquitectura
- `ATS_Arquitectura_AltoNivel.md` — descripción textual de la arquitectura de alto nivel.  
- `ATS_Arquitectura_AltoNivel.puml` — diagrama de componentes/contexto.  

---

## 🌐 7. Diagramas C4
- `ATS_C4_Context.puml` — vista Context (requiere include C4-PlantUML).  
- `ATS_C4_Container.puml` — vista Container.  
- `ATS_C4_Context_Fallback.puml` — versión sin includes.  
- `ATS_C4_Container_Fallback.puml` — versión sin includes.  
- `README_C4.md` — guía de uso.

---

## 📊 8. Próximos Artefactos (pendientes / sugeridos)
- Diagramas **C4-Component** de módulos clave (Pipeline, Ofertas/Firma).  
- **Diagrama de despliegue** (nodos, cloud, balanceadores, workers).  
- **Esquemas de seguridad** (autenticación, RBAC, cifrado en tránsito y reposo).  
- **Pruebas de rendimiento** y definición de SLAs.  

---

👉 Con este README central puedes navegar por todos los entregables generados, mantener la trazabilidad y extender la documentación conforme evolucione el proyecto.
