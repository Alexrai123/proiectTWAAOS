import React, { useEffect, useState } from "react";
import { API_BASE } from "../App";

export default function ExamListSG() {
  const [exams, setExams] = useState([]);
  const [loading, setLoading] = useState(true);
  const [msg, setMsg] = useState("");
  const [err, setErr] = useState("");
  const [group, setGroup] = useState(null);
  const email = localStorage.getItem('email');

  useEffect(() => {
    // Fetch group for this SG from backend
    fetch(`${API_BASE}/users?email=${email}`)
      .then(res => res.json())
      .then(data => {
        const user = Array.isArray(data) ? data[0] : data;
        // If no group, but email is sg@usv.ro, treat as group leader
        if (user && (user.group || email === 'sg@usv.ro')) {
          setGroup(user.group || 'DemoGroup');
          fetch(`${API_BASE}/exams/`)
            .then(res => res.json())
            .then(exams => {
              setExams(Array.isArray(exams) ? exams.filter(e => e.group_name === (user.group || 'DemoGroup')) : []);
              setLoading(false);
            });
        } else {
          setGroup(null);
          setLoading(false);
        }
      })
      .catch(() => {
        setErr("Failed to load user/group info");
        setLoading(false);
      });
  }, [email]);

  if (!email) return <div>Please log in as a group leader (sg@usv.ro).</div>;
  if (loading) return <div>Loading...</div>;
  if (!group) return <div>You are not a group leader.</div>;

  return (
    <div style={{ maxWidth: 1100, margin: 'auto', marginTop: 32 }}>
      <h2>Exams - Group Leader</h2>
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
                {/* Add propose/edit/delete buttons as needed */}
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
