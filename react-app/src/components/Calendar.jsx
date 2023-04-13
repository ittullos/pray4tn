import React, { useState, useEffect } from "react";
import DatePicker from "react-datepicker";

import "react-datepicker/dist/react-datepicker.css";

const Calendar = (props) => {
  return (
    <DatePicker selected={props.targetDate} onChange={(date) => props.setTargetDate(date)} />
  );
};

export default Calendar