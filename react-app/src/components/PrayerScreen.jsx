import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import LoadingComponent from './LoadingComponent'

function PrayerScreen(props) {
  return (
    <Modal
      {...props}
      size="lg"
      aria-labelledby="contained-modal-title-vcenter"
      centered
      className='text-center'
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
            Prayer
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
       <LoadingComponent />
      </Modal.Body>
      <Modal.Footer>
        <Button onClick={props.onHide}>Close</Button>
      </Modal.Footer>
    </Modal>
  );
}

export default PrayerScreen