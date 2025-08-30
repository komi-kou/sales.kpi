const http = require('http');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Test server running on port 9911\n');
});

server.listen(9911, () => {
  console.log('Test server listening on port 9911');
});