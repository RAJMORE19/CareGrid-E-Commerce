const express = require('express');
const cors = require('cors');
const app = express();
app.use(cors());
app.get('/health', (req, res) => res.json({ status: 'UP', service: 'auth-service' }));
app.listen(5001, () => console.log('Auth listening on 5001'));
