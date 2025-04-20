const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');
const config = require('./config/config');
const errorHandler = require('./middlewares/error');
const logger = require('./middlewares/logger');

// Import routes
const authRoutes = require('./routes/authRoutes');
const todoRoutes = require('./routes/todoRoutes');

// Initialize express app
const app = express();

// Connect to database
connectDB();

// Middleware
app.use(cors());
app.use(express.json());
app.use(logger);

// Routes
app.use('/auth', authRoutes);
app.use('/todos', todoRoutes);

// Health check route
app.get('/', (req, res) => {
    res.json({ message: 'Todo App API is running' });
});

// Error handling middleware
app.use(errorHandler);

// Handle 404 errors
app.use('*', (req, res) => {
    res.status(404).json({
        status: 404,
        message: 'Route not found',
    });
});

// Start server
const PORT = config.PORT;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
    console.log(`Logging enabled - check logs directory for details`);
});
