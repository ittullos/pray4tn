import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import { styles } from '../styles/inlineStyles'

function ErrorModal(props) {
  return (
    <Modal
      {...props}
      size="sm"
      aria-labelledby="contained-modal-title-vcenter"
      centered
      className='text-center success-modal bg-danger'
    >
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
            Error
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <h5>Something went wrong</h5>
      </Modal.Body>
      <Modal.Footer>
        <Button style={styles.navyButton} onClick={props.onHide}>
          Close
        </Button>
      </Modal.Footer>
    </Modal>
  );
}

export default ErrorModal