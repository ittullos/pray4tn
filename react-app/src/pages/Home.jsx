import React, { useState, useEffect, useContext } from 'react'
import axios from 'axios'
import Navbar from '../components/Navbar'
import Button from 'react-bootstrap/Button'
import Votd from '../components/Votd'
import RouteStats from '../components/RouteStats'
import PrayerScreen from '../components/PrayerScreen'
import DevotionalScreen from '../components/DevotionalScreen'
import StatsScreen from '../components/StatsScreen'
import CommitmentScreen from '../components/CommitmentScreen'
import RouteStopScreen from '../components/RouteStopScreen'
import Loading from '../components/Loading'
import LocationWarning from '../components/LocationWarning'
import LockWarning from '../components/LockWarning'
import PlanRouteScreen from '../components/PlanRouteScreen'
import { LoginContext, APIContext } from '../App'
import { styles } from '../styles/inlineStyles'
import { useWakeLock } from 'react-screen-wake-lock';
import NoSleep from 'nosleep.js'


const CheckpointInterval = 30000

function Home() {
  // Wake Lock
  // const { isSupported, released, request, release } = useWakeLock({
  //   onRequest: () => console.log('Screen Wake Lock: requested!'),
  //   onError: () => console.log('An error happened 💥'),
  //   onRelease: () => console.log('Screen Wake Lock: released!'),
  // })

  // VOTD state
  const [verse, setVerse]            = useState('')
  const [notation, setNotation]      = useState('')
  const [isLoading, setIsLoading]    = useState(true)

  // Pop-up screens state
  const [showPrayerScreen, setShowPrayerScreen]             = useState(false)
  const [showDevotionalScreen, setShowDevotionalScreen]     = useState(false)
  const [showStatsScreen, setShowStatsScreen]               = useState(false)
  const [showCommitmentScreen, setShowCommitmentScreen]     = useState(false)
  const [showRouteStopScreen, setShowRouteStopScreen]       = useState(false)
  const [showLocationWarning, setShowLocationWarning]       = useState(false)
  const [showLockWarning, setShowLockWarning]               = useState(false)
  const [disableLocationWarning, setDisableLocationWarning] = useState(false)
  const [disableLockWarning, setDisableLockWarning]         = useState(false)
  const [showPlanRouteScreen, setShowPlanRouteScreen]       = useState(false)

  // Route state
  const [routeMileage, setRouteMileage]       = useState(0.0)
  const [intervalId, setIntervalId]           = useState()
  const [routeStarted, setRouteStarted]       = useState(false)
  const [routeButtonText, setRouteButtonText] = useState('Start')
  const [heartbeatMode, setHeartbeatMode]     = useState(false)
  const [routeType, setRouteType]             = useState('')
  const [prayerCount, setPrayerCount]         = useState(0)

  // Location state
  const [location, setLocation]               = useState({lat: '', long: ''})
  const [locationEnabled, setLocationEnabled] = useState(null)

  // Prayer State
  const [prayerName, setPrayerName]             = useState("Isaac")
  const [prayerListLoaded, setPrayerListLoaded] = useState(false)

  // User context
  const [userId, setUserId] = useContext(LoginContext)
  const [apiEndpoint, setApiEndpoint] = useContext(APIContext)

  // NoSleep
  var noSleep = new NoSleep();
  const [noSleepActive, setNoSleepActive] = useState(false)

  useEffect(() => {
    console.log("prayerCount: ", prayerCount)

  }, [prayerCount])
  

  // Functions
  const handleRouteButton = () => {
    // Set route start
    setRouteStarted(!routeStarted)
    setNoSleepActive(!noSleepActive)
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
        user_id:   userId
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
    axios.post(`${apiEndpoint}/home`, { userId 
    }).then(res => {
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
          // alert('This page needs location services enabled to be fully functional')
          setLocationEnabled(false)
        })
      } else {
        // alert('This page needs location services enabled to be fully functional')
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
      // if (!locationEnabled) {
      //   if (localStorage.getItem('disableLocationWarning') === "true") {
      //     setDisableLocationWarning(true)
      //   }
      //   setShowLocationWarning(true)
      // }
      if (localStorage.getItem('disableLockWarning') === "true") {
        setDisableLockWarning(true)
      }
      setShowLockWarning(true)
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
      setPrayerCount(0)
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

  useEffect(() => {
    if (!locationEnabled && !isLoading) {
      if (localStorage.getItem('disableLocationWarning') === "true") {
        setDisableLocationWarning(true)
      }
      setShowLocationWarning(true)
    }
  }, [isLoading])
  

  // disable scroll on document body
document.body.style.overflow = "hidden"

  return (
    <div className='full-screen'>
      <PrayerScreen
        show={showPrayerScreen}
        onHide={() => setShowPrayerScreen(false)}
        prayerName={prayerName}
        prayerListLoaded={prayerListLoaded}
        routeStarted={routeStarted}
        userId={userId}
        setPrayerName={setPrayerName}
        setPrayerCount={setPrayerCount}
        prayerCount={prayerCount}
        setPrayerListLoaded={setPrayerListLoaded} /> 
      <DevotionalScreen
        show={showDevotionalScreen}
        onHide={() => setShowDevotionalScreen(false)}/> 
      <StatsScreen
        show={showStatsScreen}
        onHide={() => setShowStatsScreen(false)}/>
      <RouteStopScreen 
        show={showRouteStopScreen}
        onHide={() => setShowRouteStopScreen(false)}
        mileage={routeMileage}
        prayerCount={prayerCount}
        setMileage={setRouteMileage}
        userId={userId}/>
      <LocationWarning 
        show={showLocationWarning && !disableLocationWarning}
        onHide={() => setShowLocationWarning(false)} />
      <LockWarning 
        show={showLockWarning && !disableLockWarning}
        onHide={() => setShowLockWarning(false)} />
      <PlanRouteScreen 
        show={showPlanRouteScreen}
        onHide={() => setShowPlanRouteScreen(false)}
        userId={userId} />
      <CommitmentScreen
        show={showCommitmentScreen}
        onHide={() => setShowCommitmentScreen(false)}/>
      <Navbar showStatsScreen={showStatsScreen => setShowStatsScreen(showStatsScreen)}
              showCommitmentScreen={showCommitmentScreen => setShowCommitmentScreen(showCommitmentScreen)}
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
                        onClick={() =>  <>
                                          { handleRouteButton() }
                                          {/* { (released === false ? release() : request()) } */}
                                          { noSleepActive ? noSleep.disable() : noSleep.enable() }

                                        </>}
                        style={{ backgroundColor: routeStarted ? "#d9534f" : "#02b875" }}
                        className='route-button 
                                  btn-lg
                                  button
                                  mt-3'>
                  {routeButtonText} Route
                </Button>
                {routeStarted && <RouteStats mileage={routeMileage} prayerCount={prayerCount} />}
            </div>
            <div className="popups
                            col-12 
                            p-2 
                            bd-highlight 
                            d-flex 
                            flex-row 
                            justify-content-center 
                            align-items-start">
                <Button className='popup-btn m-4 navy-blue button'
                        style={styles.navyButton}
                        onClick={() => setShowDevotionalScreen(true)}>
                  Devotional
                </Button>
                <Button className='popup-btn m-4 navy-blue button'
                        style={styles.navyButton}
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

