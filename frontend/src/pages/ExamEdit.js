import React, { useEffect, useState } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { API_BASE } from "../App";

function ExamEdit() {
  const { id: examId } = useParams();
  const navigate = useNavigate();
  const [exam, setExam] = useState(null);
  const [loading, setLoading] = useState(true);
  const [form, setForm] = useState({});

  useEffect(() => {
    fetch(`${API_BASE}/exams/${examId}`)
      .then((res) => res.json())
      .then((data) => {
        setExam(data);
        setForm({ ...data });
        setLoading(false);
      });
  }, [examId]);

  if (loading) return <div>Loading...</div>;
  if (!exam) return <div>Exam not found.</div>;

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((f) => ({ ...f, [name]: value }));
  };
  const handleAssistantsChange = (e) => {
    setForm((f) => ({ ...f, assistant_ids: e.target.value.split(",").map((v) => v.trim()).filter(Boolean).map(Number) }));
  };
  const handleSubmit = (e) => {
    e.preventDefault();
    fetch(`${API_BASE}/exams/${examId}`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(form),
    }).then(() => navigate("/exams"));
  };

  return (
    <div className="exam-edit">
      <h2>Edit Exam #{examId}</h2>
      <form onSubmit={handleSubmit}>
        <label>
          Discipline ID:
          <input name="discipline_id" value={form.discipline_id || ""} onChange={handleChange} />
        </label>
        <label>
          Group:
          <input name="group_name" value={form.group_name || ""} onChange={handleChange} />
        </label>
        <label>
          Teacher ID:
          <input name="teacher_id" value={form.teacher_id || ""} onChange={handleChange} />
        </label>
        <label>
          Assistants (comma separated IDs):
          <input name="assistant_ids" value={Array.isArray(form.assistant_ids) ? form.assistant_ids.join(",") : ""} onChange={handleAssistantsChange} />
        </label>
        <label>
          Status:
          <input name="status" value={form.status || ""} onChange={handleChange} />
        </label>
        <button type="submit">Save</button>
        <button type="button" onClick={() => window.location = "/exams"}>Cancel</button>
      </form>
    </div>
  );
}

export default ExamEdit;
