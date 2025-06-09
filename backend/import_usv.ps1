$ErrorActionPreference = "Stop"
function Try-Import {
    try {
        $body = @{ email = "admin@usv.ro"; password = "admin123" } | ConvertTo-Json
        $response = Invoke-RestMethod -Uri 'http://127.0.0.1:8000/auth/login' -Method POST -Body $body -ContentType 'application/json'
        if (-not $response.access_token) { throw "No access_token in login response: $($response | ConvertTo-Json)" }
        $token = $response.access_token
        $headers = @{ Authorization = "Bearer $token" }
        $importSummary = Invoke-RestMethod -Uri 'http://127.0.0.1:8000/import_export/import/orar-usv' -Headers $headers -Method POST
        $importSummary | ConvertTo-Json -Depth 10
        return $true
    } catch {
        Write-Host "Error: $($_.Exception.Message)"
        Start-Sleep -Seconds 2
        return $false
    }
}

# Retry up to 5 times
$attempt = 0
$maxAttempts = 5
while ($attempt -lt $maxAttempts) {
    if (Try-Import) {
        break
    }
    $attempt++
    Write-Host "Retrying ($attempt/$maxAttempts)..."
    if ($attempt -eq $maxAttempts) {
        Write-Host "ERROR: Import failed after $maxAttempts attempts. Exiting."
        exit 1
    }
}
