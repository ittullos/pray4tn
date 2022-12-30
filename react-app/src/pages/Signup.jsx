import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import React, { useState, useEffect, useContext } from 'react'
import axios from 'axios'
import { useNavigate, Link } from 'react-router-dom'
import { LoginContext } from '../App';

const api = "http://localhost:9292/p4l"
// const api = "https://d3ekgffygrqmjk.cloudfront.net/p4l"

function Signup() {
  const [email, setEmail]                     = useState("")
  const [password, setPassword]               = useState("")
  const [confirmPassword, setConfirmPassword] = useState("")
  const [rememberMe, setRememberMe]           = useState(false)
  const [userId, setUserId]                   = useContext(LoginContext)

  useEffect(() => {
    if (userId !== 0) {
      navigate('/')
    }
  },[userId])

  const handleEmailChange = (event) => {
    setEmail(event.target.value)
  }

  const handlePasswordChange = (event) => {
    setPassword(event.target.value)
  }

  const handleConfirmPasswordChange = (event) => {
    setConfirmPassword(event.target.value)
  }

  const handleRememberMeChange = (event) => {
    setRememberMe(!rememberMe)
  }

  const navigate = useNavigate()

  const handleSubmit = (event) => {
    event.preventDefault()
    let signupFormData = {
      email: email,
      password: password,
      confirmPassword: confirmPassword
    }
    axios.post(`${api}/signup`, { signupFormData
    }).then(res => {
      let status = res.data["responseStatus"]
      if (status === "success") {
        setUserId(res.data["userId"])
        if (rememberMe) {
          localStorage.setItem('userId', JSON.stringify(res.data["userId"]))
        }
        navigate('/')
      } else {
        navigate('/signup')
        if (status === "Email already in use" || status === "Passwords do not match") {
          alert(status)
        }
      }
      console.log("login response: ", res)
    }).catch(err => {
      console.log(err)
    })
  }

  return (
    <>
        <div className="form-body
                        d-flex
                        flex-column
                        justify-content-center
                        align-items-center">
          <div className="form-hero
                          d-flex
                          justify-content-center
                          align-items-center
                          bg-success">
            <h1 className='form-hero-text'>Sign Up</h1>
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
              <Form.Group className="mb-3 form" 
                          controlId="formBasicConfirmPassword">
                <Form.Label>Confirm Password</Form.Label>
                <Form.Control type="password" 
                              value={confirmPassword}
                              onChange={handleConfirmPasswordChange}
                              placeholder="Confirm Password" />
              </Form.Group>
              <div className='d-flex
                              flex-row
                              justify-content-between'>
                <div>
                  <Form.Group className="mb-3" 
                              controlId="formBasicCheckbox">
                    <Form.Check type="checkbox" 
                                label="Remember Me"
                                onChange={handleRememberMeChange} />
                  </Form.Group>
                  <Button variant="primary" 
                          type="login" 
                          className='bg-primary'>
                    Sign up
                  </Button>
                </div>
                <div className='d-flex
                                flex-column'>
                  <Link to="/login"
                        className='signup-link'>
                    Cancel
                  </Link>
                </div>
              </div>
            </Form>
          </div>
        </div> 
    </>
  );
}

export default Signup;

