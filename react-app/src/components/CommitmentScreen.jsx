import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import { styles } from '../styles/inlineStyles'
import Carousel from 'react-bootstrap/Carousel'
import { useState, useContext, useEffect } from 'react';
import Calendar from './Calendar';
import LoadingComponent from './LoadingComponent';
import axios from 'axios'
import { APIContext } from '../App';
import { LoginContext } from '../App';



function CommitmentScreen(props) {
  
  const [modalOpen, setModalOpen]     = useState(false)
  const [apiEndpoint, setApiEndpoint] = useContext(APIContext)
  const [userId, setUserId]           = useContext(LoginContext)
  const [isLoading, setIsLoading]     = useState(true)
  const [journeyData, setJourneyData] = useState()

  const handleModalOpen = () => {
    if (!modalOpen) {
      setModalOpen(true)
    }
  }

  useEffect(() => {
    if (modalOpen) {
      fetchJourneys()
    }
  }, [modalOpen])

  const fetchJourneys = () => {
    axios.post(`${apiEndpoint}/journeys`, { userId 
    }).then(res => {
      console.log("fetchJourneys: ", res.data.journeys)
      setJourneyData(res.data.journeys)
      setIsLoading(false)
    }).catch(err => {
      console.log(err)
    })
  }

  return (
    <Modal
      {...props}
      size="lg"
      aria-labelledby="contained-modal-title-vcenter"
      centered
      className='text-center'
      onEntered={handleModalOpen}
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
            My Commitment
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        { isLoading ? (
          <LoadingComponent /> 
          ) : (
          <Carousel>
            {journeyData.map((item) => (   
              <Carousel.Item interval={600000} key={item.title}>
                <img
                  className="d-block w-100"
                  src={item.graphic_url}
                  alt=""
                  key={item.graphic_url}
                />
                <div className="carousel-spacer"></div>
                <h3>{item.title}</h3> 
                <h4 className='mt-3'>Distance: {item.target_miles/100}</h4>
                <h6 className='mt-4'>Target Completion Date: </h6>
                <Calendar />
                <Button className='mt-5 mb-4 commit-button' style={styles.navyButton}>Commit</Button>
              </Carousel.Item>
            ))}
          </Carousel>
        )}
      </Modal.Body>
      <Modal.Footer>
        <Button style={styles.navyButton} onClick={props.onHide}>Close</Button>
      </Modal.Footer>
    </Modal>
  );
}

export default CommitmentScreen