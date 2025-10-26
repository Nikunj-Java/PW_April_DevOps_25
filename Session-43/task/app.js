import express from 'express';
import os from 'os';
const app = express();
const port = 3000;

app.get('/', (req, res) => {
    const userInfo = os.hostname();
    res.send(`<html><body><h1>Hello from ${userInfo}!</h1> <p> this response came from <strong>${userInfo}</strong></p></body></html>`);
   
});

app.get('/health', (req, res) => {
    res.status(200).send('OK');
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
