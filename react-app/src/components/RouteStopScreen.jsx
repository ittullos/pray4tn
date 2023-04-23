import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import { styles } from '../styles/inlineStyles'
import { useState, useEffect, useContext } from 'react';
import Form from 'react-bootstrap/Form';
import { APIContext } from '../App';
import axios from 'axios'

function roundDecimal(float) {
  return Number.parseFloat(float).toFixed(2)
}

function RouteStopScreen(props) {
  const { prayerCount,
          mileage,
          setMileage,
          userId, 
          ...rest } = props

  const [showAddMileageButton, setShowAddMileageButton] = useState(true)
  const [stationaryMiles, setStationaryMiles] = useState(0)
  const [apiEndpoint, setApiEndpoint] = useContext(APIContext)

  const handleAddMileageButton = () => {
    setShowAddMileageButton(false)
  }

  const handleStationaryMilesChange = (event) => {
    setStationaryMiles(parseInt(event.target.value))
  }
  
  const handleSubmit = (event) => {
    event.preventDefault()
    console.log("mileage: ", mileage)
    console.log("stationaryMiles: ", stationaryMiles)
    setMileage(mileage + stationaryMiles)
    setShowAddMileageButton(true)

    let addMileageData = {
      userId: userId,
      mileage: stationaryMiles
    }

    axios.post(`${apiEndpoint}/add_mileage`, { addMileageData
    }).then(res => {
      console.log("add mileage response: ", res)
    }).catch(err => {
      console.log(err)
    })
  }
  

  useEffect(() => {
    console.log("stationaryMiles: ", stationaryMiles)
  
  }, [stationaryMiles])
  

  return (
    <Modal
      {...rest}
      size="lg"
      aria-labelledby="contained-modal-title-vcenter"
      centered
      className='text-center'
    >
      <Modal.Header 
        closeButton 
        className='text-center'
        style={{
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
        }}>
        <Modal.Title 
          id="contained-modal-title-vcenter" 
          className="ms-auto ps-3"
          style={{fontSize:28}}>
            Route Stats
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <h5 className='mb-4 mt-2'>Prayers: {prayerCount}</h5>
        <h5 className='mb-4'>Mileage: {roundDecimal(mileage)}</h5>
        {showAddMileageButton ? (
          <Button 
            style={styles.navyButton} 
            onClick={handleAddMileageButton}
            className='my-4'
          >
              Add stationary miles
          </Button>
          ) : null }
        {showAddMileageButton ? null : (
          <Form 
            onSubmit={handleSubmit}
            className='rounded stationary-form'>
            <Form.Group className="mb-3" controlId="formBasicEmail">
              <Form.Control onChange={handleStationaryMilesChange} size="sm" type="number" placeholder="Enter email" />
              <Form.Text className="text-muted">
                Enter stationary (treadmill) miles
              </Form.Text>
            </Form.Group>
            <Button style={styles.navyButton} variant="primary" type="submit">
              Add
            </Button>
          </Form>
        )}
      </Modal.Body>
      <Modal.Footer>
        <Button style={styles.navyButton} onClick={rest.onHide}>Close</Button>
      </Modal.Footer>
    </Modal>
  );
}

export default RouteStopScreen