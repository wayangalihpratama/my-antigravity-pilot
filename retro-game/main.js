/**
 * Retro Edu Minigame Engine (Zero-Dependency & High Frame Rate)
 * Native internal resolution: 320x240
 */

export const STATES = {
  START: 'START',
  PLAYING: 'PLAYING',
  GAMEOVER: 'GAMEOVER',
  PAUSED: 'PAUSED'
};

export const TRASH_TYPES = [
  { id: 'organic', name: 'ORGANIC', color: '#a3be8c', icon: '🍎' },
  { id: 'plastic', name: 'PLASTIC', color: '#88c0d0', icon: '🥤' },
  { id: 'paper', name: 'PAPER', color: '#ebcb8b', icon: '📄' }
];

export function createInitialState() {
  return {
    state: STATES.START,
    score: 0,
    hiScore: 0,
    lives: 3,
    player: {
      x: 144,
      y: 200,
      width: 32,
      height: 24,
      speed: 180,
      currentBinType: 0 // index in TRASH_TYPES
    },
    items: [],
    spawnTimer: 0,
    spawnInterval: 1.8,
    speedMultiplier: 1
  };
}

export function checkCollision(a, b) {
  return (
    a.x < b.x + b.width &&
    a.x + a.width > b.x &&
    a.y < b.y + b.height &&
    a.y + a.height > b.y
  );
}

export function spawnTrashItem(width = 320) {
  const typeIndex = Math.floor(Math.random() * TRASH_TYPES.length);
  const type = TRASH_TYPES[typeIndex];
  const size = 16;
  const x = Math.floor(Math.random() * (width - size - 20)) + 10;
  return {
    typeId: type.id,
    typeIndex,
    name: type.name,
    color: type.color,
    icon: type.icon,
    x,
    y: -20,
    width: size,
    height: size,
    speed: 70
  };
}

export function updateEngine(gameState, dt, input, audioCallback = null) {
  if (gameState.state !== STATES.PLAYING) {
    return gameState;
  }

  // Handle Player Movement
  if (input.left) {
    gameState.player.x -= gameState.player.speed * dt;
  }
  if (input.right) {
    gameState.player.x += gameState.player.speed * dt;
  }

  // Constrain player to screen bounds (320px width)
  if (gameState.player.x < 0) gameState.player.x = 0;
  if (gameState.player.x + gameState.player.width > 320) {
    gameState.player.x = 320 - gameState.player.width;
  }

  // Switch Bin Type on Action Input
  if (input.actionTriggered) {
    gameState.player.currentBinType = (gameState.player.currentBinType + 1) % TRASH_TYPES.length;
    if (audioCallback) audioCallback('switch');
  }

  // Spawner logic
  gameState.spawnTimer += dt;
  if (gameState.spawnTimer >= gameState.spawnInterval) {
    gameState.spawnTimer = 0;
    gameState.items.push(spawnTrashItem(320));
  }

  // Update Falling Items & Collisions
  const remainingItems = [];
  for (const item of gameState.items) {
    item.y += (item.speed * gameState.speedMultiplier) * dt;

    // Check collision with player bin
    if (checkCollision(item, gameState.player)) {
      const correctBin = gameState.player.currentBinType === item.typeIndex;
      if (correctBin) {
        gameState.score += 10;
        if (gameState.score > gameState.hiScore) gameState.hiScore = gameState.score;
        if (audioCallback) audioCallback('score');
      } else {
        gameState.lives -= 1;
        if (audioCallback) audioCallback('hit');
      }
      continue; // Item collected
    }

    // Check if missed bottom
    if (item.y > 240) {
      gameState.lives -= 1;
      if (audioCallback) audioCallback('hit');
      continue;
    }

    remainingItems.push(item);
  }

  gameState.items = remainingItems;

  // Check Game Over
  if (gameState.lives <= 0) {
    gameState.state = STATES.GAMEOVER;
    if (audioCallback) audioCallback('gameover');
  }

  return gameState;
}

// ---- Audio Synthesizer (Zero external assets) -----------------------------
let audioCtx = null;

function getAudioContext() {
  if (typeof window === 'undefined') return null;
  if (!audioCtx) {
    const AudioContextClass = window.AudioContext || window.webkitAudioContext;
    if (AudioContextClass) audioCtx = new AudioContextClass();
  }
  if (audioCtx && audioCtx.state === 'suspended') {
    audioCtx.resume();
  }
  return audioCtx;
}

export function playRetroSound(type) {
  const ctx = getAudioContext();
  if (!ctx) return;

  const now = ctx.currentTime;
  const osc = ctx.createOscillator();
  const gain = ctx.createGain();
  osc.connect(gain);
  gain.connect(ctx.destination);

  if (type === 'score') {
    osc.type = 'square';
    osc.frequency.setValueAtTime(587.33, now); // D5
    osc.frequency.setValueAtTime(880, now + 0.08); // A5
    gain.gain.setValueAtTime(0.12, now);
    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.25);
    osc.start(now);
    osc.stop(now + 0.25);
  } else if (type === 'hit') {
    osc.type = 'sawtooth';
    osc.frequency.setValueAtTime(220, now);
    osc.frequency.exponentialRampToValueAtTime(50, now + 0.2);
    gain.gain.setValueAtTime(0.15, now);
    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.2);
    osc.start(now);
    osc.stop(now + 0.2);
  } else if (type === 'switch') {
    osc.type = 'sine';
    osc.frequency.setValueAtTime(440, now);
    gain.gain.setValueAtTime(0.08, now);
    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.08);
    osc.start(now);
    osc.stop(now + 0.08);
  } else if (type === 'gameover') {
    osc.type = 'sawtooth';
    osc.frequency.setValueAtTime(180, now);
    osc.frequency.setValueAtTime(140, now + 0.15);
    osc.frequency.setValueAtTime(100, now + 0.3);
    gain.gain.setValueAtTime(0.15, now);
    gain.gain.exponentialRampToValueAtTime(0.001, now + 0.5);
    osc.start(now);
    osc.stop(now + 0.5);
  }
}

// ---- Client Browser Setup & Loop ------------------------------------------
if (typeof window !== 'undefined' && typeof document !== 'undefined') {
  let gameState = createInitialState();
  let lastTime = performance.now();

  const canvas = document.getElementById('gameCanvas');
  const ctx = canvas.getContext('2d');
  const scoreDisplay = document.getElementById('score-display');
  const hiDisplay = document.getElementById('hi-display');
  const livesDisplay = document.getElementById('lives-display');

  const input = { left: false, right: false, actionTriggered: false };

  // Keyboard events
  window.addEventListener('keydown', (e) => {
    getAudioContext();
    if (gameState.state === STATES.START || gameState.state === STATES.GAMEOVER) {
      if (e.code === 'Space' || e.code === 'Enter') {
        gameState = createInitialState();
        gameState.state = STATES.PLAYING;
      }
    }
    if (e.code === 'ArrowLeft' || e.code === 'KeyA') input.left = true;
    if (e.code === 'ArrowRight' || e.code === 'KeyD') input.right = true;
    if (e.code === 'Space' || e.code === 'KeyZ') input.actionTriggered = true;
  });

  window.addEventListener('keyup', (e) => {
    if (e.code === 'ArrowLeft' || e.code === 'KeyA') input.left = false;
    if (e.code === 'ArrowRight' || e.code === 'KeyD') input.right = false;
  });

  // Touch Virtual Buttons
  const btnLeft = document.getElementById('btn-left');
  const btnRight = document.getElementById('btn-right');
  const btnAction = document.getElementById('btn-action');

  const setupTouch = (btn, onStart, onEnd) => {
    btn.addEventListener('touchstart', (e) => { e.preventDefault(); getAudioContext(); onStart(); });
    btn.addEventListener('touchend', (e) => { e.preventDefault(); onEnd(); });
    btn.addEventListener('mousedown', () => { getAudioContext(); onStart(); });
    btn.addEventListener('mouseup', () => { onEnd(); });
  };

  setupTouch(btnLeft, () => { input.left = true; btnLeft.classList.add('active'); }, () => { input.left = false; btnLeft.classList.remove('active'); });
  setupTouch(btnRight, () => { input.right = true; btnRight.classList.add('active'); }, () => { input.right = false; btnRight.classList.remove('active'); });
  setupTouch(btnAction, () => {
    if (gameState.state === STATES.START || gameState.state === STATES.GAMEOVER) {
      gameState = createInitialState();
      gameState.state = STATES.PLAYING;
    } else {
      input.actionTriggered = true;
    }
    btnAction.classList.add('active');
  }, () => {
    btnAction.classList.remove('active');
  });

  // Render loop
  function render() {
    // Clear canvas
    ctx.fillStyle = '#0f111a';
    ctx.fillRect(0, 0, 320, 240);

    if (gameState.state === STATES.START) {
      ctx.fillStyle = '#88c0d0';
      ctx.font = '16px monospace';
      ctx.textAlign = 'center';
      ctx.fillText('ECO ARCADE SORT', 160, 80);

      ctx.fillStyle = '#d8dee9';
      ctx.font = '10px monospace';
      ctx.fillText('Tangkap sampah dengan tong yang benar!', 160, 110);
      ctx.fillText('Tombol A / Space: Ganti Tong', 160, 130);
      ctx.fillText('Tombol ◀ ▶ / A D: Geser', 160, 145);

      ctx.fillStyle = '#a3be8c';
      ctx.font = '12px monospace';
      ctx.fillText('TEKAN [A] ATAU [SPASI] MULAI', 160, 185);
      return;
    }

    if (gameState.state === STATES.GAMEOVER) {
      ctx.fillStyle = '#bf616a';
      ctx.font = '20px monospace';
      ctx.textAlign = 'center';
      ctx.fillText('GAME OVER', 160, 90);

      ctx.fillStyle = '#d8dee9';
      ctx.font = '12px monospace';
      ctx.fillText(`Skor Akhir: ${gameState.score}`, 160, 125);

      ctx.fillStyle = '#ebcb8b';
      ctx.font = '11px monospace';
      ctx.fillText('TEKAN [A] UNTUK MAIN LAGI', 160, 170);
      return;
    }

    // Draw Falling Trash Items
    for (const item of gameState.items) {
      ctx.fillStyle = item.color;
      ctx.fillRect(item.x, item.y, item.width, item.height);
      ctx.fillStyle = '#2e3440';
      ctx.font = '9px monospace';
      ctx.textAlign = 'center';
      ctx.fillText(item.name[0], item.x + item.width / 2, item.y + item.height - 4);
    }

    // Draw Player Bin
    const currentType = TRASH_TYPES[gameState.player.currentBinType];
    ctx.fillStyle = currentType.color;
    ctx.fillRect(gameState.player.x, gameState.player.y, gameState.player.width, gameState.player.height);

    // Bin label
    ctx.fillStyle = '#2e3440';
    ctx.font = 'bold 8px monospace';
    ctx.textAlign = 'center';
    ctx.fillText(currentType.name, gameState.player.x + gameState.player.width / 2, gameState.player.y + 14);

    // Update HUD
    scoreDisplay.textContent = gameState.score;
    hiDisplay.textContent = gameState.hiScore;
    livesDisplay.textContent = '❤'.repeat(Math.max(0, gameState.lives));
  }

  function gameLoop(now) {
    const dt = Math.min((now - lastTime) / 1000, 0.1);
    lastTime = now;

    updateEngine(gameState, dt, input, playRetroSound);
    input.actionTriggered = false; // reset single-frame trigger

    render();
    requestAnimationFrame(gameLoop);
  }

  requestAnimationFrame(gameLoop);
}
