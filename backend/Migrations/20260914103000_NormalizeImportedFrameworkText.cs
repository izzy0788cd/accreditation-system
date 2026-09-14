using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Infrastructure;
using backend.Data;

#nullable disable

namespace backend.Migrations
{
    /// <inheritdoc />
    [DbContext(typeof(AppDbContext))]
    [Migration("20260914103000_NormalizeImportedFrameworkText")]
    public partial class NormalizeImportedFrameworkText : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql("""
                CREATE FUNCTION public.normalize_imported_framework_text(input text)
                RETURNS text
                LANGUAGE plpgsql
                IMMUTABLE
                AS $$
                DECLARE
                    result text := input;
                BEGIN
                    result := replace(result, U&'\0393\00C7\00D6', '''');
                    result := replace(result, U&'\0393\00C7\00F6', '-');
                    result := replace(result, U&'\0393\00C7\00A3', '"');
                    result := replace(result, U&'\0393\00C7\00A5', '"');
                    result := replace(result, U&'\0393\00C7\00FF', '''');
                    result := replace(result, U&'\0393\00C7\00F3', '-');
                    result := replace(result, U&'\0393\00C7\00F4', '-');
                    result := replace(result, U&'\2229\00E2\00FF', '-');
                    result := replace(result, U&'\2229\00E2\2591', '-');
                    result := replace(result, U&'\2229\00E9\2591', '°');
                    result := replace(result, U&'\0393\00EB\00F1', '<=');
                    result := replace(result, U&'G\FFFD\FFFDs', '''s');
                    result := replace(result, U&'G\01E3', '"');
                    result := replace(result, U&'G\01E5', '"');
                    result := replace(result, U&'n\FFFD', '°');
                    RETURN result;
                END;
                $$;

                UPDATE functions
                SET "functionNumber" = public.normalize_imported_framework_text("functionNumber"),
                    "functionTitle" = public.normalize_imported_framework_text("functionTitle"),
                    "functionSummary" = public.normalize_imported_framework_text("functionSummary");

                UPDATE components
                SET "componentNumber" = public.normalize_imported_framework_text("componentNumber"),
                    "componentName" = public.normalize_imported_framework_text("componentName"),
                    "componentSummary" = public.normalize_imported_framework_text("componentSummary");

                UPDATE standards
                SET "standardNumber" = public.normalize_imported_framework_text("standardNumber"),
                    "standardTitle" = public.normalize_imported_framework_text("standardTitle"),
                    "standardSummary" = public.normalize_imported_framework_text("standardSummary");

                UPDATE criteria
                SET "criterionNumber" = public.normalize_imported_framework_text("criterionNumber"),
                    "criterionTitle" = public.normalize_imported_framework_text("criterionTitle");

                UPDATE compliances
                SET "complianceNumber" = public.normalize_imported_framework_text("complianceNumber"),
                    "complianceSummary" = public.normalize_imported_framework_text("complianceSummary");

                UPDATE evidence
                SET "evidenceNumber" = public.normalize_imported_framework_text("evidenceNumber"),
                    "evidenceSummary" = public.normalize_imported_framework_text("evidenceSummary");

                DROP FUNCTION public.normalize_imported_framework_text(text);
                """);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Text normalization is intentionally irreversible.
        }
    }
}
