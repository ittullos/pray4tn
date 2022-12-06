import React, { useState, useEffect, useRef } from 'react'
import axios from 'axios'
import Navbar from '../components/Navbar'
import Button from 'react-bootstrap/Button'
import Votd from '../components/Votd'
import RouteStats from '../components/RouteStats'

document.body.style.overflow = "hidden"

function Home() {
  // API endpoint
  // const uri = "https://2wg6nk0bs8.execute-api.us-east-1.amazonaws.com/Prod/p4l"
  const uri = "http://localhost:9292/p4l"

  // VOTD state
  const [verse, setVerse]       = useState('')
  const [notation, setNotation] = useState('')

  // Route state
  const [routeMileage, setRouteMileage]       = useState(0.0)
  const [intervalId, setIntervalId]           = useState()
  const [routeStarted, setRouteStarted]       = useState(false)
  const [routeButtonText, setRouteButtonText] = useState('Start')
  const [heartbeatMode, setHeartbeatMode]     = useState(false)
  const [routeMode, setRouteMode]             = useState('')

  // Location state
  const [location, setLocation] = useState({lat: '', long: ''})

  // Functions
  const handleRouteButton = () => {
    // Set route start
    setRouteStarted(!routeStarted)
  }

  const updateLocation = () => {
    navigator.geolocation.getCurrentPosition((position) => {
      setLocation({lat: position.coords.latitude, long: position.coords.longitude})
    })
  }

  const sendCheckpoint = (type) => {
    if (type !== "") {
      const checkpointData = {
        type:     type,
        lat:      location.lat,
        long:     location.long
      }
      console.log(checkpointData)
      axios.post(`${uri}/checkpoint`, { checkpointData
      }).then(res => {
        console.log(res)
      }).catch(err => {
        console.log(err)
      })
    }
  }

  const getVerse = () => {
    axios.get(`${uri}/home`)
    .then(res => {
      console.log(res)
      setVerse(res.data.verse)
      setNotation(res.data.notation)
    }).catch(err => {
      console.log(err)
    })
  }

  function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time));
  }

  // getVerse on page load
  useEffect(() => {
    let ignore = false
    if (!ignore)  getVerse()
    return () => { ignore = true }
    },[])

  // Send checkpoint when location changes
  useEffect(() => {
    sendCheckpoint(routeMode)
  }, [location])

  // Set routeMode when route is started
  useEffect(() => {
    // Change route button text
    setRouteButtonText(routeStarted ? "Stop" : "Start")
    if(routeStarted) {
      console.log('routeStarted: ', routeStarted);
      // Update start location
      setRouteMode("start")
      delay(3000).then(() => setRouteMode("heartbeat"))
      delay(3000).then(() => setHeartbeatMode(true))
    } else {
      if (location.lat !== "") {
        // Send stop checkpoint
        setHeartbeatMode(false)
        clearInterval(intervalId)
        setRouteMode("stop")
      }
   }
  }, [routeStarted])

  // Update location when routeMode is set
  useEffect(() => {
    if (routeMode !== "") {
      updateLocation()
    }
  }, [routeMode])

  // Start heartbeat interval
  useEffect(() => {
    if (heartbeatMode) { 
      setIntervalId(setInterval(() => {
        updateLocation()
      }, 3000))
    }
  }, [heartbeatMode]);

  return (
    <div className='full-screen'>
      <Navbar />
      <div className="body
                      row d-flex 
                      justify-content-center 
                      align-items-start
                      text-start  
                      fill-height">
          <div className="votd
                          col-12 
                          p-2 
                          bd-highlight">
            <Votd notation={notation} 
                  verse={verse}
            />
          </div>
          <div className="route 
                          col-12 
                          p-2 
                          bd-highlight 
                          d-flex 
                          flex-column 
                          justify-content-start 
                          align-items-center">
              <Button variant="success" 
                      onClick={handleRouteButton}
                      style={{ backgroundColor: routeStarted ? "#d9534f" : "#02b875" }}
                      className='route-button 
                                 btn-lg 
                                 mt-3'>
                {routeButtonText} Route
              </Button>
              {routeStarted && <RouteStats />}
          </div>
          <div className="popups
                          col-12 
                          p-2 
                          bd-highlight 
                          d-flex 
                          flex-row 
                          justify-content-center 
                          align-items-start">
              <Button variant="primary" className='popup-btn 
                                                   m-4'>
                Devotional
              </Button>
              <Button variant="primary" className='popup-btn 
                                                   m-4'>
                Prayer
              </Button>
          </div>
      </div>

              {/* <Button 
                variant="success" 
                onClick={() => setVotdShow(true)}
                className="mt-5 btn-md">
                Verse of the Day
              </Button>

              <Votd
                show={votdShow}
                onHide={() => setVotdShow(false)}
                notation={notation} 
                verse={verse}
              />           */}
        

    </div>
  )
}

export default Home
