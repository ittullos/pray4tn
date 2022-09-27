// import React, { useState, useEffect } from 'react'
import axios from 'axios'
import NavbarComp from '../components/NavbarComp'
import Button from 'react-bootstrap/Button'


function Home() {

  const getVerse = () => {
    axios.get("https://a0bdrfx4za.execute-api.us-east-1.amazonaws.com/Prod/hello/")
    .then(res => {
      console.log(res)
    }).catch(err => {
      console.log(err)
    })
  }

  return (
    <div>
      <NavbarComp />
      <div className="center-button">
        <Button className="mt-5" onClick={getVerse}>Get Verse</Button>
      </div>
      
    </div>
  )
}

export default Home
