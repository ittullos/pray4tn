import React, { useState, useEffect } from 'react'
import axios from 'axios'
import Navbar from '../components/Navbar'
import Button from 'react-bootstrap/Button'
import Votd from '../components/Votd'

document.body.style.overflow = "hidden"


function Home() {

  const [verse, setVerse] = useState('')
  const [notation, setNotation] = useState('')
  // const [votdShow, setVotdShow] = React.useState(false);

  

  const getVerse = () => {
    // axios.get("https://hztuc61z8f.execute-api.us-east-1.amazonaws.com/Prod/hello")
    axios.get("http://localhost:9292/hello")
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
      <div className="row d-flex justify-content-center align-items-between text-start body fill-height">
          <div className="col-12 p-2 bd-highlight votd">
            <Votd notation={notation} 
                  verse={verse}
            />
          </div>
          <div className="col-12 p-2 bd-highlight route d-flex flex-column justify-content-start align-items-center">
              <Button variant="success" className='btn-lg route-button mt-3'>Start Route</Button>
          </div>
          <div className="col-12 p-2 bd-highlight popups d-flex flex-row justify-content-center align-items-center">
              <Button variant="primary" className='popup-btn m-4'>
                Devotional
              </Button>
              <Button variant="primary" className='popup-btn m-4'>
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
