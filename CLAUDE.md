# CLAUDE.md

Project context for Claude Code when working in this repository.

## Project

Accreditation system for Papua New Guinea health facilities, based on the
National Health Service Standards (NHSS) Volume 2. Currently focused on
Infection Prevention and Control (IPC, Standard No. 16), reorganized around
WHO's eight Core Components for IPC Programmes.

Full-stack app: ASP.NET Core + EF Core + PostgreSQL backend, React + Vite
frontend.

## Repo layout

- `/backend` — ASP.NET Core Web API
- `/frontend` — React (plain JavaScript, not TypeScript) + Vite + Tailwind v4

## Backend conventions

- **Domain hierarchy:** Function/Component -> Standard -> Criterion ->
  Compliance -> Evidence (Framework domain). Assessment domain layers survey
  scoring on top: Survey -> ComplianceAssessment (one per Compliance) ->
  ComplianceEvidenceCheck (one per Evidence).
- **DTOs:** one class per file, e.g. `CriterionDto.cs`,
  `CriterionCreateDto.cs`, `CriterionUpdateDto.cs`. Separate Create/Update/Get
  DTOs per entity. Use the `required` keyword rather than `[Required]`
  attributes, to match the models.
- **Applicability cascades top-down only** (Criterion -> Compliance ->
  Evidence), implemented via dedicated PATCH endpoints (e.g.
  `PATCH api/criteria/{id}/applicability`), not folded into general PUT
  updates. `isApplicable` defaults to `true` server-side.
- **Numbering fields** (e.g. `criterionNumber`) use `string` type. Uniqueness
  is scoped to the parent via composite unique indexes (Criterion unique per
  Standard, Compliance unique per Criterion, Evidence unique per Compliance)
  — not globally unique, except `standardNumber` which is intentionally
  global.
- **Auth:** JWT (`Microsoft.AspNetCore.Authentication.JwtBearer`),
  `PasswordHasher<UserAccount>`. Standard access policy across domains:
  Admin-only for create/edit/delete of reference data, any authenticated
  user can read. Assessment scoring (PUT) is `[Authorize]` for any
  authenticated surveyor, not Admin-only.
- **Migrations:** one migration per model change, applied immediately (not
  batched).
- Common bugs to watch for: missing `.Include()` reload before building a
  response DTO after `Add`/`SaveChanges` (causes null nav properties),
  `CreatedAtAction` referencing action names via magic strings instead of
  `nameof()`, typos in `[ForeignKey]` attributes.

## Frontend conventions

- Plain JavaScript (no TypeScript), Vite, Tailwind v4 via
  `@tailwindcss/vite`, React Router, Axios.
- API layer is a single generic `src/api/api.js`
  (getAll/getOne/create/update/remove/patchApplicability) parameterized by
  resource string — not one file per entity.
- No formal models folder; plain JS object shapes plus optional JSDoc
  typedefs.
- Pages in `src/pages/<domain>/`, forms in `src/components/forms/`, shared
  `ConfirmDialog.jsx` / `FormModal.jsx` in `src/components/`.
- Pattern for entity CRUD: entity Form component -> flat list Page ->
  detail/drill-down page for the parent entity (master-detail navigation,
  since flat tables don't scale for high-cardinality children).
- Add-form UX: after creating (not editing) an item, keep the modal open and
  reset it to blank rather than closing, so multiple entries can be added in
  a row.
- Auth: JWT stored in-memory only via React Context (`AuthContext`) —
  deliberately not persisted to localStorage. 401 responses trigger logout +
  redirect to `/login` via an axios interceptor.
- Design direction: teal/ochre clinical palette, sidebar nav with
  clause-number markers (1 / 1.1 / 1.1.1) reflecting the hierarchy.

## Dev environment

- Backend: `http://localhost:5157` (API base `http://localhost:5157/api`)
- Frontend dev server: `http://localhost:5173`
- Database: PostgreSQL in a Docker Desktop container

## Terminology

PNG health system terms that come up often: Health Service Organisations,
PHAs (Provincial Health Authorities), NRSTTH.
