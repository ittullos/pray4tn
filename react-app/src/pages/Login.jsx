import Button from 'react-bootstrap/Button';
import Form from 'react-bootstrap/Form';

function Login() {
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
        <Form className="login-form">
          <Form.Group className="mb-3 form" controlId="formBasicEmail">
            <Form.Label>Email address</Form.Label>
            <Form.Control type="email" placeholder="Enter email" />
          </Form.Group>

          <Form.Group className="mb-3 form" controlId="formBasicPassword">
            <Form.Label>Password</Form.Label>
            <Form.Control type="password" placeholder="Password" />
          </Form.Group>
          <Form.Group className="mb-3" controlId="formBasicCheckbox">
            <Form.Check type="checkbox" label="Remember me" />
          </Form.Group>
          <Button variant="primary" type="submit">
            Submit
          </Button>
        </Form>
      </div>
    </div>
  );
}

export default Login;
