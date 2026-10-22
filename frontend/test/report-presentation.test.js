import test from "node:test";
import assert from "node:assert/strict";
import { createServer } from "vite";
import React from "react";
import { renderToStaticMarkup } from "react-dom/server";

test("report hides structured personnel names and readiness without changing source records", async () => {
  const server = await createServer({ server: { middlewareMode: true }, appType: "custom" });
  try {
    const { default: Document } = await server.ssrLoadModule("/src/pages/reports/SurveyReportDocument.jsx");
    const report = {
      survey: { surveyId: 1, facilityName: "Test facility", surveyType: "External", teamLead: "LeadPerson" },
      internalSurvey: { surveyId: 2 },
      items: [{ complianceId: 1, standardId: 1, scoreId: 1, scoreValue: 4, surveyorName: "SurveyPerson" }],
      internalItems: [{ complianceId: 1, scoreId: 1, surveyorName: "InternalPerson" }],
      standards: [{ id: 1, number: "1", title: "Test" }], included: ["signoff"],
      savedVersion: { versionNumber: 1, createdBy: "CreatorPerson" },
      approval: { approvedBy: "ApproverPerson" }, reviewerName: "ReviewerPerson",
    };
    const render = value => renderToStaticMarkup(React.createElement(Document, { report: value }));
    const visible = render(report);
    const hidden = render({ ...report, includePersonnelNames: false });
    for (const name of ["LeadPerson", "SurveyPerson", "InternalPerson", "CreatorPerson", "ApproverPerson"]) {
      assert.ok(visible.includes(name), name);
      assert.ok(!hidden.includes(name), name);
    }
    const draft = { ...report, approval: null };
    assert.ok(render(draft).includes("ReviewerPerson"));
    assert.ok(!render({ ...draft, includePersonnelNames: false }).includes("ReviewerPerson"));
    assert.ok(!render({ ...report, included: ["summary"] }).includes("Standard summation readiness"));
    assert.equal(report.survey.teamLead, "LeadPerson");
  } finally {
    await server.close();
  }
});
