import React, { useState } from "react";
import { useAuth } from "../App";

export default function Profile() {
  const { user } = useAuth();
  const [name, setName] = useState(user?.name || "");
  const [email, setEmail] = useState(user?.email || "");
  const [oldPassword, setOldPassword] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [msg, setMsg] = useState(null);
  const [err, setErr] = useState(null);

  async function handleProfile(e) {
    e.preventDefault();
    setMsg(null); setErr(null);
    try {
      const res = await fetch("http://localhost:8000/users/me", {
        method: "PUT",
        headers: { "Content-Type": "application/json", Authorization: `Bearer ${user.token}` },
        body: JSON.stringify({ name, email }),
      });
      if (!res.ok) throw new Error("Profile update failed");
      setMsg("Profile updated.");
    } catch (e) { setErr(e.message); }
  }

  async function handlePassword(e) {
    e.preventDefault();
    setMsg(null); setErr(null);
    try {
      const res = await fetch("http://localhost:8000/users/change-password", {
        method: "POST",
        headers: { "Content-Type": "application/json", Authorization: `Bearer ${user.token}` },
        body: JSON.stringify({ old_password: oldPassword, new_password: newPassword }),
      });
      if (!res.ok) throw new Error("Password change failed");
      setMsg("Password changed.");
      setOldPassword(""); setNewPassword("");
    } catch (e) { setErr(e.message); }
  }

  return (
    <div>
      <h2>Profile</h2>
      <form onSubmit={handleProfile} style={{ marginBottom: 24 }} aria-label="Edit Profile">
        <div>
          <label htmlFor="profile-name">Name:</label>
          <input id="profile-name" value={name} onChange={e => setName(e.target.value)} required aria-required="true" />
        </div>
        <div>
          <label htmlFor="profile-email">Email:</label>
          <input id="profile-email" value={email} onChange={e => setEmail(e.target.value)} required aria-required="true" type="email" />
        </div>
        <button type="submit">Update Profile</button>
      </form>
      <form onSubmit={handlePassword} aria-label="Change Password">
        <div>
          <label htmlFor="old-password">Old Password:</label>
          <input id="old-password" type="password" value={oldPassword} onChange={e => setOldPassword(e.target.value)} required aria-required="true" />
        </div>
        <div>
          <label htmlFor="new-password">New Password:</label>
          <input id="new-password" type="password" value={newPassword} onChange={e => setNewPassword(e.target.value)} required aria-required="true" />
        </div>
        <button type="submit">Change Password</button>
      </form>
      {msg && <div role="status" aria-live="polite" style={{ color: "#006400", background: "#e6ffe6", padding: 8, marginTop: 12, borderRadius: 4 }}>{msg}</div>}
      {err && <div role="alert" aria-live="assertive" style={{ color: "#b30000", background: "#ffe6e6", padding: 8, marginTop: 12, borderRadius: 4 }}>{err}</div>}
    </div>
  );
}
