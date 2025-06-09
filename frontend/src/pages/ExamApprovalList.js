import React, { useEffect, useState } from "react";
import { API_BASE } from "../App";
import { jwtDecode } from "jwt-decode";
import { DataGrid } from '@mui/x-data-grid';

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

  useEffect(() => {
    const u = getUserFromToken();
    setUser(u);
    fetch(`${API_BASE}/exams/`)
      .then((res) => res.json())
      .then((data) => {
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

  const columns = [
    { field: 'group_name', headerName: 'Group', width: 120 },
    { field: 'specialization', headerName: 'Specialization', width: 160 },
    { field: 'discipline_name', headerName: 'Discipline', width: 180 },
    { field: 'proposed_date', headerName: 'Proposed Date', width: 170 },
    { field: 'confirmed_date', headerName: 'Confirmed Date', width: 170 },
    { field: 'room_name', headerName: 'Room', width: 120 },
    { field: 'status', headerName: 'Status', width: 120 },
    {
      field: 'actions',
      headerName: 'Actions',
      width: 220,
      sortable: false,
      filterable: false,
      renderCell: (params) => {
        if (params.row.status === "pending") {
          return (
            <>
              <button onClick={() => handleApprove(params.row.id)} style={{ marginRight: 8, color: '#006400' }}>Approve</button>
              <button onClick={() => setRejectingId(params.row.id)} style={{ color: '#b30000' }}>Reject</button>
              {rejectingId === params.row.id && (
                <div style={{ marginTop: 8 }}>
                  <input
                    type="text"
                    placeholder="Rejection reason"
                    value={rejectReason}
                    onChange={e => setRejectReason(e.target.value)}
                    style={{ marginRight: 8 }}
                  />
                  <button onClick={() => handleReject(params.row.id)} style={{ color: '#b30000' }}>Confirm Reject</button>
                  <button onClick={() => { setRejectingId(null); setRejectReason(""); }} style={{ marginLeft: 4 }}>Cancel</button>
                </div>
              )}
            </>
          );
        } else {
          return <span style={{ color: '#888' }}>No actions</span>;
        }
      }
    }
  ];

  const rows = exams.map((e) => ({
    ...e,
    id: e.id,
    group_name: e.group_name || '-',
    specialization: e.specialization || '-',
    discipline_name: e.discipline_name || '-',
    proposed_date: e.proposed_date || '-',
    confirmed_date: e.confirmed_date || '-',
    room_name: e.room_name || '-',
    status: e.status || '-',
  }));

  if (loading) return <div>Loading...</div>;
  if (!user) return <div>Please log in.</div>;

  return (
    <div style={{ maxWidth: 1100, margin: 'auto', marginTop: 32 }}>
      <h2>Exam Approval (Teacher)</h2>
      {msg && <div style={{ color: 'green' }}>{msg}</div>}
      {err && <div style={{ color: 'red' }}>{err}</div>}
      <div style={{ height: 600, width: '100%' }}>
        <DataGrid rows={rows} columns={columns} pageSize={12} />
      </div>
    </div>
  );
}

export default ExamApprovalList;
