import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import LoadingComponent from './LoadingComponent'
import axios from 'axios'
import { useEffect, useState, useContext } from 'react'
import { APIContext } from '../App';

function PrayerScreen(props) {
  const { prayerName,
          setPrayerName, 
          prayerListLoaded,
          setPrayerListLoaded, 
          routeStarted, 
          userId, 
          routeMileage, 
          setRouteMileage, 
          ...rest } = props

  const [isLoading, setIsLoading]     = useState(true)
  const [location, setLocation]       = useState({lat: '', long: ''})
  const [prayerType, setPrayerType]   = useState('prayer_start')
  const [apiEndpoint, setApiEndpoint] = useContext(APIContext)
  const [modalOpen, setModalOpen]     =useState(false)

  const handleModalOpen = () => {
    setPrayerType("prayer_start")
    setModalOpen(true)
    if (!prayerListLoaded) {
      updateLocation()
    }
  }

  const handleModalClose = () => {
    if (prayerType === "prayer" && !routeStarted) {
      setPrayerType("stop")
      updateLocation()
    }
    setIsLoading(true)
    setPrayerListLoaded(false)

  }

  const handleNextPrayerName = () => {
    updateLocation()
  }

  const updateLocation = () => {
    navigator.geolocation.getCurrentPosition((position) => {
      setLocation({lat: position.coords.latitude, long: position.coords.longitude})
    }, () => {
      sendPrayerCheckpoint(prayerType, {lat: "0", long: "0"})
    })
  }

  const sendPrayerCheckpoint = (type, location) => {
    console.log("sending a ", type);
    if (type !== "") {
      const checkpointData = {
        type:     type,
        lat:      location.lat,
        long:     location.long,
        userId:   userId
      }
      axios.post(`${apiEndpoint}/checkpoint`, { checkpointData
      }).then(res => {
        let distance = res.data["distance"]
        let name = res.data["prayerName"]
        if (distance > 0.0 && routeStarted) {
          setRouteMileage(routeMileage + distance)
        }
        if (name !== "") {
          setPrayerName(name)
          if (!prayerListLoaded) {
            setPrayerListLoaded(true)
            setIsLoading(false)
          }
          if (prayerType === "prayer_start") {
            setPrayerType("prayer")
          }
          else if (prayerType === "prayer") {

          }

        }
        console.log("prayer checkpoint response: ", res)
      }).catch(err => {
        console.log(err)
      })
    }
  }

  useEffect(() => {
    if (modalOpen) {
      sendPrayerCheckpoint(prayerType, location)
    }
  }, [location])

  // useEffect(() => {
  //   let ignore = false
  //   if (!ignore && !prayerListLoaded) {
  //     updateLocation()
  //   }
  //   return () => { ignore = true }
  //  },[])
  
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
      ) : (
        <div>
          <h4 className='my-4'>{prayerName}</h4>
          <Button onClick={handleNextPrayerName} variant="success">Next</Button>
        </div>
      
      )}
       
      </Modal.Body>
      <Modal.Footer>
        <Button onClick={rest.onHide}>Close</Button>
      </Modal.Footer>
    </Modal>
  );
}

export default PrayerScreen