import React from 'react'
import "bootswatch/dist/litera/bootstrap.min.css"
import './App.css'
import { BrowserRouter as Router, Routes, Route   } from 'react-router-dom'
import Home from './pages/Home'
import Login from './pages/Login'
import Signup from './pages/Signup'
import Error from './pages/Error'

function App() {
  return (
    <Router>
      <Routes>
        <Route path='/login' element={<Login />}/>
        <Route path='/signup' element={<Signup />}/>
        <Route path='/' element={<Home />}/>
        <Route path='*' element={<Error />}/>
      </Routes>
    </Router>
  )
}

export default App;
