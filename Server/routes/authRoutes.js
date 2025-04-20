const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');
const { validateRegister, validateLogin } = require('../middlewares/validate');
const { protect } = require('../middlewares/auth');

// Register route
router.post('/register', validateRegister, authController.register);

// Login route
router.post('/login', validateLogin, authController.login);

// Refresh token route
router.post('/refresh', authController.refreshToken);

// Logout route
router.delete('/logout', protect, authController.logout);

module.exports = router;
