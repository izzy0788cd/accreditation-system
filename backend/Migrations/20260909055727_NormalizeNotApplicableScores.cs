using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class NormalizeNotApplicableScores : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<int>(
                name: "scoreValue",
                table: "scores",
                type: "integer",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "integer"
            );

            migrationBuilder.Sql(
                """
                UPDATE scores
                SET "scoreValue" = NULL
                WHERE lower(trim("scoreLabel")) IN ('na', 'n/a', 'not applicable');
                """
            );

        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<int>(
                name: "scoreValue",
                table: "scores",
                type: "integer",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "integer",
                oldNullable: true
            );
        }
    }
}
