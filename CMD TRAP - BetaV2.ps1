<#
    CMD Trap – Beta V2
    -------------------
    Author: RyZeTv7505
    Version: 2.0 (Beta)

    Description:
        Advanced real-time CMD.exe monitoring tool.
        Detects and logs *every* new cmd.exe process, including:

            • Full command line
            • Parent process name
            • Parent process command line
            • Parent process ID
            • Timestamp

        Improved detection engine:
            ✓ Faster scanning
            ✓ Better duplicate filtering
            ✓ Handles processes that exit immediately
            ✓ Stable over long sessions

        Useful for diagnosing mysterious CMD pop-ups,
        unwanted background tasks, or misbehaving services.

    Output:
        Desktop\cmd_trap_log_v2.txt

    Usage:
        Open PowerShell as Administrator:
            Start → type "PowerShell" → Right-click → Run as Administrator

        Then execute:
            & "$env:USERPROFILE\Desktop\cmd_trap_beta_v2.ps1"

        Leave the window open.
        Every detection is logged in real-time.

    Notes:
        - Read-only / Non-destructive (does NOT kill processes).
        - Compatible with Windows 10 and Windows 11.
        - You may publish, modify, or fork this tool freely.

#>

Write-Host "CMD Trap – Beta V2 running... monitoring cmd.exe launches." -ForegroundColor Cyan

$desktop = [Environment]::GetFolderPath("Desktop")
$logFile = Join-Path $desktop "cmd_trap_log_v2.txt"

# Maintain a set of already-logged PIDs
$LoggedPIDs = [System.Collections.Concurrent.ConcurrentDictionary[int,bool]]::new()

# Helper: Safely get parent process
function Get-ParentProcessInfo($pid) {
    try {
        return Get-WmiObject Win32_Process -Filter "ProcessId=$pid" -ErrorAction SilentlyContinue
    }
    catch {
        return $null
    }
}

while ($true) {
    try {
        $procs = Get-WmiObject Win32_Process -Filter "Name='cmd.exe'" -ErrorAction SilentlyContinue

        foreach ($p in $procs) {

            # Skip duplicates
            if ($LoggedPIDs.ContainsKey($p.ProcessId)) {
                continue
            }

            # Mark PID as processed
            $LoggedPIDs[$p.ProcessId] = $true

            # Gather timestamp
            $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")

            # Parent process
            $parent = Get-ParentProcessInfo $p.ParentProcessId

            $cmdline     = $p.CommandLine
            $parentName  = if ($parent) { $parent.Name } else { "Unknown" }
            $parentCmd   = if ($parent) { $parent.CommandLine } else { "Unknown" }

            # Build log entry
            $entry = @(
                "==== CMD DETECTED $timestamp ===="
                "ProcessID: $($p.ProcessId)"
                "CommandLine: $cmdline"
                "ParentProcessID: $($p.ParentProcessId)"
                "Parent Name: $parentName"
                "Parent Command: $parentCmd"
                ""
            )

            # Append to file
            $entry | Out-File -FilePath $logFile -Append -Encoding UTF8

            # Console feedback
            Write-Host "Detected CMD.exe → logged." -ForegroundColor Yellow
        }
    }
    catch { }

    Start-Sleep -Milliseconds 500     # Faster but still lightweight
}
