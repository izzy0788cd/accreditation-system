using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class AddSurveyStandardAssignments : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "surveyStandardAssignments",
                columns: table => new
                {
                    surveyStandardAssignmentId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    surveyId = table.Column<int>(type: "integer", nullable: false),
                    standardId = table.Column<int>(type: "integer", nullable: false),
                    surveyorId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveyStandardAssignments", x => x.surveyStandardAssignmentId);
                    table.ForeignKey(
                        name: "FK_surveyStandardAssignments_standards_standardId",
                        column: x => x.standardId,
                        principalTable: "standards",
                        principalColumn: "standardId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveyStandardAssignments_surveyors_surveyorId",
                        column: x => x.surveyorId,
                        principalTable: "surveyors",
                        principalColumn: "surveyorId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveyStandardAssignments_surveys_surveyId",
                        column: x => x.surveyId,
                        principalTable: "surveys",
                        principalColumn: "surveyId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_surveyStandardAssignments_standardId",
                table: "surveyStandardAssignments",
                column: "standardId");

            migrationBuilder.CreateIndex(
                name: "IX_surveyStandardAssignments_surveyId_standardId",
                table: "surveyStandardAssignments",
                columns: new[] { "surveyId", "standardId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_surveyStandardAssignments_surveyorId",
                table: "surveyStandardAssignments",
                column: "surveyorId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "surveyStandardAssignments");
        }
    }
}
