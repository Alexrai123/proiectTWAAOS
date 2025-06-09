import React from "react";
import { Button } from "@mui/material";

export default function DashboardSEC() {
  return (
    <div style={{ maxWidth: 900, margin: 'auto', marginTop: 32 }}>
      <h2>Dashboard - Secretariat</h2>
      <Button variant="contained" href="/all-exams" style={{ marginRight: 16 }}>View All Exams</Button>
      <Button variant="contained" href="/import-export" style={{ marginRight: 16 }}>Import/Export</Button>
<Button variant="contained" href="/groupLeaders" style={{ marginRight: 16 }}>Manage Group Leaders</Button>
      {/* Add more secretariat-specific buttons here as needed */}
    </div>
  );
}
