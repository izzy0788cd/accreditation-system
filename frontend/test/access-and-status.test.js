import test from "node:test";
import assert from "node:assert/strict";
import { canManageReferenceData, hasCapability, policyNames } from "../src/utils/access.js";
import { getAccreditationStatusClass } from "../src/utils/accreditationStatus.js";

test("only administrators can manage reference data", () => {
  assert.equal(canManageReferenceData("Admin"), true);
  assert.equal(canManageReferenceData("Surveyor"), false);
  assert.equal(canManageReferenceData(undefined), false);
});

test("named policies allow supported roles and reject unknown roles", () => {
  for (const role of ["Admin", "Surveyor", "Team Lead", "User", "Viewer"]) assert.equal(hasCapability(role, policyNames.referenceRead), true);
  for (const role of ["Preceptor", "Secretariat", "Survey Team Lead", null]) assert.equal(hasCapability(role, policyNames.referenceRead), false);
  assert.equal(hasCapability("Team Lead", policyNames.reportsGenerate), true);
  assert.equal(hasCapability("Viewer", policyNames.reportsGenerate), false);
});

test("accreditation status colours communicate the right state", () => {
  assert.match(getAccreditationStatusClass("Not yet assessed"), /slate/);
  assert.match(getAccreditationStatusClass("Assessment in progress"), /sky/);
  assert.match(getAccreditationStatusClass("Accredited"), /emerald/);
  assert.match(getAccreditationStatusClass("Accreditation expired"), /red/);
});
