using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class AddSurveyActionItems : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "surveyActionItems",
                columns: table => new
                {
                    surveyActionItemId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    surveyId = table.Column<int>(type: "integer", nullable: false),
                    complianceAssessmentId = table.Column<int>(type: "integer", nullable: false),
                    recommendation = table.Column<string>(type: "text", nullable: false),
                    correctiveAction = table.Column<string>(type: "text", nullable: true),
                    responsibleOfficer = table.Column<string>(type: "text", nullable: true),
                    dueDate = table.Column<DateOnly>(type: "date", nullable: true),
                    status = table.Column<string>(type: "text", nullable: false),
                    closureNotes = table.Column<string>(type: "text", nullable: true),
                    createdAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    updatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveyActionItems", x => x.surveyActionItemId);
                    table.ForeignKey(
                        name: "FK_surveyActionItems_complianceAssessments_complianceAssessmen~",
                        column: x => x.complianceAssessmentId,
                        principalTable: "complianceAssessments",
                        principalColumn: "complianceAssessmentId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveyActionItems_surveys_surveyId",
                        column: x => x.surveyId,
                        principalTable: "surveys",
                        principalColumn: "surveyId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_surveyActionItems_complianceAssessmentId",
                table: "surveyActionItems",
                column: "complianceAssessmentId");

            migrationBuilder.CreateIndex(
                name: "IX_surveyActionItems_surveyId",
                table: "surveyActionItems",
                column: "surveyId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "surveyActionItems");
        }
    }
}
