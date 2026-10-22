import test from "node:test";
import assert from "node:assert/strict";
import { createServer } from "vite";
import { parseHTML } from "linkedom";
import React from "react";
import { renderToStaticMarkup } from "react-dom/server";
import { Packer } from "docx";
import JSZip from "jszip";
import { writeFile } from "node:fs/promises";
import { reportWordDocument } from "../src/utils/reportWord.js";

test("Word export preserves selected preview, comparison, evidence and name visibility", async () => {
  const server = await createServer({ server: { middlewareMode: true }, appType: "custom" });
  try {
    const { default: Report } = await server.ssrLoadModule("/src/pages/reports/SurveyReportDocument.jsx");
    const report = {
      survey: { surveyId: 36, facilityName: "Example facility", surveyType: "External", teamLead: "LeadPrivate", startDate: "2026-10-01", endDate: "2026-10-03" },
      internalSurvey: { surveyId: 2, startDate: "2026-09-01", endDate: "2026-09-03" },
      internalItems: [{ complianceId: 1, scoreId: 1, scoreValue: 4, surveyorName: "InternalPrivate", complianceComments: "Internal findings", evidence: [] }],
      items: [{ complianceAssessmentId: 1, complianceId: 1, standardId: 1, standardNumber: "1", criterionNumber: "1.1", criterionTitle: "Organisation", complianceNumber: "1.1.1", complianceSummary: "A documented governance structure", scoreId: 1, scoreValue: 2, surveyorName: "SurveyPrivate", complianceComments: "Improve documentation\nReview the current structure", evidence: [{ evidenceId: 1, evidenceNumber: "1", evidenceSummary: "Approved chart", isApplicable: true, isChecked: false }] }],
      standards: [{ id: 1, number: "1", title: "Governance" }],
      included: ["summary", "standards", "findings", "evidence", "signoff"], mode: "full",
      reviewerName: "ReviewerPrivate", generatedAt: "2026-10-22T00:00:00Z", includePersonnelNames: false,
    };
    const exportXml = async value => {
      const { document } = parseHTML(`<html><body>${renderToStaticMarkup(React.createElement(Report, { report: value }))}</body></html>`);
      const buffer = await Packer.toBuffer(reportWordDocument(document.querySelector("article")));
      if (process.env.REPORT_WORD_QA_PATH) await writeFile(process.env.REPORT_WORD_QA_PATH, buffer);
      const zip = await JSZip.loadAsync(buffer);
      return zip.file("word/document.xml").async("string");
    };
    const hidden = await exportXml(report);
    for (const value of ["Example facility", "Improve documentation", "Internal findings", "Approved chart", "No", "Assessment distribution"]) assert.ok(hidden.includes(value), value);
    for (const value of ["LeadPrivate", "InternalPrivate", "SurveyPrivate", "ReviewerPrivate", "Standard summation readiness"]) assert.ok(!hidden.includes(value), value);
    assert.ok(hidden.includes("w:tblHeader"));
    assert.ok(hidden.includes('w:w="11906"'));
    const shown = await exportXml({ ...report, includePersonnelNames: true });
    for (const value of ["LeadPrivate", "InternalPrivate", "SurveyPrivate", "ReviewerPrivate"]) assert.ok(shown.includes(value), value);
    const summary = await exportXml({ ...report, included: ["standards"] });
    assert.ok(!summary.includes("Approved chart"));
    assert.ok(!summary.includes("Internal findings"));
    if (process.env.REPORT_WORD_QA_PATH) await exportXml(report);
  } finally { await server.close(); }
});
