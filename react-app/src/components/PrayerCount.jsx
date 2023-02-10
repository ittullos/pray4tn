import React from 'react'
import prayingHandsIcon from '../images/praying-hands-icon-black.png'


function PrayerCount(props) {
  return (
    <div className='d-flex
                    flex-column
                    justify-content-center
                    align-items-center
                    pb-1'>
      <div className="prayer-count my-1">{props.prayerCount}</div>
      <img src={prayingHandsIcon} alt="" className='praying-hands-icon  pt-1' />
    </div>
  )
}

export default PrayerCount
