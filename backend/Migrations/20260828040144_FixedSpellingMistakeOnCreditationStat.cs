using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class FixedSpellingMistakeOnCreditationStat : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "creditaitonStatusId",
                table: "creditationStatuses",
                newName: "creditationStatusId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "creditationStatusId",
                table: "creditationStatuses",
                newName: "creditaitonStatusId");
        }
    }
}
