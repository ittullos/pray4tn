import React from 'react'
import loadingIcon from '../images/iphone-spinner.svg'

function Loading() {
  return (
    <div className='d-flex
                    justify-content-center
                    align-items-center
                    loading-icon-container'>
      <img src={loadingIcon} 
           alt=""
           className='loading-icon
                      mb-5' />
    </div>
  )
}

export default Loading
