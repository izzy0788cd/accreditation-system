using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class UpdateDeleteBehaviours : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_compliances_criteria_criterionId",
                table: "compliances");

            migrationBuilder.DropForeignKey(
                name: "FK_criteria_standards_standardId",
                table: "criteria");

            migrationBuilder.DropForeignKey(
                name: "FK_standards_components_componentId",
                table: "standards");

            migrationBuilder.DropForeignKey(
                name: "FK_standards_functions_functionId",
                table: "standards");

            migrationBuilder.CreateTable(
                name: "regions",
                columns: table => new
                {
                    regionId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    regionName = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_regions", x => x.regionId);
                });

            migrationBuilder.CreateTable(
                name: "provinces",
                columns: table => new
                {
                    provinceId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    provinceName = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    regionId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_provinces", x => x.provinceId);
                    table.ForeignKey(
                        name: "FK_provinces_regions_regionId",
                        column: x => x.regionId,
                        principalTable: "regions",
                        principalColumn: "regionId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "districts",
                columns: table => new
                {
                    districtId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    districtName = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    provinceId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_districts", x => x.districtId);
                    table.ForeignKey(
                        name: "FK_districts_provinces_provinceId",
                        column: x => x.provinceId,
                        principalTable: "provinces",
                        principalColumn: "provinceId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_districts_provinceId",
                table: "districts",
                column: "provinceId");

            migrationBuilder.CreateIndex(
                name: "IX_provinces_regionId",
                table: "provinces",
                column: "regionId");

            migrationBuilder.AddForeignKey(
                name: "FK_compliances_criteria_criterionId",
                table: "compliances",
                column: "criterionId",
                principalTable: "criteria",
                principalColumn: "criterionId",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_criteria_standards_standardId",
                table: "criteria",
                column: "standardId",
                principalTable: "standards",
                principalColumn: "standardId",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_standards_components_componentId",
                table: "standards",
                column: "componentId",
                principalTable: "components",
                principalColumn: "componentId",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_standards_functions_functionId",
                table: "standards",
                column: "functionId",
                principalTable: "functions",
                principalColumn: "functionId",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_compliances_criteria_criterionId",
                table: "compliances");

            migrationBuilder.DropForeignKey(
                name: "FK_criteria_standards_standardId",
                table: "criteria");

            migrationBuilder.DropForeignKey(
                name: "FK_standards_components_componentId",
                table: "standards");

            migrationBuilder.DropForeignKey(
                name: "FK_standards_functions_functionId",
                table: "standards");

            migrationBuilder.DropTable(
                name: "districts");

            migrationBuilder.DropTable(
                name: "provinces");

            migrationBuilder.DropTable(
                name: "regions");

            migrationBuilder.AddForeignKey(
                name: "FK_compliances_criteria_criterionId",
                table: "compliances",
                column: "criterionId",
                principalTable: "criteria",
                principalColumn: "criterionId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_criteria_standards_standardId",
                table: "criteria",
                column: "standardId",
                principalTable: "standards",
                principalColumn: "standardId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_standards_components_componentId",
                table: "standards",
                column: "componentId",
                principalTable: "components",
                principalColumn: "componentId",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_standards_functions_functionId",
                table: "standards",
                column: "functionId",
                principalTable: "functions",
                principalColumn: "functionId",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
