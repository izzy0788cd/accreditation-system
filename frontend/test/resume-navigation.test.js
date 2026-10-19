import test from 'node:test';
import assert from 'node:assert/strict';
import { createResumeNavigation } from '../src/utils/resumeNavigation.js';

test('risk/score refreshes and standard selection do not replay a consumed resume scroll', () => {
  const navigation = createResumeNavigation();
  navigation.visit('entry-1:survey-1:resume-42');
  assert.equal(navigation.isPending('entry-1:survey-1:resume-42'), true);
  navigation.complete('entry-1:survey-1:resume-42');
  for (let refresh = 0; refresh < 5; refresh++) {
    navigation.visit('entry-1:survey-1:resume-42');
    assert.equal(navigation.isPending('entry-1:survey-1:resume-42'), false);
  }
});

test('loading and cancelled effects leave resume pending until the target renders', () => {
  const navigation = createResumeNavigation();
  navigation.visit('a');
  navigation.visit('a');
  assert.equal(navigation.isPending('a'), true);
});

test('a deliberate link, same-target link, or back navigation can scroll again', () => {
  const navigation = createResumeNavigation();
  for (const key of ['entry-1:42', 'entry-2:42', 'entry-3:99', 'entry-1:42']) {
    navigation.visit(key);
    assert.equal(navigation.isPending(key), true);
    navigation.complete(key);
    assert.equal(navigation.isPending(key), false);
  }
});

test('a stale callback cannot consume the current navigation', () => {
  const navigation = createResumeNavigation();
  navigation.visit('old');
  navigation.visit('new');
  navigation.complete('old');
  assert.equal(navigation.isPending('old'), false);
  assert.equal(navigation.isPending('new'), true);
});
