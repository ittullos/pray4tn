import Button from 'react-bootstrap/Button';
import Modal from 'react-bootstrap/Modal';
import { styles } from '../styles/inlineStyles'
import AudioPlayer from 'react-h5-audio-player';
import 'react-h5-audio-player/lib/styles.css';
import ListGroup from 'react-bootstrap/ListGroup'
import { useState, useEffect, useContext } from 'react';
import LoadingComponent from './LoadingComponent';
import axios from 'axios'
import { APIContext } from '../App';

function DevotionalScreen(props) {
  const [url, setUrl]                 = useState()
  const [imgUrl, setImgUrl]           = useState()
  const [title, setTitle]             = useState()
  const [modalOpen, setModalOpen]     = useState(false)
  const [apiEndpoint, setApiEndpoint] = useContext(APIContext)
  const [isLoading, setIsLoading]     = useState(true)
  const [devotionalData, setDevotionalData] = useState()

  const handleModalOpen = () => {
    if (!modalOpen) {
      setModalOpen(true)
    }
  }

  const handleTrackSelect = (event) => {
    setUrl(event.url)
    setImgUrl(event.img_url)
    setTitle(event.title)
  }

  useEffect(() => {
    if (modalOpen) {
      fetchDevotionals()
    }
  }, [modalOpen])

  const fetchDevotionals = () => {
    axios.get(`${apiEndpoint}/devotionals`)
    .then(res => {
      console.log("fetchDevotionals: ", res)
      setDevotionalData(res.data.devotionals)
      setUrl(res.data.devotionals[0]["url"])
      setImgUrl(res.data.devotionals[0]["img_url"])
      setTitle(res.data.devotionals[0]["title"])
      setIsLoading(false)
    }).catch(err => {
      console.log(err)
    })
  }

  return (
    <Modal
      {...props}
      size="lg"
      aria-labelledby="contained-modal-title-vcenter"
      className='text-center pop-up'
      onEntered={handleModalOpen}
      centered
      dialogClassName="modal-30w"
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
            Devotionals
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        { isLoading ? (
          <LoadingComponent />
        ) : (
          <div>
            <img src={imgUrl} alt="" className='devotional-image py-3' />
            <h6 className='mb-4'>{title}</h6>
            <AudioPlayer
              src={url}
            />
            <div className="track-select-container">
              <ListGroup defaultActiveKey={url} className='button-left'>
                {devotionalData.map((item) => (
                  <ListGroup.Item 
                    active={item.url === url} 
                    key={item.url} 
                    onClick={() => {handleTrackSelect(item)}}
                    className='devotional-select'
                  >
                    {item.title}
                  </ListGroup.Item>
                ))}
              </ListGroup>
            </div>
          </div>
        )}
      </Modal.Body>
      <Modal.Footer>
        <Button style={styles.navyButton} onClick={props.onHide}>Close</Button>
      </Modal.Footer>
    </Modal>

  );
}

export default DevotionalScreen