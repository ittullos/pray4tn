import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import React, { useState, useEffect, useContext } from 'react'
import axios from 'axios'
import { useNavigate, Link } from 'react-router-dom'
import { LoginContext } from '../App';
import Loading from '../components/Loading';

const api = "http://localhost:9292/p4l"

function Login() {
  const [email, setEmail]                 = useState("")
  const [password, setPassword]           = useState("")
  const [rememberMe, setRememberMe]       = useState(false)
  const [userId, setUserId]               = useContext(LoginContext)
  const [showLoginForm, setShowLoginForm] = useState(false)

  useEffect(() => {
    if (userId !== 0) {
      navigate('/')
    } else {
      setShowLoginForm(true)
    }
  },[userId])

  const handleEmailChange = (event) => {
    setEmail(event.target.value)
  }

  const handlePasswordChange = (event) => {
    setPassword(event.target.value)
  }

  const handleRememberMeChange = (event) => {
    setRememberMe(!rememberMe)
  }

  const navigate = useNavigate()

  const handleSubmit = (event) => {
    event.preventDefault()
    let loginFormData = {
      email: email,
      password: password
    }
    axios.post(`${api}/login`, { loginFormData
    }).then(res => {
      let status = res.data["responseStatus"]
      if (status === "success") {
        setUserId(res.data["userId"])
        if (rememberMe) {
          localStorage.setItem('userId', JSON.stringify(res.data["userId"]))
        }
        navigate('/')
      } else {
        navigate('/')
        if (status === "Invalid Email" || status === "Invalid Password") {
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
      { showLoginForm ? (
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
                          className='bg-success'>
                    Login
                  </Button>
                </div>
                <div className='d-flex
                                flex-column
                                align-items-end'>
                  <Link to="/password_reset"
                        className='password-reset-link'>
                    Forgot Password?
                    </Link>
                  <Link to="/signup"
                        className='signup-link'>
                    Sign Up
                  </Link>
                </div>
              </div>
              

            </Form>
          </div>
        </div> 
      ) : (
        <Loading />)
      }
    </>
  );
}

export default Login;
