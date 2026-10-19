import test from 'node:test';
import assert from 'node:assert/strict';
import { readSurveyResume, rememberSurveyResume } from '../src/utils/surveyResume.js';

test('resume follows assessment, summation, next standard and handover', () => {
  const store = new Map();
  globalThis.localStorage = { getItem: key => store.get(key), setItem: (key, value) => store.set(key, value) };
  rememberSurveyResume(10, 1, { assessmentId: 42 });
  assert.equal(readSurveyResume(10, 1), '/surveys/1?resume=42');
  rememberSurveyResume(10, 1, { step: 'summation', standardId: 3, nextStandardId: 9 });
  assert.equal(readSurveyResume(10, 1), '/surveys/1/standards/3/summary?resumeStep=summation&next=9');
  rememberSurveyResume(10, 1, { standardId: 9 });
  assert.equal(readSurveyResume(10, 1), '/surveys/1?standard=9');
  rememberSurveyResume(10, 1, { step: 'handover' });
  assert.equal(readSurveyResume(10, 1), '/surveys/1/report?resumeStep=summations');
  assert.equal(readSurveyResume(11, 1), null);
  assert.equal(readSurveyResume(10, 2), null);
});

test('legacy entries and unavailable storage do not break resume', () => {
  globalThis.localStorage = { getItem: () => JSON.stringify({ assessmentId: 7 }) };
  assert.equal(readSurveyResume(10, 1), '/surveys/1?resume=7');
  globalThis.localStorage = { getItem: () => { throw Error('blocked'); }, setItem: () => { throw Error('blocked'); } };
  assert.equal(readSurveyResume(10, 1), null);
  assert.doesNotThrow(() => rememberSurveyResume(10, 1, { standardId: 9 }));
});
