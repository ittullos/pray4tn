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
export const APIContext   = createContext()

function App() {
  const [userId, setUserId] = useState(0)
  const [apiEndpoint, setApiEndpoint] = useState("http://localhost:9292/p4l")
  // const [apiEndpoint, setApiEndpoint] = useState("https://d3ekgffygrqmjk.cloudfront.net/p4l")

  useEffect(() => {
    if (localStorage.getItem('userId') === "0") {
      setUserId(0)
    } 
    if (localStorage.getItem('userId') !== "0" &&  localStorage.getItem('userId') != null) {
      setUserId(localStorage.getItem('userId'))
    }
  }, [userId])

  return (
    <APIContext.Provider value={[apiEndpoint, setApiEndpoint]}>
      <LoginContext.Provider value={[userId, setUserId]}>
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
    </APIContext.Provider>
  )
}

export default App;
