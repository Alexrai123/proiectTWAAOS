import React, { useEffect, useState, useRef } from "react";
import { useAuth, API_BASE } from "../App";
import Modal from "../components/Modal";

export default function Users() {
  const { user } = useAuth();
  const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [err, setErr] = useState("");
  const fileInput = useRef();

  useEffect(() => {
    fetch(`${API_BASE}/users/`, {
      headers: { Authorization: `Bearer ${user.token}` },
    })
      .then((res) => res.json())
      .then((data) => {
        setUsers(Array.isArray(data) ? data : []);
        setLoading(false);
      })
      .catch((e) => {
        setErr("Failed to load users");
        setLoading(false);
      });
  }, [user.token]);

  // Modal state for editing
  const [editId, setEditId] = useState(null);
  const [editData, setEditData] = useState({ name: "", email: "" });
  const [msg, setMsg] = useState("");

  const handleEdit = (id) => {
    const userToEdit = users.find(u => u.id === id);
    setEditId(id);
    setEditData({ name: userToEdit.name, email: userToEdit.email });
    setMsg("");
    setErr("");
  };

  async function handleDelete(id) {
    if (!window.confirm("Are you sure you want to delete this user?")) return;
    setMsg(""); setErr("");
    try {
      const res = await fetch(`${API_BASE}/users/${id}`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${user.token}` },
      });
      if (!res.ok) throw new Error("Delete failed");
      setUsers(users => users.filter(u => u.id !== id));
      setMsg("User deleted.");
    } catch (e) {
      setErr(e.message);
    }
  }

  async function handleEditSave(e) {
    e.preventDefault();
    setMsg(""); setErr("");
    try {
      const res = await fetch(`${API_BASE}/users/${editId}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json", Authorization: `Bearer ${user.token}` },
        body: JSON.stringify(editData),
      });
      if (!res.ok) throw new Error("Update failed");
      setUsers(users => users.map(u => u.id === editId ? { ...u, ...editData } : u));
      setMsg("User updated.");
      setEditId(null);
    } catch (e) {
      setErr(e.message);
    }
  }

  return (
    <div>
      <h2>User Management</h2>

      {msg && <div style={{ color: 'green', marginBottom: 8 }}>{msg}</div>}
      {err && <div style={{ color: 'red', marginBottom: 8 }}>{err}</div>}
      {loading ? (
        <div>Loading...</div>
      ) : (
        <table border={1} cellPadding={6}>
          <thead>
            <tr>
              <th>Name</th><th>Email</th><th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {users.filter(u => u.email !== 'admin@usv.ro' && u.role !== 'SG').map((u) => (
              <tr key={u.id}>
                <td>{u.name}</td>
                <td>{u.email}</td>
                <td>
                  <button onClick={() => handleEdit(u.id)}>Edit</button>
                  <button onClick={() => handleDelete(u.id)} style={{ marginLeft: 8 }}>Delete</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
      <Modal open={editId !== null} onClose={() => setEditId(null)}>
        <form onSubmit={handleEditSave} style={{ display: 'flex', flexDirection: 'column', gap: 12 }}>
          <h3>Edit User</h3>
          <label>
            Name:
            <input value={editData.name} onChange={e => setEditData({ ...editData, name: e.target.value })} required />
          </label>
          <label>
            Email:
            <input value={editData.email} onChange={e => setEditData({ ...editData, email: e.target.value })} required />
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
