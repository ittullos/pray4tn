import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import Form from 'react-bootstrap/Form'
import { useState, useEffect } from 'react';

function LockWarning(props) {

  const [disableCheckbox, setDisableCheckbox] = useState(false)

  const handleDisableChange = () => {
    setDisableCheckbox(!disableCheckbox)
  }

  const handleSubmit = () => {
    if (disableCheckbox) {
      localStorage.setItem('disableLockWarning', "true")
    } else {
      localStorage.setItem('disableLockWarning', "false")
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
            Remember
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <p>
          Pastor4Life works best with your device unlocked and the app open.
          While logging mileage, Pastor4Life will override your device's auto-lock feature.
          If you lock your device or leave the app, Pastor4Life will resume logging mileage when you return.
          Don't forget to use the Prayer and Devotional features while you log mileage!
        </p>
      </Modal.Body>
      <Modal.Footer className='d-flex
                               flex-column
                               justify-content-center
                               align-items-center'>
        <Form>
          <Form.Group controlId="formBasicCheckbox">
            <Form.Check type="checkbox" 
                        label="Don't show this message again"
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

export default LockWarning