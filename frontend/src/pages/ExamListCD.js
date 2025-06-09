import React, { useEffect, useState } from "react";
import { API_BASE } from "../App";

export default function ExamListCD() {
  const [exams, setExams] = useState([]);
  const [loading, setLoading] = useState(true);
  const [msg, setMsg] = useState("");
  const [err, setErr] = useState("");
  const [rejectingId, setRejectingId] = useState(null);
  const [rejectReason, setRejectReason] = useState("");

  // Get email from localStorage
  const email = localStorage.getItem('email');

  useEffect(() => {
    fetch(`${API_BASE}/exams/`)
      .then(res => res.json())
      .then(data => {
        // Filter exams where teacher_email matches
        setExams(Array.isArray(data) ? data.filter(e => e.teacher_email === email) : []);
        setLoading(false);
      })
      .catch(() => {
        setErr("Failed to load exams");
        setLoading(false);
      });
  }, [email]);

  async function handleApprove(id) {
    setMsg(""); setErr("");
    try {
      const res = await fetch(`${API_BASE}/exams/${id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ status: "approved" }),
      });
      if (!res.ok) throw new Error("Failed to approve exam");
      const updated = await res.json();
      setExams(exams => exams.map(e => e.id === updated.id ? { ...e, ...updated } : e));
      setMsg("Exam approved.");
    } catch (e) {
      setErr(e.message);
    }
  }

  async function handleReject(id) {
    setMsg(""); setErr("");
    try {
      const res = await fetch(`${API_BASE}/exams/${id}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ status: "rejected", rejection_reason: rejectReason }),
      });
      if (!res.ok) throw new Error("Failed to reject exam");
      const updated = await res.json();
      setExams(exams => exams.map(e => e.id === updated.id ? { ...e, ...updated } : e));
      setMsg("Exam rejected.");
      setRejectingId(null);
      setRejectReason("");
    } catch (e) {
      setErr(e.message);
    }
  }

  if (!email) return <div>Please log in as a teacher (cd@usv.ro).</div>;
  if (loading) return <div>Loading...</div>;

  return (
    <div style={{ maxWidth: 1100, margin: 'auto', marginTop: 32 }}>
      <h2>Exams - Teacher</h2>
      <button type="button" style={{ padding: '6px 12px', background: '#1976d2', color: 'white', marginBottom: 16 }} onClick={() => window.location = '/exams/approval'}>
        Go to Exam Approval
      </button>
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
                {row.status === 'pending' ? (
                  <>
                    <button onClick={() => handleApprove(row.id)} style={{ marginRight: 8, color: '#006400' }}>Approve</button>
                    <button onClick={() => setRejectingId(row.id)} style={{ color: '#b30000' }}>Reject</button>
                    {rejectingId === row.id && (
                      <div style={{ marginTop: 8 }}>
                        <input
                          type="text"
                          placeholder="Rejection reason"
                          value={rejectReason}
                          onChange={e => setRejectReason(e.target.value)}
                          style={{ marginRight: 8 }}
                        />
                        <button onClick={() => handleReject(row.id)} style={{ color: '#b30000' }}>Confirm Reject</button>
                        <button onClick={() => { setRejectingId(null); setRejectReason(""); }} style={{ marginLeft: 4 }}>Cancel</button>
                      </div>
                    )}
                  </>
                ) : (
                  <span style={{ color: '#888' }}>No actions</span>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
