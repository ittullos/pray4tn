import { Navigate, Outlet } from 'react-router-dom'
import React, { useContext } from 'react'
import { LoginContext } from '../App'

const PrivateRoutes = () => {
  let loggedIn = null
  const [userId, setUserId] = useContext(LoginContext)
  if (userId === 0) {
    loggedIn = false
  } else { 
    loggedIn = true 
  }
  return (
    loggedIn ? <Outlet/> : <Navigate to='/login'/>
  )
}

export default PrivateRoutes