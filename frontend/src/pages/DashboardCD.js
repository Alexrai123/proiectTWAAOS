import React from "react";
import { Button } from "@mui/material";

export default function DashboardCD() {
  return (
    <div style={{ maxWidth: 900, margin: 'auto', marginTop: 32 }}>
      <h2>Dashboard - Teacher</h2>
      <Button variant="contained" href="/exams/approval" style={{ marginRight: 16 }}>Approve/Reject Exams</Button>
      {/* Add more teacher-specific buttons here as needed */}
    </div>
  );
}
