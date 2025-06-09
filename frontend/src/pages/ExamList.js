import React, { useEffect, useState } from "react";
import { API_BASE } from "../App";
import { DataGrid } from '@mui/x-data-grid';

function ExamList() {
  const [rooms, setRooms] = useState([]);
  console.log('ExamList mounted');
  const [exams, setExams] = useState([]);
  const [user, setUser] = useState(null);
  const [role, setRole] = useState(null);
  const [loading, setLoading] = useState(true);
  const [msg, setMsg] = useState("");
  const [err, setErr] = useState("");
  const fileInput = React.useRef();
  const [importResult, setImportResult] = useState(null);
  const [importError, setImportError] = useState(null);

  useEffect(() => {
    console.log('useEffect ran');
    const email = localStorage.getItem('email');
    setUser(email);
    if (email) {
      if (email === 'admin@usv.ro') setRole('ADM');
      else if (email === 'secretary@usv.ro') setRole('SEC');
      else if (email === 'cd@usv.ro') setRole('CD');
      else if (email === 'sg@usv.ro') setRole('SG');
      else setRole('UNKNOWN');
    } else {
      setRole('UNKNOWN');
    }
    fetch(`${API_BASE}/exams/`)
      .then((res) => res.json())
      .then((data) => {
        setExams(Array.isArray(data) ? data : []);
        setLoading(false);
      })
      .catch((e) => {
        setErr("Failed to load exams");
        setLoading(false);
      });
    // Fetch rooms
    fetch(`${API_BASE}/rooms/`)
      .then((res) => res.json())
      .then((data) => {
        setRooms(Array.isArray(data) ? data : []);
      })
      .catch((e) => {
        setErr("Failed to load rooms");
      });
  }, []);

  // Inline edit modal state (must be before any return/conditional)
  const [editExam, setEditExam] = useState(null);
  const [editForm, setEditForm] = useState({});
  const [editMsg, setEditMsg] = useState("");
  const [editErr, setEditErr] = useState("");
  // Approve/Reject state for CD
  const [rejectingId, setRejectingId] = useState(null);
  const [rejectReason, setRejectReason] = useState("");

  if (loading) return <div>Loading...</div>;
  if (!user) return <div>Please log in.</div>;
  if (role === 'UNKNOWN') return <div style={{color:'red'}}>Could not determine your role. Please log out and log in again with a known email.</div>;
  // Role-based filtering
  let visibleExams = exams;
  if (role === "SG") {
    visibleExams = exams.filter((e) => e.group_name === user.group_name);
  } else if (role === "CD") {
    visibleExams = exams.filter((e) => e.teacher_id === user.sub || e.teacher_id === user.id);
  }
  console.log('Visible exams:', visibleExams);

  // DataGrid columns
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
        // CD (teacher): Only Approve/Reject for pending exams
        if (role === 'CD' && (params.row.teacher_id === user.sub || params.row.teacher_id === user.id)) {
          if (params.row.status === 'pending') {
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
        // SEC/ADM: Edit/Delete
        if (role === 'SEC' || role === 'ADM') {
          return (
            <>
              <button onClick={() => handleEdit(params.row.id)} style={{ marginRight: 8 }}>Edit</button>
              <button onClick={() => handleDelete(params.row.id)} style={{ color: '#b30000' }}>Delete</button>
            </>
          );
        }
        // SG: existing logic
        if (role === 'SG' && params.row.group_name === user.group_name) {
          return (
            <>
              <button onClick={() => handleEdit(params.row.id)} style={{ marginRight: 8 }}>Edit</button>
              <button onClick={() => handleDelete(params.row.id)} style={{ color: '#b30000' }}>Delete</button>
            </>
          );
        }
        return null;
      }
    }
  ];

  async function openEditModal(exam) {
    // Fetch the full exam object from backend to get discipline_id
    try {
      const res = await fetch(`${API_BASE}/exams/${exam.id}`);
      if (!res.ok) throw new Error('Failed to fetch exam details');
      const fullExam = await res.json();
      // Use room_name from table if present, else map from room_id
      let roomName = exam.room_name;
      if (!roomName && fullExam.room_id) {
        const room = rooms.find(r => r.id === fullExam.room_id);
        roomName = room ? room.name : '';
      }
      setEditExam(fullExam);
      setEditForm({ ...fullExam, room_name: roomName });
      setEditMsg("");
      setEditErr("");
    } catch (e) {
      setEditErr('Could not load exam details for editing.');
    }
  }

  function closeEditModal() {
    setEditExam(null);
    setEditForm({});
    setEditMsg("");
    setEditErr("");
  }
  function handleEditChange(e) {
    setEditForm({ ...editForm, [e.target.name]: e.target.value });
  }
  async function saveExamEdit() {
    setEditMsg(""); setEditErr("");
    try {
      // Convert room_name to room_id
      const selectedRoom = rooms.find(r => r.name === editForm.room_name);
      // Only send backend-compatible fields
      const payload = {
        discipline_name: editForm.discipline_name,
        group_name: editForm.group_name,
        room_id: selectedRoom ? selectedRoom.id : null,
        confirmed_date: editForm.confirmed_date,
        status: editForm.status
      };
      console.log('Exam PUT payload:', payload);
      const res = await fetch(`${API_BASE}/exams/${editExam.id}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
      if (!res.ok) throw new Error("Failed to update exam");
      const updated = await res.json();
      setExams(exams => exams.map(e => e.id === updated.id ? { ...e, ...updated } : e));
      setEditMsg("Exam updated.");
      setTimeout(closeEditModal, 800);
    } catch (e) {
      setEditErr(e.message);
    }
  }

  function handleEdit(id) {
    const exam = exams.find(e => e.id === id);
    if (exam) openEditModal(exam);
  }

  async function handleDelete(id) {
    if (!window.confirm('Delete exam ' + id + '?')) return;
    setMsg(""); setErr("");
    try {
      const token = localStorage.getItem("token");
      if (!token) throw new Error("Not logged in or session expired.");
      const res = await fetch(`${API_BASE}/exams/${id}`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${token}` },
      });
      if (res.status === 401) throw new Error("Unauthorized: Please log in again.");
      if (!res.ok) throw new Error("Delete failed");
      setExams(exams => exams.filter(e => e.id !== id));
      setMsg("Exam deleted.");
    } catch (e) {
      setErr(e.message);
    }
  }

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

  // DataGrid rows
  const rows = visibleExams.map((e) => ({
    ...e,
    id: e.id,
    group_name: e.group_name || '-',
    specialization: e.specialization || '-', // Add specialization if present, else '-'
    discipline_name: e.discipline_name || '-',
    proposed_date: e.proposed_date || '-',
    confirmed_date: e.confirmed_date || '-',
    room_name: e.room_name || '-',
    status: e.status || '-',
  }));

  // Export handlers (no auth)
  const handleExcelExport = () => {
    window.open(`${API_BASE}/import_export/export/excel?type=exams`, '_blank');
  };
  const handlePDFExport = () => {
    window.open(`${API_BASE}/import_export/export/pdf?type=exams`, '_blank');
  };

  async function handleImport(e) {
    e.preventDefault();
    setImportResult(null);
    setImportError(null);
    const file = fileInput.current.files[0];
    if (!file) return;
    const formData = new FormData();
    formData.append("file", file);
    try {
      const res = await fetch(`${API_BASE}/import_export/import/excel`, {
        method: "POST",
        body: formData,

      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || "Import failed");
      setImportResult(data);
    } catch (err) {
      setImportError(err.message);
    }
  }
  return (
    <div className="exam-list">
      {/* Edit Modal */}
      {editExam && (
        <div style={{
          position: 'fixed', top: 0, left: 0, width: '100vw', height: '100vh', background: 'rgba(0,0,0,0.35)',
          display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000
        }}>
          <div style={{ background: 'white', padding: 24, borderRadius: 8, minWidth: 320, boxShadow: '0 4px 12px #0002' }}>
            <h3>Edit Exam #{editExam.id}</h3>
            <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
              <label>Discipline: <span style={{ padding: '6px 0', display: 'inline-block', minWidth: 160 }}>{editForm.discipline_name || '-'}</span></label>
              <label>Group: <input name="group_name" value={editForm.group_name || ''} onChange={handleEditChange} /></label>
              <label>Room: 
                <select name="room_name" value={editForm.room_name || ''} onChange={e => setEditForm({ ...editForm, room_name: e.target.value })}>
                  <option value="">Select room</option>
                  {rooms.map(r => (
                    <option key={r.id} value={r.name}>{r.name}</option>
                  ))}
                </select>
              </label>
              <label>Confirmed Date: <input name="confirmed_date" value={editForm.confirmed_date || ''} onChange={handleEditChange} /></label>
              <label>Status: <input name="status" value={editForm.status || ''} onChange={handleEditChange} /></label>
            </div>
            {editMsg && <div style={{ color: 'green', marginTop: 8 }}>{editMsg}</div>}
            {editErr && <div style={{ color: 'red', marginTop: 8 }}>{editErr}</div>}
            <div style={{ marginTop: 16, display: 'flex', gap: 12 }}>
              <button onClick={saveExamEdit} style={{ padding: '6px 16px' }}>Save</button>
              <button onClick={closeEditModal} style={{ padding: '6px 16px' }}>Cancel</button>
            </div>
          </div>
        </div>
      )}
      <div style={{ display: 'flex', flexDirection: 'column', gap: '16px', marginBottom: '16px' }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: '16px' }}>
          <h2 style={{ margin: 0 }}>Exams</h2>
          <button onClick={handleExcelExport} style={{ padding: '6px 12px' }}>Export Excel</button>
          <button onClick={handlePDFExport} style={{ padding: '6px 12px' }}>Export PDF</button>
          <a href={`${API_BASE}/import_export/template/exam`} download style={{ textDecoration: 'none' }}>
  <button type="button" style={{ padding: '6px 12px', background: '#009e3d', color: 'white' }}>Download Exam Template</button>
</a>
          {role === 'CD' && (
            <button type="button" style={{ padding: '6px 12px', background: '#1976d2', color: 'white', marginLeft: 8 }} onClick={() => window.location = '/exams/approval'}>
              Go to Exam Approval
            </button>
          )}
        </div>
        {(role === 'SEC' || role === 'ADM') && (
          <form onSubmit={handleImport} style={{ marginBottom: 8 }}>
            <label>
              Import Excel (.xlsx):
              <input type="file" accept=".xlsx" ref={fileInput} required />
            </label>
            <button type="submit">Upload</button>
          </form>
        )}
        {importResult && (
          <div style={{ color: 'green' }}>
            <strong>Import Success:</strong>
            <pre>{JSON.stringify(importResult, null, 2)}</pre>
          </div>
        )}
        {importError && (
          <div style={{ color: 'red' }}>
            <strong>Import Error:</strong> {importError}
          </div>
        )}
      </div>
      {(role === "SEC" || role === "ADM") && (
        <>
          <button onClick={() => window.location = "/import"}>Import</button>
          <button onClick={() => window.location = "/export"}>Export</button>
        </>
      )}
      {msg && <div style={{ color: 'green', marginBottom: 8 }}>{msg}</div>}
      {err && <div style={{ color: 'red', marginBottom: 8 }}>{err}</div>}
      <div style={{ height: 600, width: '100%' }}>
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
    {rows.map((row) => (
      <tr key={row.id}>
        <td>{row.group_name}</td>
        <td>{row.specialization}</td>
        <td>{row.discipline_name}</td>
        <td>{row.proposed_date ? row.proposed_date.replace('T', ' ') : ''}</td>
        <td>{row.confirmed_date ? row.confirmed_date.replace('T', ' ') : ''}</td>
        <td>{row.room_name}</td>
        <td>{row.status}</td>
        <td>
          <button onClick={() => handleEdit(row.id)} style={{ marginRight: 8 }}>Edit</button>
          <button onClick={() => handleDelete(row.id)} style={{ color: '#b30000' }}>Delete</button>
        </td>
      </tr>
    ))}
  </tbody>
</table>
      </div>
    </div>
  );
}

export default ExamList;
