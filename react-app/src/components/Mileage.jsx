import React from 'react'

function roundDecimal(float) {
  return Number.parseFloat(float).toFixed(1)
}

function Mileage(props) {
  return (
    <div className='d-flex
                    flex-column
                    justify-content-center
                    align-items-center'>
      <div className='mileage-counter'>
        {roundDecimal(props.mileage)}
      </div>
      <div className='mileage-text pt-2'>
        mi
      </div>
    </div>
  )
}

export default Mileage
