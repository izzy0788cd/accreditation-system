using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class AddSurveyToolkitComplianceScope : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "surveyToolkitSnapshotCompliances",
                columns: table => new
                {
                    surveyToolkitSnapshotComplianceId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    surveyToolkitSnapshotId = table.Column<int>(type: "integer", nullable: false),
                    complianceId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveyToolkitSnapshotCompliances", x => x.surveyToolkitSnapshotComplianceId);
                    table.ForeignKey(
                        name: "FK_surveyToolkitSnapshotCompliances_compliances_complianceId",
                        column: x => x.complianceId,
                        principalTable: "compliances",
                        principalColumn: "complianceId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveyToolkitSnapshotCompliances_surveyToolkitSnapshots_sur~",
                        column: x => x.surveyToolkitSnapshotId,
                        principalTable: "surveyToolkitSnapshots",
                        principalColumn: "surveyToolkitSnapshotId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "surveyToolkitTemplateCompliances",
                columns: table => new
                {
                    surveyToolkitTemplateComplianceId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    surveyToolkitTemplateId = table.Column<int>(type: "integer", nullable: false),
                    complianceId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveyToolkitTemplateCompliances", x => x.surveyToolkitTemplateComplianceId);
                    table.ForeignKey(
                        name: "FK_surveyToolkitTemplateCompliances_compliances_complianceId",
                        column: x => x.complianceId,
                        principalTable: "compliances",
                        principalColumn: "complianceId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveyToolkitTemplateCompliances_surveyToolkitTemplates_sur~",
                        column: x => x.surveyToolkitTemplateId,
                        principalTable: "surveyToolkitTemplates",
                        principalColumn: "surveyToolkitTemplateId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_surveyToolkitSnapshotCompliances_complianceId",
                table: "surveyToolkitSnapshotCompliances",
                column: "complianceId");

            migrationBuilder.CreateIndex(
                name: "IX_surveyToolkitSnapshotCompliances_surveyToolkitSnapshotId_co~",
                table: "surveyToolkitSnapshotCompliances",
                columns: new[] { "surveyToolkitSnapshotId", "complianceId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_surveyToolkitTemplateCompliances_complianceId",
                table: "surveyToolkitTemplateCompliances",
                column: "complianceId");

            migrationBuilder.CreateIndex(
                name: "IX_surveyToolkitTemplateCompliances_surveyToolkitTemplateId_co~",
                table: "surveyToolkitTemplateCompliances",
                columns: new[] { "surveyToolkitTemplateId", "complianceId" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "surveyToolkitSnapshotCompliances");

            migrationBuilder.DropTable(
                name: "surveyToolkitTemplateCompliances");
        }
    }
}
