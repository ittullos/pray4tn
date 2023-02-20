import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import Uploader from './Uploader';
import { styles } from '../styles/inlineStyles'

function PlanRouteScreen (props) {
  const { userId, ...rest } = props
  return (
    <Modal
      {...rest}
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
            Plan Route
        </Modal.Title>
      </Modal.Header>
      <Modal.Body className='d-flex
                             flex-column
                             justify-content-center
                             align-items-center'>
        <div className="plan-route
                        d-flex
                        flex-column
                        justify-content-center
                        align-items-center">
          <h5 className='pt-2 plan-route-text'>
            Step 1: Download your local prayer list from
            <br />
            <a href="https://blesseveryhome.com" style={{ textDecoration: 'none' }} target="_blank">
            &nbsp;Bless Every Home
            </a>
          </h5>
          <hr className='page-line'/>
          <div className='py-3'>
            <h5 className='plan-route-text ms-4'>
              Step 2: Upload your prayer list here:
            </h5>
            <Uploader onHide={rest.onHide} userId={userId}/>
          </div>
          <hr className='page-line'/>
          <h5 className='py-2 mb-2 plan-route-text'>Step 3: Pray for people in your community</h5>
        </div>
      </Modal.Body>
      <Modal.Footer>
        <Button style={styles.navyButton} onClick={rest.onHide}>Close</Button>
      </Modal.Footer>
    </Modal>
  );
}

export default PlanRouteScreen