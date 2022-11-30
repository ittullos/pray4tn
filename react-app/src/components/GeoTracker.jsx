import React from 'react'
import Timer from '../components/Timer'

function GeoTracker() {
  return (
    <div className="tracker-stats
                    d-flex
                    debug-border
                    flex-row
                    col-12
                    justify-content-center 
                    align-items-center">
      <div className="timer 
                      d-flex
                      justify-content-center 
                      align-items-center">
        <Timer />
      </div>
      <div className="mileage
                      debug-border">
      </div>
      <div className="prayer-count">

      </div>

    </div>
  )
}

export default GeoTracker
