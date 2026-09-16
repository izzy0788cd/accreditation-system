using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class AddSurveyorReports : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "surveyorReports",
                columns: table => new
                {
                    surveyorReportId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    surveyId = table.Column<int>(type: "integer", nullable: false),
                    surveyorId = table.Column<int>(type: "integer", nullable: false),
                    summary = table.Column<string>(type: "text", nullable: true),
                    priorityFindings = table.Column<string>(type: "text", nullable: true),
                    recommendations = table.Column<string>(type: "text", nullable: true),
                    goodPractices = table.Column<string>(type: "text", nullable: true),
                    notApplicableNotes = table.Column<string>(type: "text", nullable: true),
                    isSubmitted = table.Column<bool>(type: "boolean", nullable: false),
                    submittedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    updatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveyorReports", x => x.surveyorReportId);
                    table.ForeignKey(
                        name: "FK_surveyorReports_surveyors_surveyorId",
                        column: x => x.surveyorId,
                        principalTable: "surveyors",
                        principalColumn: "surveyorId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveyorReports_surveys_surveyId",
                        column: x => x.surveyId,
                        principalTable: "surveys",
                        principalColumn: "surveyId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_surveyorReports_surveyId_surveyorId",
                table: "surveyorReports",
                columns: new[] { "surveyId", "surveyorId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_surveyorReports_surveyorId",
                table: "surveyorReports",
                column: "surveyorId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "surveyorReports");
        }
    }
}
