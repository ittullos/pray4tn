import React, { useState, useEffect, useContext } from 'react'
import axios from 'axios'
import Navbar from '../components/Navbar'
import Button from 'react-bootstrap/Button'
import Votd from '../components/Votd'
import RouteStats from '../components/RouteStats'
import PrayerScreen from '../components/PrayerScreen'
import DevotionalScreen from '../components/DevotionalScreen'
import StatsScreen from '../components/StatsScreen'
import RouteStopScreen from '../components/RouteStopScreen'
import Loading from '../components/Loading'
import LocationWarning from '../components/LocationWarning'
import PlanRouteScreen from '../components/PlanRouteScreen'
import { LoginContext, APIContext } from '../App'

const CheckpointInterval = 30000

function Home() {

  // VOTD state
  const [verse, setVerse]            = useState('')
  const [notation, setNotation]      = useState('')
  const [isLoading, setIsLoading]    = useState(true)

  // Pop-up screens state
  const [showPrayerScreen, setShowPrayerScreen]             = useState(false)
  const [showDevotionalScreen, setShowDevotionalScreen]     = useState(false)
  const [showStatsScreen, setShowStatsScreen]               = useState(false)
  const [showRouteStopScreen, setShowRouteStopScreen]       = useState(false)
  const [showLocationWarning, setShowLocationWarning]       = useState(false)
  const [disableLocationWarning, setDisableLocationWarning] = useState(false)
  const [showPlanRouteScreen, setShowPlanRouteScreen]       = useState(false)

  // Route state
  const [routeMileage, setRouteMileage]       = useState(0.0)
  const [intervalId, setIntervalId]           = useState()
  const [routeStarted, setRouteStarted]       = useState(false)
  const [routeButtonText, setRouteButtonText] = useState('Start')
  const [heartbeatMode, setHeartbeatMode]     = useState(false)
  const [routeType, setRouteType]             = useState('')

  // Location state
  const [location, setLocation]               = useState({lat: '', long: ''})
  const [locationEnabled, setLocationEnabled] = useState(null)

  // User context
  const [userId, setUserId] = useContext(LoginContext)
  const [apiEndpoint, setApiEndpoint] = useContext(APIContext)

  // Functions
  const handleRouteButton = () => {
    // Set route start
    setRouteStarted(!routeStarted)
  }

  const updateLocation = () => {
    navigator.geolocation.getCurrentPosition((position) => {
      setLocation({lat: position.coords.latitude, long: position.coords.longitude})
    }, () => {
      sendCheckpoint(routeType, {lat: "0", long: "0"})
    })
  }

  const sendCheckpoint = (type, location) => {
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
        setRouteMileage(routeMileage + distance)
        console.log("checkpoint response: ", res)
      }).catch(err => {
        console.log(err)
      })
    }
  }

  const getVerse = () => {
    axios.get(`${apiEndpoint}/home`)
    .then(res => {
      console.log("getVerse: ", res)
      setVerse(res.data.verse)
      setNotation(res.data.notation)
    }).catch(err => {
      console.log(err)
    })
  }

  function delay(time) {
    return new Promise(resolve => setTimeout(resolve, time));
  }

  // getVerse and prompt for geo location on page load
  useEffect(() => {
    let ignore = false
    if (!ignore) {
      getVerse()
      if(navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
          setLocationEnabled(true)
        }, function(error) {
          // alert('Error occurred. Error code: ' + error.code)
          alert('This page needs location services enabled to be fully functional')
          setLocationEnabled(false)
        })
      } else {
        //  alert("no geolocation support")
        alert('This page needs location services enabled to be fully functional')
        setLocationEnabled(false)
      }
    }
    return () => { ignore = true }
    },[])

  // Send checkpoint when location changes
  useEffect(() => {
    if (heartbeatMode && !routeStarted) {
      clearInterval(intervalId)
    } else {
      sendCheckpoint(routeType, location)
    }
  }, [location])

  // Set routeType when route is started
  useEffect(() => {
    // Change route button text
    setRouteButtonText(routeStarted ? "Stop" : "Start")
    if (routeStarted) {
      if (!locationEnabled) {
        if (localStorage.getItem('disableLocationWarning') === "true") {
          setDisableLocationWarning(true)
        }
        setShowLocationWarning(true)
      }
      // Update start location
      setRouteType("start")
      delay(CheckpointInterval).then(() => setRouteType("heartbeat"))
      delay(CheckpointInterval).then(() => setHeartbeatMode(true))
    } else {
      if (routeType !== "") {
        // Send stop checkpoint
        setHeartbeatMode(false)
        clearInterval(intervalId)
        setRouteType("stop")
      }
   }
  }, [routeStarted])

  useEffect(() => {
    if (routeButtonText === "Start") {
      clearInterval(intervalId)
    }
  }, [routeButtonText])

  // Update location when routeType is set
  useEffect(() => {
    if (routeType !== "") {
      updateLocation()
    }
    if (routeType === "stop") {
      setShowRouteStopScreen(true)
    }
  }, [routeType])

  // Reset route mileage when route stop screen closes
  useEffect(() => {
    if (!showRouteStopScreen) {
      setRouteMileage(0.0)
    }
  }, [showRouteStopScreen])

  // Start heartbeat interval
  useEffect(() => {
    if (heartbeatMode) { 
      setIntervalId(setInterval(() => {
          updateLocation()
      }, CheckpointInterval))
    }
  }, [heartbeatMode]);

  useEffect(() => {
    if (verse !== "" && locationEnabled != null) {
      setIsLoading(false)
    }
  }, [verse, locationEnabled])

  // disable scroll on document body
document.body.style.overflow = "hidden"

  return (
    <div className='full-screen'>
      <PrayerScreen
        show={showPrayerScreen}
        onHide={() => setShowPrayerScreen(false)}/> 
      <DevotionalScreen
        show={showDevotionalScreen}
        onHide={() => setShowDevotionalScreen(false)}/> 
      <StatsScreen
        show={showStatsScreen}
        onHide={() => setShowStatsScreen(false)}/>
      <RouteStopScreen 
        show={showRouteStopScreen}
        onHide={() => setShowRouteStopScreen(false)}
        mileage={routeMileage}/>
      <LocationWarning 
        show={showLocationWarning && !disableLocationWarning}
        onHide={() => setShowLocationWarning(false)} />
      <PlanRouteScreen 
        show={showPlanRouteScreen}
        onHide={() => setShowPlanRouteScreen(false)} />
      <Navbar showStatsScreen={showStatsScreen => setShowStatsScreen(showStatsScreen)}
              showPlanRouteScreen={showPlanRouteScreen => setShowPlanRouteScreen(showPlanRouteScreen)}/>

      { isLoading ? (
        <Loading />
      ) : (   
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
                {routeStarted && <RouteStats mileage={routeMileage}/>}
            </div>
            <div className="popups
                            col-12 
                            p-2 
                            bd-highlight 
                            d-flex 
                            flex-row 
                            justify-content-center 
                            align-items-start">
                <Button variant="primary" 
                        className='popup-btn m-4'
                        onClick={() => setShowDevotionalScreen(true)}>
                  Devotional
                </Button>
                <Button variant="primary" 
                        className='popup-btn m-4'
                        onClick={() => setShowPrayerScreen(true)}>
                  Prayer
                </Button>
            </div>
        </div>
      )}
    </div>
  )
}

export default Home

