@echo off
setlocal
pushd "%~dp0"
chcp 65001 >nul 2>nul
title DeadMoon OpenHands Launcher
set "DEADMOON_SELF=%~f0"
set "DEADMOON_DIR=%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$lines = [System.IO.File]::ReadAllLines($env:DEADMOON_SELF, [System.Text.Encoding]::UTF8); $m = ':: [DEADMOON_' + 'PS_PAYLOAD]'; $idx = [Array]::IndexOf($lines, $m); if ($idx -ge 0) { $code = ($lines[($idx + 1)..($lines.Length - 1)]) -join [Environment]::NewLine; Invoke-Expression $code } else { Write-Host 'ERROR: Could not locate embedded DeadMoon payload.' -ForegroundColor Red; Read-Host 'Press Enter to exit'; exit 1 }"
set "EXIT_CODE=%ERRORLEVEL%"
popd
if not "%EXIT_CODE%"=="0" (
    echo.
    echo [DeadMoon Launcher] Process exited with code %EXIT_CODE%.
    pause
)
exit /b %EXIT_CODE%

:: [DEADMOON_PS_PAYLOAD]
$ErrorActionPreference = "Continue";
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8;
[Console]::InputEncoding  = [System.Text.Encoding]::UTF8;

try {
    $vtCode = 'using System; using System.Runtime.InteropServices; public class DeadMoonConsole { [DllImport("kernel32.dll", SetLastError = true)] public static extern IntPtr GetStdHandle(int nStdHandle); [DllImport("kernel32.dll", SetLastError = true)] public static extern bool GetConsoleMode(IntPtr hConsoleHandle, out uint lpMode); [DllImport("kernel32.dll", SetLastError = true)] public static extern bool SetConsoleMode(IntPtr hConsoleHandle, uint dwMode); public static void EnableVT() { IntPtr hOut = GetStdHandle(-11); uint mode; if (GetConsoleMode(hOut, out mode)) { SetConsoleMode(hOut, mode | 0x0004); } } }';
    Add-Type -TypeDefinition $vtCode -ErrorAction SilentlyContinue;
    [DeadMoonConsole]::EnableVT();
} catch {}

$ESC = [char]27;
$NL  = [Environment]::NewLine;

$C = @{
    reset  = "$ESC[0m";
    bold   = "$ESC[1m";
    dim    = "$ESC[2m";
    red    = "$ESC[91m";
    green  = "$ESC[92m";
    yellow = "$ESC[93m";
    blue   = "$ESC[94m";
    purple = "$ESC[95m";
    cyan   = "$ESC[96m";
    white  = "$ESC[97m";
    gray   = "$ESC[90m";
};

$Emoji = @{
    moon   = [char]::ConvertFromUtf32(0x1F319);
    rocket = [char]::ConvertFromUtf32(0x1F680);
    folder = [char]::ConvertFromUtf32(0x1F4C2);
    spark  = [char]::ConvertFromUtf32(0x2728);
    check  = [char]::ConvertFromUtf32(0x2705);
    tick   = [char]::ConvertFromUtf32(0x2714);
    warn   = [char]::ConvertFromUtf32(0x26A0);
    cross  = [char]::ConvertFromUtf32(0x274C);
    shield = [char]::ConvertFromUtf32(0x1F6E1);
    broom  = [char]::ConvertFromUtf32(0x1F9F9);
    bulb   = [char]::ConvertFromUtf32(0x1F4A1);
    stop   = [char]::ConvertFromUtf32(0x1F6D1);
    wait   = [char]::ConvertFromUtf32(0x23F3);
    globe  = [char]::ConvertFromUtf32(0x1F310);
    down   = [char]::ConvertFromUtf32(0x2B07);
};

try { $Host.UI.RawUI.WindowTitle = "$($Emoji.moon) DeadMoon OpenHands Launcher"; } catch {}

$DefaultWorkspace = "C:\AI_Workspace";
$ScriptDir        = if ($env:DEADMOON_DIR) { $env:DEADMOON_DIR.TrimEnd('\') } else { (Get-Location).Path };
$ConfigFile       = Join-Path $ScriptDir ".openhands_launcher.cfg";
$ImageTag         = "latest";
$ImageName        = "ghcr.io/openhands/openhands:$ImageTag";

function Get-MoonFrame([int]$frameIdx) {
    $f = $frameIdx % 4;

    $nCol1 = if ($f % 2 -eq 0) { $C.yellow } else { $C.cyan };
    $nCol2 = if ($f % 2 -eq 0) { $C.purple } else { $C.yellow };
    $s1 = if ($f -eq 0) { "*" } elseif ($f -eq 1) { "+" } elseif ($f -eq 2) { "." } else { "+" };
    $s2 = if ($f -eq 0) { "." } elseif ($f -eq 1) { "*" } elseif ($f -eq 2) { "+" } else { "." };

    $topNoteL = if ($f -eq 1 -or $f -eq 2) { $nCol1 + "d~~b" + $C.reset } else { "    " };
    $midNoteL = if ($f -eq 1 -or $f -eq 2) { $nCol1 + "d  b" + $C.reset } else { $nCol1 + "d~~b" + $C.reset };
    $botNoteL = if ($f -eq 1 -or $f -eq 2) { "    " } else { $nCol1 + "d  b" + $C.reset };

    $topNoteR = if ($f -eq 2 -or $f -eq 3) { $nCol2 + "d~~b" + $C.reset } else { "    " };
    $midNoteR = if ($f -eq 2 -or $f -eq 3) { $nCol2 + "d  b" + $C.reset } else { $nCol2 + "d~~b" + $C.reset };
    $botNoteR = if ($f -eq 2 -or $f -eq 3) { "    " } else { $nCol2 + "d  b" + $C.reset };

    $lowNote1 = if ($f -eq 0 -or $f -eq 3) { $nCol1 + "d~b" + $C.reset } else { "   " };
    $lowNote2 = if ($f -eq 0 -or $f -eq 3) { $nCol1 + "d b" + $C.reset } else { $nCol2 + "d~b" + $C.reset };
    $lowNote3 = if ($f -eq 0 -or $f -eq 3) { "   " } else { $nCol2 + "d b" + $C.reset };

    $waveL = if ($f -eq 0) { " .--- " } elseif ($f -eq 1) { "(( .--" } elseif ($f -eq 2) { "((( .-" } else { " ( .--" };
    $waveR = if ($f -eq 0) { " ---. " } elseif ($f -eq 1) { "--. ))" } elseif ($f -eq 2) { "-. )))" } else { "--. ) " };
    $midWaveL = if ($f -eq 1 -or $f -eq 2) { "((    " } else { " (    " };
    $midWaveR = if ($f -eq 1 -or $f -eq 2) { "    ))" } else { "    ) " };

    $eyes = "\____/    \____/";
    $mouth = if ($f -eq 2) { " .----. " } else { "  .---. " };

    $rows = @(
        ("      " + $C.cyan + $s1 + "   " + $topNoteL + "  " + $s2 + $C.reset + "        " + $C.blue + ".================." + $C.reset + "        " + $C.cyan + $s2 + "   " + $topNoteR + "   " + $s1 + $C.reset + "   "),
        ("   " + $C.cyan + $s2 + "    " + $midNoteL + $C.reset + "      " + $C.blue + ".==='  " + $C.yellow + ".------------." + $C.blue + "  '===." + $C.reset + "      " + $midNoteR + "     " + $C.cyan + $s2 + $C.reset + "   "),
        ("      " + $C.cyan + $s1 + " " + $botNoteL + $C.reset + "    " + $C.blue + "/   " + $C.yellow + ".-'    .      o    '-." + $C.blue + "   \" + $C.reset + "     " + $botNoteR + "   " + $C.cyan + $s1 + $C.reset + "   "),
        ("               " + $C.blue + "/  " + $C.yellow + ".'   o       .      .   '." + $C.blue + "  \" + $C.reset + "        " + $C.cyan + $s2 + $C.reset + "   "),
        ("    " + $C.cyan + $s1 + $C.reset + "         " + $C.blue + "[===]" + $C.yellow + "  .    " + $C.white + "/        \" + $C.yellow + "    .  " + $C.blue + "[===]" + $C.reset + "   " + $C.cyan + $s2 + "       " + $s1 + $C.reset + "   "),
        ("        " + $C.blue + $waveL + "[===]" + $C.yellow + "     " + $C.white + $eyes + $C.yellow + "   " + $C.blue + "[===]" + $waveR + $C.reset + "   " + $lowNote1 + "   "),
        ("        " + $C.blue + $midWaveL + "[===]" + $C.yellow + "   o     " + $C.white + $mouth + $C.yellow + "     O " + $C.blue + "[===]" + $midWaveR + $C.reset + "   " + $lowNote2 + "   "),
        ("    " + $C.cyan + $s2 + $C.reset + "   " + $C.blue + " '--- [===]" + $C.yellow + "    .    " + $C.white + "/      \" + $C.yellow + "   .   " + $C.blue + "[===] ---' " + $C.reset + "   " + $lowNote3 + "   "),
        ("       " + $C.cyan + $s1 + $C.reset + "       " + $C.blue + "\  " + $C.yellow + "'.     .            o  .'" + $C.blue + "  /" + $C.reset + "       " + $C.cyan + $s1 + $C.reset + "   "),
        ("    " + $C.cyan + $s2 + $C.reset + "           " + $C.blue + "'.  " + $C.yellow + "'-.    o   .   .  .-'" + $C.blue + "  .'" + $C.reset + "     " + $C.cyan + $s2 + "       " + $C.reset + "   "),
        ("         " + $C.cyan + $s1 + $C.reset + "        " + $C.blue + "'===='" + $C.yellow + "--------------" + $C.blue + "'===='" + $C.reset + "          " + $C.cyan + $s2 + $C.reset + "   ")
    );
    return ($rows -join $NL);
}

function Invoke-MoonSplash {
    $stages = @(
        @{ pct = 25;  bar = "###---------"; color = $C.yellow; text = "Tuning frequencies...      " },
        @{ pct = 50;  bar = "######------"; color = $C.cyan;   text = "Loading probability bank..." },
        @{ pct = 75;  bar = "#########---"; color = $C.purple; text = "Syncing relay protocols... " },
        @{ pct = 100; bar = "############"; color = $C.green;  text = "Ready.                     " }
    );

    try { [Console]::Clear(); } catch {}
    try { [Console]::CursorVisible = $false; } catch {}

    try {
        for ($i = 0; $i -lt 12; $i++) {
            $stIdx = [Math]::Min([Math]::Floor($i / 3), 3);
            $st = $stages[$stIdx];
            $pctStr = $st.pct.ToString().PadLeft(3, ' ');
            try { [Console]::SetCursorPosition(0, 0); } catch {}
            $frame = $NL +
                (Get-MoonFrame $i) + $NL + $NL +
                "  " + $C.purple + "============================================================================" + $C.reset + $NL +
                "    " + $C.bold + $C.white + "$($Emoji.moon)  D E A D M O O N   O P E N H A N D S   L A U N C H E R  $($Emoji.moon)" + $C.reset + $NL +
                "  " + $C.purple + "============================================================================" + $C.reset + $NL + $NL +
                "    " + $st.color + "[Moonlight Engine] " + $C.white + $st.text + " " + $st.color + "[" + $st.bar + "] " + $pctStr + "%" + $C.reset + "   " + $NL;
            [Console]::Write($frame);
            Start-Sleep -Milliseconds 150;
        }
    } finally {
        try { [Console]::CursorVisible = $true; } catch {}
        Write-Host "";
    }
}

function Request-WorkspaceDirectory([string]$defaultPath) {
    Write-Host "";
    Write-Host "  $($C.purple)============================================================================$($C.reset)";
    Write-Host "    $($C.bold)$($C.white)$($Emoji.moon)  W O R K S P A C E   C O N F I G U R A T I O N$($C.reset)";
    Write-Host "  $($C.purple)============================================================================$($C.reset)";
    Write-Host "  $($C.gray)Choose where OpenHands will store your project files and configuration.$($C.reset)";
    Write-Host "";
    $inputPath = Read-Host "  $($Emoji.folder) Enter AI Workspace path (Press Enter for default [$defaultPath])";
    if ([string]::IsNullOrWhiteSpace($inputPath)) {
        $chosen = $defaultPath;
    } else {
        $chosen = $inputPath.Trim().Trim('"');
    }
    try {
        $chosen = [System.IO.Path]::GetFullPath($chosen);
    } catch {}
    $chosen = $chosen.TrimEnd('\', '/');
    [System.IO.File]::WriteAllText($ConfigFile, $chosen, [System.Text.Encoding]::UTF8);
    Write-Host "  $($C.green)$($Emoji.spark) Saved workspace configuration:$($C.reset) $($C.yellow)$chosen$($C.reset)";
    return $chosen;
}

try {
    Invoke-MoonSplash;

    Write-Host "  $($C.cyan)$($Emoji.moon) [Moonlight Engine]$($C.reset) $($C.white)Step 1/5: Checking for Docker installation...$($C.reset)";
    $dockerCmd = Get-Command docker -ErrorAction SilentlyContinue;
    if (-not $dockerCmd -and (Test-Path "C:\Program Files\Docker\Docker\resources\bin\docker.exe")) {
        $env:Path += ";C:\Program Files\Docker\Docker\resources\bin";
        $dockerCmd = Get-Command docker -ErrorAction SilentlyContinue;
    }
    if (-not $dockerCmd) {
        Write-Host "";
        Write-Host "  $($C.red)$($Emoji.cross) [ERROR] Docker was not found on your system!$($C.reset)";
        Write-Host "  $($C.yellow)$($Emoji.globe) Redirecting you to the official Docker Desktop download page...$($C.reset)";
        Start-Process "https://www.docker.com/products/docker-desktop/";
        Write-Host "";
        Write-Host "  $($C.gray)Please install Docker Desktop, restart if prompted, and launch this script again.$($C.reset)";
        Write-Host "";
        Read-Host "  Press Enter to exit";
        exit 1;
    }

    Write-Host "  $($C.cyan)$($Emoji.moon) [Moonlight Engine]$($C.reset) $($C.white)Step 2/5: Verifying Docker Desktop daemon...$($C.reset)";
    cmd.exe /c "docker info >nul 2>nul";
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  $($C.yellow)$($Emoji.warn)  [WARN] Docker Desktop is not currently running.$($C.reset)";
        $dockerDesktopExe = "C:\Program Files\Docker\Docker\Docker Desktop.exe";
        if (Test-Path $dockerDesktopExe) {
            Write-Host "  $($C.purple)$($Emoji.rocket) Starting Docker Desktop automatically...$($C.reset)";
            Start-Process $dockerDesktopExe;
            Write-Host "  $($C.gray)$($Emoji.wait) Waiting for Docker engine to initialize (this may take 30-60 seconds)...$($C.reset)";
            $ready = $false;
            for ($w = 0; $w -lt 30; $w++) {
                Start-Sleep -Seconds 3;
                cmd.exe /c "docker info >nul 2>nul";
                if ($LASTEXITCODE -eq 0) {
                    $ready = $true;
                    break;
                }
            }
            if (-not $ready) {
                Write-Host "  $($C.red)$($Emoji.cross) [ERROR] Docker Desktop did not become ready in time. Please start it manually and retry.$($C.reset)";
                Read-Host "  Press Enter to exit";
                exit 1;
            }
            Write-Host "  $($C.green)$($Emoji.spark) Docker Desktop engine is online!$($C.reset)";
        } else {
            Write-Host "  $($C.red)$($Emoji.cross) [ERROR] Please start Docker Desktop first and run this script again.$($C.reset)";
            Read-Host "  Press Enter to exit";
            exit 1;
        }
    } else {
        Write-Host "  $($C.green)$($Emoji.check) Docker daemon is active and responding.$($C.reset)";
    }

    $WorkspaceBase = "";
    $ForcePull = $false;
    if (Test-Path $ConfigFile) {
        $rawCfg = [System.IO.File]::ReadAllText($ConfigFile, [System.Text.Encoding]::UTF8).Trim();
        $WorkspaceBase = $rawCfg.Trim([char]0xFEFF).Trim();
    }

    if ([string]::IsNullOrWhiteSpace($WorkspaceBase)) {
        $WorkspaceBase = Request-WorkspaceDirectory $DefaultWorkspace;
    } else {
        Write-Host "";
        Write-Host "  $($C.purple)----------------------------------------------------------------------------$($C.reset)";
        Write-Host "    $($C.cyan)$($Emoji.folder) Active AI Workspace:$($C.reset) $($C.bold)$($C.yellow)$WorkspaceBase$($C.reset)";
        Write-Host "  $($C.purple)----------------------------------------------------------------------------$($C.reset)";
        Write-Host "    $($C.green)[R]$($C.reset) $($Emoji.rocket) Launch OpenHands $($C.gray)(auto-selects in 3s)$($C.reset)";
        Write-Host "    $($C.yellow)[C]$($C.reset) $($Emoji.folder) Change Workspace Directory";
        Write-Host "    $($C.cyan)[U]$($C.reset) $($Emoji.down)  Force Update OpenHands Docker Image";
        Write-Host "  $($C.purple)----------------------------------------------------------------------------$($C.reset)";
        [Console]::Write("    $($Emoji.moon) Select an option [R/C/U]: ");

        $choiceKey = "R";
        try {
            while ([Console]::KeyAvailable) { [void][Console]::ReadKey($true); }
            $stopwatch = [System.Diagnostics.Stopwatch]::StartNew();
            while ($stopwatch.ElapsedMilliseconds -lt 3000) {
                if ([Console]::KeyAvailable) {
                    $k = [Console]::ReadKey($true).KeyChar.ToString().ToUpperInvariant();
                    if ($k -in @("R", "C", "U")) {
                        $choiceKey = $k;
                        break;
                    }
                }
                Start-Sleep -Milliseconds 50;
            }
        } catch {}
        Write-Host $choiceKey;

        if ($choiceKey -eq "C") {
            $WorkspaceBase = Request-WorkspaceDirectory $DefaultWorkspace;
        } elseif ($choiceKey -eq "U") {
            $ForcePull = $true;
        }
    }

    $WorkspaceDir = Join-Path $WorkspaceBase "workspace";
    $ConfigDir    = Join-Path $WorkspaceBase ".openhands";

    Write-Host "";
    Write-Host "  $($C.cyan)$($Emoji.moon) [Moonlight Engine]$($C.reset) $($C.white)Step 3/5: Verifying workspace directories...$($C.reset)";
    foreach ($dir in @($WorkspaceDir, $ConfigDir)) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Force -Path $dir | Out-Null;
            Write-Host "  $($C.green)$($Emoji.spark) Created:$($C.reset) $dir";
        } else {
            Write-Host "  $($C.gray)$($Emoji.tick)  Exists:  $dir$($C.reset)";
        }
    }

    $driveLetter = $WorkspaceBase.Substring(0, 1).ToLowerInvariant();
    $subPath     = $WorkspaceBase.Substring(2).Replace('\', '/');
    $PosixWorkspace = "/$driveLetter$subPath/workspace";

    Write-Host "";
    Write-Host "  $($C.cyan)$($Emoji.moon) [Moonlight Engine]$($C.reset) $($C.white)Step 4/5: Checking OpenHands image ($ImageName)...$($C.reset)";
    cmd.exe /c "docker image inspect ""$ImageName"" >nul 2>nul";
    if ($LASTEXITCODE -ne 0) {
        $ForcePull = $true;
    }

    if ($ForcePull) {
        Write-Host "  $($C.yellow)$($Emoji.down)  Downloading $ImageName (this may take several minutes)...$($C.reset)";
        & docker pull $ImageName;
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  $($C.red)$($Emoji.cross) [ERROR] Failed to download the OpenHands image. Check your internet connection.$($C.reset)";
            Read-Host "  Press Enter to exit";
            exit 1;
        }
        Write-Host "  $($C.green)$($Emoji.spark) Image download complete!$($C.reset)";
    } else {
        Write-Host "  $($C.green)$($Emoji.check) OpenHands image is ready locally.$($C.reset)";
    }

    Write-Host "";
    Write-Host "  $($C.cyan)$($Emoji.moon) [Moonlight Engine]$($C.reset) $($C.white)Step 5/5: Purging stale sandboxes & calibrating ports...$($C.reset)";
    cmd.exe /c "docker rm -f openhands-app >nul 2>nul";
    $staleSandboxes = @(docker ps -a --filter "name=oh-agent-server-" -q 2>$null);
    foreach ($sbId in $staleSandboxes) {
        if (-not [string]::IsNullOrWhiteSpace($sbId)) {
            cmd.exe /c "docker rm -f $sbId >nul 2>nul";
        }
    }
    Write-Host "  $($C.gray)$($Emoji.broom) Cleaned up leftover OpenHands and agent-server containers.$($C.reset)";

    $isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator);
    if ($isAdmin) {
        Write-Host "  $($C.purple)$($Emoji.shield)  Resetting Windows NAT (winnat) to release reserved ephemeral ports...$($C.reset)";
        Restart-Service -Name "winnat" -Force -ErrorAction SilentlyContinue;
        Write-Host "  $($C.green)$($Emoji.check) Windows NAT port table refreshed.$($C.reset)";
    } else {
        Write-Host "  $($C.gray)$($Emoji.bulb) [TIP] Right-click & 'Run as administrator' if Windows ever locks ephemeral ports.$($C.reset)";
    }

    Write-Host "";
    Write-Host "  $($C.purple)============================================================================$($C.reset)";
    Write-Host "    $($C.green)$($Emoji.rocket) OpenHands is launching at:$($C.reset)  $($C.bold)$($C.cyan)http://localhost:3000$($C.reset)";
    Write-Host "    $($C.yellow)$($Emoji.folder) Mounted Sandbox Volume:$($C.reset)     $($C.white)$PosixWorkspace`:/workspace:rw$($C.reset)";
    Write-Host "    $($C.gray)$($Emoji.stop) Press Ctrl+C in this window at any time to shut down OpenHands.$($C.reset)";
    Write-Host "  $($C.purple)============================================================================$($C.reset)";
    Write-Host "";

    $dockerArgs = @(
        "run", "-it", "--rm",
        "-e", "SANDBOX_VOLUMES=$PosixWorkspace`:/workspace:rw",
        "-e", "SANDBOX_STARTUP_GRACE_SECONDS=120",
        "-e", "OH_MAX_NUM_SANDBOXES=1",
        "-e", "NO_PROXY=host.docker.internal,localhost,127.0.0.1",
        "-e", "FILE_UPLOADS_MAX_FILE_SIZE_MB=50",
        "-e", "LOG_ALL_EVENTS=true",
        "-v", "/var/run/docker.sock:/var/run/docker.sock",
        "-v", "$ConfigDir`:/.openhands",
        "-p", "3000:3000",
        "--add-host", "host.docker.internal:host-gateway",
        "--name", "openhands-app",
        $ImageName
    );
    & docker @dockerArgs;

    Write-Host "";
    Write-Host "  $($C.purple)$($Emoji.moon) [Moonlight Engine]$($C.reset) $($C.yellow)OpenHands session has ended.$($C.reset)";
    Read-Host "  Press Enter to close";
    exit 0;
} catch {
    Write-Host "";
    Write-Host "  $($C.red)$($Emoji.cross) [FATAL ERROR] $($_.Exception.Message)$($C.reset)";
    Read-Host "  Press Enter to close";
    exit 1;
}