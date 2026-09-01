using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class ChangeDbContextFacilityLevelsNamingUserSurveyorsFK : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_surveys_users_userId",
                table: "surveys");

            migrationBuilder.DropIndex(
                name: "IX_surveys_userId",
                table: "surveys");

            migrationBuilder.DropIndex(
                name: "IX_surveyors_userId",
                table: "surveyors");

            migrationBuilder.DropColumn(
                name: "userId",
                table: "surveys");

            migrationBuilder.DropColumn(
                name: "creditationId",
                table: "facilities");

            migrationBuilder.CreateIndex(
                name: "IX_surveyors_userId",
                table: "surveyors",
                column: "userId",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_surveyors_userId",
                table: "surveyors");

            migrationBuilder.AddColumn<int>(
                name: "userId",
                table: "surveys",
                type: "integer",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "creditationId",
                table: "facilities",
                type: "integer",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_surveys_userId",
                table: "surveys",
                column: "userId");

            migrationBuilder.CreateIndex(
                name: "IX_surveyors_userId",
                table: "surveyors",
                column: "userId");

            migrationBuilder.AddForeignKey(
                name: "FK_surveys_users_userId",
                table: "surveys",
                column: "userId",
                principalTable: "users",
                principalColumn: "userId");
        }
    }
}
