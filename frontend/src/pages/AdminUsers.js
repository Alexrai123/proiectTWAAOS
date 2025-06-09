import React, { useEffect, useState } from "react";
import { useAuth } from "../App";

export default function AdminUsers() {
  const { user } = useAuth();
  const [users, setUsers] = useState([]);
  const [editId, setEditId] = useState(null);
  const [editData, setEditData] = useState({});
  const [msg, setMsg] = useState(null);
  const [err, setErr] = useState(null);
  const [resetPw, setResetPw] = useState("");

  async function fetchUsers() {
    setMsg(null); setErr(null);
    try {
      const res = await fetch("http://localhost:8000/users/", {
        headers: { Authorization: `Bearer ${user.token}` },
      });
      if (!res.ok) throw new Error("Failed to load users");
      setUsers(await res.json());
    } catch (e) { setErr(e.message); }
  }

  useEffect(() => { fetchUsers(); }, []);

  function startEdit(u) {
    setEditId(u.id);
    setEditData({ name: u.name, email: u.email, role: u.role });
  }

  async function saveEdit(id) {
    setMsg(null); setErr(null);
    try {
      const res = await fetch(`http://localhost:8000/users/me`, {
        method: "PUT",
        headers: { "Content-Type": "application/json", Authorization: `Bearer ${user.token}` },
        body: JSON.stringify({ ...editData }),
      });
      if (!res.ok) throw new Error("Failed to update user");
      setMsg("User updated.");
      setEditId(null);
      fetchUsers();
    } catch (e) { setErr(e.message); }
  }

  async function activate(id) {
    setMsg(null); setErr(null);
    try {
      const res = await fetch(`http://localhost:8000/users/${id}/activate`, {
        method: "POST",
        headers: { Authorization: `Bearer ${user.token}` },
      });
      if (!res.ok) throw new Error("Failed to activate");
      setMsg("User activated.");
      fetchUsers();
    } catch (e) { setErr(e.message); }
  }

  async function deactivate(id) {
    setMsg(null); setErr(null);
    try {
      const res = await fetch(`http://localhost:8000/users/${id}/deactivate`, {
        method: "POST",
        headers: { Authorization: `Bearer ${user.token}` },
      });
      if (!res.ok) throw new Error("Failed to deactivate");
      setMsg("User deactivated.");
      fetchUsers();
    } catch (e) { setErr(e.message); }
  }

  async function resetPassword(id) {
    setMsg(null); setErr(null);
    if (!resetPw) { setErr("Enter new password"); return; }
    try {
      const res = await fetch(`http://localhost:8000/users/${id}/reset-password`, {
        method: "POST",
        headers: { "Content-Type": "application/json", Authorization: `Bearer ${user.token}` },
        body: JSON.stringify({ new_password: resetPw }),
      });
      if (!res.ok) throw new Error("Failed to reset password");
      setMsg("Password reset.");
      setResetPw("");
      fetchUsers();
    } catch (e) { setErr(e.message); }
  }

  async function del(id) {
    setMsg(null); setErr(null);
    if (!window.confirm("Delete user?")) return;
    try {
      const res = await fetch(`http://localhost:8000/users/${id}`, {
        method: "DELETE",
        headers: { Authorization: `Bearer ${user.token}` },
      });
      if (!res.ok) throw new Error("Failed to delete");
      setMsg("User deleted.");
      fetchUsers();
    } catch (e) { setErr(e.message); }
  }

  return (
    <div>
      <h2>Admin User Management</h2>
      {msg && <div role="status" aria-live="polite" style={{ color: "#006400", background: "#e6ffe6", padding: 8, marginTop: 12, borderRadius: 4 }}>{msg}</div>}
      {err && <div role="alert" aria-live="assertive" style={{ color: "#b30000", background: "#ffe6e6", padding: 8, marginTop: 12, borderRadius: 4 }}>{err}</div>}
      <table border="1" cellPadding="4" style={{ marginTop: 16, width: "100%" }}>
        <thead>
          <tr>
            <th scope="col">ID</th>
            <th scope="col">Name</th>
            <th scope="col">Email</th>
            <th scope="col">Role</th>
            <th scope="col">Active</th>
            <th scope="col">Actions</th>
          </tr>
        </thead>
        <tbody>
          {users.map(u => (
            <tr key={u.id} style={{ background: u.is_active ? "#fff" : "#f8d7da" }}>
              <td>{u.id}</td>
              <td>{editId === u.id ? <input aria-label="Edit name" value={editData.name} onChange={e => setEditData({ ...editData, name: e.target.value })} /> : u.name}</td>
              <td>{editId === u.id ? <input aria-label="Edit email" value={editData.email} onChange={e => setEditData({ ...editData, email: e.target.value })} /> : u.email}</td>
              <td>{editId === u.id ? <input aria-label="Edit role" value={editData.role} onChange={e => setEditData({ ...editData, role: e.target.value })} /> : u.role}</td>
              <td>{u.is_active ? "Yes" : "No"}</td>
              <td>
                {editId === u.id ? (
                  <>
                    <button onClick={() => saveEdit(u.id)} autoFocus>Save</button>
                    <button onClick={() => setEditId(null)}>Cancel</button>
                  </>
                ) : (
                  <>
                    <button onClick={() => startEdit(u)}>Edit</button>
                    {u.is_active ? <button onClick={() => deactivate(u.id)}>Deactivate</button> : <button onClick={() => activate(u.id)}>Activate</button>}
                    <label htmlFor={`resetpw-${u.id}`} style={{ display: 'none' }}>New Password</label>
                    <input id={`resetpw-${u.id}`} type="password" aria-label="New password for reset" placeholder="New Password" value={resetPw} onChange={e => setResetPw(e.target.value)} style={{ width: 100 }} />
                    <button onClick={() => resetPassword(u.id)}>Reset PW</button>
                    <button onClick={() => del(u.id)} style={{ color: "red" }}>Delete</button>
                  </>
                )}
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
