import { Navigate, Outlet } from 'react-router-dom'
import React, { useContext } from 'react'
import { LoginContext } from '../App'

const PrivateRoutes = () => {
  const [loggedIn, setLoggedIn] = useContext(LoginContext)
  return (
    loggedIn ? <Outlet/> : <Navigate to='/login'/>
  )
}

export default PrivateRoutes