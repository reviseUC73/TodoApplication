const User = require('../models/User');
const { AppError } = require('../utils/errorHandler');
const { generateAccessToken, generateRefreshToken, verifyRefreshToken } = require('../utils/jwt');

// Register new user
const register = async (userData) => {
  const { username, email, password } = userData;

  // Check if user already exists
  const existingUser = await User.findOne({
    $or: [{ email }, { username }],
  });

  if (existingUser) {
    const field = existingUser.email === email ? 'email' : 'username';
    throw new AppError(`${field.charAt(0).toUpperCase() + field.slice(1)} is already in use`, 400);
  }

  // Create new user
  const user = await User.create({
    username,
    email,
    password,
  });

  // Generate tokens
  const access_token = generateAccessToken(user._id);
  const refresh_token = generateRefreshToken(user._id);

  return {
    access_token,
    refresh_token,
    expires_in: 3600,
    user: {
      id: user._id,
      username: user.username,
      email: user.email,
      created_at: user.created_at,
    },
  };
};

// Login user
const login = async (userData) => {
  const { username, password } = userData;

  // Find user
  const user = await User.findOne({ username }).select('+password');

  if (!user || !(await user.comparePassword(password))) {
    throw new AppError('Invalid username or password', 401);
  }

  // Generate tokens
  const access_token = generateAccessToken(user._id);
  const refresh_token = generateRefreshToken(user._id);

  return {
    access_token,
    refresh_token,
    expires_in: 3600,
    user: {
      id: user._id,
      username: user.username,
      email: user.email,
      created_at: user.created_at,
    },
  };
};

// Refresh token
const refreshToken = async (refreshToken) => {
  try {
    // Verify refresh token
    const decoded = verifyRefreshToken(refreshToken);

    // Find user
    const user = await User.findById(decoded.id);
    if (!user) {
      throw new AppError('Invalid refresh token', 401);
    }

    // Generate new tokens
    const access_token = generateAccessToken(user._id);
    const new_refresh_token = generateRefreshToken(user._id);

    return {
      access_token,
      refresh_token: new_refresh_token,
      expires_in: 3600,
      user: {
        id: user._id,
        username: user.username,
        email: user.email,
        created_at: user.created_at,
      },
    };
  } catch (error) {
    throw new AppError('Invalid refresh token', 401);
  }
};

module.exports = {
  register,
  login,
  refreshToken,
};
