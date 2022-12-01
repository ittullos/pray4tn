import React from 'react'
import Timer from '../components/Timer'
import Mileage from '../components/Mileage'
import PrayerCount from '../components/PrayerCount'

function GeoTracker() {
  return (
    <div className="tracker-stats
                    d-flex
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
                      d-flex
                      justify-content-center
                      align-items-center">
        <Mileage />
      </div>
      <div className="prayer-count
                      d-flex
                      justify-content-center
                      align-items-center">
        <PrayerCount />
      </div>

    </div>
  )
}

export default GeoTracker


