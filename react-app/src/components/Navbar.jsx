import React, { useState } from 'react'
import closeIcon from '../images/close-icon.svg'
import menuIcon from '../images/menu-icon.svg'

function Navbar(props) {
  const [navbarClose, setNavbarClose] = useState(true)
  const handleNavbarClose = () => setNavbarClose(!navbarClose)

  return (
    <>
      <nav className='navbar'>
        <div className="nav-container">
          <h3 className='nav-logo mb-5'>
            
          </h3>
          <ul className={!navbarClose ? "nav-menu active" : "nav-menu"}>
            <li className='nav-item' onClick={() => { props.showStatsScreen(true)
                                                      handleNavbarClose() }}>
              <h6 className='nav-link'>My Stats</h6>
            </li>
            <li className='nav-item' onClick={() => { props.showCommitmentScreen(true)
                                                      handleNavbarClose() }}>
              <h6 className='nav-link'>My Commitment</h6>
            </li>
            <li className='nav-item' onClick={() => { props.showPlanRouteScreen(true)
                                                      handleNavbarClose() }}>
              <h6 className='nav-link'>Plan Route</h6>
            </li>
            <li className='nav-item' onClick={handleNavbarClose}>
              <h6 className='nav-link'>Settings</h6>
            </li>
          </ul>
          <div className="nav-icon" onClick={handleNavbarClose }>
            {navbarClose ? (
                <img src={menuIcon} alt="" className='burger' />
              ) : (
                <img src={closeIcon} alt="" className='close-icon' />
            )}
          </div>
        </div>
      </nav>
    </>
  )
}

export default Navbar