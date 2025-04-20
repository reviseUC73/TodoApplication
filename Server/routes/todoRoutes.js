const express = require('express');
const router = express.Router();
const todoController = require('../controllers/todoController');
const { protect } = require('../middlewares/auth');
const { validateTodo } = require('../middlewares/validate');

// Apply authentication middleware to all routes
router.use(protect);

// Get all todos and create todo
router.route('/')
  .get(todoController.getAllTodos)
  .post(validateTodo, todoController.createTodo);

// Get, update, and delete a single todo
router.route('/:id')
  .get(todoController.getTodo)
  .put(validateTodo, todoController.updateTodo)
  .delete(todoController.deleteTodo);

module.exports = router;
