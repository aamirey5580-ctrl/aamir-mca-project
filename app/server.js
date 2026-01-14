/**
 * ============================================
 * Node.js REST API Server
 * MCA Final Project - Aamir Qureshi
 * ============================================
 */

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

// Initialize Express
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// MongoDB Connection
const MONGO_URI = process.env.MONGO_URI || 'mongodb://localhost:27017/mca_project';

mongoose.connect(MONGO_URI)
  .then(() => console.log('✅ Connected to MongoDB'))
  .catch(err => console.error('❌ MongoDB connection error:', err));

// Task Schema
const taskSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: String,
  status: { type: String, enum: ['pending', 'in-progress', 'completed'], default: 'pending' },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

const Task = mongoose.model('Task', taskSchema);

// ============================================
// API Routes
// ============================================

// Health Check
app.get('/health', (req, res) => {
  res.json({ 
    status: 'healthy', 
    timestamp: new Date().toISOString(),
    service: 'nodejs-mongodb-api',
    version: '1.0.0'
  });
});

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to Task Manager API',
    author: 'Aamir Qureshi',
    project: 'MCA Final Project',
    endpoints: {
      health: 'GET /health',
      tasks: 'GET /api/tasks',
      createTask: 'POST /api/tasks',
      getTask: 'GET /api/tasks/:id',
      updateTask: 'PUT /api/tasks/:id',
      deleteTask: 'DELETE /api/tasks/:id'
    }
  });
});

// Get all tasks
app.get('/api/tasks', async (req, res) => {
  try {
    const tasks = await Task.find().sort({ createdAt: -1 });
    res.json({ success: true, count: tasks.length, data: tasks });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Create task
app.post('/api/tasks', async (req, res) => {
  try {
    const task = new Task(req.body);
    await task.save();
    res.status(201).json({ success: true, data: task });
  } catch (error) {
    res.status(400).json({ success: false, error: error.message });
  }
});

// Get single task
app.get('/api/tasks/:id', async (req, res) => {
  try {
    const task = await Task.findById(req.params.id);
    if (!task) {
      return res.status(404).json({ success: false, error: 'Task not found' });
    }
    res.json({ success: true, data: task });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// Update task
app.put('/api/tasks/:id', async (req, res) => {
  try {
    req.body.updatedAt = Date.now();
    const task = await Task.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!task) {
      return res.status(404).json({ success: false, error: 'Task not found' });
    }
    res.json({ success: true, data: task });
  } catch (error) {
    res.status(400).json({ success: false, error: error.message });
  }
});

// Delete task
app.delete('/api/tasks/:id', async (req, res) => {
  try {
    const task = await Task.findByIdAndDelete(req.params.id);
    if (!task) {
      return res.status(404).json({ success: false, error: 'Task not found' });
    }
    res.json({ success: true, message: 'Task deleted successfully' });
  } catch (error) {
    res.status(500).json({ success: false, error: error.message });
  }
});

// 404 Handler
app.use((req, res) => {
  res.status(404).json({ success: false, error: 'Route not found' });
});

// Start Server
app.listen(PORT, '0.0.0.0', () => {
  console.log(`
  ============================================
  🚀 Server running on port ${PORT}
  📦 Project: MCA Final Project
  👤 Author: Aamir Qureshi
  ============================================
  `);
});

