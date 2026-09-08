import test from "node:test";
import assert from "node:assert/strict";
import { canManageReferenceData } from "../src/utils/access.js";
import { getAccreditationStatusClass } from "../src/utils/accreditationStatus.js";

test("only administrators can manage reference data", () => {
  assert.equal(canManageReferenceData("Admin"), true);
  assert.equal(canManageReferenceData("Surveyor"), false);
  assert.equal(canManageReferenceData(undefined), false);
});

test("accreditation status colours communicate the right state", () => {
  assert.match(getAccreditationStatusClass("Not yet assessed"), /slate/);
  assert.match(getAccreditationStatusClass("Assessment in progress"), /sky/);
  assert.match(getAccreditationStatusClass("Accredited"), /emerald/);
  assert.match(getAccreditationStatusClass("Accreditation expired"), /red/);
});
