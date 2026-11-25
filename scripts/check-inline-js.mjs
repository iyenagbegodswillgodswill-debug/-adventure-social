import { readFileSync } from 'node:fs';
import { spawnSync } from 'node:child_process';

const files = [
  'index.html', 'admin.html', 'support.html', 'account.html',
  'messages.html', 'news.html', 'marketplace.html', 'discover.html',
  'notifications.html', 'policies.html'
];
let failed = false;
for (const file of files) {
  let html;
  try { html = readFileSync(file, 'utf8'); }
  catch (error) { console.error('Cannot read ' + file + ': ' + error.message); failed = true; continue; }
  const scripts = [...html.matchAll(/<script\\b[^>]*>([\\s\\S]*?)<\\/script>/gi)].map(match => match[1]).filter(code => code.trim());
  for (let i = 0; i < scripts.length; i++) {
    const result = spawnSync(process.execPath, ['--check', '--input-type=module'], { input: scripts[i], encoding: 'utf8' });
    if (result.status !== 0) {
      console.error('JavaScript syntax error in ' + file + ' inline script ' + (i + 1) + ':');
      console.error(result.stderr || result.stdout);
      failed = true;
    }
  }
  if (!scripts.length) console.log(file + ': no inline scripts');
  else if (!failed) console.log(file + ': ' + scripts.length + ' inline script(s) passed');
}
if (failed) process.exit(1);
console.log('Adventure inline JavaScript syntax checks passed.');
