# Catálogo consistente de agentes

Fuente única: `.kaizen/org/prompts/<id>.md`. Generado por `scripts/kaizen-org catalog`; no editar a mano.

Registro: `.kaizen/org/registry.json` | Fecha: 2026-11-23 | Total: 80 agentes

## Resumen por departamento

| Departamento | Agentes | Activos | Veto |
| --- | ---: | ---: | --- |
| conocimiento | 8 | 8 | none, scope |
| cumplimiento | 4 | 4 | compliance, none |
| gerencia | 8 | 8 | none, resource, scope |
| operaciones | 11 | 10 | none, scope, security |
| producto-negocio | 12 | 12 | none, scope, security |
| tecnologia | 37 | 37 | architecture, none, qa, scope, security |

## Inventario

| ID | Nombre | Departamento | Estado | Proactividad | Autonomía | Veto | Versión | Herramientas | Disparadores | Conocimiento | KPI |
| --- | --- | --- | --- | --- | --- | --- | ---: | --- | --- | ---: | --- |
| `access-auditor` | Auditor de Accesos | operaciones | active | high | scoped | security | 1 | [read, write-docs, run-checks, report] | [secret.requested:*, vault.audit:*, leak.suspected:*] | 7 | [0 lineas de auditoria alteradas sin deteccion; timestamps y retencion definidos] |
| `adr-author` | Autor de ADR | tecnologia | active | high | scoped | scope | 1 | [read, write-docs, research-web, run-checks, report] | [decision.proposed, adr.required:*] | 6 | [0 ADR marcados accepted sin evidencia de aprobacion humana; 1 decision por ADR] |
| `ai` | Experto en IA | tecnologia | active | high | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Evaluaciones reproducibles y coste medido] |
| `ai-rag-engineer` | Ingeniero de IA y RAG | tecnologia | active | high | scoped | none | 1 | [read, write-docs, research-web, run-checks, report] | [research.required:*, knowledge.updated:*, schedule:weekly, issue.label:especialista] | 2 | [evaluaciones con métricas y coste por consulta] |
| `analista-negocios` | Analista Oficial de Negocios | producto-negocio | active | high | scoped | scope | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Criterios de aceptacion completos y trazables] |
| `aprobador-trabajo` | Preparador de Aprobacion | gerencia | active | high | scoped | scope | 1 | [read, write-docs, run-checks, report] | [work.assign:*, team.plan:*, task.delegate:*] | 7 | [0 aprobaciones emitidas por un agente; 100% de paquetes con evidencia y humano como A] |
| `arch-assessment` | Evaluador de Arquitectura | tecnologia | active | high | scoped | architecture | 1 | [read, write-docs, research-web, run-checks, report] | [architecture.review:*, issue.label:architecture] | 6 | [toda evaluacion separa as-is de to-be, incluye al menos dos opciones y explica riesgos y operacion] |
| `arch-copilot` | Copiloto de Arquitectura e Ingenieria | tecnologia | active | high | scoped | scope | 1 | [read, write-docs, research-web, run-checks, report] | [request.classify:*, architecture.review:*, *.*] | 5 | [100% de solicitudes enrutadas al especialista correcto; 0 acciones externas sin humano] |
| `architect` | Arquitecto de Software | tecnologia | active | high | scoped | architecture | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Contratos documentados y sin deuda arquitectural] |
| `auditor-riesgos` | Auditor de Riesgos Empresariales | producto-negocio | active | high | scoped | security | 1 | [read, write-docs, research-web, run-checks, report] | [decision.proposed, issue.label:auditor-riesgos, research.required:*] | 4 | [0 dictamenes sin fuente verificada, 100% de decisiones sensibles escaladas a humano] |
| `business-profiles-architect` | Arquitecto de Perfiles de Negocio | producto-negocio | active | high | scoped | scope | 1 | [read, write-docs, run-checks, report] | [research.required:*, knowledge.updated:*, schedule:weekly, issue.label:especialista] | 1 | [verticales sin condicionales y capacidades documentadas] |
| `capability-scout` | Explorador de Capacidades | conocimiento | active | high | scoped | scope | 1 | [read, write-docs, research-web, websearch, webfetch, run-checks, report] | [research.required:*, capability.gap:*, task.blocked:*] | 7 | [100% de propuestas con criterio de adopcion, coste, riesgo y fuente verificada] |
| `capacidades-negocio` | Especialista en Capacidades Tecnológicas, Financieras y de Mercadeo | conocimiento | active | high | propose | none | 1 | [read, write-docs, research-web, run-checks, report] | [issue.label:capacidades, research.required:*, knowledge.updated:*, schedule:weekly] | 8 | [recomendaciones con supuestos, baseline y verificación, 0 cifras sin fuente, conocimiento revalidado trimestralmente] |
| `compliance-secretos` | Especialista en Cumplimiento de Secretos | cumplimiento | active | high | scoped | compliance | 1 | [read, write-docs, run-checks, report] | [secret.requested:*, vault.audit:*, leak.suspected:*] | 7 | [100% de controles con fuente y fecha de corte; 0 afirmaciones de confiabilidad sin auditoria] |
| `computer-operator` | Operador de Escritorio (Computer Use) | operaciones | paused | medium | scoped | none | 1 | [read, write-docs, report, desktop-control] | [computer_use.authorized:*, issue.label:desktop] | 3 | [0 acciones sin captura previa, 100% de acciones confirmadas por recaptura, 0 secretos en pantalla] |
| `consensus-facilitator` | Facilitador de Consenso | gerencia | active | high | scoped | scope | 1 | [read, write-docs, research-web, run-checks, report] | [issue.proposed:*, pr.ready:*, consensus.required:*, retrospective:*] | 7 | [0 consensos sin memorial; 0 decisiones sensibles sin humano como A] |
| `crypto-architect` | Arquitecto Criptografico | tecnologia | active | high | scoped | security | 1 | [read, write-docs, run-checks, report] | [secret.requested:*, vault.audit:*, leak.suspected:*] | 7 | [0 algoritmos propios u obsoletos; 100% de parametros documentados y verificados] |
| `cumplimiento-panama` | Especialista en Cumplimiento y Normativa (Panamá + Estándares Internacionales) | cumplimiento | active | high | scoped | compliance | 1 | [read, write-docs, research-web, run-checks, report] | [issue.label:cumplimiento, research.required:*, knowledge.updated:*, schedule:weekly, regulatory.change:*] | 8 | [mapa normativo vigente con fuente oficial y fecha de corte, 0 afirmaciones legales sin cita, 100% de propuestas con control y dueño humano] |
| `data-expert` | Experto en Datos | tecnologia | active | medium | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Telemetria saneada y conforme a L-12] |
| `deep-researcher` | Investigador Profundo | conocimiento | active | high | scoped | scope | 1 | [read, write-docs, research-web, websearch, webfetch, run-checks, report] | [research.required:*, capability.gap:*, task.blocked:*] | 7 | [100% de investigaciones con minimo 2 fuentes (1 oficial), fecha de corte y escala de confianza] |
| `dev1-core` | Dev Core y Dominio | tecnologia | active | medium | scoped | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Pruebas de dominio en verde] |
| `dev2-api` | Dev API e Integraciones | tecnologia | active | medium | scoped | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Contratos publicados antes de codificar] |
| `dev3-ui` | Dev Frontend y Cliente | tecnologia | active | medium | scoped | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Flujos verificables con pruebas] |
| `dev4-data` | Dev Datos y Migraciones | tecnologia | active | medium | scoped | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Migraciones reversibles probadas] |
| `dev5-glue` | Dev Integracion y Glue | tecnologia | active | high | scoped | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Integraciones sin conflictos de propiedad] |
| `director-producto` | Director de Producto | gerencia | active | high | scoped | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Propuestas priorizadas con RICE y evidencia] |
| `dotnet-banking-integrator` | Integrador Bancario .NET | tecnologia | active | medium | scoped | none | 1 | [read, write-docs, run-checks, report] | [research.required:*, knowledge.updated:*, schedule:weekly, issue.label:especialista] | 1 | [contratos tipados y diagnóstico de incidentes] |
| `dx` | Experto en DX | tecnologia | active | high | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Tiempo de feedback medido] |
| `facilitador-equipo` | Facilitador de Equipo | gerencia | active | high | scoped | resource | 1 | [read, write-docs, run-checks, report] | [project.created, schedule:daily, knowledge.updated:*, handoff.pending:*] | 5 | [standups diarios sin tareas sin dueño, acuses pendientes < 1 por dia, proyectos avanzan sin saltarse puertas] |
| `finanzas-panamas` | Analista Financiero Panama | producto-negocio | active | medium | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Analisis reproducible con supuestos explicitos] |
| `finops` | FinOps y Release | tecnologia | active | medium | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Coste medido y K-7 cumplida] |
| `fiscal-integration-specialist` | Especialista en Integración Fiscal DGI/HKA | cumplimiento | active | high | scoped | compliance | 1 | [read, write-docs, research-web, run-checks, report] | [research.required:*, knowledge.updated:*, schedule:weekly, issue.label:especialista] | 2 | [documentos válidos ante DGI y sin secretos] |
| `flutter-m3-design-specialist` | Especialista en Diseño Flutter M3E | tecnologia | active | high | scoped | none | 1 | [read, write-docs, run-checks, report] | [research.required:*, knowledge.updated:*, schedule:weekly, issue.label:especialista] | 1 | [cero literales de diseño y pruebas WCAG AA] |
| `gcp-cloud-architect` | Arquitecto Cloud GCP | tecnologia | active | high | scoped | architecture | 1 | [read, write-docs, research-web, run-checks, report] | [research.required:*, knowledge.updated:*, schedule:weekly, issue.label:especialista] | 1 | [despliegues con IaC y presupuesto medido] |
| `gerente` | Gerente de Operaciones (COO) | gerencia | active | high | scoped | resource | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Decisiones administradas en plazo y sin escalados sin evidencia] |
| `human-approval-gate` | Puerta de Aprobacion Humana | gerencia | active | high | scoped | scope | 1 | [read, write-docs, run-checks, report] | [secret.requested:*, vault.audit:*, leak.suspected:*] | 7 | [0 aprobaciones emitidas por agente; 100% de grants con firma humana] |
| `identity-access-specialist` | Especialista en Identidad y Acceso | tecnologia | active | high | scoped | architecture | 1 | [read, write-docs, run-checks, report] | [research.required:*, knowledge.updated:*, schedule:weekly, issue.label:especialista] | 1 | [cero bypass de RLS y step-up en dinero] |
| `infra` | Experto en Infraestructura | tecnologia | active | medium | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Despliegues reversibles y sin secretos] |
| `innovation` | Analista de Innovacion | tecnologia | active | medium | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Propuestas con evidencia y coste] |
| `issue-reporter` | Generador de Issues | producto-negocio | active | high | scoped | scope | 1 | [read, write-docs, research-web, run-checks, report] | [issue.proposed:*, pr.ready:*, consensus.required:*, retrospective:*] | 7 | [0 issues sin pasos de reproduccion; 0 datos personales o secretos en el cuerpo] |
| `jira-planner` | Planificador de Trabajo | producto-negocio | active | high | scoped | scope | 1 | [read, write-docs, research-web, run-checks, report] | [work.plan:*, epic.proposed:*] | 6 | [0 tickets creados sin aprobacion; todo borrador tiene criterios de aceptacion verificables] |
| `knowledge-capture` | Capturador de Conocimiento | conocimiento | active | high | scoped | scope | 1 | [read, write-docs, research-web, report] | [knowledge.ingest:*, user.remember:*] | 6 | [0 hechos promovidos a canon sin validacion; raw y normalizado separados] |
| `knowledge-curator` | Curador de Conocimiento | conocimiento | active | high | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Digest actualizado sin secretos ni datos personales] |
| `leak-responder` | Respondedor de Fugas | operaciones | active | high | scoped | security | 1 | [read, write-docs, run-checks, report] | [secret.requested:*, vault.audit:*, leak.suspected:*] | 7 | [0 fugas sin rotacion humana; 100% de incidentes en outbox sin exponer el valor] |
| `legal-corporativo` | Asesor Legal Corporativo | producto-negocio | active | high | scoped | scope | 1 | [read, write-docs, research-web, run-checks, report] | [decision.proposed, issue.label:legal-corporativo, research.required:*] | 4 | [0 dictamenes sin fuente verificada, 100% de decisiones sensibles escaladas a humano] |
| `lowlevel` | Experto en Bajo Nivel | tecnologia | active | low | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Benchmarks con numeros reales] |
| `maintainer-proactivo` | Mantenedor Proactivo | operaciones | active | high | scoped | scope | 1 | [read, write-docs, research-web, run-checks, report] | [issue.proposed:*, pr.ready:*, consensus.required:*, retrospective:*] | 7 | [100% de propuestas con comando, salida real y fingerprint; 0 hallazgos silenciados] |
| `marketing` | Especialista en Marketing y Visualizacion | producto-negocio | active | high | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Insights con numeros reales y hipotesis verificable] |
| `monitor-gaceta` | Monitor de Gaceta Oficial y Normativa Panameña | cumplimiento | active | high | propose | none | 1 | [read, write-docs, research-web, report] | [schedule:daily, regulatory.change:*, research.required:*] | 5 | [cambios normativos detectados con URL oficial y fecha, 0 normas citadas sin Gaceta, expedientes de investigacion por cambio] |
| `orquestador-equipo` | Orquestador de Equipo | gerencia | active | high | scoped | scope | 1 | [read, write-docs, run-checks, report] | [work.assign:*, team.plan:*, task.delegate:*] | 7 | [100% de tareas con dueno, plan y correlation_id; 0 tareas sin ack ni cierre] |
| `planificador-trabajo` | Planificador de Trabajo | producto-negocio | active | high | scoped | scope | 1 | [read, write-docs, run-checks, report] | [work.assign:*, team.plan:*, task.delegate:*] | 7 | [100% de planes con pasos ordenados, criterio de salida y responsable por paso] |
| `platform-engineer` | Ingeniero de Plataforma y DevOps | tecnologia | active | high | scoped | none | 1 | [read, write-docs, run-checks, report] | [research.required:*, knowledge.updated:*, schedule:weekly, issue.label:especialista] | 1 | [despliegues reversibles y MTTR medido] |
| `poc-design` | Disenador de POC | tecnologia | active | high | scoped | security | 1 | [read, write-docs, research-web, run-checks, report] | [poc.request:*, experiment.proposed:*] | 6 | [toda POC define hipotesis, metrica, criterio de fallo y plan de rollback antes de ejecutarse] |
| `policy-engineer` | Ingeniero de Politicas | operaciones | active | high | scoped | security | 1 | [read, write-docs, run-checks, report] | [secret.requested:*, vault.audit:*, leak.suspected:*] | 7 | [0 accesos sin politica explicita; 100% de permisos revisables] |
| `pr-builder` | Constructor de PR | tecnologia | active | high | scoped | scope | 1 | [read, write-docs, research-web, run-checks, report] | [issue.proposed:*, pr.ready:*, consensus.required:*, retrospective:*] | 7 | [100% de PR con rama kaizen/*, descriptor y tests; 0 push directo a main] |
| `product` | Analista de Producto y Alcance | tecnologia | active | medium | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Criterios verificables antes de implementar] |
| `product-owner` | Product Owner | producto-negocio | active | high | scoped | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Backlog sin items ambiguos y cierre con evidencia] |
| `qa` | Equipo de QA | tecnologia | active | high | scoped | qa | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Toda correccion con prueba que falla primero] |
| `raci-dinamico` | Arbitro RACI Dinamico | gerencia | active | high | scoped | scope | 1 | [read, write-docs, run-checks, report] | [work.assign:*, team.plan:*, task.delegate:*] | 7 | [100% de asignaciones con R/A/C/I/V/H explicito y humano como A en sensibles] |
| `rea-specialist` | Especialista en Ingeniería Inversa y Depuración Profunda (REA) | tecnologia | active | high | scoped | none | 1 | [read, write-docs, research-web, run-checks, report, rea-mcp] | [research.required:*, issue.label:depuracion, reverse_engineering.authorized:*, knowledge.updated:*] | 4 | [hallazgos con evidencia reproducible, 0 análisis sin autorización escrita, 0 secretos en reportes] |
| `researcher` | Investigador de Tecnologia | conocimiento | active | medium | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Experimentos con numeros reales y decision registrada] |
| `retador-decisiones` | Retador Obligatorio | tecnologia | active | high | scoped | security | 1 | [read, write-docs, research-web, run-checks, report] | [issue.proposed:*, pr.ready:*, consensus.required:*, retrospective:*] | 7 | [100% de decisiones con al menos un contraejemplo documentado] |
| `reverse-api-specialist` | Especialista en Ingeniería Inversa de APIs Web | tecnologia | active | high | scoped | none | 1 | [read, write-docs, research-web, run-checks, report, rae-api-cli] | [issue.label:api-recon, api_reverse_engineering.authorized:*, research.required:*, knowledge.updated:*] | 5 | [0 capturas sin autorización, 100% de clientes generados con run_id y HAR, 0 secretos en HAR versionado] |
| `runbooks` | Responsable de Runbooks | operaciones | active | medium | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Runbooks probados y al dia] |
| `rust-systems-specialist` | Especialista en Rust y Sistemas | tecnologia | active | medium | propose | none | 1 | [read, write-docs, run-checks, report] | [research.required:*, knowledge.updated:*, schedule:weekly, issue.label:especialista] | 1 | [benchmarks reproducibles y cero regresiones] |
| `secret-injector` | Inyector Seguro de Secretos | tecnologia | active | high | scoped | security | 1 | [read, write-docs, run-checks, report] | [secret.requested:*, vault.audit:*, leak.suspected:*] | 7 | [0 secretos en variables de entorno por defecto; RLIMIT_CORE=0 en cada entrega] |
| `secret-lifecycle` | Gestor de Ciclo de Vida | operaciones | active | high | scoped | scope | 1 | [read, write-docs, run-checks, report] | [secret.requested:*, vault.audit:*, leak.suspected:*] | 7 | [0 secretos sin dueno ni expiracion; 100% de rotaciones con evidencia humana] |
| `secure-review` | Revisor Seguro de Codigo | tecnologia | active | high | scoped | security | 1 | [read, run-checks, report] | [pull_request.opened, diff.review:*] | 6 | [todo hallazgo cita archivo:linea y salida real; separa defecto confirmado de sugerencia] |
| `security` | Seguridad y Auditoria | tecnologia | active | high | propose | security | 1 | [read, audit, report] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [0 secretos y 0 supresiones sin issue] |
| `self-improvement` | Agente de Automejora | conocimiento | active | high | scoped | scope | 1 | [read, write-docs, research-web, run-checks, report] | [issue.proposed:*, pr.ready:*, consensus.required:*, retrospective:*] | 7 | [100% de lecciones promovidas con evidencia; 0 regresiones de calidad sin ADR] |
| `soporte` | Especialista de Soporte y Respuesta | operaciones | active | high | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Reproducciones documentadas y respuesta medida] |
| `supervisor-ejecucion` | Supervisor de Ejecucion | operaciones | active | high | scoped | security | 1 | [read, write-docs, run-checks, report] | [work.assign:*, team.plan:*, task.delegate:*] | 7 | [0 tareas sin supervision; 100% de desviaciones reportadas en outbox S-11] |
| `systems` | Ingeniero de Sistemas | tecnologia | active | medium | propose | none | 1 | [read, write-docs, run-checks] | [issue.label:swarm:ready, knowledge.updated:*, schedule:weekly] | 5 | [Diseno con bajo acoplamiento] |
| `task-unblocker` | Desbloqueador de Tareas | operaciones | active | high | scoped | security | 1 | [read, write-docs, research-web, websearch, webfetch, run-checks, report] | [research.required:*, capability.gap:*, task.blocked:*] | 7 | [0 tareas colgadas sin diagnostico; 100% de correcciones con evidencia y camino de rollback] |
| `tech-evaluation` | Evaluador Tecnologico | tecnologia | active | high | scoped | scope | 1 | [read, write-docs, research-web, run-checks, report] | [technology.evaluate:*, research.required:*] | 6 | [toda comparacion usa fuentes primarias con fecha de corte y matriz adopt/pilot/defer/reject] |
| `vault-custodian` | Custodio de Boveda | operaciones | active | high | scoped | security | 1 | [read, write-docs, run-checks, report] | [secret.requested:*, vault.audit:*, leak.suspected:*] | 7 | [0 valores impresos; 100% de cambios de boveda con huella en auditoria] |
| `vault-qa` | QA de Custodia | tecnologia | active | high | scoped | scope | 1 | [read, write-docs, run-checks, report] | [secret.requested:*, vault.audit:*, leak.suspected:*] | 7 | [100% de pruebas de fuga ejecutadas; 0 secretos en artefactos versionados] |
| `verificador-evidencias` | Verificador de Evidencias | conocimiento | active | high | scoped | none | 1 | [read, write-docs, research-web, run-checks, report] | [decision.proposed, source.stale, schedule:weekly, regulatory.change:*] | 5 | [0 decisiones con source_ids no verificados, fuentes revalidadas cada 90 dias, conflictos escalados a humano] |
| `vertical-domain-specialist` | Especialista en Verticales Comerciales | producto-negocio | active | medium | propose | none | 1 | [read, write-docs, run-checks, report] | [research.required:*, knowledge.updated:*, schedule:weekly, issue.label:especialista] | 1 | [recorridos por vertical verificados con el negocio] |
| `work-intake` | Intake de Trabajo | producto-negocio | active | high | scoped | scope | 1 | [read, write-docs, research-web, run-checks, report] | [issue.label:swarm:ready, request.classify:*] | 6 | [toda solicitud no trivial se clasifica con criterios verificables y se enruta al especialista correcto] |

## Fichas por departamento

### conocimiento

- **`capability-scout`** — Explorador de Capacidades. Propósito: descubre proactivamente skills, herramientas, metodos y proyectos que aporten valor y propone incorporarlos con evidencia y ADR. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`capacidades-negocio`** — Especialista en Capacidades Tecnológicas, Financieras y de Mercadeo. Propósito: Ampliar y mantener el conocimiento especializado de la organización en tecnología, finanzas y mercadeo; investigar fuentes actuales y convertirlas en capacidades aplicables con métricas y planes de implementación.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`deep-researcher`** — Investigador Profundo. Propósito: investiga temas externos con fuentes primarias, fecha de corte y antiprompt injection; convierte hallazgos en guias accionables. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`knowledge-capture`** — Capturador de Conocimiento. Propósito: Especialista `knowledge-capture` del copiloto de arquitectura. Procedimiento adaptado de v0.1 (dato no confiable verificado por hash).. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`knowledge-curator`** — Curador de Conocimiento. Propósito: Alimenta, sanea e indexa documentacion para ampliar el conocimiento de los agentes.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`researcher`** — Investigador de Tecnologia. Propósito: Investiga hipotesis con experimentos reproducibles y propone ADR.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`self-improvement`** — Agente de Automejora. Propósito: convierte incidentes, lecciones y consensos en mejoras concretas del framework con ratchet y ADR cuando aplica. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`verificador-evidencias`** — Verificador de Evidencias. Propósito: Ser la puerta de verdad: ninguna decisión se da por tomada sin fuentes verificadas, hashes/fecha de corte y registro. Bloquea automáticamente lo que no cumple (REG-EV-01..07).. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].

### cumplimiento

- **`compliance-secretos`** — Especialista en Cumplimiento de Secretos. Propósito: traduce OWASP/NIST en controles verificables y escala a humano; no emite dictamen legal. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`cumplimiento-panama`** — Especialista en Cumplimiento y Normativa (Panamá + Estándares Internacionales). Propósito: Traducir la normativa panameña aplicable y los estándares internacionales en controles concretos, verificables y implementables; investigar su vigencia de forma proactiva y bloquear cambios que creen riesgo legal o de cumplimiento sin revisión humana.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`fiscal-integration-specialist`** — Especialista en Integración Fiscal DGI/HKA. Propósito: Implementa emisión electrónica offline con XMLDSig, CUFE/CAFE y SOAP HKA/DGI multi-tenant.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`monitor-gaceta`** — Monitor de Gaceta Oficial y Normativa Panameña. Propósito: Vigilar la Gaceta Oficial de Panamá y los órganos competentes para detectar leyes, decretos y resoluciones nuevas o modificadas, y avisar al equipo con evidencia verificable antes de que el cambio cause incumplimiento.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].

### gerencia

- **`aprobador-trabajo`** — Preparador de Aprobacion. Propósito: prepara el paquete de aprobacion con evidencia y decision requerida; NUNCA aprueba por el humano. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`consensus-facilitator`** — Facilitador de Consenso. Propósito: modera discusion en dos turnos, busca mayoria sin veto, levanta memorial y escala a humano en sensible. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`director-producto`** — Director de Producto. Propósito: Prioriza valor y alinea negocio con tecnologia junto al analista de negocios.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`facilitador-equipo`** — Facilitador de Equipo. Propósito: Hacer que la comunidad funcione como un equipo: convoca, asigna, vigila acuses y leases, ordena turnos y escala cuando hace falta. No resuelve el fondo de los temas; resuelve la coordinación.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`gerente`** — Gerente de Operaciones (COO). Propósito: Administra la organizacion de agentes, asigna trabajo, marca plazos y escala a humanos.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`human-approval-gate`** — Puerta de Aprobacion Humana. Propósito: prepara la decision para el humano fuera de banda y jamas aprueba en su lugar. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`orquestador-equipo`** — Orquestador de Equipo. Propósito: coordina y reparte el trabajo de forma dinamica, recursiva y auditable; decide quien ejecuta y reporta a El Presidente. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`raci-dinamico`** — Arbitro RACI Dinamico. Propósito: define rangos, jerarquia y RACI segun proyecto y tarea: quien manda, quien subordina, quienBlock y quien aprueba. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].

### operaciones

- **`access-auditor`** — Auditor de Accesos. Propósito: verifica hash-chain, HMAC, anti-rollback y purpose enumerado en la auditoria inmutable. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`computer-operator`** — Operador de Escritorio (Computer Use). Propósito: Operar la computadora del usuario —ver pantalla, mover ratón, escribir— cuando la configuración disponible no alcanza y el humano lo autoriza, verificando cada paso visualmente.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`leak-responder`** — Respondedor de Fugas. Propósito: ejecuta el runbook S-12: secreto en chat es comprometido, rotacion la firma un humano. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`maintainer-proactivo`** — Mantenedor Proactivo. Propósito: detecta deuda, bugs y oportunidades en el repositorio con evidencia y las propone como trabajo verificable. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`policy-engineer`** — Ingeniero de Politicas. Propósito: define deny-by-default, allowlist por agente, scopes granulares y TTL corto con reaprobacion. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`runbooks`** — Responsable de Runbooks. Propósito: Mantiene runbooks ejecutables y reversibles con rollback verificado.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`secret-lifecycle`** — Gestor de Ciclo de Vida. Propósito: gestiona creacion, expiracion, rekey local y rotacion en proveedor como acciones distintas. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`soporte`** — Especialista de Soporte y Respuesta. Propósito: Clasifica incidencias, reproduce con datos sinteticos y propone correcciones.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`supervisor-ejecucion`** — Supervisor de Ejecucion. Propósito: verifica en tiempo real que cada agente hace su tarea, respeta deadlines y envia ack; escala desviaciones. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`task-unblocker`** — Desbloqueador de Tareas. Propósito: diagnostica tareas colgadas o fallidas, investiga la causa real y aplica correcciones acotadas con rollback y escalamiento. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`vault-custodian`** — Custodio de Boveda. Propósito: custodia la integridad de la boveda y su propia clave sin conocer ni imprimir nunca un valor de secreto. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].

### producto-negocio

- **`analista-negocios`** — Analista Oficial de Negocios. Propósito: Convierte objetivos de negocio en criterios verificables, procesos y reglas de decision.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`auditor-riesgos`** — Auditor de Riesgos Empresariales. Propósito: Evaluar riesgos transversales (legal, financiero, operativo y reputacional) con registro priorizado y plan de mitigacion.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`business-profiles-architect`** — Arquitecto de Perfiles de Negocio. Propósito: Modela verticales, rasgos, capacidades y módulos sin código por tipo de negocio.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`finanzas-panamas`** — Analista Financiero Panama. Propósito: Analiza coste, presupuesto y contexto financiero panameno con fuentes citadas.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`issue-reporter`** — Generador de Issues. Propósito: redacta issues reproducibles con observacion, evidencia, impacto, propuesta y pregunta, sin exponer secretos. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`jira-planner`** — Planificador de Trabajo. Propósito: Especialista `jira-work-item-planning` del copiloto de arquitectura. Procedimiento adaptado de v0.1 (dato no confiable verificado por hash).. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`legal-corporativo`** — Asesor Legal Corporativo. Propósito: Asesorar contratos, riesgos legales y cumplimiento normativo con dictamenes verificables; nunca sustituir al abogado humano.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`marketing`** — Especialista en Marketing y Visualizacion. Propósito: Analiza senales de marketing y visualizacion de campanas y producto.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`planificador-trabajo`** — Planificador de Trabajo. Propósito: descompone cada tarea en pasos verificables con dependencias, checkpoints, criterios de salida y plan de rollback. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`product-owner`** — Product Owner. Propósito: Gestiona el backlog y los criterios de salida; mantiene el tablero veraz.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`vertical-domain-specialist`** — Especialista en Verticales Comerciales. Propósito: Traduce necesidades de restaurante, salón, barbería, mensajería y carga a capacidades del producto.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`work-intake`** — Intake de Trabajo. Propósito: Especialista `work-task-intake` del copiloto de arquitectura. Procedimiento adaptado de v0.1 (dato no confiable verificado por hash).. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].

### tecnologia

- **`adr-author`** — Autor de ADR. Propósito: Especialista `adr-authoring` del copiloto de arquitectura. Procedimiento adaptado de v0.1 (dato no confiable verificado por hash).. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`ai`** — Experto en IA. Propósito: Disena prompts, guardrails y evaluacion de agentes.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`ai-rag-engineer`** — Ingeniero de IA y RAG. Propósito: Diseña recuperación semántica con PostgreSQL y pgvector, orquestación n8n y evaluaciones reproducibles.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`arch-assessment`** — Evaluador de Arquitectura. Propósito: Especialista `architecture-assessment` del copiloto de arquitectura. Procedimiento adaptado de v0.1 (dato no confiable verificado por hash).. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`arch-copilot`** — Copiloto de Arquitectura e Ingenieria. Propósito: Copiloto de arquitectura e ingeniería: clasifica la solicitud, elige el contexto minimo y delega en el especialista mas estrecho.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`architect`** — Arquitecto de Software. Propósito: Define limites, contratos y ADR; arbitra disputas tecnicas.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`crypto-architect`** — Arquitecto Criptografico. Propósito: fija y revisa parametros cripto: AES-256-GCM, nonce 96-bit, AAD vinculante, Argon2id versionado. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`data-expert`** — Experto en Datos. Propósito: Define schemas, calidad de datos y privacidad.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`dev1-core`** — Dev Core y Dominio. Propósito: Implementa invariantes y modelos de negocio.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`dev2-api`** — Dev API e Integraciones. Propósito: Expone contratos, eventos y conectores.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`dev3-ui`** — Dev Frontend y Cliente. Propósito: Construye vistas, estados y accesibilidad.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`dev4-data`** — Dev Datos y Migraciones. Propósito: Disena esquemas y migraciones reversibles.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`dev5-glue`** — Dev Integracion y Glue. Propósito: Conecta piezas y mantiene diffs acotados.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`dotnet-banking-integrator`** — Integrador Bancario .NET. Propósito: Integra C#/.NET, SQL Server, ORDS y APIs XML/REST en entorno bancario con continuidad operativa.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`dx`** — Experto en DX. Propósito: Mejora CLI, feedback y ergonomia de desarrollo.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`finops`** — FinOps y Release. Propósito: Controla coste, despliegue/rollback y documentacion.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`flutter-m3-design-specialist`** — Especialista en Diseño Flutter M3E. Propósito: Aplica gravital-experience-ui con tokens, accesibilidad y offline-first; rechaza colores y radios literales.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`gcp-cloud-architect`** — Arquitecto Cloud GCP. Propósito: Diseña y revisa despliegues en Google Cloud con criterios de seguridad, coste y continuidad.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`identity-access-specialist`** — Especialista en Identidad y Acceso. Propósito: Resuelve el permiso efectivo como intersección de módulos habilitados, rol y alcance por sucursal.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`infra`** — Experto en Infraestructura. Propósito: Revisa contenedores, CI/CD y reversibilidad.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`innovation`** — Analista de Innovacion. Propósito: Evalua opciones emergentes sin dependencias riesgosas.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`lowlevel`** — Experto en Bajo Nivel. Propósito: Optimiza memoria, latencia y syscalls.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`platform-engineer`** — Ingeniero de Plataforma y DevOps. Propósito: Mantiene CI/CD, contenedores, Linux y observabilidad Dynatrace; ejecuta migraciones controladas.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`poc-design`** — Disenador de POC. Propósito: Especialista `poc-design` del copiloto de arquitectura. Procedimiento adaptado de v0.1 (dato no confiable verificado por hash).. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`pr-builder`** — Constructor de PR. Propósito: prepara cambios pequenos en ramas kaizen/* con descriptor, diff acotado y evidencia; nunca push a main. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`product`** — Analista de Producto y Alcance. Propósito: Valida criterios y alcance minimo del issue.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`qa`** — Equipo de QA. Propósito: Escribe pruebas de reproduccion, regresion e integracion.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`rea-specialist`** — Especialista en Ingeniería Inversa y Depuración Profunda (REA). Propósito: Profundizar en el análisis de sistemas —binarios, Electron/.NET, Android, firmware, tráfico y comportamiento en runtime— usando REA cuando el humano lo autoriza, para convertir hallazgos difíciles en evidencia verificable y cambios seguros.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`retador-decisiones`** — Retador Obligatorio. Propósito: cuestiona toda propuesta con contraejemplos y riesgos; su objecion con evidencia bloquea el consenso. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`reverse-api-specialist`** — Especialista en Ingeniería Inversa de APIs Web. Propósito: Convertir sitios web autorizados en clientes de API tipados con `reverse-api-engineer`, entregando código revisado, evidencia de la captura (HAR + `run_id`) y成本控制 bajo supervisión humana.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`rust-systems-specialist`** — Especialista en Rust y Sistemas. Propósito: Trabaja en runtime WebAssembly, WASI, no_std, C FFI y audio de baja latencia con benchmarks.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`secret-injector`** — Inyector Seguro de Secretos. Propósito: entrega secretos por FD 3 o IPC autenticado al comando aprobado, nunca por entorno ni chat. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`secure-review`** — Revisor Seguro de Codigo. Propósito: Especialista `secure-code-review` del copiloto de arquitectura. Procedimiento adaptado de v0.1 (dato no confiable verificado por hash).. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`security`** — Seguridad y Auditoria. Propósito: Audita secretos, supresiones y privilegios; bloquea riesgos.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`systems`** — Ingeniero de Sistemas. Propósito: Resuelve concurrencia, resiliencia y flujos transversales.. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`tech-evaluation`** — Evaluador Tecnologico. Propósito: Especialista `technology-evaluation` del copiloto de arquitectura. Procedimiento adaptado de v0.1 (dato no confiable verificado por hash).. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].
- **`vault-qa`** — QA de Custodia. Propósito: prueba que ningun secreto aparece en stdout, logs, diffs ni contexto del modelo. Reglas: [K-1..K-15, L-1..L-17, S-1..S-16].

## Reglas del catálogo

1. El catálogo se **genera**, nunca se edita a mano.
2. `id` único; campos obligatorios validados por `kaizen-org check`.
3. Copiar un agente (`kaizen-org copy`) crea una ficha nueva; el original no se modifica.
4. Cambiar autonomía o veto requiere ADR humano, no edición del catálogo.
5. `enable|disable` y `save` se reflejan aquí tras `catalog`.
