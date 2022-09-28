import React, { useState } from 'react'
import axios from 'axios'
import NavbarComp from '../components/NavbarComp'
import Button from 'react-bootstrap/Button'


function Home() {

  const [verse, setVerse] = useState('')
  const [notation, setNotation] = useState('')

  const getVerse = () => {
    axios.get("https://1wegclp8d9.execute-api.us-east-1.amazonaws.com/Prod/hello")
    .then(res => {
      console.log(res)
      setVerse(res.data.verse)
      setNotation(res.data.notation)
    }).catch(err => {
      console.log(err)
    })
  }

  return (
    <div>
      <NavbarComp />
      <div className="center-button">
        <Button className="mt-5 btn-lg" onClick={getVerse}>Get Verse</Button>
      </div>
      <div className="text-center mx-5 mt-5">
        <figure>
          <blockquote className="blockquote">
            <p className="mb-0" style={{fontSize: 25}}>"{verse}"</p>
          
          </blockquote>
          <figcaption className="blockquote-footer mt-2" style={{fontSize: 20}}>
            {notation}
          </figcaption>
        </figure>
      </div>
      
    </div>
  )
}

export default Home
