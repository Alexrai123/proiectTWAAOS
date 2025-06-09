import React, { useRef } from "react";
import { API_BASE } from "../App";

function ExamImport() {
  const fileInput = useRef();

  const handleImport = (e) => {
    e.preventDefault();
    const file = fileInput.current.files[0];
    if (!file) return;
    const formData = new FormData();
    formData.append("file", file);
    fetch(`${API_BASE}/exams/import`, {
      method: "POST",
      headers: { Authorization: `Bearer ${localStorage.getItem("token")}` },
      body: formData,
    }).then(() => window.location = "/exams");
  };

  return (
    <div className="exam-import">
      <h2>Import Exams</h2>
      <form onSubmit={handleImport}>
        <input type="file" ref={fileInput} accept=".xlsx,.xls,.csv" />
        <button type="submit">Import</button>
        <button type="button" onClick={() => window.location = "/exams"}>Cancel</button>
      </form>
    </div>
  );
}

export default ExamImport;
