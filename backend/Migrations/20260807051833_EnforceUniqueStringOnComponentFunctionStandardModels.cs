using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class EnforceUniqueStringOnComponentFunctionStandardModels : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_standards_standardNumber",
                table: "standards",
                column: "standardNumber",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_functions_functionNumber",
                table: "functions",
                column: "functionNumber",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_components_componentNumber",
                table: "components",
                column: "componentNumber",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_standards_standardNumber",
                table: "standards");

            migrationBuilder.DropIndex(
                name: "IX_functions_functionNumber",
                table: "functions");

            migrationBuilder.DropIndex(
                name: "IX_components_componentNumber",
                table: "components");
        }
    }
}
