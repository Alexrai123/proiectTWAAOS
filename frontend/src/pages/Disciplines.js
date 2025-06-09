import React, { useEffect, useState, useRef } from "react";
import { API_BASE, useAuth } from "../App";

export default function Disciplines() {
  const { user } = useAuth();
  const [disciplines, setDisciplines] = useState([]);
  const [loading, setLoading] = useState(true);
  const [msg, setMsg] = useState(null);
  const [err, setErr] = useState(null);
  const fileInput = useRef();

  useEffect(() => {
    fetch(`${API_BASE}/disciplines/`, {
      headers: { Authorization: `Bearer ${user.token}` },
    })
      .then((res) => res.json())
      .then((data) => {
        setDisciplines(Array.isArray(data) ? data : []);
        setLoading(false);
      })
      .catch((e) => {
        setErr("Failed to load disciplines");
        setLoading(false);
      });
  }, [user.token]);

  async function handleImport(e) {
    e.preventDefault();
    setMsg(null); setErr(null);
    const file = fileInput.current.files[0];
    if (!file) return;
    const formData = new FormData();
    formData.append("file", file);
    try {
      const res = await fetch(`${API_BASE}/import_export/import/excel`, {
        method: "POST",
        body: formData,
        headers: { Authorization: `Bearer ${user.token}` },
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || "Import failed");
      setMsg("Import successful");
      setErr(null);
    } catch (e) {
      setErr(e.message);
    }
  }

  async function handleDelete(id) {
    if (!window.confirm("Delete this discipline?")) return;
    setMsg(null); setErr(null);
    try {
      const res = await fetch(`${API_BASE}/disciplines/${id}`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${user.token}` },
      });
      if (!res.ok) throw new Error("Delete failed");
      setMsg("Deleted");
      setDisciplines(disciplines.filter((d) => d.id !== id));
    } catch (e) { setErr(e.message); }
  }


  return (
    <div>
      <h2>Management of Disciplines</h2>
      <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 16 }}>
        <a href={`${API_BASE}/import_export/template/discipline`} download>
          <button style={{ minWidth: 320, padding: '10px 0' }}>Download Discipline Excel Template</button>
        </a>
      </div>
      <form onSubmit={handleImport} style={{ marginBottom: 24 }}>
        <label>
          Import Disciplines via Excel:
          <input type="file" accept=".xlsx" ref={fileInput} required />
        </label>
        <button type="submit">Upload</button>
      </form>
      {msg && <div style={{ color: "green" }}>{msg}</div>}
      {err && <div style={{ color: "red" }}>{err}</div>}
      {loading ? (
        <div>Loading...</div>
      ) : (
        <table border={1} cellPadding={6}>
          <thead>
            <tr>
              <th>Name</th><th>Specialization</th><th>Year</th><th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {disciplines.map((d) => (
              <tr key={d.id}>
                <td>{d.name}</td>
                <td>{d.program || '-'}</td>
                <td>{d.year || '-'}</td>
                <td>
                  <button onClick={() => handleDelete(d.id)}>Delete</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}
