import React, { useState, useEffect } from "react";
import { Button } from "@mui/material";
import { API_BASE } from "../App";
import NotificationBanner from "../components/NotificationBanner";

export default function DashboardSEC() {
  const [notifications, setNotifications] = useState([]);

  useEffect(() => {
    const token = localStorage.getItem("token");
    if (!token) return;
    let userId;
    try {
      const payload = JSON.parse(atob(token.split(".")[1]));
      userId = payload.user_id || payload.id || payload.sub || payload.user || payload.uid;
      if (!userId && payload.email) {
        // fallback: fetch user by email
        fetch(`${API_BASE}/users?email=${payload.email}`)
          .then(res => res.json())
          .then(data => {
            const user = Array.isArray(data) ? data[0] : data;
            if (user && user.id) fetchNotifications(user.id);
          });
        return;
      }
    } catch {
      return;
    }
    if (userId) fetchNotifications(userId);
  }, []);

  function fetchNotifications(userId) {
    fetch(`${API_BASE}/notifications/unseen?user_id=${userId}`)
      .then(res => res.json())
      .then(data => {
        setNotifications(Array.isArray(data) ? data : []);
      });
  }

  function handleMarkNotificationsRead() {
    const token = localStorage.getItem("token");
    let userId;
    try {
      const payload = JSON.parse(atob(token.split(".")[1]));
      userId = payload.user_id || payload.id || payload.sub || payload.user || payload.uid;
    } catch {
      return;
    }
    if (!userId) return;
    fetch(`${API_BASE}/notifications/mark_read`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ user_id: userId })
    })
      .then(() => setNotifications([]));
  }

  return (
    <div style={{ maxWidth: 900, margin: 'auto', marginTop: 32 }}>
      <NotificationBanner notifications={notifications} onMarkRead={handleMarkNotificationsRead} />
      <h2>Dashboard - Secretariat</h2>
      <Button variant="contained" href="/all-exams" style={{ marginRight: 16 }}>View All Exams</Button>
      <Button variant="contained" href="/import-export" style={{ marginRight: 16 }}>Import/Export</Button>
      <Button variant="contained" href="/groupLeaders" style={{ marginRight: 16 }}>Manage Group Leaders</Button>
      <Button variant="contained" href="/disciplines" style={{ marginRight: 16 }}>Disciplines</Button>
      {/* Add more secretariat-specific buttons here as needed */}
    </div>
  );
}
