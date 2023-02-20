import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';
import React, { useState, useEffect, useContext } from 'react'
import axios from 'axios'
import { useNavigate, Link } from 'react-router-dom'
import { LoginContext, APIContext } from '../App';
import Loading from '../components/Loading';
import p4lLogo from '../images/p4l_logo.png'


function Login() {
  const [email, setEmail]                 = useState("")
  const [password, setPassword]           = useState("")
  const [rememberMe, setRememberMe]       = useState(false)
  const [userId, setUserId]               = useContext(LoginContext)
  const [apiEndpoint, setApiEndpoint] = useContext(APIContext)
  const [showLoginForm, setShowLoginForm] = useState(false)

  useEffect(() => {
    console.log("Login:userId: ", userId)
    if (userId) {
      navigate('/')
    } else {
      setShowLoginForm(true)
    }
  },[userId])

  useEffect(() => {
    console.log("Login:showLoginForm: ", showLoginForm)
  }, [showLoginForm])

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
    axios.post(`${apiEndpoint}/login`, { loginFormData
    }).then(res => {
      let status = res.data["responseStatus"]
      if (status === "success") {
        setUserId(res.data["userId"])
        if (rememberMe) {
          localStorage.setItem('userId', JSON.stringify(res.data["userId"]))
        }
      } else {
        setUserId(0)
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
    <div className='login-container'>
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
            <img src={p4lLogo} alt="" className='login-logo'/>
          </div>
          <h3 className='text-white'>Sign In</h3>
          <div className="form-container
                          d-flex
                          flex-column">
            <Form className="login-form rounded"
                  onSubmit={handleSubmit}>
              <Form.Group className="mb-3 form" 
                          controlId="formBasicEmail">
                <Form.Control type="email" 
                              value={email} 
                              onChange={handleEmailChange}
                              className='form-control rounded-pill button'
                              placeholder="Email" />
              </Form.Group>
              <Form.Group className="mb-3 form" 
                          controlId="formBasicPassword">
                <Form.Control type="password" 
                              value={password}
                              onChange={handlePasswordChange}
                              className='form-control rounded-pill button'
                              placeholder="Password" />
              </Form.Group>
              <div className='d-flex
                              flex-column
                              justify-content-between'>
                <div className='d-flex
                                flex-row
                                justify-content-between'>
                  <Form.Group className="mb-3" 
                              controlId="formBasicCheckbox">
                    <Form.Check type="checkbox" 
                                label="Remember Me"
                                onChange={handleRememberMeChange}
                                className='text-white remember-me' />
                  </Form.Group>
                  <Link to="/password_reset"
                        className='password-reset-link text-white'>
                    Forgot Password? <b>Click Here</b>
                    </Link>

                </div>
                <div className='d-flex
                                flex-column
                                align-items-center'>

                  <Button variant="primary" 
                          type="login" 
                          className='login-button rounded-pill button'>
                    Login
                  </Button>
                  <Link to="/signup"
                        className='signup-link text-white'>
                    Don't have an account? <b>Sign Up</b>
                  </Link>
                </div>
              </div>
              

            </Form>
          </div>
        </div> 
      ) : (
        <Loading />)
      }
    </div>
  );
}

export default Login;
