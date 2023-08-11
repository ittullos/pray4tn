import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import LoadingComponent from './LoadingComponent'
import axios from 'axios'
import { useEffect, useState, useContext } from 'react'
import { APIContext } from '../App';
import { styles } from '../styles/inlineStyles'

function PrayerScreen(props) {
  const { prayerName,
          setPrayerName, 
          prayerCount,
          setPrayerCount,
          routeStarted,
          prayerListLoaded,
          setPrayerListLoaded,
          userId,  
          ...rest } = props

  const [isLoading, setIsLoading]     = useState(true)
  const [apiEndpoint, setApiEndpoint] = useContext(APIContext)
  const [modalOpen, setModalOpen]     = useState(false)

  const handleModalOpen = () => {
    if (!modalOpen) {
      setModalOpen(true)
    }
  }
  
  const handleModalClose = () => {
    // setIsLoading(true)
    // setModalOpen(false)
    // setPrayerListLoaded(false)
  }

  const handleNextPrayerName = () => {
    sendPrayerCheckpoint("prayer")
  }

  // The isLoading and prayerListLoading variables may need to be removed because of duplication
  const sendPrayerCheckpoint = (type) => {
    if (type !== "") {
      const checkpointData = {
        type:     type,
        lat:      0,
        long:     0,
        user_id:   userId
      }
      console.log("PrayerScreen:sendPrayerCheckpoint:checkpointData: ", checkpointData)
      axios.post(`${apiEndpoint}/checkpoint`, { checkpointData
      }).then(res => {
        let name = res.data["prayerName"]
        if (name !== "") {
          setPrayerName(name)
          setPrayerListLoaded(true)
          setIsLoading(false)
          if (type === "prayer" && routeStarted) {
            setPrayerCount(prayerCount + 1)
          }
        } else {
          setPrayerListLoaded(false)
          setIsLoading(false)
        }
        console.log("prayer checkpoint response: ", res)
      }).catch(err => {
        console.log(err)
      })
    }
  }

  useEffect(() => {
    if (modalOpen) {
      sendPrayerCheckpoint("prayer")
    }
  }, [modalOpen])

  useEffect(() => {
    console.log("isLoading: ", isLoading)
    console.log("prayerListLoaded: ", prayerListLoaded)

  }, [isLoading, prayerListLoaded])
  
  return (

    <Modal
      {...rest}
      size="lg"
      aria-labelledby="contained-modal-title-vcenter"
      centered
      className='text-center'
      onEntered={handleModalOpen}
      onExit={handleModalClose}
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
      { isLoading ? (
        <LoadingComponent />
      ) : (!prayerListLoaded) ? (
        <>
          <h3>No prayer list loaded</h3>
          <h6 className='my-3'>Visit the "Plan Route" Screen to download your prayer list.</h6>
        </>
      ) : (
      // )
        <div>
          <h4 className='my-4'>{prayerName}</h4>
          <Button onClick={handleNextPrayerName} variant="success" className='mb-3 mt-1'>Next</Button>
        </div>
      
      )}
       
      </Modal.Body>
      <Modal.Footer>
        <Button style={styles.navyButton} className="button" onClick={rest.onHide}>Close</Button>
      </Modal.Footer>
    </Modal>
  );
}

export default PrayerScreen