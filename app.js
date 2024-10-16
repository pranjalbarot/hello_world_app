// Import the express module
const express = require('express');

// Create an instance of an Express app
const app = express();

// Define a route for the root URL that responds with "Hello World"
app.get('/', (req, res) => {
  res.send('Hello World');
});

// Start the server on port 3000
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
