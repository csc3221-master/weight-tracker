import { Link, Routes, Route } from 'react-router'

function Home() {
  return <h1>Weight Track</h1>
}

function History() {
  return <h1>History</h1>
}

function Reports() {
  return <h1>Reports</h1>
}

export default function App() {
  return (
    <div style={{ padding: '1rem' }}>
      <nav style={{ display: 'flex', gap: '1rem', marginBottom: '1rem' }}>
        <Link to="/">Home</Link>
        <Link to="/history">History</Link>
        <Link to="/reports">Reports</Link>
      </nav>

      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/history" element={<History />} />
        <Route path="/reports" element={<Reports />} />
      </Routes>
    </div>
  )
}