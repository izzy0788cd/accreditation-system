using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class MakeComplianceCriterionNumberUnique : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_criteria_criterionNumber",
                table: "criteria");

            migrationBuilder.DropIndex(
                name: "IX_criteria_standardId",
                table: "criteria");

            migrationBuilder.DropIndex(
                name: "IX_compliances_complianceNumber",
                table: "compliances");

            migrationBuilder.DropIndex(
                name: "IX_compliances_criterionId",
                table: "compliances");

            migrationBuilder.CreateIndex(
                name: "IX_criteria_standardId_criterionNumber",
                table: "criteria",
                columns: new[] { "standardId", "criterionNumber" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_compliances_criterionId_complianceNumber",
                table: "compliances",
                columns: new[] { "criterionId", "complianceNumber" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_criteria_standardId_criterionNumber",
                table: "criteria");

            migrationBuilder.DropIndex(
                name: "IX_compliances_criterionId_complianceNumber",
                table: "compliances");

            migrationBuilder.CreateIndex(
                name: "IX_criteria_criterionNumber",
                table: "criteria",
                column: "criterionNumber",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_criteria_standardId",
                table: "criteria",
                column: "standardId");

            migrationBuilder.CreateIndex(
                name: "IX_compliances_complianceNumber",
                table: "compliances",
                column: "complianceNumber",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_compliances_criterionId",
                table: "compliances",
                column: "criterionId");
        }
    }
}
