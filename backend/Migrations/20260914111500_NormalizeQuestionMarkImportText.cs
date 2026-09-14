using backend.Data;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    [DbContext(typeof(AppDbContext))]
    [Migration("20260914111500_NormalizeQuestionMarkImportText")]
    public partial class NormalizeQuestionMarkImportText : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("""
                CREATE FUNCTION public.normalize_question_mark_import_text(input text)
                RETURNS text
                LANGUAGE plpgsql
                IMMUTABLE
                AS $$
                DECLARE
                    result text := input;
                BEGIN
                    -- Repair the lossy ??? representation used by the older import.
                    result := replace(result, '???s', '''s');
                    result := regexp_replace(result, E'([[:alpha:]])s\\?\\?\\?', E'\\1s''', 'g');
                    result := replace(result, '???C', '°C');
                    result := replace(result, '??? 0.5', '<= 0.5');
                    result := replace(result, E'\n???\t', E'\n- \t');
                    result := replace(result, E'???\t', E'- \t');
                    result := replace(result, ' ??? ', ' - ');
                    result := regexp_replace(result, E'\\?\\?\\?([[:alpha:]])', E'"\\1', 'g');
                    result := regexp_replace(result, E'([[:alpha:]])\\?\\?\\?', E'\\1"', 'g');
                    result := replace(result, '???', '"');
                    RETURN result;
                END;
                $$;

                UPDATE functions
                SET "functionNumber" = public.normalize_question_mark_import_text("functionNumber"),
                    "functionTitle" = public.normalize_question_mark_import_text("functionTitle"),
                    "functionSummary" = public.normalize_question_mark_import_text("functionSummary");

                UPDATE components
                SET "componentNumber" = public.normalize_question_mark_import_text("componentNumber"),
                    "componentName" = public.normalize_question_mark_import_text("componentName"),
                    "componentSummary" = public.normalize_question_mark_import_text("componentSummary");

                UPDATE standards
                SET "standardNumber" = public.normalize_question_mark_import_text("standardNumber"),
                    "standardTitle" = public.normalize_question_mark_import_text("standardTitle"),
                    "standardSummary" = public.normalize_question_mark_import_text("standardSummary");

                UPDATE criteria
                SET "criterionNumber" = public.normalize_question_mark_import_text("criterionNumber"),
                    "criterionTitle" = public.normalize_question_mark_import_text("criterionTitle");

                UPDATE compliances
                SET "complianceNumber" = public.normalize_question_mark_import_text("complianceNumber"),
                    "complianceSummary" = public.normalize_question_mark_import_text("complianceSummary");

                UPDATE evidence
                SET "evidenceNumber" = public.normalize_question_mark_import_text("evidenceNumber"),
                    "evidenceSummary" = public.normalize_question_mark_import_text("evidenceSummary");

                DROP FUNCTION public.normalize_question_mark_import_text(text);
                """);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Text normalization is intentionally irreversible.
        }
    }
}
