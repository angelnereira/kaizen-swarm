---
id: FIND-BPA-001
correlation_id: BPA-CAP-2026
from: business-profiles-architect
to: product-owner
channel: direct
intent: finding
status: open
expects_ack: true
deadline: 2026-11-23T18:00:00Z
created: 2026-11-22T06:12:21Z
source_ids: [LOCAL-001, LOCAL-003, LOCAL-004, PA-001]
---

# Finding: Propuesta de capacidades V1 — Arquitecto de Perfiles de Negocio

## 1. Investigación: ¿aplica la contribución proactiva?

- Disparadores de mi definición (`.kaizen/org/prompts/business-profiles-architect.md`): `research.required:*`, `knowledge.updated:*`, `schedule:weekly`, `issue.label:especialista`.
- Verificado: `.kaizen/swarm/issues/` vacío; `.kaizen/team/projects/` vacío; no hay proactive en el inbox para business-profiles-architect.
- Inbox proactivo de hoy (06:08): `ai`, `ai-rag-engineer`, `analista-negocios` con evidencia vacía ("sin evidencia no hay decisión", K-10). Contribución ejecutada bajo instrucción directa del presidente (autonomía scoped).
- Delegación a los especialistas listados (identity-access, vertical-domain, flutter-m3, ai-rag): excluida — profundidad máxima KR_MAX_DEPTH=3 ya alcanzada (KAZEN_AGENT_DEPTH=3); evidencia consolidada desde contratos verificados de los especialistas.

## 2. Propuesta: matriz de capacidades V1 (métrica antes → después)

Formato de recomendación: `.kaizen/org/knowledge/business/CAPACIDADES.md` §4.

| Pilar | Especialista (contrato verificado) | Fuente base verificada | Métrica antes → después |
| --- | --- | --- | --- |
| Vertical Domain | vertical-domain-specialist (autonomía: propose) | LOCAL-004 | verticales sin condicionales: 13 → 13 con traits base documentados (0 → 13) |
| Flutter M3E | flutter-m3-design-specialist (autonomía: scoped) | LOCAL-003 (ADR-0010) | literales de diseño: 0 → 0; ADR-0010 verificado (tokens.json → tokens.g.dart + tokens.css) |
| Identity & Access | identity-access-specialist (veto: architecture) | LOCAL-004, PA-001 | hallazgos bypass RLS: 0 → 0; step-up en dinero sin bypass |
| IA/RAG | ai-rag-engineer (autonomía: scoped) | LOCAL-001, LOCAL-004 | evals versionados: 0 → 1 set (métrica + coste por consulta) |

## 3. Pilar 1 — Vertical Domain

- Verificado: 13 verticales del perfil PlentyPay — retail, grocery, apparel, wholesale, online seller, restaurant, quick service, beauty salon, barbershop, courier, freight, professional services, other (CAPACIDADES-REFERENCIA.md §2, LOCAL-004). El código consulta capacidades, nunca el nombre de la vertical.
- Propuesta V1: traits base sin condicionales para cada vertical: `trait=[tipo de compra/recurrencia]`, `capability=[módulo del producto]`, `deny-by-default` (sin módulos habilitados → sin capacidades). Forma de verificación: checklist de traits por vertical en CAPACIDADES.md.
- Fuentes: LOCAL-004.
- Métrica: verticales con traits base: 0 → 13; capacidades propuestas: 0 → 13.

## 4. Pilar 2 — Flutter M3E (diseño)

- Verificado: ADR-0010 — `tokens.json` → `tokens.g.dart` y `tokens.css` (una sola fuente de verdad); Material 3 Expressive; `material_ui ≥1.6`; Flutter ≥3.47 / Dart 3.13; tipografía Google Sans Flex (SIL OFL 1.1); cifras tabulares; `intl` con `es_PA`.
- Propuesta V1: matriz de diseño V1: escala de 10 radios; jerarquía tonal sin sombra por defecto; resorte Standard para operación repetitiva y Expressive para momentos únicos; WCAG 2.2 AA (objetivos 48dp / 56dp en POS, texto al 200%, contraste 4.5:1/3:1, movimiento reducido); componentes de dominio: MoneyText, AmountInput, NumPad, ReceiptView, StatusChip, MapSheetScaffaffold, EmptyState, ErrorState, OfflineBanner; offline-first con cola de acciones y OfflineBanner; regla de importación (solo el paquete compartido).
- Fuentes: LOCAL-003.
- Métrica: literales de diseño en apps: 0 → 0.

## 5. Pilar 3 — Identity & Access (modelos de acceso)

- Verificado: modelo semántico — permiso efectivo = intersección(módulos habilitados del negocio ∩ permisos del rol ∩ alcance por sucursal); entradas: tenant_id, business_profile, vertical, trait, capability, plan, role, membership, scope, branch_id, job_title, permiso efectivo, SoD (CAPACIDADES-REFERENCIA.md §3, LOCAL-004).
- Propuesta V1: contrato de capacidad: deny-by-default; step-up para acciones de dinero; RLS sin bypass (KPI del especialista: cero bypass de RLS y step-up en dinero).
- Fuentes: LOCAL-004, PA-001 (Ley 81/2019, Gaceta Oficial 28743-A).
- Métrica: hallazgos de bypass RLS en implementación: 0 → 0.

## 6. Pilar 4 — IA/RAG

- Verificado: plataforma interna de conocimiento — PostgreSQL + pgvector (recuperación semántica), orquestación n8n, vaults por área con permisos, interfaz conversacional (CAPACIDADES-REFERENCIA.md §1, LOCAL-004; LOCAL-001: CV Arquitecto IA Generativo).
- Propuesta V1: pipeline RAG versionado con evals reproducibles; KPI: evaluaciones con métricas y coste por consulta.
- Fuentes: LOCAL-001, LOCAL-004.
- Métrica: evals versionados: 0 → 1 set.

## 7. KPI total del arquitecto

- Antes (verificado): `pilares_V1 = 0/4`; capacidades documentadas en el perfil PlentyPay = 0; evals RAG = 0; afirmaciones sobre verticales sin source_id: n/a (dato interno, LOCAL-004).
- Después (propuesta): `pilares_V1 = 4/4`; capacidades documentadas = 13 traits base verticales + 4 pilares; evals RAG = 1 set.

## 8. Decisión requerida / Siguiente paso

1. Aprobación de la propuesta V1 por El Presidente (decisión con source_ids verificados; REG-EV-01).
2. Escritura en el perfil PlentyPay (LOCAL-004): traits, capacidades y matriz vertical-módulo.
3. Registro de decisión verificada (`verificador-evidencias` + `kaizen-team verify` en verde).

No se hizo push ni se abrió PR (correcto; lo hace el orquestador).
