using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class AddSurveyCancellation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "cancellationReason",
                table: "surveys",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "cancelledAt",
                table: "surveys",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "cancelledByUsername",
                table: "surveys",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "isCancelled",
                table: "surveys",
                type: "boolean",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "cancellationReason",
                table: "surveys");

            migrationBuilder.DropColumn(
                name: "cancelledAt",
                table: "surveys");

            migrationBuilder.DropColumn(
                name: "cancelledByUsername",
                table: "surveys");

            migrationBuilder.DropColumn(
                name: "isCancelled",
                table: "surveys");
        }
    }
}
