# Role-access matrix

This matrix describes the current access model. The API enforces it through
named authorization policies; frontend visibility is a convenience, not a
security boundary.

| Capability / policy | Admin | Team Lead | Surveyor | User | Viewer |
| --- | --- | --- | --- | --- | --- |
| `ReferenceData.Read` | Yes | Yes* | Yes* | Yes | Yes |
| `ReferenceData.Manage` | Yes | No | No | No | No |
| `Survey.Work` | Yes | Yes | Yes | No | No |
| `Survey.ReviewTeam` | Yes | Yes | No | No | No |
| `Survey.Administer` | Yes | No | No | No | No |
| `Reports.Generate` | Yes | Yes | No** | No | No |
| `Accounts.Manage` | Yes | No | No | No | No |

\* Surveyors and Team Leads may read supporting reference records through the
API while undertaking survey work. The full Framework, Location, and Facility
directories are intentionally not shown in their navigation.

\** A Surveyor can create, submit, view, and print their own surveyor handover
report. Formal consolidated report generation is restricted to the Team Lead
or an Administrator.

## Scope rules

- A Surveyor can score only compliance requirements assigned to them.
- A Team Lead can review only surveys for which they are the assigned team lead.
- An Administrator can administer all surveys and accounts.
- `User` and `Viewer` are read-only roles. `Viewer` is intended for oversight;
  `User` is intended for general operational reference access.

## Adding a role

When adding Preceptor or Secretariat, update all three places in the same
change: `backend/Program.cs`, `frontend/src/utils/access.js`, and this matrix.
Review controller scope checks as well—policies grant a capability, while the
controller still restricts records to the relevant survey or person.
