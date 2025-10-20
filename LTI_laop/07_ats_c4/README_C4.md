
# C4 Diagrams — ATS

Se incluyen dos niveles del modelo C4 en PlantUML:

- `ATS_C4_Context.puml` — **Context** (requiere C4-PlantUML via `!includeurl`).
- `ATS_C4_Container.puml` — **Container** (requiere C4-PlantUML).

Además, versiones **fallback** sin includes (renderizan en cualquier visor PlantUML):
- `ATS_C4_Context_Fallback.puml`
- `ATS_C4_Container_Fallback.puml`


## Notas
- Las flechas/modelado siguen los flujos definidos del ATS: publicación, aplicación, pipeline, entrevistas, notificaciones, integraciones, firma y alta HRM.
- Adapta nombres de contenedores según tu stack real (Java/NestJS, etc.).
