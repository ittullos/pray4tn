import React , { useState, useEffect } from 'react'
import Timer from './Timer'
import Mileage from './Mileage'
import PrayerCount from './PrayerCount'

export const RouteStats = (props) => {
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

export default RouteStats