import React , { useState, useEffect, useContext } from 'react';
import AWS from 'aws-sdk'
import Button from 'react-bootstrap/Button'
import UploadSuccessModal from './UploadSuccessModal'
import ErrorModal from './ErrorModal';
import { APIContext } from '../App';
import axios from 'axios';

const Uploader = (props) => {

    const [selectedFile, setSelectedFile]           = useState(null)
    const [showUploadSuccess, setShowUploadSuccess] = useState(false)
    const [showUploadError, setShowUploadError]     = useState(false)
    const [apiEndpoint, setApiEndpoint]             = useContext(APIContext)
    const [s3BucketName, setS3BucketName]           = useState("")
    const [region, setRegion]                       = useState("")
    const [accessKeyId, setAccessKeyId]             = useState("")
    const [secretAccessKey, setSecretAccessKey]     = useState("")
    const [location, setLocation]                   = useState({lat: '', long: ''})


    // Fetch settings and get GPS location when component mounts
    useEffect(() => {
        let ignore = false;
        
        if (!ignore) { 
            fetchSettings() 
            updateLocation()
        }
        return () => { ignore = true; }
    },[]);

    const updateLocation = () => {
            navigator.geolocation.getCurrentPosition((position) => {
                setLocation({lat: position.coords.latitude, long: position.coords.longitude})
            }, () => {
                setLocation({lat: "0", long: "0"})
            })
      }

    const S3_BUCKET ='wpt.bap.tn.resident.names'

    AWS.config.update({
        accessKeyId:     accessKeyId,
        secretAccessKey: secretAccessKey
    })

    const myBucket = new AWS.S3({
        params: { Bucket: s3BucketName},
        region: region,
    })

    const handleFileInput = (e) => {
        setSelectedFile(e.target.files[0]);
    }
    
    const fetchSettings = () => {
        axios.get(`${apiEndpoint}/settings`)
        .then(res => {
          console.log("fetchSettings: ", res)
            setS3BucketName(res.data.s3BucketName)
            setRegion(res.data.region)
            setAccessKeyId(res.data.accessKeyId)
            setSecretAccessKey(res.data.secretAccessKey)
        }).catch(err => {
          console.log(err)
        })
    }

    const uploadFile = (file, bucketName) => {

        console.log("s3BucketName: ", bucketName);
        let emailId = props.userId.replace("@", "-d")
        let fileName = `t${location.lat}${location.long}-u${emailId}.pdf`

        // Had to use a hardcoded value for 'Bucket'
        // Value from DB does not work for some reason
        const params = {
            ACL: 'public-read',
            Body: file,
            Bucket: S3_BUCKET,
            Key: fileName.replace(/['"]+/g, '')
            // Key: file.name
        };

        console.log("params: ", params)

        myBucket.putObject(params)
            .on('httpUploadProgress', (evt) => {
                setShowUploadSuccess(true)
            })
            .send((err) => {
                if (err) {
                    console.log(err)
                    setShowUploadError(true)
                }

            })
    }

    return (
      <div className='d-flex
                      flex-column
                      justify-content-center
                      align-items-center'>
        <UploadSuccessModal 
            show={showUploadSuccess}
            onHide={() => setShowUploadSuccess(false)} />
        <ErrorModal
            show={showUploadError}
            onHide={() => setShowUploadError(false)} />

        <label htmlFor="files" className="drop-container my-4">
            <div className="upload-text"><span className="drop-title">Drop file here</span><br />
            or</div>
            <input onChange={handleFileInput} type="file" id="files" accept="*" required />
        </label>
        <Button variant="success" 
                size="lg"
                className='button'
                onClick={() => uploadFile(selectedFile, s3BucketName)}>
            Upload
        </Button>
      </div>)
}

export default Uploader