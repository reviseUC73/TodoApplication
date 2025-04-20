const Todo = require('../models/Todo');
const { AppError } = require('../utils/errorHandler');

// Get all todos for a user with optional filtering
const getAllTodos = async (userId, filters = {}) => {
  const query = { user: userId };

  // Apply filters
  if (filters.category) {
    query.category = filters.category;
  }
  
  if (filters.completed !== undefined) {
    query.is_completed = filters.completed === 'true';
  }
  
  if (filters.due_date) {
    // If we want to filter by exact date, we would need to handle date ranges
    const date = new Date(filters.due_date);
    const nextDay = new Date(date);
    nextDay.setDate(date.getDate() + 1);
    
    query.due_date = {
      $gte: date,
      $lt: nextDay,
    };
  }

  // Get todos
  const todos = await Todo.find(query).sort({ created_at: -1 });

  return {
    data: todos.map(todo => ({
      id: todo._id,
      title: todo.title,
      description: todo.description,
      category: todo.category,
      due_date: todo.due_date,
      is_completed: todo.is_completed,
      created_at: todo.created_at,
      updated_at: todo.updated_at,
    })),
    meta: {
      total: todos.length,
    },
  };
};

// Create new todo
const createTodo = async (userId, todoData) => {
  const todo = await Todo.create({
    ...todoData,
    user: userId,
  });

  return {
    id: todo._id,
    title: todo.title,
    description: todo.description,
    category: todo.category,
    due_date: todo.due_date,
    is_completed: todo.is_completed,
    created_at: todo.created_at,
    updated_at: todo.updated_at,
  };
};

// Get single todo
const getTodo = async (todoId, userId) => {
  const todo = await Todo.findOne({ _id: todoId, user: userId });

  if (!todo) {
    throw new AppError('Todo not found', 404);
  }

  return {
    id: todo._id,
    title: todo.title,
    description: todo.description,
    category: todo.category,
    due_date: todo.due_date,
    is_completed: todo.is_completed,
    created_at: todo.created_at,
    updated_at: todo.updated_at,
  };
};

// Update todo
const updateTodo = async (todoId, userId, todoData) => {
  const todo = await Todo.findOneAndUpdate(
    { _id: todoId, user: userId },
    todoData,
    { new: true, runValidators: true }
  );

  if (!todo) {
    throw new AppError('Todo not found', 404);
  }

  return {
    id: todo._id,
    title: todo.title,
    description: todo.description,
    category: todo.category,
    due_date: todo.due_date,
    is_completed: todo.is_completed,
    created_at: todo.created_at,
    updated_at: todo.updated_at,
  };
};

// Delete todo
const deleteTodo = async (todoId, userId) => {
  const todo = await Todo.findOneAndDelete({ _id: todoId, user: userId });

  if (!todo) {
    throw new AppError('Todo not found', 404);
  }

  return true;
};

module.exports = {
  getAllTodos,
  createTodo,
  getTodo,
  updateTodo,
  deleteTodo,
};
