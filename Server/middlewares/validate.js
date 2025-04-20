const { AppError } = require('../utils/errorHandler');

// Validate registration data
const validateRegister = (req, res, next) => {
  const { username, email, password } = req.body;
  const errors = {};

  // Validate username
  if (!username) {
    errors.username = ['Username is required'];
  } else if (username.length < 3) {
    errors.username = ['Username must be at least 3 characters'];
  }

  // Validate email
  if (!email) {
    errors.email = ['Email is required'];
  } else if (!isValidEmail(email)) {
    errors.email = ['The email must be a valid email address'];
  }

  // Validate password
  if (!password) {
    errors.password = ['Password is required'];
  } else if (password.length < 6) {
    errors.password = ['The password must be at least 6 characters'];
  }

  // If there are errors, return error response
  if (Object.keys(errors).length > 0) {
    return next(
      new AppError('Validation failed', 400, {
        message: 'Validation failed',
        errors,
      })
    );
  }

  next();
};

// Validate login data
const validateLogin = (req, res, next) => {
  const { username, password } = req.body;
  const errors = {};

  if (!username) {
    errors.username = ['Username is required'];
  }

  if (!password) {
    errors.password = ['Password is required'];
  }

  if (Object.keys(errors).length > 0) {
    return next(
      new AppError('Validation failed', 400, {
        message: 'Validation failed',
        errors,
      })
    );
  }

  next();
};

// Validate todo data
const validateTodo = (req, res, next) => {
  const { title, category } = req.body;
  const errors = {};

  if (!title) {
    errors.title = ['Title is required'];
  }

  const validCategories = ['Work', 'Personal', 'Shopping', 'Health', 'Education', 'Finance', 'Other'];
  if (category && !validCategories.includes(category)) {
    errors.category = [`Category must be one of: ${validCategories.join(', ')}`];
  }

  if (Object.keys(errors).length > 0) {
    return next(
      new AppError('Validation failed', 400, {
        message: 'Validation failed',
        errors,
      })
    );
  }

  next();
};

// Helper function to validate email
const isValidEmail = (email) => {
  const emailRegex = /^\S+@\S+\.\S+$/;
  return emailRegex.test(email);
};

module.exports = {
  validateRegister,
  validateLogin,
  validateTodo,
};
