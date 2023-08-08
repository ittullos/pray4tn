import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import Form from 'react-bootstrap/Form'
import { styles } from '../styles/inlineStyles'
import LoadingComponent from './LoadingComponent';
import { useState, useContext, useEffect } from 'react';
import axios from 'axios';
import { LoginContext, APIContext } from '../App'
import ProgressBar from 'react-bootstrap/ProgressBar';


function StatsScreen(props) {
  const [userId, setUserId]           = useContext(LoginContext)
  const [apiEndpoint, setApiEndpoint] = useContext(APIContext)
  const [isLoading, setIsLoading]     = useState(true)
  const [currentDate, setCurrentDate] = useState(new Date())

  const [journeyTitle, setJourneyTitle]   = useState()
  const [targetDate, setTargetDate]       = useState("")
  const [progressMiles, setProgressMiles] = useState(0)
  const [targetMiles, setTargetMiles]     = useState(0)
  const [prayerCount, setPrayerCount]     = useState(0)
  const [seconds, setSeconds]             = useState(0)
  const [allTimeMiles, setAllTimeMiles] = useState(0)
  const [allTimeDuration, setAllTimeDuration] = useState(0)
  const [allTimePrayers, setAllTimePrayers] = useState(0)

  const [allTimeSeconds, setAllTimeSeconds] = useState(0)
  const [allTimeMinutes, setAllTimeMinutes] = useState(0)
  const [allTimeHours, setAllTimeHours] = useState(0)


  const [statSwitch, setStatSwitch] = useState(false)

  useEffect(() => {
    formatDuration(allTimeDuration)
  }, [allTimeDuration])
  

  const formatDuration = (time) => {
    setAllTimeHours(Math.floor(time / 3600))
    setAllTimeMinutes(Math.floor(time % 3600 / 60))
    setAllTimeSeconds(Math.floor(time % 3600 % 60))
  }


  const handleModalOpen = () => {
    axios.post(`${apiEndpoint}/stats`, { userId 
    }).then(res => {
      console.log("fetchStats: ", res.data)
      setJourneyTitle(res.data.title)
      setTargetDate(res.data.targetDate)
      setProgressMiles(res.data.progressMiles)
      setTargetMiles(res.data.targetMiles)
      setPrayerCount(res.data.prayers)
      setSeconds(res.data.seconds)
      setAllTimeMiles(res.data.allTimeMiles)
      setAllTimeDuration(res.data.allTimeDuration)
      setAllTimePrayers(res.data.allTimePrayers)
      // formatDuration(allTimeDuration)
      setIsLoading(false)
    }).catch(err => {
      console.log(err)
    })
  }

  function roundDecimal(float) {
    return Number.parseFloat(float).toFixed(1)
  }

  const handleCheckChange = () => {
    setStatSwitch(!statSwitch)
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
            My Stats
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <div className="check-box d-flex justify-content-center">
          <p>Commitment</p>   
          <Form className='mx-3'>
            <Form.Check
              type="switch"
              id="custom-switch"
              defaultChecked={statSwitch}
              onChange={handleCheckChange}
            />
          </Form>
          <p>All-Time</p>
        </div>
          { (isLoading) ? <LoadingComponent/> : 
              (statSwitch) ? (
                <>
                  <h3 className='my-4'>Mileage:</h3>
                  <h3 className="my-3">{roundDecimal(allTimeMiles)}</h3>
                  <hr/>
                  <h3 className='my-4'>Prayers:</h3>
                  <h3 className="my-3">{allTimePrayers}</h3>
                  <hr/>
                  <h3 className='my-4'>Route Time:</h3>
                  {(allTimeDuration >= 3600) ? (<h3 className="my-3">{allTimeHours}:{(allTimeMinutes < 10) ? 0 : null}{allTimeMinutes}:{(allTimeSeconds < 10) ? 0 : null}{allTimeSeconds}</h3>) :
                  (allTimeDuration < 60) ? (<h3 className="my-3">0:{(allTimeSeconds < 10) ? 0 : null}{allTimeSeconds}</h3>) :
                  (<h3 className="my-3">{allTimeMinutes}:{(allTimeSeconds < 10) ? 0 : null}{allTimeSeconds}</h3>)}
                  
                  <hr/>
                  <h3 className='my-4'>My Accomplishments:</h3>
                  
                </>
              ) : 

                (journeyTitle === "No commitment") ? (
                  <>
                    <h3>No Commitment</h3>
                    <p>Please see the "My Commitment" section in the menu</p>
                  </>
                ) : (
                <>
                  <h6 className='mt-4'>My Commitment:</h6>
                  <h5>{journeyTitle}</h5>
                  <hr />
                  <h6 className='my-4'>Mileage: &nbsp;{roundDecimal(progressMiles/1000)} / {(targetMiles/1000)}</h6>
                  <ProgressBar animated now={(progressMiles/targetMiles)*100} />
                  <hr />
                  <h6 className='mt-4'>Prayers: &nbsp;{prayerCount}</h6>
                  <hr />
                  <h6 className='my-4'>Commitment End Date:</h6>
                  <h5 className='mt-1'>{targetDate.substring(0, 10)}</h5>     
                </>
          )}
      </Modal.Body>
      <Modal.Footer>
        <Button style={styles.navyButton} onClick={props.onHide}>Close</Button>
      </Modal.Footer>
    </Modal>
  );
}

export default StatsScreen