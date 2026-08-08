using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class Initial : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "components",
                columns: table => new
                {
                    componentId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    componentName = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    componentSummary = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_components", x => x.componentId);
                });

            migrationBuilder.CreateTable(
                name: "functions",
                columns: table => new
                {
                    functionId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    functiontTitle = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    functionSummary = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_functions", x => x.functionId);
                });

            migrationBuilder.CreateTable(
                name: "standards",
                columns: table => new
                {
                    standardId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    standardTitle = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    functionId = table.Column<int>(type: "integer", nullable: false),
                    componentId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_standards", x => x.standardId);
                    table.ForeignKey(
                        name: "FK_standards_components_componentId",
                        column: x => x.componentId,
                        principalTable: "components",
                        principalColumn: "componentId",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_standards_functions_functionId",
                        column: x => x.functionId,
                        principalTable: "functions",
                        principalColumn: "functionId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "criteria",
                columns: table => new
                {
                    criterionId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    criterionTitle = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: false),
                    standardId = table.Column<int>(type: "integer", nullable: false),
                    isApplicable = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_criteria", x => x.criterionId);
                    table.ForeignKey(
                        name: "FK_criteria_standards_standardId",
                        column: x => x.standardId,
                        principalTable: "standards",
                        principalColumn: "standardId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "compliances",
                columns: table => new
                {
                    complianceId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    complianceSummary = table.Column<string>(type: "text", nullable: false),
                    criterionId = table.Column<int>(type: "integer", nullable: false),
                    isApplicable = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_compliances", x => x.complianceId);
                    table.ForeignKey(
                        name: "FK_compliances_criteria_criterionId",
                        column: x => x.criterionId,
                        principalTable: "criteria",
                        principalColumn: "criterionId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "evidence",
                columns: table => new
                {
                    evidenceId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    evidenceSumaary = table.Column<string>(type: "text", nullable: false),
                    complianceId = table.Column<int>(type: "integer", nullable: false),
                    isApplicable = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_evidence", x => x.evidenceId);
                    table.ForeignKey(
                        name: "FK_evidence_compliances_complianceId",
                        column: x => x.complianceId,
                        principalTable: "compliances",
                        principalColumn: "complianceId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_compliances_criterionId",
                table: "compliances",
                column: "criterionId");

            migrationBuilder.CreateIndex(
                name: "IX_criteria_standardId",
                table: "criteria",
                column: "standardId");

            migrationBuilder.CreateIndex(
                name: "IX_evidence_complianceId",
                table: "evidence",
                column: "complianceId");

            migrationBuilder.CreateIndex(
                name: "IX_standards_componentId",
                table: "standards",
                column: "componentId");

            migrationBuilder.CreateIndex(
                name: "IX_standards_functionId",
                table: "standards",
                column: "functionId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "evidence");

            migrationBuilder.DropTable(
                name: "compliances");

            migrationBuilder.DropTable(
                name: "criteria");

            migrationBuilder.DropTable(
                name: "standards");

            migrationBuilder.DropTable(
                name: "components");

            migrationBuilder.DropTable(
                name: "functions");
        }
    }
}
