using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class AddStructuredStandardSummation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "areasOfConcern",
                table: "surveyorStandardSummaries",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "recommendations",
                table: "surveyorStandardSummaries",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "serviceAreasJson",
                table: "surveyorStandardSummaries",
                type: "text",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "areasOfConcern",
                table: "surveyorStandardSummaries");

            migrationBuilder.DropColumn(
                name: "recommendations",
                table: "surveyorStandardSummaries");

            migrationBuilder.DropColumn(
                name: "serviceAreasJson",
                table: "surveyorStandardSummaries");
        }
    }
}
