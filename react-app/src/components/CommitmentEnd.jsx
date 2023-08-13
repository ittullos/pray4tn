import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import Form from 'react-bootstrap/Form'
import { useState, useEffect, useContext } from 'react';
import { styles } from '../styles/inlineStyles';
import axios from 'axios';
import { APIContext, LoginContext } from '../App';

function CommitmentEnd(props) {

  const [apiEndpoint, setApiEndpoint] = useContext(APIContext)
  const [userId, setUserId]           = useContext(LoginContext)
  const [progressMiles, setProgressMiles] = useState(0)
  const [prayerCount, setPrayerCount] = useState(0)
  const [seconds, setSeconds] = useState(0)
  const [commitAchievement, setCommitAchievement] = useState("")
  const [commitAchievementTitle, setCommitAchievementTitle] = useState("")
  const [commitAchievementMileage, setCommitAchievementMileage] = useState(0)
  const [commitMinutes, setCommitMinutes] = useState(0)
  const [commitSeconds, setCommitSeconds] = useState(0)
  const [commitHours, setCommitHours] = useState(0)
  const [journeyTitle, setJourneyTitle] = useState()

  // const { userId,
  //         nextJourney,
  //         nextJourneyMiles,
  //         setJourneyTitle,
  //         setTargetMiles,
  //         ...rest } = props

  const handleCommitChange = () => {
    localStorage.setItem('disableJourneyComplete', "false")
    let commitData = {
      user_id: userId,
      journey_id: journeyTitle
    }
    axios.post(`${apiEndpoint}/commitment_end`, { commitData 
    }).then(res => {
      console.log("sendCommit response: ", res)

    }).catch(err => {
      console.log(err)
    })
  }

  useEffect(() => {
    console.log("journeyTitle Commit End: ", journeyTitle)
      if (journeyTitle && journeyTitle.includes('Nice Work!!!')) {
        console.log("Changing journeyTitle to last journey")
      }
  }, [journeyTitle])
  

  const handleModalOpen = () => {
    axios.post(`${apiEndpoint}/stats`, { userId 
    }).then(res => {
      console.log("fetchStats: ", res.data)
      setJourneyTitle(res.data.title)
      // setTargetDate(res.data.targetDate)
      setProgressMiles(res.data.progressMiles)
      // setTargetMiles(res.data.targetMiles)
      setPrayerCount(res.data.prayers)
      setSeconds(res.data.seconds)
      // setAllTimeMiles(res.data.allTimeMiles)
      // setAllTimeDuration(res.data.allTimeDuration)
      // setAllTimePrayers(res.data.allTimePrayers)
      // setAchievements(res.data.achievement)
      setCommitAchievement(res.data.commit_achievement)
      setCommitAchievementTitle(res.data.commit_achievement_title)
      setCommitAchievementMileage(res.data.commit_achievement_mileage)
      // setNextJourney(res.data.next_journey)
      // setNextJourneyMiles(res.data.next_journey_miles)
      // formatDuration(seconds)
      // setIsLoading(false)
    }).catch(err => {
      console.log(err)
    })
  }

  function roundDecimal(float) {
    return Number.parseFloat(float).toFixed(1)
  }

  const formatDuration = (time) => {
    setCommitHours(Math.floor(time / 3600))
    setCommitMinutes(Math.floor(time % 3600 / 60))
    setCommitSeconds(Math.floor(time % 3600 % 60))
  }

  useEffect(() => {
    formatDuration(seconds)
  }, [seconds])
  

  return (
    <Modal
      {...props}
      size="lg"
      aria-labelledby="contained-modal-title-vcenter"
      centered
      onExit={handleCommitChange}
      onEnter={handleModalOpen}
      className='text-center bg-success'>
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
            Commitment End
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <h6 className='mb-4'>Your Annual Commitment time has expired!</h6>
        <hr />
        { (commitAchievementTitle === "") ? (
          <>
            <h4 className='my-4'>No Journey achieved</h4>
            <hr />
          </>
        ) : (
          <>
            <h4 className='mt-4'>Journey Achieved:</h4>
            <h5 className='mb-4'>{commitAchievementTitle} ({commitAchievementMileage/1000} miles)</h5>
            <hr />
          </>
        )}
        <h2>Commitment Stats:</h2>
        <hr />
        <h3 className='my-4'>Mileage:</h3>
        <h3 className="my-3">{roundDecimal(progressMiles/1000)}</h3>
        <hr/>
        <h3 className='my-4'>Prayers:</h3>
        <h3 className="my-3">{prayerCount}</h3>
        <hr/>
        <h3 className='my-4'>Route Time:</h3>
        {(seconds >= 3600) ? (<h3 className="my-3">{commitHours}:{(commitMinutes < 10) ? 0 : null}{commitMinutes}:{(commitSeconds < 10) ? 0 : null}{commitSeconds}</h3>) :
        (seconds < 60) ? (<h3 className="my-3">0:{(commitSeconds < 10) ? 0 : null}{commitSeconds}</h3>) :
        (<h3 className="my-3">{commitMinutes}:{(commitSeconds < 10) ? 0 : null}{commitSeconds}</h3>)}
        <p>- We have created a new Commitment that starts today.</p>
        <p>- We have selected the same Journey from your last Commitment.</p>
        <p>- Feel free to change your Commitment by visiting the "My Commitment" screen.</p>
      </Modal.Body>
      <Modal.Footer className='d-flex
                               flex-column
                               justify-content-center
                               align-items-center'>
        <Button style={styles.navyButton} onClick={props.onHide}>
          Close
        </Button>
      </Modal.Footer>
    </Modal>
  );
}

export default CommitmentEnd