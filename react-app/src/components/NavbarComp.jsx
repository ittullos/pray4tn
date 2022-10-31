import Container from 'react-bootstrap/Container';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';

function BasicExample() {
  return (
    <Navbar sticky="top" 
            fixed="top" 
            bg="primary" 
            variant="dark" 
            expand="lg"
            className='sticky-nav'>
      <Container>
        <Navbar.Brand href="#home">Pastor4Life</Navbar.Brand>
        <Navbar.Toggle aria-controls="basic-navbar-nav" />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="ms-auto">
            <Nav.Link href="#home">Settings</Nav.Link>
            <Nav.Link href="#link">My Stats</Nav.Link>
            <Nav.Link href="#link">My Commitment</Nav.Link>
          </Nav>
        </Navbar.Collapse>
      </Container>
    </Navbar>
  )
}

export default BasicExample;