import useTimer from 'easytimer-react-hook'
import stopwatchIcon from '../images/stopwatch.svg.png'

const truncateTimer = (time) => { 
  let start_index = 0
  for (let i = 0; i < time.length; i++) {
    if (time[i] !== ":" && time[i] !== "0") {
      start_index = i
      break
    }
    if (i === 7 && start_index === 0) {
      start_index = 4
    }
  }
  if (start_index > 4) {
    start_index = 4
  }
  return time.substring(start_index)
}

const Timer = (props) => {
    /* The hook returns an EasyTimer instance and a flag to see if the target has been achieved */
    const [timer, isTargetAchieved] = useTimer({
        /* Hook configuration */
    });

    timer.start({
        /* EasyTimer start configuration */
    })

    const output = timer.getTimeValues().toString()

    return <div className='d-flex
                           flex-column
                           justify-content-center
                           align-items-center
                           pt-1'>
            {truncateTimer(output)}
            <img src={stopwatchIcon} alt="" className='stopwatch-icon' />
          </div>;
}

export default Timer