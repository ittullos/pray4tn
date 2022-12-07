import React from 'react'

function roundDecimal(float) {
  return Number.parseFloat(float).toFixed(1)
}

function Mileage(props) {
  return (
    <>
      <div className='mileage-counter p-2 ms-4'>
        {roundDecimal(props.mileage)}
      </div>
      <div className='mileage-text'>
        mi
      </div>
    </>
  )
}

export default Mileage
