import React, { useEffect, useState } from 'react';
import axios from 'axios';

const API_BASE_URL = process.env.API_BASE_URL || '';

function App() {
  const [todos, setTodos] = useState([]);
  const [newTitle, setNewTitle] = useState('');

  const fetchTodos = async () => {
    const res = await axios.get(`${API_BASE_URL}/api/todos`);
    setTodos(res.data);
  };

  const addTodo = async () => {
    if (!newTitle.trim()) return;
    await axios.post(`${API_BASE_URL}/api/todos`, { title: newTitle });
    setNewTitle('');
    fetchTodos();
  };

  const deleteTodo = async (id) => {
    await axios.delete(`${API_BASE_URL}/api/todos/${id}`);
    fetchTodos();
  };

  const toggleTodo = async (id) => {
    await axios.patch(`${API_BASE_URL}/api/todos/${id}/toggle`);
    fetchTodos();
  };

  const updateTodo = async (id, title, completed) => {
    await axios.put(`${API_BASE_URL}/api/todos/${id}`, { title, completed });
    fetchTodos();
  };

  useEffect(() => {
    fetchTodos();
  }, []);

  return (
    <div style={{
      maxWidth: 600,
      margin: '0 auto',
      padding: 24,
      backgroundColor: '#f9f9f9',
      borderRadius: 12,
      boxShadow: '0 4px 12px rgba(0,0,0,0.1)',
      fontFamily: 'Segoe UI, sans-serif',
    }}>
      <h1 style={{ textAlign: 'center', color: '#333' }}>📝 My TODO List</h1>

      <div style={{ display: 'flex', gap: 8, marginBottom: 20 }}>
        <input
          style={{
            flex: 1,
            padding: 10,
            borderRadius: 8,
            border: '1px solid #ccc',
            fontSize: 16,
          }}
          placeholder="Add new task..."
          value={newTitle}
          onChange={(e) => setNewTitle(e.target.value)}
        />
        <button
          onClick={addTodo}
          style={{
            padding: '10px 16px',
            backgroundColor: '#4CAF50',
            color: 'white',
            border: 'none',
            borderRadius: 8,
            cursor: 'pointer',
            fontWeight: 'bold'
          }}
        >
          Add
        </button>
      </div>

      <ul style={{ listStyle: 'none', padding: 0 }}>
        {todos.map((todo) => (
          <li key={todo.id} style={{
            marginBottom: 12,
            backgroundColor: '#fff',
            padding: 12,
            borderRadius: 10,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'space-between',
            boxShadow: '0 2px 6px rgba(0,0,0,0.05)'
          }}>
            <div style={{ display: 'flex', alignItems: 'center', gap: 8, flex: 1 }}>
              <input
                type="checkbox"
                checked={todo.completed}
                onChange={() => toggleTodo(todo.id)}
              />
              <input
                value={todo.title}
                onChange={(e) => updateTodo(todo.id, e.target.value, todo.completed)}
                style={{
                  flex: 1,
                  padding: 6,
                  border: '1px solid #ddd',
                  borderRadius: 6,
                  fontSize: 15,
                  backgroundColor: todo.completed ? '#e0ffe0' : '#fff',
                  textDecoration: todo.completed ? 'line-through' : 'none'
                }}
              />
            </div>
            <button
              onClick={() => deleteTodo(todo.id)}
              style={{
                marginLeft: 12,
                backgroundColor: '#f44336',
                color: 'white',
                border: 'none',
                padding: '6px 10px',
                borderRadius: 6,
                cursor: 'pointer',
              }}
            >
              Delete
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;

