const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 8080 });
console.log("✅ WebSocket server running on ws://localhost:8080");

let clients = [];

wss.on('connection', ws => {
  clients.push(ws);
  console.log("🔗 New client connected, total:", clients.length);

  ws.on('message', message => {
    console.log("📨 Received:", message.toString());
    // Broadcast to all clients
    clients.forEach(client => {
      if (client.readyState === WebSocket.OPEN) {
        client.send(message.toString());
      }
    });
  });

  ws.on('close', () => {
    clients = clients.filter(c => c !== ws);
    console.log("❌ Client disconnected, total:", clients.length);
  });
});
