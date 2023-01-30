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
                    align-items-center
                    mt-1">
      <div className="timer 
                      d-flex
                      justify-content-center 
                      align-items-center
                      pt-2">
        <Timer />
      </div>
      <div className="mileage
                      d-flex
                      justify-content-center
                      align-items-center
                      mt-2">
        <Mileage mileage={props.mileage} />
      </div>
      <div className="prayer-counter
                      d-flex
                      justify-content-center
                      align-items-center">
        <PrayerCount prayerCount={props.prayerCount} />
      </div>
    </div>
  )
}

export default RouteStats