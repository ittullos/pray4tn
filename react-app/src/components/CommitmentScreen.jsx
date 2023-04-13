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
import CommitSuccessModal from './CommitSuccessModal';
import Alert from 'react-bootstrap/Alert';



function CommitmentScreen(props) {
  
  const [modalOpen, setModalOpen]     = useState(false)
  const [apiEndpoint, setApiEndpoint] = useContext(APIContext)
  const [userId, setUserId]           = useContext(LoginContext)
  const [isLoading, setIsLoading]     = useState(true)
  const [journeyData, setJourneyData] = useState()
  const [activeSlide, setActiveSlide] = useState(0)
  const [targetDate, setTargetDate]   = useState(new Date())
  const [currentDate, setCurrentDate]   = useState(new Date())
  const [showCommitSuccess, setShowCommitSuccess] = useState(false)
  const [showCommitDateFailure, setShowCommitDateFailure] = useState(false)

  // const [activeSlideTitle, setActiveSlideTitle] = useState(journeyData[0].title)

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

  const sendCommit = (targetDate, currentDate, title, userId) => {
    console.log("targetDate: ", targetDate)
    console.log("currentDate: ", currentDate)
    console.log("title: ", title)
    console.log("userId: ", userId)

    if (targetDate > currentDate) {
      const commitmentData = { 
        user_id: userId,
        journey_id: title,
        target_date: targetDate
       }
      axios.post(`${apiEndpoint}/commitment`, { commitmentData 
      }).then(res => {
        console.log("sendCommit response: ", res)
        setShowCommitSuccess(true)
      }).catch(err => {
        console.log(err)
      })
    }
    else {
      setShowCommitDateFailure(true)
    }

  }

  useEffect(() => {
    if (setShowCommitDateFailure) {
      setShowCommitDateFailure(false)
    }
  

  }, [targetDate])
  

  useEffect(() => {
    console.log("activeSlide: ", activeSlide)
  }, [activeSlide])

  useEffect(() => {
    console.log("targetDate: ", targetDate)
  }, [targetDate])
  
  return (
    <>
      <CommitSuccessModal 
      show={showCommitSuccess}
      onHide={() => setShowCommitSuccess(false)} />

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
            <Carousel onSlide={setActiveSlide}>
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
                  <h4 className='mt-3'>Distance: {item.target_miles/100} miles</h4>
                  
                </Carousel.Item>
              ))}
            </Carousel>
          )}
          <h6 className='mt-4'>Target Completion Date: </h6>
          <Calendar setTargetDate={setTargetDate} targetDate={targetDate} />
          <div className="alert-container">
            <Alert variant="danger" show={showCommitDateFailure} className="date-alert">
              Please choose a valid completion date
            </Alert>
          </div>
          <Button 
            className='mt-4 mb-4 commit-button' 
            onClick={() => sendCommit(targetDate, currentDate, journeyData[activeSlide].title, userId.replace(/['"]+/g, ''))} 
            style={styles.navyButton}>Commit</Button>
        </Modal.Body>
        <Modal.Footer>
          <Button style={styles.navyButton} onClick={props.onHide}>Close</Button>
        </Modal.Footer>
      </Modal>
    </>
  );
}

export default CommitmentScreen