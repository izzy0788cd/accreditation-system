using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class ChangedScoreValueFromStringToInt : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(
                "ALTER TABLE scores ALTER COLUMN \"scoreValue\" TYPE integer USING \"scoreValue\"::integer;"
            );

            migrationBuilder.AddColumn<int>(
                name: "severityOrder",
                table: "riskRatings",
                type: "integer",
                nullable: true
            );
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(name: "severityOrder", table: "riskRatings");

            migrationBuilder.AlterColumn<string>(
                name: "scoreValue",
                table: "scores",
                type: "text",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(int),
                oldType: "integer",
                oldNullable: true
            );
        }
    }
}
