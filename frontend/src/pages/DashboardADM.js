import React from "react";
import { Box, Typography, Button, Grid, Card, CardContent, CardActions } from "@mui/material";
import ListAltIcon from '@mui/icons-material/ListAlt';
import ImportExportIcon from '@mui/icons-material/ImportExport';
import GroupIcon from '@mui/icons-material/Group';
import AssignmentIndIcon from '@mui/icons-material/AssignmentInd';
import AdminPanelSettingsIcon from '@mui/icons-material/AdminPanelSettings';

export default function DashboardADM() {
  return (
    <Box sx={{ p: 4 }}>
      <Typography variant="h4" gutterBottom>Admin Dashboard</Typography>
      <Grid container spacing={3}>
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6">Exam Management</Typography>
              <Typography variant="body2" color="text.secondary">View and manage all exams in the system.</Typography>
            </CardContent>
            <CardActions>
              <Button variant="contained" startIcon={<ListAltIcon />} href="/all-exams">Go to Exam List</Button>
            </CardActions>
          </Card>
        </Grid>
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6">Import/Export</Typography>
              <Typography variant="body2" color="text.secondary">Import or export all exam data.</Typography>
            </CardContent>
            <CardActions>
              <Button variant="contained" startIcon={<ImportExportIcon />} href="/import-export">Import/Export</Button>
            </CardActions>
          </Card>
        </Grid>
        <Grid item xs={12} md={6}>
          <Card>
            <CardContent>
              <Typography variant="h6">Users & Groups</Typography>
              <Typography variant="body2" color="text.secondary">Manage users, group leaders, and disciplines.</Typography>
            </CardContent>
            <CardActions>
              <Button variant="contained" startIcon={<AdminPanelSettingsIcon />} href="/users" sx={{ mr: 1 }}>Manage Users</Button>
              <Button variant="contained" startIcon={<GroupIcon />} href="/groupLeaders" sx={{ mr: 1 }}>Group Leaders</Button>
              <Button variant="contained" startIcon={<AssignmentIndIcon />} href="/disciplines">Disciplines</Button>
            </CardActions>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
}
