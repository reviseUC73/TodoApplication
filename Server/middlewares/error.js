const { handleValidationError, handleDuplicateKeyError } = require('../utils/errorHandler');

const errorHandler = (err, req, res, next) => {
  let error = { ...err };
  error.message = err.message;
  error.stack = err.stack;

  // Log error for debugging
  console.error('ERROR 💥', err);

  // Mongoose validation error
  if (err.name === 'ValidationError') {
    error = handleValidationError(err);
  }

  // Mongoose duplicate key error
  if (err.code === 11000) {
    error = handleDuplicateKeyError(err);
  }

  // JWT errors are handled in auth middleware

  // Send error response
  return res.status(error.statusCode || error.status || 500).json({
    status: error.status || error.statusCode || 500,
    message: error.message || 'Something went wrong',
    errors: error.errors || null,
    stack: process.env.NODE_ENV === 'development' ? error.stack : undefined,
  });
};

module.exports = errorHandler;
