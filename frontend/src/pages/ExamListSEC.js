import React, { useEffect, useState } from "react";
import { API_BASE } from "../App";

export default function ExamListSEC() {
  const [exams, setExams] = useState([]);
  const [loading, setLoading] = useState(true);
  const [msg, setMsg] = useState("");
  const [err, setErr] = useState("");
  const email = localStorage.getItem('email');

  useEffect(() => {
    fetch(`${API_BASE}/exams/`)
      .then(res => res.json())
      .then(data => {
        setExams(Array.isArray(data) ? data : []);
        setLoading(false);
      })
      .catch(() => {
        setErr("Failed to load exams");
        setLoading(false);
      });
  }, []);

  if (!email) return <div>Please log in as a secretary (secretary@usv.ro).</div>;
  if (loading) return <div>Loading...</div>;

  return (
    <div style={{ maxWidth: 1100, margin: 'auto', marginTop: 32 }}>
      <h2>Exams - Secretariat</h2>
      {/* Remove /users button for SEC */}
      {/* All other actions as in original SEC logic */}
      {msg && <div style={{ color: 'green', marginBottom: 8 }}>{msg}</div>}
      {err && <div style={{ color: 'red', marginBottom: 8 }}>{err}</div>}
      <table border={1} cellPadding={6} style={{ width: '100%', marginTop: 16 }}>
        <thead>
          <tr>
            <th>Group</th>
            <th>Specialization</th>
            <th>Discipline</th>
            <th>Proposed Date</th>
            <th>Confirmed Date</th>
            <th>Room</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          {exams.map((row) => (
            <tr key={row.id}>
              <td>{row.group_name}</td>
              <td>{row.specialization}</td>
              <td>{row.discipline_name}</td>
              <td>{row.proposed_date ? row.proposed_date.replace('T', ' ') : ''}</td>
              <td>{row.confirmed_date ? row.confirmed_date.replace('T', ' ') : ''}</td>
              <td>{row.room_name}</td>
              <td>{row.status}</td>
              <td>
                {/* SEC actions: edit/delete/import/export */}
                <button style={{marginRight:8}}>Edit</button>
                <button style={{color:'#b30000'}}>Delete</button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
