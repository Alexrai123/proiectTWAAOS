import React from "react";
import { API_BASE } from "../App";

function ExamExport() {
  const handleExport = (type) => {
    window.location = `${API_BASE}/exams/export?type=${type}&token=${localStorage.getItem("token")}`;
  };

  return (
    <div className="exam-export">
      <h2>Export Exams</h2>
      <button onClick={() => handleExport("xlsx")}>Export as Excel</button>
      <button onClick={() => handleExport("pdf")}>Export as PDF</button>
      <button onClick={() => handleExport("ics")}>Export as ICS</button>
      <button onClick={() => window.location = "/exams"}>Back</button>
    </div>
  );
}

export default ExamExport;
