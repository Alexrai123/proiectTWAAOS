import React, { useState } from "react";
import { Button } from "@mui/material";
import { API_BASE } from "../App";
import { useNavigate } from "react-router-dom";

export default function DashboardSG() {
  const [exams, setExams] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [showExams, setShowExams] = useState(false);
  const navigate = useNavigate();

  async function handleFetchExams() {
    setLoading(true);
    setError("");
    setShowExams(true);
    try {
      const res = await fetch(`${API_BASE}/exams/`);
      if (!res.ok) throw new Error("Failed to fetch exams");
      const data = await res.json();
      setExams(data);
    } catch (e) {
      setError(e.message);
      setExams([]);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div style={{ maxWidth: 900, margin: 'auto', marginTop: 32 }}>
      <h2>Dashboard - Group Leader</h2>
      <Button variant="contained" onClick={handleFetchExams} style={{ marginRight: 16 }}>
        View Group Exams
      </Button>
      <Button variant="contained" onClick={() => navigate('/import-export')} style={{ marginRight: 16 }}>
        Import/Export Exams
      </Button>
      {showExams && (
        <div style={{ marginTop: 24 }}>
          <h3>Group Exams</h3>
          {loading && <div>Loading...</div>}
          {error && <div style={{ color: 'red' }}>{error}</div>}
          {!loading && exams.length > 0 ? (
            <table border={1} cellPadding={6} style={{ width: '100%', borderCollapse: 'collapse' }}>
              <thead style={{ background: '#f0f0f0' }}>
                <tr>
                  <th>Discipline</th>
                  <th>Date</th>
                  <th>Status</th>
                  <th>Room</th>
                </tr>
              </thead>
              <tbody>
                {exams.map(exam => (
                  <tr key={exam.id}>
                    <td>{exam.discipline_name}</td>
                    <td>{exam.confirmed_date ? exam.confirmed_date.replace('T', ' ').slice(0, 16) : exam.proposed_date ? exam.proposed_date.replace('T', ' ').slice(0, 16) : '-'}</td>
                    <td>{exam.status}</td>
                    <td>{exam.room_name || '-'}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          ) : !loading && <div>No exams found.</div>}
        </div>
      )}
      {/* Add more group leader-specific buttons here as needed */}
    </div>
  );
}

