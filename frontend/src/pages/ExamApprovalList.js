import React, { useEffect, useState } from "react";
import { API_BASE } from "../App";
import { jwtDecode } from "jwt-decode";
import Button from '@mui/material/Button';


function getUserFromToken() {
  const token = localStorage.getItem("token");
  if (!token) return null;
  try {
    return jwtDecode(token);
  } catch {
    return null;
  }
}

function ExamApprovalList() {
  const [exams, setExams] = useState([]);
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [msg, setMsg] = useState("");
  const [err, setErr] = useState("");
  const [rejectingId, setRejectingId] = useState(null);
  const [rejectReason, setRejectReason] = useState("");
  const [selectedExamId, setSelectedExamId] = useState(null);

  useEffect(() => {
    const u = getUserFromToken();
    setUser(u);
    fetch(`${API_BASE}/exams/`)
      .then((res) => res.json())
      .then((data) => {
        console.log("Fetched exams data:", data); // DEBUG: See raw backend data
        // Only show exams for this teacher
        const filtered = Array.isArray(data)
          ? data.filter((e) => e.teacher_id === u.sub || e.teacher_id === u.id)
          : [];
        setExams(filtered);
        setLoading(false);
      })
      .catch((e) => {
        setErr("Failed to load exams");
        setLoading(false);
      });
  }, []);

  async function handleApprove(id) {
    setMsg(""); setErr("");
    try {
      const res = await fetch(`${API_BASE}/exams/${id}/approve`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
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
  console.log("handleReject called with id:", id);
    setMsg(""); setErr("");
    try {
      const res = await fetch(`${API_BASE}/exams/${id}/reject`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
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



  const rows = exams.map((e) => ({
    ...e,
    id: e.id,
    group_name: e.group_name || '-',
    specialization: e.specialization || '-',
    discipline_name: e.discipline_name || '-',
    proposed_date: e.proposed_date,
    confirmed_date: e.confirmed_date,
    room_name: e.room_name || '-',
    status: e.status || '-',
  }));

  if (loading) return <div>Loading...</div>;
  if (!user) return <div>Please log in.</div>;

  return (
    <div>
      <div style={{ maxWidth: 1400, margin: 'auto', marginTop: 32 }}>
        <h2>Exam Approval (Teacher)</h2>
        {msg && <div style={{ color: 'green' }}>{msg}</div>}
        {err && <div style={{ color: 'red' }}>{err}</div>}

        <div style={{ position: 'relative', zIndex: 10, background: '#fff', padding: 16, marginBottom: 16, borderRadius: 8, boxShadow: '0 2px 8px #0001', display: 'block' }}>
          <button
          disabled={
            loading ||
            !selectedExamId ||
            !rows.find(e => e.id === selectedExamId && e.status === 'pending') ||
            rejectingId !== null
          }
          style={{
            background: '#1e7e34', color: '#fff', fontWeight: 'bold', border: 'none', borderRadius: 4, padding: '10px 24px', marginRight: 16, minWidth: 180, cursor: 'pointer', fontSize: 16, opacity: (loading || !selectedExamId || !rows.find(e => e.id === selectedExamId && e.status === 'pending') || rejectingId !== null) ? 0.5 : 1
          }}
          onClick={() => handleApprove(selectedExamId)}
        >
          Approve Selected Exam
        </button>
        <button
          disabled={
            loading ||
            !selectedExamId ||
            !rows.find(e => e.id === selectedExamId && e.status === 'pending') ||
            rejectingId !== null
          }
          style={{
            background: '#b30000', color: '#fff', fontWeight: 'bold', border: 'none', borderRadius: 4, padding: '10px 24px', marginRight: 16, minWidth: 180, cursor: 'pointer', fontSize: 16, opacity: (loading || !selectedExamId || !rows.find(e => e.id === selectedExamId && e.status === 'pending') || rejectingId !== null) ? 0.5 : 1
          }}
          onClick={() => setRejectingId(selectedExamId)}
        >
          Reject Selected Exam
        </button>
          {rejectingId && (
            <>
              <input
                type="text"
                placeholder="Rejection reason"
                value={rejectReason}
                onChange={e => setRejectReason(e.target.value)}
                style={{ marginRight: 8 }}
                autoFocus
              />
              <button
              disabled={loading}
              style={{
                background: '#b30000', color: '#fff', fontWeight: 'bold', border: 'none', borderRadius: 4, padding: '10px 24px', marginRight: 8, minWidth: 150, cursor: 'pointer', fontSize: 16, opacity: loading ? 0.5 : 1
              }}
              onClick={() => handleReject(rejectingId)}
            >
              Confirm Reject
            </button>
            <button
              disabled={loading}
              style={{
                background: '#eee', color: '#333', fontWeight: 'bold', border: '1px solid #ccc', borderRadius: 4, padding: '10px 24px', marginLeft: 8, minWidth: 120, cursor: 'pointer', fontSize: 16, opacity: loading ? 0.5 : 1
              }}
              onClick={() => { setRejectingId(null); setRejectReason(""); }}
            >
              Cancel
            </button>
            </>
          )}
        </div>
        <div style={{ overflowX: 'auto', marginTop: 24 }}>
          <table border={1} cellPadding={6} style={{ width: '100%', borderCollapse: 'collapse' }}>
            <thead style={{ background: '#f0f0f0' }}>
              <tr>
                <th>Group</th>
                <th>Specialization</th>
                <th>Discipline</th>
                <th>Proposed Date (by SG)</th>
                <th>Confirmed Date (by CD)</th>
                <th>Room</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {rows.map(row => (
                <tr
                  key={row.id}
                  style={{
                    background:
                      selectedExamId === row.id
                        ? '#e0f7fa'
                        : row.status === 'rejected'
                          ? '#ffe6e6'
                          : row.status === 'approved'
                            ? '#e6ffe6'
                            : undefined,
                    cursor: 'pointer'
                  }}
                  onClick={() => {
                    setSelectedExamId(row.id);
                    setRejectingId(null);
                    setRejectReason("");
                  }}
                >
                  <td>{row.group_name}</td>
                  <td>{row.specialization}</td>
                  <td>{row.discipline_name}</td>
                  <td>{row.proposed_date ? row.proposed_date.replace('T', ' ').slice(0, 16) : '-'}</td>
                  <td>{row.confirmed_date ? row.confirmed_date.replace('T', ' ').slice(0, 16) : '-'}</td>
                  <td>{row.room_name}</td>
                  <td>{row.status}</td>
                  <td></td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

export default ExamApprovalList;
