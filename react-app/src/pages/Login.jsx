import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import React, { useState, useEffect } from 'react'
import axios from 'axios'
import Alert from 'react-bootstrap/Alert';
import { Navigate, Outlet } from 'react-router-dom'



const api = "http://localhost:9292/p4l"

function Login() {

  const [email, setEmail]       = useState("")
  const [password, setPassword] = useState("")

  useEffect(() => {
    console.log(email);
    console.log(password)
  }, [email, password])

  const handleEmailChange = (event) => {
    setEmail(event.target.value)
  }

  const handlePasswordChange = (event) => {
    setPassword(event.target.value)
  }

  const handleSubmit = (event) => {
    event.preventDefault()
    const loginFormData = {
      email:    email,
      password: password
    }
    let auth = {'token':false}
    axios.post(`${api}/login`, {loginFormData})
    .then(res => {
      // let auth = {'token':true}
      console.log(res)
      return (
        auth.token ? <Outlet/> : <Navigate to='/login'/>
      )
    
    }).catch(err => {
      console.log(err)
    })
  }

  return (
    <div className="form-body
                    d-flex
                    flex-column
                    justify-content-center
                    align-items-center">
      <div className="form-hero
                      d-flex
                      justify-content-center
                      align-items-center">
        <h1 className='form-hero-text'>Pastor4Life</h1>
      </div>
      <div className="form-container">
        <Form className="login-form rounded"
              onSubmit={handleSubmit}>
          <Form.Group className="mb-3 form" 
                      controlId="formBasicEmail">
            <Form.Label>Email address</Form.Label>
            <Form.Control type="email" 
                          value={email} 
                          onChange={handleEmailChange} 
                          placeholder="Enter email" />
          </Form.Group>
          <Form.Group className="mb-3 form" 
                      controlId="formBasicPassword">
            <Form.Label>Password</Form.Label>
            <Form.Control type="password" 
                          value={password}
                          onChange={handlePasswordChange}
                          placeholder="Password" />
          </Form.Group>
          <Form.Group className="mb-3" 
                      controlId="formBasicCheckbox">
            <Form.Check type="checkbox" 
                        label="Remember Me" />
          </Form.Group>
          <Button variant="primary" 
                  type="login" 
                  className='bg-success'>
            Login
          </Button>
        </Form>
      </div>
    </div>
  );
}

export default Login;
