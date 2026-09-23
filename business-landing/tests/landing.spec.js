import test from 'node:test';
import assert from 'node:assert/strict';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const htmlPath = path.resolve(__dirname, '../index.html');

test('Business Landing HTML Structure & Integrity', async (t) => {
  assert.ok(fs.existsSync(htmlPath), 'index.html must exist in stack root');
  const html = fs.readFileSync(htmlPath, 'utf8');

  await t.test('includes CDN script tags', () => {
    assert.ok(html.includes('cdn.tailwindcss.com'), 'Tailwind CSS CDN should be present');
    assert.ok(html.includes('alpinejs'), 'Alpine.js CDN should be present');
    assert.ok(html.includes('lucide'), 'Lucide Icons CDN should be present');
  });

  await t.test('includes semantic HTML5 landmarks', () => {
    assert.ok(html.includes('<header'), 'Header landmark must exist');
    assert.ok(html.includes('<main'), 'Main landmark must exist');
    assert.ok(html.includes('<section id="layanan"'), 'Layanan section must exist');
    assert.ok(html.includes('<section id="lokasi"'), 'Lokasi section must exist');
    assert.ok(html.includes('<section id="faq"'), 'FAQ section must exist');
    assert.ok(html.includes('<footer'), 'Footer landmark must exist');
  });

  await t.test('includes WhatsApp Click-to-Chat CTA links', () => {
    assert.ok(html.includes('https://wa.me/'), 'WhatsApp wa.me links must exist');
    assert.ok(html.includes('target="_blank"'), 'Outbound links should open in new tab');
    assert.ok(html.includes('rel="noopener noreferrer"'), 'Outbound links must have rel=noopener');
  });

  await t.test('includes responsive Google Maps embed', () => {
    assert.ok(html.includes('maps.google.com'), 'Google Maps iframe embed must exist');
    assert.ok(html.includes('aspect-video'), 'Map wrapper should have aspect ratio container');
  });

  await t.test('includes Alpine.js modal and mobile menu state hooks', () => {
    assert.ok(html.includes('x-data="{ mobileMenuOpen: false'), 'Alpine x-data root state must exist');
    assert.ok(html.includes('modalOpen'), 'Alpine modal state must exist');
    assert.ok(html.includes('x-cloak'), 'x-cloak must be used for layout stabilization');
  });
});
