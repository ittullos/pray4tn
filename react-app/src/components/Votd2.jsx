import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';

function Votd(props) {
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
            Verse of the day
        </Modal.Title>
      </Modal.Header>
      <Modal.Body className='mt-3'>
        <figure className="text-center">
          <blockquote className="blockquote" style={{fontSize:24}}>
            <p className="mb-0">
              {props.verse}
            </p>      
          </blockquote>
          <figcaption 
            className="blockquote-footer mt-2 me-1"
            style={{fontSize:22}}>
              {props.notation}
          </figcaption>
        </figure>
      </Modal.Body>
      <Modal.Footer>
        <Button onClick={props.onHide}>Close</Button>
      </Modal.Footer>
    </Modal>
  );
}

export default Votd