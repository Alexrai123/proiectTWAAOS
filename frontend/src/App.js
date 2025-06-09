import ExamListCD from "./pages/ExamListCD";
import ExamListSG from "./pages/ExamListSG";
import ExamListSEC from "./pages/ExamListSEC";
import DashboardCD from "./pages/DashboardCD";
import DashboardSG from "./pages/DashboardSG";
import DashboardSEC from "./pages/DashboardSEC";
import DashboardADM from "./pages/DashboardADM";

import React, { useState, useEffect, createContext, useContext } from "react";
import { Routes, Route, Link, useNavigate, Navigate, useLocation } from "react-router-dom";
import { TextField, Button, Paper, Box, Typography, Alert, Grid, Card, CardContent, CardActions } from "@mui/material";
import LockOutlinedIcon from '@mui/icons-material/LockOutlined';
import Avatar from '@mui/material/Avatar';
import GroupIcon from '@mui/icons-material/Group';
import SchoolIcon from '@mui/icons-material/School';
import AssignmentIndIcon from '@mui/icons-material/AssignmentInd';
import AdminPanelSettingsIcon from '@mui/icons-material/AdminPanelSettings';
import AppBar from '@mui/material/AppBar';
import Toolbar from '@mui/material/Toolbar';
import IconButton from '@mui/material/IconButton';
import HomeIcon from '@mui/icons-material/Home';
import ListAltIcon from '@mui/icons-material/ListAlt';
import ImportExportIcon from '@mui/icons-material/ImportExport';
import IntegrationInstructionsIcon from '@mui/icons-material/IntegrationInstructions';
import LogoutIcon from '@mui/icons-material/Logout';
import Tooltip from '@mui/material/Tooltip';

// Custom role-based dashboard redirect
function RoleDashboardRedirect() {
  const { user } = useAuth();
  const navigate = useNavigate();
  React.useEffect(() => {
    if (!user) {
      navigate('/login', { replace: true });
    } else if (user.role === 'CD') {
      navigate('/dashboard-cd', { replace: true });
    } else if (user.role === 'SG') {
      navigate('/dashboard-sg', { replace: true });
    } else if (user.role === 'SEC') {
      navigate('/dashboard-sec', { replace: true });
    } else if (user.role === 'ADM') {
      navigate('/dashboard-adm', { replace: true });
    } else {
      navigate('/login', { replace: true });
    }
  }, [user, navigate]);
  return <div>Redirecting...</div>;
}

const AuthContext = createContext();
export const useAuth = () => useContext(AuthContext);

export const API_BASE = "http://localhost:8000";
const GOOGLE_CLIENT_ID = "YOUR_GOOGLE_CLIENT_ID_HERE"; // <-- Replace with real client ID

const EMAIL_ROLE_MAP = {
  "admin@usv.ro": "ADM",
  "sec@usv.ro": "SEC",
  "cd@usv.ro": "CD",
  "sg@usv.ro": "SG",
};

function AuthProvider({ children }) {
  const [user, setUser] = useState(() => {
    const stored = localStorage.getItem("twaaos_user");
    return stored ? JSON.parse(stored) : null;
  });
  const [error, setError] = useState(null);
  const navigate = useNavigate();

  // Google OAuth2 login (SG/SEC/CD)
  async function loginWithGoogle(googleIdToken) {
    setError(null);
    try {
      const res = await fetch(`${API_BASE}/auth/login`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ google_id_token: googleIdToken }),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || "Login failed");
      // Map email to role
      const role = EMAIL_ROLE_MAP[data.email] || "SG";
      const token = data.access_token || data.token;
      const mappedUser = { ...data, role, token };
      setUser(mappedUser);
      localStorage.setItem("twaaos_user", JSON.stringify(mappedUser));
      if (mappedUser.role === "ADM") {
        navigate("/dashboard-adm");
      } else {
        navigate("/");
      }
    } catch (err) {
      setError(err.message);
    }
  }

  // JWT login (ADM, SEC, CD, SG)
  async function loginAsAdmin(email, password) {
    setError(null);
    try {
      const res = await fetch(`${API_BASE}/auth/login`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password }),
      });
      const data = await res.json();
      if (!res.ok) throw new Error(data.detail || "Login failed");
      // Map email to role
      const role = EMAIL_ROLE_MAP[email] || "SG";
      const token = data.access_token || data.token;
      const mappedUser = { ...data, email, role, token };
      setUser(mappedUser);
      localStorage.setItem("twaaos_user", JSON.stringify(mappedUser));
      if (mappedUser.role === "ADM") {
        navigate("/dashboard-adm");
      } else {
        navigate("/");
      }
    } catch (err) {
      setError(err.message);
    }
  }

  function logout() {
    setUser(null);
    localStorage.removeItem("twaaos_user");
    navigate("/login");
  }

  return (
    <AuthContext.Provider value={{ user, loginWithGoogle, loginAsAdmin, logout, error }}>{children}</AuthContext.Provider>
  );
}




function NavBar() {
  const { user, logout } = useAuth();
  const location = useLocation();
  // Hide navbar on login route
  if (location.pathname === "/login") return null;

  return (
    <AppBar position="static" color="default" elevation={1} sx={{ mb: 3 }}>
      <Toolbar>
        <Tooltip title="Dashboard">
          <IconButton color="primary" component={Link} to="/">
            <HomeIcon />
          </IconButton>
        </Tooltip>
        {user && (
          <Tooltip title="Exams">
            <IconButton color="primary" component={Link} to="/exams">
              <ListAltIcon />
            </IconButton>
          </Tooltip>
        )}
        {user && (user.role === "SEC" || user.role === "ADM") && (
          <Tooltip title="Import/Export">
            <IconButton color="primary" component={Link} to="/import-export">
              <ImportExportIcon />
            </IconButton>
          </Tooltip>
        )}

        <div style={{ flexGrow: 1 }} />
        {user && (
          <Tooltip title="Logout">
            <Button
              color="secondary"
              variant="contained"
              startIcon={<LogoutIcon />}
              onClick={logout}
              sx={{ ml: 2 }}
            >
              Logout
            </Button>
          </Tooltip>
        )}
      </Toolbar>
    </AppBar>
  );
}

function RequireAuth({ children, roles }) {
  const { user } = useAuth();
  if (!user) return <Navigate to="/login" replace />;
  if (roles && !roles.includes(user.role)) return <Navigate to="/" replace />;
  return children;
}



function Dashboard() {
  const { user } = useAuth();
  if (!user) return null;

  const role = user.role;
  const name = user.name || user.email;
  const friendlyRole =
    role === 'ADM' ? 'Admin' :
    role === 'SEC' ? 'Secretariat' :
    role === 'CD' ? 'Professor' :
    role === 'SG' ? 'Group Leader' : role;

  return (
    <Box sx={{ p: 3 }}>
      <Typography variant="h4" sx={{ mb: 2 }}>
        Welcome, {friendlyRole}!
      </Typography>
      <Typography variant="h6" sx={{ mb: 4, color: 'text.secondary' }}>
        {name}
      </Typography>
      <Grid container spacing={3}>
        {/* SG (Group Leader) */}
        {role === 'SG' && (
          <>
            <Grid item xs={12} md={4}>
              <Card>
                <CardContent>
                  <GroupIcon color="primary" sx={{ fontSize: 40, mb: 1 }} />
                  <Typography variant="h6">Propose Exam Date</Typography>
                  <Typography variant="body2" color="text.secondary">Propose new exam dates for your group/year only.</Typography>
                </CardContent>
                <CardActions>
                  <Button variant="contained" href="/exams">Go to Exams</Button>
                  <Button variant="outlined" href="/import">Import Exams</Button>
                </CardActions>
              </Card>
            </Grid>
            <Grid item xs={12} md={4}>
              <Card>
                <CardContent>
                  <Typography variant="h6">View/Edit Exams</Typography>
                  <Typography variant="body2" color="text.secondary">View or edit exams for your group.</Typography>
                </CardContent>
                <CardActions>
                  <Button variant="contained" href="/exams">View/Edit Exams</Button>
                </CardActions>
              </Card>
            </Grid>
            <Grid item xs={12} md={4}>
              <Card>
                <CardContent>
                  <Typography variant="h6">Upcoming/Pending Exams</Typography>
                  <Typography variant="body2" color="text.secondary">See a list of upcoming/pending exams for your group.</Typography>
                  {/* Placeholder for list */}
                  <Box sx={{ mt: 2 }}>
                    <Typography variant="body2" color="text.secondary">No upcoming exams.</Typography>
                  </Box>
                </CardContent>
              </Card>
            </Grid>
          </>
        )}
        {/* CD (Professor) */}
        {role === 'CD' && (
          <>
            <Grid item xs={12} md={4}>
              <Card>
                <CardContent>
                  <SchoolIcon color="secondary" sx={{ fontSize: 40, mb: 1 }} />
                  <Typography variant="h6">Approve/Reject Exams</Typography>
                  <Typography variant="body2" color="text.secondary">Approve or reject exams for your disciplines.</Typography>
                </CardContent>
                <CardActions>
                  <Button variant="contained" href="/exams">Review Exams</Button>
                </CardActions>
              </Card>
            </Grid>
            <Grid item xs={12} md={4}>
              <Card>
                <CardContent>
                  <Typography variant="h6">Assign Rooms/Assistants</Typography>
                  <Typography variant="body2" color="text.secondary">Assign rooms and assistant professors to exams.</Typography>
                </CardContent>
                <CardActions>
                  <Button variant="contained" href="/exams">Assign</Button>
                </CardActions>
              </Card>
            </Grid>
            <Grid item xs={12} md={4}>
              <Card>
                <CardContent>
                  <Typography variant="h6">Your Disciplines' Exams</Typography>
                  <Typography variant="body2" color="text.secondary">See a list of exams for your disciplines.</Typography>
                  {/* Placeholder for list */}
                  <Box sx={{ mt: 2 }}>
                    <Typography variant="body2" color="text.secondary">No exams found.</Typography>
                  </Box>
                </CardContent>
              </Card>
            </Grid>
          </>
        )}
        {/* SEC (Secretariat) */}
        {role === 'SEC' && (
          <>
            <Grid item xs={12} md={4}>
              <Card>
                <CardContent>
                  <AssignmentIndIcon color="success" sx={{ fontSize: 40, mb: 1 }} />
                  <Typography variant="h6">Upload/Edit/Export Templates</Typography>
                  <Typography variant="body2" color="text.secondary">Upload, edit, or export templates for schedules and exams.</Typography>
                </CardContent>
                <CardActions>
                  <Button variant="contained" href="/import-export">Import/Export</Button>
                  <Button variant="outlined" href="/groupLeaders">Manage Group Leaders</Button>
                  <Button variant="outlined" href="/disciplines">Manage Disciplines</Button>
                </CardActions>
              </Card>
            </Grid>
            <Grid item xs={12} md={4}>
              <Card>
                <CardContent>
                  <Typography variant="h6">Edit/Finalize Schedules</Typography>
                  <Typography variant="body2" color="text.secondary">Edit or finalize exam schedules.</Typography>
                </CardContent>
                <CardActions>
                  <Button variant="contained" href="/exams">Edit Schedules</Button>
                </CardActions>
              </Card>
            </Grid>
            <Grid item xs={12} md={6}>
              <Card>
                <CardContent>
                  <Typography variant="h6">All Exams & Scheduling Actions</Typography>
                  <Typography variant="body2" color="text.secondary">See all exams and scheduling actions.</Typography>
                  {/* Placeholder for table */}
                  <Box sx={{ mt: 2 }}>
                    <Typography variant="body2" color="text.secondary">No data available.</Typography>
                  </Box>
                </CardContent>
              </Card>
            </Grid>
          </>
        )}
        {/* ADM (Admin) */}
        {role === 'ADM' && (
          <>
            <Grid item xs={12} md={4}>
              <Card>
                <CardContent>
                  <AdminPanelSettingsIcon color="warning" sx={{ fontSize: 40, mb: 1 }} />
                  <Typography variant="h6">User & Data Management</Typography>
                  <Typography variant="body2" color="text.secondary">Full access to user and data management features.</Typography>
                </CardContent>
                <CardActions>
                  <Button variant="contained" href="/users" sx={{ minWidth: 220, mr: 2 }}>Manage Users</Button>
<Button variant="contained" href="/groupLeaders" sx={{ minWidth: 220, mr: 2 }}>Manage Group Leaders</Button>
<Button variant="contained" href="/disciplines" sx={{ minWidth: 220 }}>Manage Disciplines</Button>
                </CardActions>
              </Card>
            </Grid>
            <Grid item xs={12} md={4}>
              <Card>
                <CardContent>
                  <Typography variant="h6">Settings</Typography>
                  <Typography variant="body2" color="text.secondary">Manage system settings and configuration.</Typography>
                </CardContent>
                <CardActions>
                  <Button variant="contained" href="/settings">Settings</Button>
                </CardActions>
              </Card>
            </Grid>
            <Grid item xs={12} md={4}>
              <Card>
                <CardContent>
                  <Typography variant="h6">Audit Logs</Typography>
                  <Typography variant="body2" color="text.secondary">View audit trail for all changes and actions.</Typography>
                </CardContent>
                <CardActions>
                  <Button variant="contained" href="/audit-logs">Audit Logs</Button>
                </CardActions>
              </Card>
            </Grid>
            <Grid item xs={12} md={6}>
              <Card>
                <CardContent>
                  <Typography variant="h6">Full Data Access</Typography>
                  <Typography variant="body2" color="text.secondary">Access all actions and data in the system.</Typography>
                </CardContent>
                <CardActions>
                  <Button variant="contained" href="/import-export">Import/Export</Button>
                </CardActions>
              </Card>
            </Grid>
          </>
        )}
      </Grid>
    </Box>
  );
}
const ExamList = React.lazy(() => import("./pages/ExamList"));
const ExamApprovalList = React.lazy(() => import("./pages/ExamApprovalList"));
const ExamEdit = React.lazy(() => import("./pages/ExamEdit"));
const ExamImport = React.lazy(() => import("./pages/ExamImport"));
const ExamExport = React.lazy(() => import("./pages/ExamExport"));
const ImportExport = React.lazy(() => import("./pages/ImportExport"));
const GroupLeaders = React.lazy(() => import("./pages/GroupLeaders"));
const Users = React.lazy(() => import("./pages/Users"));
const Disciplines = React.lazy(() => import("./pages/Disciplines"));

function Login() {
  const { loginAsAdmin, error } = useAuth();
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  function handleLogin(e) {
    e.preventDefault();
    loginAsAdmin(email, password);
  }

  return (
    <Box sx={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center', bgcolor: '#f3f6f9' }}>
      <Paper elevation={6} sx={{ p: 4, maxWidth: 350, width: '100%' }}>
        <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', mb: 2 }}>
          <Avatar sx={{ m: 1, bgcolor: 'primary.main' }}>
            <LockOutlinedIcon />
          </Avatar>
          <Typography component="h1" variant="h5">
            Login
          </Typography>
        </Box>
        <form onSubmit={handleLogin}>
          <TextField
            margin="normal"
            required
            fullWidth
            label="Username or Email"
            value={email}
            onChange={e => setEmail(e.target.value)}
            autoFocus
          />
          <TextField
            margin="normal"
            required
            fullWidth
            label="Password"
            type="password"
            value={password}
            onChange={e => setPassword(e.target.value)}
          />
          {error && <Alert severity="error" sx={{ mt: 2 }}>{error}</Alert>}
          <Button
            type="submit"
            fullWidth
            variant="contained"
            color="primary"
            sx={{ mt: 3, mb: 2 }}
          >
            Login
          </Button>
        </form>

      </Paper>
    </Box>
  );
}

function App() {
  return (
    <AuthProvider>
      <NavBar />
      <React.Suspense fallback={<div>Loading...</div>}>
        <Routes>
          <Route path="/" element={<RequireAuth><RoleDashboardRedirect /></RequireAuth>} />
          <Route path="/exams" element={<RequireAuth roles={["ADM"]}><ExamList /></RequireAuth>} />
<Route path="/all-exams" element={<RequireAuth roles={["ADM", "SEC"]}><ExamList /></RequireAuth>} />
<Route path="/exams-cd" element={<RequireAuth><ExamListCD /></RequireAuth>} />
<Route path="/exams-sg" element={<RequireAuth><ExamListSG /></RequireAuth>} />
<Route path="/exams-sec" element={<RequireAuth><ExamListSEC /></RequireAuth>} />
<Route path="/dashboard-cd" element={<RequireAuth><DashboardCD /></RequireAuth>} />
<Route path="/dashboard-sg" element={<RequireAuth><DashboardSG /></RequireAuth>} />
<Route path="/dashboard-sec" element={<RequireAuth><DashboardSEC /></RequireAuth>} />
<Route path="/dashboard-adm" element={<RequireAuth roles={["ADM"]}><DashboardADM /></RequireAuth>} />
          <Route path="/exams/approval" element={<RequireAuth roles={["CD"]}><ExamApprovalList /></RequireAuth>} />
          <Route path="/exams/:id/edit" element={<RequireAuth><ExamEdit /></RequireAuth>} />
          <Route path="/import" element={<RequireAuth><ExamImport /></RequireAuth>} />
          <Route path="/export" element={<RequireAuth roles={["SEC", "ADM"]}><ExamExport /></RequireAuth>} />
          <Route path="/import-export" element={<RequireAuth roles={["SEC", "ADM", "SG"]}><ImportExport /></RequireAuth>} />
          <Route path="/users" element={<RequireAuth><Users /></RequireAuth>} />
          <Route path="/groupLeaders" element={<RequireAuth><GroupLeaders /></RequireAuth>} />
          <Route path="/disciplines" element={<RequireAuth roles={["SEC", "ADM"]}><Disciplines /></RequireAuth>} />


          <Route path="/login" element={<Login />} />
        </Routes>
      </React.Suspense>
    </AuthProvider>
  );
}

export default App;
