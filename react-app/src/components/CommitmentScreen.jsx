import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import { styles } from '../styles/inlineStyles'
import Carousel from 'react-bootstrap/Carousel'
import { useState, useContext, useEffect, useRef } from 'react';
import Calendar from './Calendar';
import LoadingComponent from './LoadingComponent';
import axios from 'axios'
import { APIContext } from '../App';
import { LoginContext } from '../App';
import CommitSuccessModal from './CommitSuccessModal';
import ErrorModal from './ErrorModal';
import Alert from 'react-bootstrap/Alert';
import Form from 'react-bootstrap/Form';

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
  const [showCommitError, setShowCommitError] = useState(false)
  const [showCommitDateFailure, setShowCommitDateFailure] = useState(false)
  const [selectedJourney, setSelectedJourney] = useState(null)

  const jumpToDescription = useRef(null)
  const jumpToTop         = useRef(null)

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
        setShowCommitError(true)
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

  const handleJumpToDescription = () => {
    jumpToDescription.current?.scrollIntoView({ behavior: 'smooth' })
  }

  const handleJumpToTop = () => {
    jumpToTop.current?.scrollIntoView({ behavior: 'smooth' })
  }

  const handleJourneySelect = e => {
    e.persist()
    console.log("JourneySelect: ", e.target.value)
    setSelectedJourney(e.target.value)
  }

  const handleCommitSubmit = (selectedJourney, userId) => {
    // console.log(selectedJourney, userId)
    if (selectedJourney) {
      let commitData = {
        user_id: userId,
        journey_id: selectedJourney
      }
      axios.post(`${apiEndpoint}/commitment`, { commitData 
      }).then(res => {
        console.log("sendCommit response: ", res)
        setShowCommitSuccess(true)
      }).catch(err => {
        console.log(err)
        setShowCommitError(true)
      })
    }
    else {
      alert("Please select a Journey")
    }

  }
  
  return (
    <>
      <CommitSuccessModal 
      show={showCommitSuccess}
      onHide={() => setShowCommitSuccess(false)} />
      <ErrorModal 
      show={showCommitError}
      onHide={() => setShowCommitError(false)} />

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
          ref={jumpToTop}
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
          <h6>Annual Commitment, Walk/Run/Cycle*</h6>
          <Button className='mt-3 mb-2' onClick={handleJumpToDescription}>How does this work?</Button>
          <h4 className='mt-3'>Select a Journey:</h4>
          { isLoading ? (
            <LoadingComponent /> 
            ) : (
              <>
                <Form 
                  className='d-flex justify-content-center journey-container'>
                  <span>
                    <Form.Group controlId='selectedJourney'>
                      {journeyData.map((item) => (
                        <div className='my-4' key={item.title}>
                          <Form.Check
                            label={item.title}
                            value={item.title}
                            name="group1"
                            type='radio'
                            // id={`reverse-radio-2`}
                            key={item.title}
                            className="radio-box"
                            onChange={handleJourneySelect}
                            // checked={selectedJourney === item.title}
                          />
                          <div className='d-flex align-items-start annual-miles'>
                            - {item.annual_miles/1000} miles
                          </div>
                          <div className='d-flex align-items-start monthly-miles'>
                            - {item.monthly_miles/1000} mi/month
                          </div>
                          <div className='d-flex align-items-start weekly-miles'>
                            - {item.weekly_miles/1000} mi/week
                          </div>
                        </div>
                      ))}
                    </Form.Group>
                    <div className='me-4'>
                      <div>*some mileage rounded for </div>
                      <div>ease of measurement</div>
                    </div>
                  </span>
                </Form>
                <Button 
                  className='mt-4 mb-4 commit-button'
                  // type='submit'
                  onClick={() => handleCommitSubmit(selectedJourney, userId.replace(/['"]+/g, ''))}
                  style={styles.navyButton}>
                    Commit
                </Button>
              </>
            )}

          <div className="commit-description" ref={jumpToDescription}>
            <Button className='mt-3 mb-2' onClick={handleJumpToTop}>Back to Top</Button>
            <h3 className='my-4'>How it Works</h3>
            <div className="commit-description-text mx-4">
              <div className='my-4'>
                - Pastor4Life is a spiritual wellness app that keeps track of
                walking / running / cycling distances and uses TN landmarks 
                to benchmark success
              </div>
              <div className='my-4'>
                - Creating a new commitment is essentially setting a personal
                goal. All commitments run on an annual cycle, meaning the 
                goal is designed to be completed within a year of the commit date.
              </div>
              <div className='my-4'>
                - To make a new commitment select a journey from the list at
                the top of this page and press the commit button.
              </div>
              <div className='my-4'>
                - To log mileage go back to the home screen and press the 
                "Start Route" button. Distance is automatically recorded 
                while in a route. Don't forget to use the Prayer Screen
                to pray for people in your area!
              </div>
              <div className='my-4'>
                - To see your commitment progress go to the "My Stats"
                screen using the hamburger menu. Here you can see the
                mileage logged against your commitment as well as how
                much time you have left to complete your commitment.
              </div>
            </div>
          </div>
        </Modal.Body>
        <Modal.Footer>
          <Button style={styles.navyButton} onClick={props.onHide}>Close</Button>
        </Modal.Footer>
      </Modal>
    </>
  );
}

export default CommitmentScreen