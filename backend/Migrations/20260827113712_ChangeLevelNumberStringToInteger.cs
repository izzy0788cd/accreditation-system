using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class ChangeLevelNumberStringToInteger : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "levelNumber",
                table: "levels");

            migrationBuilder.RenameColumn(
                name: "levelLabel",
                table: "levels",
                newName: "levelName");

            migrationBuilder.AddColumn<int>(
                name: "levelOrder",
                table: "levels",
                type: "integer",
                maxLength: 1,
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "levelOrder",
                table: "levels");

            migrationBuilder.RenameColumn(
                name: "levelName",
                table: "levels",
                newName: "levelLabel");

            migrationBuilder.AddColumn<string>(
                name: "levelNumber",
                table: "levels",
                type: "character varying(1)",
                maxLength: 1,
                nullable: false,
                defaultValue: "");
        }
    }
}
