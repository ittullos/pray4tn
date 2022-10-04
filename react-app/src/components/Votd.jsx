import React from 'react'
import Button from 'react-bootstrap/Button'
import "../styles/Modal.css"


function Votd(props) {
  return (
    <div className='modalBackground'>
      <div className='modalContainer'>
        <div className='modalCloseBtn'>
          <button onClick={() => props.closeModal(false)}> X </button>
        </div>
        <div className='modalTitle'>
          <h3>Verse of the day</h3>
        </div>
        <div className='modalBody'>
          <div className="text-center mx-5 mt-5">
            <figure>
              <blockquote className="blockquote">
                <p className="mb-0" style={{fontSize: 25}}>"{props.verse}"</p>
              
              </blockquote>
              <figcaption className="blockquote-footer mt-2" style={{fontSize: 20}}>
                {props.notation}
              </figcaption>
            </figure>
          </div>
        </div>
        <div className='modalFooter'>
          <Button onClick={() => props.closeModal(false)}>Exit</Button>
        </div>
      </div>
    </div>
  )
}

export default Votd