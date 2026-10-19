import test from "node:test";
import assert from "node:assert/strict";
import { canResetAndRemoveStandard } from "../src/utils/standardRemoval.js";

test("reset and removal requires a reason and explicit acknowledgement", () => {
  assert.equal(canResetAndRemoveStandard("Incorrect standard", false), false);
  assert.equal(canResetAndRemoveStandard(" ", true), false);
  assert.equal(canResetAndRemoveStandard(null, true), false);
  assert.equal(canResetAndRemoveStandard("Incorrect standard", true), true);
});
test("reset and removal blocks duplicate in-flight actions and overlong reasons", () => {
  assert.equal(canResetAndRemoveStandard("Incorrect standard", true, true), false);
  assert.equal(canResetAndRemoveStandard("x".repeat(2001), true), false);
  assert.equal(canResetAndRemoveStandard("x".repeat(2000), true), true);
});
