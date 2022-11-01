import React from 'react'

function Votd(props) {
  return (
    <div>
      <div className="votd-container text-center"       
           aria-labelledby="contained-modal-title-vcenter">
        <h2 className='pt-3 mt-1'>Verse of the Day</h2>
        <figure className="text-center mx-4 mt-3">
          <blockquote className="blockquote" style={{fontSize:24}}>
            <p className="mb-0">
              {props.verse}
            </p>      
          </blockquote>
          <figcaption 
            className="blockquote-footer mt-2 me-1"
            style={{fontSize:22}}>
              {props.notation}
          </figcaption>
        </figure>
      </div>
    </div>
  )
}

export default Votd