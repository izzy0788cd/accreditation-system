using System;
using Microsoft.EntityFrameworkCore.Migrations;
using Npgsql.EntityFrameworkCore.PostgreSQL.Metadata;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class AddAllRemainingDataModels : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "categories",
                columns: table => new
                {
                    categoryId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    categoryName = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    description = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_categories", x => x.categoryId);
                });

            migrationBuilder.CreateTable(
                name: "creditationStatuses",
                columns: table => new
                {
                    creditaitonStatusId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    creditationStatus = table.Column<string>(type: "text", nullable: false),
                    description = table.Column<string>(type: "text", nullable: false),
                    comments = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_creditationStatuses", x => x.creditaitonStatusId);
                });

            migrationBuilder.CreateTable(
                name: "levels",
                columns: table => new
                {
                    levelId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    levelNumber = table.Column<string>(type: "character varying(1)", maxLength: 1, nullable: false),
                    levelLabel = table.Column<string>(type: "character varying(100)", maxLength: 100, nullable: false),
                    description = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_levels", x => x.levelId);
                });

            migrationBuilder.CreateTable(
                name: "riskRatings",
                columns: table => new
                {
                    riskId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    riskValue = table.Column<string>(type: "text", nullable: false),
                    riskLabel = table.Column<string>(type: "text", nullable: false),
                    description = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_riskRatings", x => x.riskId);
                });

            migrationBuilder.CreateTable(
                name: "roles",
                columns: table => new
                {
                    roleId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    roleName = table.Column<string>(type: "text", nullable: false),
                    description = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_roles", x => x.roleId);
                });

            migrationBuilder.CreateTable(
                name: "scores",
                columns: table => new
                {
                    scoreId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    scoreValue = table.Column<string>(type: "text", nullable: false),
                    scoreLabel = table.Column<string>(type: "text", nullable: false),
                    description = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_scores", x => x.scoreId);
                });

            migrationBuilder.CreateTable(
                name: "specializations",
                columns: table => new
                {
                    specializationId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    specializationName = table.Column<string>(type: "text", nullable: false),
                    description = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_specializations", x => x.specializationId);
                });

            migrationBuilder.CreateTable(
                name: "surveyorCertStatuses",
                columns: table => new
                {
                    surveyorCertStatusId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    surveyorCertStatusName = table.Column<string>(type: "text", nullable: false),
                    description = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveyorCertStatuses", x => x.surveyorCertStatusId);
                });

            migrationBuilder.CreateTable(
                name: "surveyTypes",
                columns: table => new
                {
                    surveyTypeId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    surveyTypeName = table.Column<string>(type: "text", nullable: false),
                    description = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveyTypes", x => x.surveyTypeId);
                });

            migrationBuilder.CreateTable(
                name: "organizations",
                columns: table => new
                {
                    organizationId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    organizationName = table.Column<string>(type: "text", nullable: false),
                    categoryId = table.Column<int>(type: "integer", nullable: false),
                    description = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_organizations", x => x.organizationId);
                    table.ForeignKey(
                        name: "FK_organizations_categories_categoryId",
                        column: x => x.categoryId,
                        principalTable: "categories",
                        principalColumn: "categoryId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "userAccounts",
                columns: table => new
                {
                    userAccountId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    roleId = table.Column<int>(type: "integer", nullable: false),
                    username = table.Column<string>(type: "text", nullable: false),
                    passwordHash = table.Column<string>(type: "text", nullable: false),
                    isActive = table.Column<bool>(type: "boolean", nullable: false),
                    dateCreated = table.Column<DateOnly>(type: "date", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_userAccounts", x => x.userAccountId);
                    table.ForeignKey(
                        name: "FK_userAccounts_roles_roleId",
                        column: x => x.roleId,
                        principalTable: "roles",
                        principalColumn: "roleId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "facilities",
                columns: table => new
                {
                    facilityId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    levelId = table.Column<int>(type: "integer", nullable: false),
                    facilityName = table.Column<string>(type: "text", nullable: false),
                    districtId = table.Column<int>(type: "integer", nullable: false),
                    organizationId = table.Column<int>(type: "integer", nullable: false),
                    creditationStatusId = table.Column<int>(type: "integer", nullable: false),
                    headOfService = table.Column<string>(type: "text", nullable: true),
                    comments = table.Column<string>(type: "text", nullable: true),
                    creditationId = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_facilities", x => x.facilityId);
                    table.ForeignKey(
                        name: "FK_facilities_creditationStatuses_creditationStatusId",
                        column: x => x.creditationStatusId,
                        principalTable: "creditationStatuses",
                        principalColumn: "creditaitonStatusId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_facilities_districts_districtId",
                        column: x => x.districtId,
                        principalTable: "districts",
                        principalColumn: "districtId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_facilities_levels_levelId",
                        column: x => x.levelId,
                        principalTable: "levels",
                        principalColumn: "levelId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_facilities_organizations_organizationId",
                        column: x => x.organizationId,
                        principalTable: "organizations",
                        principalColumn: "organizationId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "users",
                columns: table => new
                {
                    userId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    userAccountId = table.Column<int>(type: "integer", nullable: false),
                    firstName = table.Column<string>(type: "text", nullable: false),
                    lastName = table.Column<string>(type: "text", nullable: false),
                    organizationId = table.Column<int>(type: "integer", nullable: false),
                    position = table.Column<string>(type: "text", nullable: true),
                    email = table.Column<string>(type: "text", nullable: false),
                    phone = table.Column<string>(type: "text", nullable: false),
                    mobile = table.Column<string>(type: "text", nullable: true),
                    comments = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_users", x => x.userId);
                    table.ForeignKey(
                        name: "FK_users_organizations_organizationId",
                        column: x => x.organizationId,
                        principalTable: "organizations",
                        principalColumn: "organizationId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_users_userAccounts_userAccountId",
                        column: x => x.userAccountId,
                        principalTable: "userAccounts",
                        principalColumn: "userAccountId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "surveyors",
                columns: table => new
                {
                    surveyorId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    userId = table.Column<int>(type: "integer", nullable: false),
                    surveyorCertStatusId = table.Column<int>(type: "integer", nullable: false),
                    specializationId = table.Column<int>(type: "integer", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveyors", x => x.surveyorId);
                    table.ForeignKey(
                        name: "FK_surveyors_specializations_specializationId",
                        column: x => x.specializationId,
                        principalTable: "specializations",
                        principalColumn: "specializationId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveyors_surveyorCertStatuses_surveyorCertStatusId",
                        column: x => x.surveyorCertStatusId,
                        principalTable: "surveyorCertStatuses",
                        principalColumn: "surveyorCertStatusId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveyors_users_userId",
                        column: x => x.userId,
                        principalTable: "users",
                        principalColumn: "userId",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "surveys",
                columns: table => new
                {
                    surveyId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    facilityId = table.Column<int>(type: "integer", nullable: false),
                    surveyTypeId = table.Column<int>(type: "integer", nullable: false),
                    surveyorId = table.Column<int>(type: "integer", nullable: false),
                    startDate = table.Column<DateOnly>(type: "date", nullable: false),
                    endDate = table.Column<DateOnly>(type: "date", nullable: false),
                    userId = table.Column<int>(type: "integer", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_surveys", x => x.surveyId);
                    table.ForeignKey(
                        name: "FK_surveys_facilities_facilityId",
                        column: x => x.facilityId,
                        principalTable: "facilities",
                        principalColumn: "facilityId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveys_surveyTypes_surveyTypeId",
                        column: x => x.surveyTypeId,
                        principalTable: "surveyTypes",
                        principalColumn: "surveyTypeId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveys_surveyors_surveyorId",
                        column: x => x.surveyorId,
                        principalTable: "surveyors",
                        principalColumn: "surveyorId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_surveys_users_userId",
                        column: x => x.userId,
                        principalTable: "users",
                        principalColumn: "userId");
                });

            migrationBuilder.CreateTable(
                name: "complianceAssessments",
                columns: table => new
                {
                    complianceAssessmentId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    surveyorId = table.Column<int>(type: "integer", nullable: false),
                    surveyId = table.Column<int>(type: "integer", nullable: false),
                    complianceId = table.Column<int>(type: "integer", nullable: false),
                    scoreId = table.Column<int>(type: "integer", nullable: false),
                    riskRatingId = table.Column<int>(type: "integer", nullable: false),
                    complianceComments = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_complianceAssessments", x => x.complianceAssessmentId);
                    table.ForeignKey(
                        name: "FK_complianceAssessments_compliances_complianceId",
                        column: x => x.complianceId,
                        principalTable: "compliances",
                        principalColumn: "complianceId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_complianceAssessments_riskRatings_riskRatingId",
                        column: x => x.riskRatingId,
                        principalTable: "riskRatings",
                        principalColumn: "riskId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_complianceAssessments_scores_scoreId",
                        column: x => x.scoreId,
                        principalTable: "scores",
                        principalColumn: "scoreId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_complianceAssessments_surveyors_surveyorId",
                        column: x => x.surveyorId,
                        principalTable: "surveyors",
                        principalColumn: "surveyorId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_complianceAssessments_surveys_surveyId",
                        column: x => x.surveyId,
                        principalTable: "surveys",
                        principalColumn: "surveyId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "complianceEvidenceChecks",
                columns: table => new
                {
                    complianceEvidenceCheckId = table.Column<int>(type: "integer", nullable: false)
                        .Annotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.IdentityByDefaultColumn),
                    complianceAssessmentId = table.Column<int>(type: "integer", nullable: false),
                    evidenceId = table.Column<int>(type: "integer", nullable: false),
                    isChecked = table.Column<bool>(type: "boolean", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_complianceEvidenceChecks", x => x.complianceEvidenceCheckId);
                    table.ForeignKey(
                        name: "FK_complianceEvidenceChecks_complianceAssessments_complianceAs~",
                        column: x => x.complianceAssessmentId,
                        principalTable: "complianceAssessments",
                        principalColumn: "complianceAssessmentId",
                        onDelete: ReferentialAction.Restrict);
                    table.ForeignKey(
                        name: "FK_complianceEvidenceChecks_evidence_evidenceId",
                        column: x => x.evidenceId,
                        principalTable: "evidence",
                        principalColumn: "evidenceId",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateIndex(
                name: "IX_complianceAssessments_complianceId",
                table: "complianceAssessments",
                column: "complianceId");

            migrationBuilder.CreateIndex(
                name: "IX_complianceAssessments_riskRatingId",
                table: "complianceAssessments",
                column: "riskRatingId");

            migrationBuilder.CreateIndex(
                name: "IX_complianceAssessments_scoreId",
                table: "complianceAssessments",
                column: "scoreId");

            migrationBuilder.CreateIndex(
                name: "IX_complianceAssessments_surveyId_complianceId",
                table: "complianceAssessments",
                columns: new[] { "surveyId", "complianceId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_complianceAssessments_surveyorId",
                table: "complianceAssessments",
                column: "surveyorId");

            migrationBuilder.CreateIndex(
                name: "IX_complianceEvidenceChecks_complianceAssessmentId",
                table: "complianceEvidenceChecks",
                column: "complianceAssessmentId");

            migrationBuilder.CreateIndex(
                name: "IX_complianceEvidenceChecks_evidenceId",
                table: "complianceEvidenceChecks",
                column: "evidenceId");

            migrationBuilder.CreateIndex(
                name: "IX_facilities_creditationStatusId",
                table: "facilities",
                column: "creditationStatusId");

            migrationBuilder.CreateIndex(
                name: "IX_facilities_districtId",
                table: "facilities",
                column: "districtId");

            migrationBuilder.CreateIndex(
                name: "IX_facilities_levelId",
                table: "facilities",
                column: "levelId");

            migrationBuilder.CreateIndex(
                name: "IX_facilities_organizationId",
                table: "facilities",
                column: "organizationId");

            migrationBuilder.CreateIndex(
                name: "IX_organizations_categoryId",
                table: "organizations",
                column: "categoryId");

            migrationBuilder.CreateIndex(
                name: "IX_surveyors_specializationId",
                table: "surveyors",
                column: "specializationId");

            migrationBuilder.CreateIndex(
                name: "IX_surveyors_surveyorCertStatusId",
                table: "surveyors",
                column: "surveyorCertStatusId");

            migrationBuilder.CreateIndex(
                name: "IX_surveyors_userId",
                table: "surveyors",
                column: "userId");

            migrationBuilder.CreateIndex(
                name: "IX_surveys_facilityId",
                table: "surveys",
                column: "facilityId");

            migrationBuilder.CreateIndex(
                name: "IX_surveys_surveyorId",
                table: "surveys",
                column: "surveyorId");

            migrationBuilder.CreateIndex(
                name: "IX_surveys_surveyTypeId",
                table: "surveys",
                column: "surveyTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_surveys_userId",
                table: "surveys",
                column: "userId");

            migrationBuilder.CreateIndex(
                name: "IX_userAccounts_roleId",
                table: "userAccounts",
                column: "roleId");

            migrationBuilder.CreateIndex(
                name: "IX_users_organizationId",
                table: "users",
                column: "organizationId");

            migrationBuilder.CreateIndex(
                name: "IX_users_userAccountId",
                table: "users",
                column: "userAccountId",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "complianceEvidenceChecks");

            migrationBuilder.DropTable(
                name: "complianceAssessments");

            migrationBuilder.DropTable(
                name: "riskRatings");

            migrationBuilder.DropTable(
                name: "scores");

            migrationBuilder.DropTable(
                name: "surveys");

            migrationBuilder.DropTable(
                name: "facilities");

            migrationBuilder.DropTable(
                name: "surveyTypes");

            migrationBuilder.DropTable(
                name: "surveyors");

            migrationBuilder.DropTable(
                name: "creditationStatuses");

            migrationBuilder.DropTable(
                name: "levels");

            migrationBuilder.DropTable(
                name: "specializations");

            migrationBuilder.DropTable(
                name: "surveyorCertStatuses");

            migrationBuilder.DropTable(
                name: "users");

            migrationBuilder.DropTable(
                name: "organizations");

            migrationBuilder.DropTable(
                name: "userAccounts");

            migrationBuilder.DropTable(
                name: "categories");

            migrationBuilder.DropTable(
                name: "roles");
        }
    }
}
