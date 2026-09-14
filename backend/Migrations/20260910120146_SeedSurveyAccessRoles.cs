using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class SeedSurveyAccessRoles : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("""
                INSERT INTO roles ("roleName", description)
                SELECT 'Team Lead', 'Leads assigned survey teams and can view the complete assigned survey.'
                WHERE NOT EXISTS (SELECT 1 FROM roles WHERE "roleName" = 'Team Lead');
                INSERT INTO roles ("roleName", description)
                SELECT 'Viewer', 'Read-only access to reference information and dashboard summaries.'
                WHERE NOT EXISTS (SELECT 1 FROM roles WHERE "roleName" = 'Viewer');
                """);

        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("DELETE FROM roles AS role_record WHERE role_record.\"roleName\" IN ('Team Lead', 'Viewer') AND NOT EXISTS (SELECT 1 FROM \"userAccounts\" AS account WHERE account.\"roleId\" = role_record.\"roleId\");");

        }
    }
}
