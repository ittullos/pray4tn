import React, { useState, useEffect } from 'react'
import axios from 'axios'
import Navbar from '../components/Navbar'
import Button from 'react-bootstrap/Button'
import Votd from '../components/Votd'
import GeoTracker from '../components/GeoTracker'

document.body.style.overflow = "hidden"


function Home() {

  const [verse, setVerse]                     = useState('')
  const [notation, setNotation]               = useState('')
  const [routeStarted, setRouteStarted]           = useState(false)
  const [routeButtonText, setRouteButtonText] = useState('Start')

  const handleRouteStart = () => {
    setRouteStarted(!routeStarted)
    setRouteButtonText(routeStarted ? "Start" : "Stop")}
  // const [votdShow, setVotdShow] = React.useState(false);

  

  const getVerse = () => {
    // axios.get("https://2wg6nk0bs8.execute-api.us-east-1.amazonaws.com/Prod/p4l/home")
    axios.get("http://localhost:9292/p4l/home")
    .then(res => {
      console.log(res)
      setVerse(res.data.verse)
      setNotation(res.data.notation)
    }).catch(err => {
      console.log(err)
    })
  }

  useEffect(() => {
    let ignore = false
    if (!ignore)  getVerse()
    return () => { ignore = true }
    },[])

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
                      onClick={handleRouteStart}
                      style={{ backgroundColor: routeStarted ? "#d9534f" : "#02b875" }}
                      className='route-button 
                                 btn-lg 
                                 mt-3'>
                                  {/* #02b875 */}
                                  {/* #d9534f */}
                {routeButtonText} Route
              </Button>
              {routeStarted && <GeoTracker />}
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
