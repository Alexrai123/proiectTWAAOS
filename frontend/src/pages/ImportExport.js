import React, { useRef, useState } from "react";
import { useAuth } from "../App";

import { API_BASE } from "../App";

export default function ImportExport() {
  const { user } = useAuth();
  const fileInput = useRef();
  const [importResult, setImportResult] = useState(null);
  const [importError, setImportError] = useState(null);
  const [exportType, setExportType] = useState("exams");
  const [exportFormat, setExportFormat] = useState("excel");
  const [downloading, setDownloading] = useState(false);

  // Import Excel handler

async function handleImport(e) {
    e.preventDefault();
    setImportResult(null);
    setImportError(null);
    const file = fileInput.current.files[0];
    if (!file) return;
    const formData = new FormData();
    formData.append("file", file);
    try {
      // Previously, this could have used API data for validation; now it uses only the local database via backend.
      const res = await fetch(`${API_BASE}/import_export/import/excel`, {
        method: "POST",
        body: formData,
        headers: { Authorization: `Bearer ${user.token}` },
      });
      // UPGRADE: All import validation and lookups are now performed using data from the local database, not from any external API.
      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || "Import failed");
      setImportResult(data);
    } catch (err) {
      setImportError(err.message);
    }
  }

  // Export handler (Excel or PDF)
  async function handleExport(e, format) {
    e.preventDefault();
    setDownloading(true);
    let url = `${API_BASE}/export/${format}`;
    if (format === "excel" || format === "pdf") url += `?type=${exportType}`;
    try {
      const res = await fetch(url, {
        headers: { Authorization: `Bearer ${user.token}` },
      });
      if (res.status === 403) throw new Error("You do not have permission to export this data.");
      if (!res.ok) throw new Error("Export failed");
      const blob = await res.blob();
      const link = document.createElement("a");
      link.href = window.URL.createObjectURL(blob);
      link.download = `${exportType}.${format === "excel" ? "xlsx" : format}`;
      link.click();
    } catch (err) {
      alert(err.message);
    }
    setDownloading(false);
  }

  return (
    <div>
      <h2>Import/Export</h2>
      {/* Import: SEC/ADM only */}
      {(user.role === "SEC" || user.role === "ADM") && (
        <form onSubmit={handleImport} style={{ marginBottom: 24 }}>
          <label>
            Import Excel (.xlsx):
            <input type="file" accept=".xlsx" ref={fileInput} required />
          </label>
          <button type="submit">Upload</button>
        </form>
      )}
      {importResult && (
        <div style={{ color: "green" }}>
          <strong>Import Success:</strong>
          <pre>{JSON.stringify(importResult, null, 2)}</pre>
        </div>
      )}
      {importError && <div style={{ color: "red" }}>{importError}</div>}

      {/* Export: all roles */}
      <div style={{ marginTop: 24 }}>
        <label>
          Export type: 
          <select value={exportType} onChange={e => setExportType(e.target.value)}>
            <option value="exams">Exams</option>
            <option value="disciplines">Disciplines</option>
            <option value="rooms">Rooms</option>
            {(user.role === "SEC" || user.role === "ADM") && <option value="users">Users</option>}
          </select>
        </label>
        <button
          onClick={e => handleExport(e, "excel")}
          disabled={downloading}
          style={{ marginLeft: 16 }}
        >
          Export Excel
        </button>
        {/* PDF Export button: only for authorized roles */}
        {user && ["SG", "SEC", "CD", "ADM"].includes(user.role) && (
          <button
            onClick={e => handleExport(e, "pdf")}
            disabled={downloading}
            style={{ marginLeft: 8 }}
          >
            Export PDF
          </button>
        )}
      </div>
    </div>
  );
}
