import { Navigate, Outlet } from 'react-router-dom'
import React, { useContext, useEffect } from 'react'
import { LoginContext } from '../App'

const PrivateRoutes = () => {
  const [userId, setUserId] = useContext(LoginContext)

  return (
    userId ? <Outlet/> : <Navigate to='/login'/>
  )
}

export default PrivateRoutes