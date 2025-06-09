import React, { useEffect, useState, useRef } from "react";
import { API_BASE, useAuth } from "../App";
import Modal from "../components/Modal";

export default function GroupLeaders() {
  const { user } = useAuth();

  const [leaders, setLeaders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [msg, setMsg] = useState(null);
  const [err, setErr] = useState(null);
  const fileInput = useRef();



  useEffect(() => {
    fetch(`${API_BASE}/users/`)
      .then((res) => res.json())
      .then((data) => {
        setLeaders(Array.isArray(data) ? data.filter(u => u.role === 'SG') : []);
        setLoading(false);
      })
      .catch((e) => {
        setErr("Failed to load group leaders");
        setLoading(false);
      });
  }, []);

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
    if (!window.confirm("Delete this group leader?")) return;
    setMsg(null); setErr(null);
    try {
      const res = await fetch(`${API_BASE}/users/${id}`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${user.token}` },
      });
      if (!res.ok) throw new Error("Delete failed");
      setMsg("Deleted");
    } catch (e) { setErr(e.message); }
  }

  // Modal state for editing
  const [editId, setEditId] = useState(null);
  const [editData, setEditData] = useState({ name: "", email: "", group_name: "" });

  function handleEdit(id) {
    const leader = leaders.find(l => l.id === id);
    setEditId(id);
    setEditData({ name: leader.name, email: leader.email, group_name: leader.group_name });
    setMsg(null); setErr(null);
  }

  async function handleEditSave(e) {
    e.preventDefault();
    setMsg(null); setErr(null);
    try {
      const res = await fetch(`${API_BASE}/users/${editId}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json", Authorization: `Bearer ${user.token}` },
        body: JSON.stringify(editData),
      });
      if (!res.ok) throw new Error("Update failed");
      setLeaders(leaders => leaders.map(l => l.id === editId ? { ...l, ...editData } : l));
      setMsg("Group leader updated.");
      setEditId(null);
    } catch (e) {
      setErr(e.message);
    }
  }

  return (
    <div>
      <h2>Management of Group Leaders</h2>
      <div style={{ marginBottom: 16 }}>
        <div style={{ display: 'flex', justifyContent: 'center', marginBottom: 16 }}>
          <a href={`${API_BASE}/import_export/template/group_leader`} download>
            <button style={{ minWidth: 320, padding: '10px 0' }}>Download Group Leader Excel Template</button>
          </a>
        </div>

      </div>
      <form onSubmit={handleImport} style={{ marginBottom: 24 }}>
        <label>
          Import Group Leaders via Excel:
          <input type="file" accept=".xlsx" ref={fileInput} required />
        </label>
        <button type="submit">Upload</button>
      </form>
      {msg && <div style={{ color: "green" }}>{msg}</div>}
      {err && <div style={{ color: "red" }}>{err}</div>}
      {msg && <div style={{ color: 'green', marginBottom: 8 }}>{msg}</div>}
      {err && <div style={{ color: 'red', marginBottom: 8 }}>{err}</div>}
      {loading ? (
        <div>Loading...</div>
      ) : (
        <table border={1} cellPadding={6}>
          <thead>
            <tr>
              <th>Name</th><th>Email</th><th>Group</th><th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {leaders.filter(l => l.email !== 'admin@usv.ro').map((l) => (
              <tr key={l.id}>
                <td>{l.name}</td>
                <td>{l.email}</td>
                <td>{l.group_name || '-'}</td>
                <td>
                  <button onClick={() => handleEdit(l.id)}>Edit</button>
                  <button onClick={() => handleDelete(l.id)} style={{ marginLeft: 8 }}>Delete</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
      <Modal open={editId !== null} onClose={() => setEditId(null)}>
        <form onSubmit={handleEditSave} style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
          <h3>Edit Group Leader</h3>
          <label>
            Name:
            <input value={editData.name} onChange={e => setEditData({ ...editData, name: e.target.value })} required />
          </label>
          <label>
            Email:
            <input value={editData.email} onChange={e => setEditData({ ...editData, email: e.target.value })} required />
          </label>
          <label>
            Group:
            <input value={editData.group_name} onChange={e => setEditData({ ...editData, group_name: e.target.value })} required />
          </label>
          <div style={{ display: 'flex', gap: 8, marginTop: 8 }}>
            <button type="submit">Save</button>
            <button type="button" onClick={() => setEditId(null)}>Cancel</button>
          </div>
        </form>
      </Modal>
    </div>
  );
}
