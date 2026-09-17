using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    public partial class AdoptFourPointSurveyRatings : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "guidance",
                table: "scores",
                type: "text",
                nullable: true);

            // Preserve existing assessments while translating the previous 0–2 scale:
            // 0 (non-compliant) → 1, 1 (partially compliant) → 2, and 2 (compliant) → 4.
            migrationBuilder.Sql(
                """
                UPDATE scores
                SET "scoreValue" = CASE
                    WHEN "scoreValue" = 0 THEN 1
                    WHEN "scoreValue" = 1 THEN 2
                    WHEN "scoreValue" = 2 THEN 4
                    ELSE "scoreValue"
                END
                WHERE "scoreValue" IS NOT NULL;

                UPDATE scores
                SET
                    "scoreLabel" = CASE "scoreValue"
                        WHEN 1 THEN 'Poor achievement'
                        WHEN 2 THEN 'Fair achievement'
                        WHEN 3 THEN 'Good achievement'
                        WHEN 4 THEN 'Full achievement'
                        ELSE 'N/A'
                    END,
                    "description" = CASE "scoreValue"
                        WHEN 1 THEN 'Poor achievement (less than 30%). Few or none of the criterion elements are addressed. A recommendation and risk assessment are required.'
                        WHEN 2 THEN 'Fair achievement (30–60%). Some criterion elements are addressed. A recommendation and risk assessment are required.'
                        WHEN 3 THEN 'Good achievement (more than 60%). The majority of criterion elements are addressed. A recommendation for improvement is required.'
                        WHEN 4 THEN 'Full achievement in compliance (100%). No recommendation is required, although an opportunity for improvement may be noted.'
                        ELSE NULL
                    END,
                    "guidance" = CASE "scoreValue"
                        WHEN 1 THEN 'Include the rationale for the recommendation and risk assessment in the surveyor finding.'
                        WHEN 2 THEN 'Include the rationale for the recommendation and risk assessment in the surveyor finding.'
                        WHEN 3 THEN 'Include a recommendation or opportunity for improvement in the surveyor finding.'
                        WHEN 4 THEN 'Note where the organisation has exceeded the surveyor finding.'
                        ELSE 'Use N/A only when the standard is not relevant to the assessment.'
                    END;

                INSERT INTO scores ("scoreValue", "scoreLabel", "description", "guidance")
                SELECT
                    3,
                    'Good achievement',
                    'Good achievement (more than 60%). The majority of criterion elements are addressed. A recommendation for improvement is required.',
                    'Include a recommendation or opportunity for improvement in the surveyor finding.'
                WHERE NOT EXISTS (SELECT 1 FROM scores WHERE "scoreValue" = 3);
                """
            );
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "guidance",
                table: "scores");
        }
    }
}
