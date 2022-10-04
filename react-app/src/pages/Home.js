import React, { useState } from 'react'
import axios from 'axios'
import NavbarComp from '../components/NavbarComp'
import Button from 'react-bootstrap/Button'
import Votd from '../components/Votd'


function Home() {

  const [verse, setVerse] = useState('')
  const [notation, setNotation] = useState('')
  const [openVotd, setOpenVotd] = useState(false)

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
        <Button className="mt-5 btn-md btn-info" onClick={()=>{ getVerse(); setOpenVotd(true) }}>Verse of the Day</Button>
      </div>
      <div>
        {openVotd && <Votd notation={notation} verse={verse} closeModal={setOpenVotd}/>}
      </div>
    </div>
  )
}

export default Home
