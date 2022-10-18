import React, { useState, useEffect } from 'react'
import axios from 'axios'
import NavbarComp from '../components/NavbarComp'
import Button from 'react-bootstrap/Button'
import Votd from '../components/Votd'


function Home() {

  const [verse, setVerse] = useState('')
  const [notation, setNotation] = useState('')
  const [votdShow, setVotdShow] = React.useState(false);

  const getVerse = () => {
    axios.get("https://ard1b3wic0.execute-api.us-east-1.amazonaws.com/Prod/hello")
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
    <div>
      <NavbarComp />
      <div className="center-button">
        
        <Button 
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
        />
      </div>
    </div>
  )
}

export default Home
