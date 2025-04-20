const todoService = require('../services/todoService');

// Get all todos
const getAllTodos = async (req, res, next) => {
  try {
    const filters = {
      category: req.query.category,
      completed: req.query.completed,
      due_date: req.query.due_date,
    };
    
    const result = await todoService.getAllTodos(req.user._id, filters);
    res.status(200).json(result);
  } catch (error) {
    next(error);
  }
};

// Create todo
const createTodo = async (req, res, next) => {
  try {
    const result = await todoService.createTodo(req.user._id, req.body);
    res.status(201).json(result);
  } catch (error) {
    next(error);
  }
};

// Get single todo
const getTodo = async (req, res, next) => {
  try {
    const result = await todoService.getTodo(req.params.id, req.user._id);
    res.status(200).json(result);
  } catch (error) {
    next(error);
  }
};

// Update todo
const updateTodo = async (req, res, next) => {
  try {
    const result = await todoService.updateTodo(req.params.id, req.user._id, req.body);
    res.status(200).json(result);
  } catch (error) {
    next(error);
  }
};

// Delete todo
const deleteTodo = async (req, res, next) => {
  try {
    await todoService.deleteTodo(req.params.id, req.user._id);
    res.status(200).json({
      message: 'Todo deleted successfully',
    });
  } catch (error) {
    next(error);
  }
};

module.exports = {
  getAllTodos,
  createTodo,
  getTodo,
  updateTodo,
  deleteTodo,
};
