// This is a simple React component for a chatbot interface

import { useState } from 'react';

function App() {
  const [input, setInput] = useState('');
  const [messages, setMessages] = useState([]);

  const sendMessage = async () => {
    const response = await fetch('/api/chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ message: input }),
    });
    const data = await response.json();
    setMessages([...messages, { role: 'user', text: input }, { role: 'bot', text: data.reply }]);
    setInput('');
  };

  return (
    <div>
      <h1>Language Tutor Chatbot</h1>
      <div>
        {messages.map((m, i) => (
          <div key={i}><strong>{m.role}:</strong> {m.text}</div>
        ))}
      </div>
      <input value={input} onChange={e => setInput(e.target.value)} />
      <button onClick={sendMessage}>Send</button>
    </div>
  );
}

export default App;
