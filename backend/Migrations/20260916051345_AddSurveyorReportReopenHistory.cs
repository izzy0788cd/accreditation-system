using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class AddSurveyorReportReopenHistory : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "surveyorReportReopens",
                columns: table => new
                {
                    surveyorReportReopenId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    surveyorReportId = table.Column<int>(type: "integer", nullable: false),
                    reason = table.Column<string>(type: "text", nullable: false),
                    reopenedByUsername = table.Column<string>(type: "text", nullable: false),
                    reopenedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    previousSubmittedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveyorReportReopens", x => x.surveyorReportReopenId);
                    table.ForeignKey(
                        name: "FK_surveyorReportReopens_surveyorReports_surveyorReportId",
                        column: x => x.surveyorReportId,
                        principalTable: "surveyorReports",
                        principalColumn: "surveyorReportId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_surveyorReportReopens_surveyorReportId",
                table: "surveyorReportReopens",
                column: "surveyorReportId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "surveyorReportReopens");
        }
    }
}
