import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import Form from 'react-bootstrap/Form'
import { useState, useEffect, useContext } from 'react';
import { styles } from '../styles/inlineStyles';
import axios from 'axios';
import { APIContext } from '../App';

function JourneyComplete(props) {

  const [apiEndpoint, setApiEndpoint] = useContext(APIContext)

  const { userId,
          nextJourney,
          nextJourneyMiles,
          setJourneyTitle,
          setTargetMiles,
          progressMiles,
          ...rest } = props

  const handleCommitChange = () => {
    if (!nextJourney.includes('Nice Work!!!')) {
      let commitData = {
        user_id: userId,
        journey_id: nextJourney
      }
      axios.post(`${apiEndpoint}/commitment`, { commitData 
      }).then(res => {
        console.log("sendCommit response: ", res)
        console.log("nextJourney: ", nextJourney, "nextJourneyMiles: ", nextJourneyMiles)
        setJourneyTitle(nextJourney)
        setTargetMiles(nextJourneyMiles)
        // setShowCommitSuccess(true)

      }).catch(err => {
        console.log(err)
        // setShowCommitError(true)
      })
    }
    else {
      console.log("progressMiles inside: ", progressMiles)
      localStorage.setItem('disableJourneyComplete', "true")
    }
  }

  return (
    <Modal
      {...rest}
      size="lg"
      aria-labelledby="contained-modal-title-vcenter"
      centered
      onExit={handleCommitChange}
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
            Congratulations!!!
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <h5 className='mb-4'>You have completed your commitment!</h5>
        <p>- We have changed your current commitment to the next journey.</p>
        <p>- See if you can make the next journey distance before your commitment end date.</p>
        <p>- You can change journeys by visiting the "My Commitment" screen.</p>
        <p>- To see your accomplishments, visit the "My Stats" screen and move the switch at the top to "All-Time"</p>
      </Modal.Body>
      <Modal.Footer className='d-flex
                               flex-column
                               justify-content-center
                               align-items-center'>
        <Button style={styles.navyButton} onClick={rest.onHide}>
          Close
        </Button>
      </Modal.Footer>
    </Modal>
  );
}

export default JourneyComplete