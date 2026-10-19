import test from "node:test";
import assert from "node:assert/strict";
import { componentStandardIds, achievementPoints } from "../src/utils/reportScope.js";
test("component selection limits actual standard IDs, not just visible labels", () => {
  const items = [{standardId:1,componentNumber:"1"},{standardId:1,componentNumber:"1"},{standardId:2,componentNumber:"6"},{standardId:3}];
  assert.deepEqual(componentStandardIds(items,"1"),[1]);
  assert.deepEqual(componentStandardIds(items,"6"),[2]);
  assert.deepEqual(componentStandardIds(items,"2"),[]);
  assert.deepEqual(componentStandardIds(items),[1,2,3]);
});
test("achievement points exclude unscored, N/A and inapplicable requirements", () => {
  assert.deepEqual(achievementPoints([{scoreId:1,scoreValue:4},{scoreId:2,scoreValue:2},{scoreId:null,scoreValue:4},{scoreId:9,scoreValue:null},{scoreId:1,scoreValue:4,isApplicable:false}]),{earned:6,possible:8});
  assert.deepEqual(achievementPoints([]),{earned:0,possible:0});
});
