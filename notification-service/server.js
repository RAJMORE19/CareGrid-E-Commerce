const express = require('express');
const cors = require('cors');
const app = express();
app.use(cors());
app.use(express.json());

let callbackRequests = [];

app.get('/health', (req, res) => res.json({ status: 'UP', service: 'notification-service' }));

app.post('/callback', (req, res) => {
  const { phone, query } = req.body;
  const entry = {
    id: 'REQ-' + Math.floor(1000 + Math.random() * 9000),
    phone: phone || '6353468394',
    query: query || 'General Diagnostic Consultation',
    time: new Date().toLocaleTimeString('en-IN'),
    status: 'Queued for Team Contact'
  };
  callbackRequests.unshift(entry);
  res.json({ success: true, message: 'Team will connect you shortly', request: entry });
});

app.get('/callbacks', (req, res) => res.json({ total: callbackRequests.length, requests: callbackRequests }));

app.listen(5006, () => console.log('Notification on 5006'));
