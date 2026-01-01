import { Routes, Route, Link, BrowserRouter } from "react-router-dom";
import Home from "./pages/Home";
import Data from "./pages/Data";

function App() {
  return (
    <BrowserRouter>
      <div className="w-full bg-gray-900 text-slate-100 h-screen p-2">
        <header className="flex justify-between gap-1 p-2">
          <div>
            <h1>Auth Sample</h1>
          </div>
          <div>
            <Link className="mr-1 btn" to="/">Home</Link>
            <Link className="mr-1 btn" to="/data">Data</Link>
          </div>
        </header>

        <main>
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/data" element={<Data />} />
          </Routes>
        </main>
      </div>
    </BrowserRouter>
  )
}

export default App
