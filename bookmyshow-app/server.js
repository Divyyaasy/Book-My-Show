const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files from React build
app.use(express.static(path.join(__dirname, 'bookmyshow-app/build')));

// API endpoint for health check
app.get('/api/health', (req, res) => {
    res.json({ status: 'OK', message: 'BookMyShow API is running' });
});

// All other requests go to React app
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'bookmyshow-app/build', 'index.html'));
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
