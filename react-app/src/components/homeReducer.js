export const INITIAL_STATE = {
  location:      {lat: '', long: ''},
  heartbeatMode: false,
  routeType:     ''
}

export const homeReducer = (state, action) => {
  switch(action.type) {
    case "updateLocation":
      return {
        ...state,
        location: action.payload
      }
    case "setRouteType":
      return {
        ...state,
        routeType: action.payload
      }
    case "setHeartbeatMode":
      return {
        ...state,
        heartbeatMode: action.payload
      }
    case "example":
      return {

      }
    default: 
      return state;
  }
}