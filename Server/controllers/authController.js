const authService = require('../services/authService');
const { AppError } = require('../utils/errorHandler');

// Register controller
const register = async (req, res, next) => {
  try {
    const result = await authService.register(req.body);
    res.status(200).json(result);
  } catch (error) {
    next(error);
  }
};

// Login controller
const login = async (req, res, next) => {
  try {
    const result = await authService.login(req.body);
    res.status(200).json(result);
  } catch (error) {
    next(error);
  }
};

// Refresh token controller
const refreshToken = async (req, res, next) => {
  try {
    const { refresh_token } = req.body;
    
    if (!refresh_token) {
      return next(new AppError('Refresh token is required', 400));
    }
    
    const result = await authService.refreshToken(refresh_token);
    res.status(200).json(result);
  } catch (error) {
    next(error);
  }
};

// Logout controller
const logout = async (req, res, next) => {
  try {
    // In a real application, you might want to blacklist the token or
    // remove the refresh token from the database. For now, we'll just
    // return a success message
    res.status(200).json({
      message: 'Successfully logged out',
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  register,
  login,
  refreshToken,
  logout,
};
