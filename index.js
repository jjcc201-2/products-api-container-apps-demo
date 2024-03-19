//CommonJS module syntax is used to import the express module. This can be changed to ES6 module syntax if desired.
const express = require('express');
const path = require('path');

const app = express();

// Middleware needed to parse JSON. Needed to be placed before the routes 
app.use(express.json());

// Define routes here
app.use('/api/products', require('./routes/api/products'))

// Server starts on port 3000, or whatever port is defined in the environment variable PORT
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
});
