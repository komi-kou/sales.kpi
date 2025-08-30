const { spawn } = require('child_process');
const path = require('path');

// Set environment variables
process.env.PORT = '5001';
process.env.JWT_SECRET = 'your-secret-key-change-this';

console.log('Starting Sales KPI Tracker...');

// Start backend
console.log('Starting backend on port 5001...');
const backend = spawn('node', ['server.js'], {
  cwd: path.join(__dirname, 'backend'),
  env: process.env,
  stdio: 'inherit'
});

// Wait a bit for backend to start
setTimeout(() => {
  console.log('Starting frontend on port 9911...');
  
  // Start frontend
  const frontend = spawn('npm', ['run', 'dev'], {
    cwd: path.join(__dirname, 'frontend'),
    env: process.env,
    stdio: 'inherit'
  });
  
  frontend.on('error', (err) => {
    console.error('Frontend error:', err);
  });
}, 3000);

backend.on('error', (err) => {
  console.error('Backend error:', err);
});

// Handle exit
process.on('SIGINT', () => {
  console.log('\nShutting down...');
  backend.kill();
  process.exit();
});