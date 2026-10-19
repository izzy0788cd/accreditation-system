using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class AddSurveyorStandardSummaries : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "surveyorStandardSummaries",
                columns: table => new
                {
                    surveyorStandardSummaryId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    surveyId = table.Column<int>(type: "integer", nullable: false),
                    surveyorId = table.Column<int>(type: "integer", nullable: false),
                    standardId = table.Column<int>(type: "integer", nullable: false),
                    summary = table.Column<string>(type: "text", nullable: false),
                    goodPractices = table.Column<string>(type: "text", nullable: true),
                    notApplicableNotes = table.Column<string>(type: "text", nullable: true),
                    updatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveyorStandardSummaries", x => x.surveyorStandardSummaryId);
                    table.ForeignKey(
                        name: "FK_surveyorStandardSummaries_standards_standardId",
                        column: x => x.standardId,
                        principalTable: "standards",
                        principalColumn: "standardId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveyorStandardSummaries_surveyors_surveyorId",
                        column: x => x.surveyorId,
                        principalTable: "surveyors",
                        principalColumn: "surveyorId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveyorStandardSummaries_surveys_surveyId",
                        column: x => x.surveyId,
                        principalTable: "surveys",
                        principalColumn: "surveyId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_surveyorStandardSummaries_standardId",
                table: "surveyorStandardSummaries",
                column: "standardId");

            migrationBuilder.CreateIndex(
                name: "IX_surveyorStandardSummaries_surveyId_surveyorId_standardId",
                table: "surveyorStandardSummaries",
                columns: new[] { "surveyId", "surveyorId", "standardId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_surveyorStandardSummaries_surveyorId",
                table: "surveyorStandardSummaries",
                column: "surveyorId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "surveyorStandardSummaries");
        }
    }
}
