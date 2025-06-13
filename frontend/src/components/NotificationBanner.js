import React from "react";
import Button from "@mui/material/Button";

export default function NotificationBanner({ notifications, onMarkRead }) {
  if (!notifications || notifications.length === 0) return null;
  return (
    <div style={{
      background: '#fffbe6',
      border: '1px solid #ffe58f',
      color: '#ad8b00',
      padding: '16px 24px',
      marginBottom: 24,
      borderRadius: 6,
      boxShadow: '0 2px 8px #f0f1f2',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'space-between',
      gap: 24
    }}>
      <div>
        <strong>Notifications:</strong>
        <ul style={{ margin: 0, paddingLeft: 20 }}>
          {notifications.map(n => (
            <li key={n.id} style={{ marginBottom: 4 }}>
              {n.message} <span style={{ fontSize: 12, color: '#888' }}>({new Date(n.created_at).toLocaleString()})</span>
            </li>
          ))}
        </ul>
      </div>
      <Button variant="contained" color="warning" onClick={onMarkRead}>
        Mark as read
      </Button>
    </div>
  );
}
