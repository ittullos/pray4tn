import React, { createContext, useEffect, useState } from 'react'
import "bootswatch/dist/litera/bootstrap.min.css"
import './App.css'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import Home from './pages/Home'
import Login from './pages/Login'
import Signup from './pages/Signup'
import Error from './pages/Error'
import PrivateRoutes from './components/PrivateRoutes'
import PasswordReset from './pages/PasswordReset'

export const LoginContext = createContext()

function App() {
  const [loggedIn, setLoggedIn] = useState(null)
  const [userId, setUserId]     = useState(0)

  useEffect(() => {
    console.log("loggedIn: ", loggedIn)
    if (localStorage.getItem('loggedIn') === "true") {
      setLoggedIn(true)
    }
    if (localStorage.getItem('loggedIn') === "false") {
      setLoggedIn(false)
    }
  }, [loggedIn])

  return (
    <LoginContext.Provider value={[loggedIn, setLoggedIn, userId, setUserId]}>
      <Router>
        <Routes>
          <Route element={<PrivateRoutes/>}>
                <Route path='/' element={<Home/>} />
          </Route>
          <Route path='/login'          element={<Login />}/>
          <Route path='/signup'         element={<Signup />}/>
          <Route path='/password_reset' element={<PasswordReset />} />
          <Route path='*'               element={<Error />}/>
        </Routes>
      </Router>
    </LoginContext.Provider>
  )
}

export default App;
