import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';

function UploadSuccessModal(props) {
  return (
    <Modal
      {...props}
      size="sm"
      aria-labelledby="contained-modal-title-vcenter"
      centered
      className='text-center success-modal bg-success'
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
            Success!!
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <h5>Prayer List Uploaded</h5>
      </Modal.Body>
      <Modal.Footer>
        <Button onClick={props.onHide}>
          Close
        </Button>
      </Modal.Footer>
    </Modal>
  );
}

export default UploadSuccessModal