using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class AddSurveyToolkitTemplates : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "surveyToolkitSnapshots",
                columns: table => new
                {
                    surveyToolkitSnapshotId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    surveyId = table.Column<int>(type: "integer", nullable: false),
                    scopeType = table.Column<string>(type: "text", nullable: false),
                    templateSummary = table.Column<string>(type: "text", nullable: true),
                    customisationReason = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveyToolkitSnapshots", x => x.surveyToolkitSnapshotId);
                    table.ForeignKey(
                        name: "FK_surveyToolkitSnapshots_surveys_surveyId",
                        column: x => x.surveyId,
                        principalTable: "surveys",
                        principalColumn: "surveyId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "surveyToolkitTemplates",
                columns: table => new
                {
                    surveyToolkitTemplateId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    templateName = table.Column<string>(type: "text", nullable: false),
                    templateVersion = table.Column<string>(type: "text", nullable: false),
                    description = table.Column<string>(type: "text", nullable: true),
                    levelId = table.Column<int>(type: "integer", nullable: true),
                    isServiceOverlay = table.Column<bool>(type: "boolean", nullable: false),
                    isActive = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveyToolkitTemplates", x => x.surveyToolkitTemplateId);
                    table.ForeignKey(
                        name: "FK_surveyToolkitTemplates_levels_levelId",
                        column: x => x.levelId,
                        principalTable: "levels",
                        principalColumn: "levelId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "surveyToolkitSnapshotStandards",
                columns: table => new
                {
                    surveyToolkitSnapshotStandardId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    surveyToolkitSnapshotId = table.Column<int>(type: "integer", nullable: false),
                    standardId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveyToolkitSnapshotStandards", x => x.surveyToolkitSnapshotStandardId);
                    table.ForeignKey(
                        name: "FK_surveyToolkitSnapshotStandards_standards_standardId",
                        column: x => x.standardId,
                        principalTable: "standards",
                        principalColumn: "standardId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveyToolkitSnapshotStandards_surveyToolkitSnapshots_surve~",
                        column: x => x.surveyToolkitSnapshotId,
                        principalTable: "surveyToolkitSnapshots",
                        principalColumn: "surveyToolkitSnapshotId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "surveyToolkitTemplateStandards",
                columns: table => new
                {
                    surveyToolkitTemplateStandardId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    surveyToolkitTemplateId = table.Column<int>(type: "integer", nullable: false),
                    standardId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveyToolkitTemplateStandards", x => x.surveyToolkitTemplateStandardId);
                    table.ForeignKey(
                        name: "FK_surveyToolkitTemplateStandards_standards_standardId",
                        column: x => x.standardId,
                        principalTable: "standards",
                        principalColumn: "standardId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveyToolkitTemplateStandards_surveyToolkitTemplates_surve~",
                        column: x => x.surveyToolkitTemplateId,
                        principalTable: "surveyToolkitTemplates",
                        principalColumn: "surveyToolkitTemplateId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_surveyToolkitSnapshots_surveyId",
                table: "surveyToolkitSnapshots",
                column: "surveyId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_surveyToolkitSnapshotStandards_standardId",
                table: "surveyToolkitSnapshotStandards",
                column: "standardId");

            migrationBuilder.CreateIndex(
                name: "IX_surveyToolkitSnapshotStandards_surveyToolkitSnapshotId_stan~",
                table: "surveyToolkitSnapshotStandards",
                columns: new[] { "surveyToolkitSnapshotId", "standardId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_surveyToolkitTemplates_levelId",
                table: "surveyToolkitTemplates",
                column: "levelId");

            migrationBuilder.CreateIndex(
                name: "IX_surveyToolkitTemplateStandards_standardId",
                table: "surveyToolkitTemplateStandards",
                column: "standardId");

            migrationBuilder.CreateIndex(
                name: "IX_surveyToolkitTemplateStandards_surveyToolkitTemplateId_stan~",
                table: "surveyToolkitTemplateStandards",
                columns: new[] { "surveyToolkitTemplateId", "standardId" },
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "surveyToolkitSnapshotStandards");

            migrationBuilder.DropTable(
                name: "surveyToolkitTemplateStandards");

            migrationBuilder.DropTable(
                name: "surveyToolkitSnapshots");

            migrationBuilder.DropTable(
                name: "surveyToolkitTemplates");
        }
    }
}
