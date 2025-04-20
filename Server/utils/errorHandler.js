// Custom Error class
class AppError extends Error {
  constructor(message, statusCode) {
    super(message);
    this.statusCode = statusCode;
    this.status = `${statusCode}`.startsWith('4') ? 'fail' : 'error';
    this.isOperational = true;

    Error.captureStackTrace(this, this.constructor);
  }
}

// Handle Mongoose validation errors
const handleValidationError = (err) => {
  const errors = {};
  
  Object.values(err.errors).forEach((error) => {
    errors[error.path] = [error.message];
  });
  
  return {
    status: 400,
    message: 'Validation failed',
    errors,
  };
};

// Handle duplicate key errors from MongoDB
const handleDuplicateKeyError = (err) => {
  const field = Object.keys(err.keyValue)[0];
  const message = `${field.charAt(0).toUpperCase() + field.slice(1)} is already in use`;
  
  return {
    status: 400,
    message: 'Validation failed',
    errors: {
      [field]: [message],
    },
  };
};

module.exports = {
  AppError,
  handleValidationError,
  handleDuplicateKeyError,
};
