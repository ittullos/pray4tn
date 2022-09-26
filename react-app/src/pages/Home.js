import React, { useState, useEffect } from 'react'
import axios from 'axios'
import NavbarComp from '../components/NavbarComp'


function Home() {
  const url = "https://a6kho7q6m8.execute-api.us-east-1.amazonaws.com/Prod/hello/"
  const [verse, setVerse] = useState(null)

    useEffect(() => {
      axios.get(url)
        .then(response => {
          setVerse(response.data)
        })
    }, [url])

  return (
    <div>
      <NavbarComp />
    </div>
  )
}

export default Home
