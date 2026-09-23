import test from 'node:test';
import assert from 'node:assert/strict';
import {
  STATES,
  TRASH_TYPES,
  createInitialState,
  checkCollision,
  spawnTrashItem,
  updateEngine
} from '../main.js';

test('Retro Game Engine Core Mechanics', async (t) => {
  await t.test('initial state integrity', () => {
    const state = createInitialState();
    assert.equal(state.state, STATES.START);
    assert.equal(state.score, 0);
    assert.equal(state.lives, 3);
    assert.equal(state.player.x, 144);
    assert.equal(state.items.length, 0);
  });

  await t.test('AABB collision detection', () => {
    const boxA = { x: 10, y: 10, width: 20, height: 20 };
    const boxB = { x: 15, y: 15, width: 20, height: 20 };
    const boxC = { x: 50, y: 50, width: 20, height: 20 };

    assert.equal(checkCollision(boxA, boxB), true, 'Overlapping boxes should collide');
    assert.equal(checkCollision(boxA, boxC), false, 'Separated boxes should not collide');
  });

  await t.test('player movement constraints', () => {
    let state = createInitialState();
    state.state = STATES.PLAYING;

    // Move left beyond boundary
    state = updateEngine(state, 10, { left: true, right: false, actionTriggered: false });
    assert.equal(state.player.x, 0, 'Player X should be clamped at 0');

    // Move right beyond boundary
    state = updateEngine(state, 10, { left: false, right: true, actionTriggered: false });
    assert.equal(state.player.x, 320 - state.player.width, 'Player X should be clamped at screen width');
  });

  await t.test('bin switching on action triggered', () => {
    let state = createInitialState();
    state.state = STATES.PLAYING;
    assert.equal(state.player.currentBinType, 0);

    state = updateEngine(state, 0.016, { left: false, right: false, actionTriggered: true });
    assert.equal(state.player.currentBinType, 1);

    state = updateEngine(state, 0.016, { left: false, right: false, actionTriggered: true });
    assert.equal(state.player.currentBinType, 2);

    state = updateEngine(state, 0.016, { left: false, right: false, actionTriggered: true });
    assert.equal(state.player.currentBinType, 0, 'Should cycle back to 0');
  });

  await t.test('correct bin collection awards score', () => {
    let state = createInitialState();
    state.state = STATES.PLAYING;
    state.player.currentBinType = 0; // ORGANIC
    state.player.x = 100;
    state.player.y = 200;

    // Place matching item directly on player
    state.items = [{
      typeId: 'organic',
      typeIndex: 0,
      name: 'ORGANIC',
      color: '#a3be8c',
      x: 100,
      y: 200,
      width: 16,
      height: 16,
      speed: 100
    }];

    const sounds = [];
    state = updateEngine(state, 0.016, { left: false, right: false, actionTriggered: false }, (s) => sounds.push(s));

    assert.equal(state.score, 10, 'Score should increase by 10');
    assert.equal(state.lives, 3, 'Lives should remain unchanged');
    assert.equal(state.items.length, 0, 'Item should be collected');
    assert.ok(sounds.includes('score'), 'Should play score sound');
  });

  await t.test('game over transition when lives reach 0', () => {
    let state = createInitialState();
    state.state = STATES.PLAYING;
    state.lives = 1;
    state.player.currentBinType = 1; // PLASTIC

    // Drop organic item on plastic bin (wrong match)
    state.items = [{
      typeId: 'organic',
      typeIndex: 0,
      name: 'ORGANIC',
      color: '#a3be8c',
      x: 144,
      y: 200,
      width: 16,
      height: 16,
      speed: 100
    }];

    state = updateEngine(state, 0.016, { left: false, right: false, actionTriggered: false });
    assert.equal(state.lives, 0);
    assert.equal(state.state, STATES.GAMEOVER, 'State should transition to GAMEOVER');
  });
});
