import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import Form from 'react-bootstrap/Form'
import { useState, useEffect } from 'react';

function LocationWarning(props) {

  const [disableCheckbox, setDisableCheckbox] = useState(false)

  const handleDisableChange = () => {
    setDisableCheckbox(!disableCheckbox)
  }

  const handleSubmit = () => {
    if (disableCheckbox) {
      localStorage.setItem('disableLocationWarning', "true")
    } else {
      localStorage.setItem('disableLocationWarning', "false")
    }
  }

  return (
    <Modal
      {...props}
      size="lg"
      aria-labelledby="contained-modal-title-vcenter"
      centered
      className='text-center'>
      <Modal.Header 
        closeButton 
        className='text-center'
        style={{
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
        }}>
        <Modal.Title 
          id="contained-modal-title-vcenter" 
          className="ms-auto ps-3"
          style={{fontSize:28}}>
            Oops!
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <p>
          This app requires location services to track your distance.
          You can still enter stationary mileage without using location services.
        </p>
      </Modal.Body>
      <Modal.Footer className='d-flex
                               flex-column
                               justify-content-center
                               align-items-center'>
        <Form>
          <Form.Group controlId="formBasicCheckbox">
            <Form.Check type="checkbox" 
                        label="If your primary use for Pastor4Life is stationary (treadmill, etc.) check here to block this message"
                        onChange={handleDisableChange} />   
            <Button onClick={() => {
              props.onHide() 
              handleSubmit()}}
              className="mt-3">
              Close
            </Button>
          </Form.Group>
        </Form>
      </Modal.Footer>
    </Modal>
  );
}

export default LocationWarning