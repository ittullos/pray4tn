/* eslint-disable react/jsx-no-comment-textnodes */
import React, { useState, useEffect } from 'react'
import axios from 'axios'
import NavbarComp from '../components/NavbarComp'
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import Col from 'react-bootstrap/Col';
// import Button from 'react-bootstrap/Button'
// import Votd from '../components/Votd'


function Home() {

  const [verse, setVerse] = useState('')
  const [notation, setNotation] = useState('')
  // const [votdShow, setVotdShow] = React.useState(false);

  const getVerse = () => {
    axios.get("https://hztuc61z8f.execute-api.us-east-1.amazonaws.com/Prod/hello")
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
      <NavbarComp />
      <div class="row d-flex justify-content-center align-items-between text-start body fill-height">
          <div class="col-12 p-2 bd-highlight votd bg-secondary">
              // Add Content
          </div>
          <div class="col-12 p-2 bd-highlight route bg-success">
              // Add Content
          </div>
          <div class="col-12 p-2 bd-highlight popups bg-danger">
              // Add Content
          </div>
      </div>
      {/* <div className="body bg-warning flex-column flex-md-row justify-content-between">

        <div className="votd bg-secondary">
          VOTD
        </div>

        <div className="route bg-success">
          ROUTE
        </div>

        <div className="popups bg-danger">
          POPUPS
        </div> */}
        
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
        />
      </div> */}
    </div>
  )
}

export default Home
