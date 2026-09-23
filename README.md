**[English](README.md)** | **[Español](README.es.md)**

---

# Claude Desktop - Multi-Instance (`Setup-ClaudeMulti`)

A PowerShell automation suite to run **multiple simultaneous, isolated instances of Claude Desktop in parallel** on Windows, each with its own account, session, local history, MCP servers, and independent configuration.

Anthropic does not natively support account switching or concurrent accounts in Claude Desktop: you are forced to log out and authenticate again every time. This project removes that restriction seamlessly and securely.

---

## Key Features

- **Automatic Language Detection & Localization (English / Spanish):** Automatically detects your Windows OS display language (Spanish Windows $\rightarrow$ Spanish; any other language $\rightarrow$ English). Also supports manual language selection and forcing at any time.
- **Native Graphical User Interface (Windows Forms GUI):** Manage, add, edit notes/emails, and remove profiles with a single click. Includes real-time language switching.
- **Unique Per-Profile Color Icons:** Generates multi-resolution `.ico` files with color-coded badges to easily distinguish desktop shortcuts.
- **Full Compatibility (Store MSIX and Traditional Exe):** Works with Microsoft Store (MSIX) packages via a self-managed portable copy in `C:\ClaudePortable`, as well as standard direct executables.
- **Safe Automatic Updates:** Verifies the installed Claude Desktop version when opening any profile. When updated, it stages and validates a new copy without disrupting active profiles.
- **Shared Memory MCP (Optional):** Interconnects accounts to a shared context graph (`memory.json`) and common files directory using MCP servers.
- **Diagnostic Run Log (`last-run.log`):** Logs every run to `%APPDATA%\ClaudeMulti\last-run.log` for easy troubleshooting.
- **Integrated Test Suite:** Automated Pester tests to validate launchers, process management, portable staging, and log formatting.

---

## The Problem and The Solution

Claude Desktop stores **all** user state — including session tokens, preferences, and MCP settings — in a single user data folder (`%APPDATA%\Claude`). With only one default directory, only one account can be active at a time.

```
BEFORE  →  Log out → log in with account B → work → log out → log in with account A...
AFTER   →  Multiple windows open simultaneously, one per account.
```

Because Claude Desktop is an Electron application, it accepts the `--user-data-dir` parameter. By starting the executable with isolated paths (`%APPDATA%\Claude-<Name>`), each window runs in a completely separate environment.

---

## Language Detection and Manual Override

This project provides full bilingual support in **English** and **Spanish**:

1. **Automatic Detection:**
   - If Windows is set to Spanish (`es-*`), the setup, GUI, CLI menu, and shortcuts launch in **Spanish**.
   - If Windows is in any other language (`en`, `fr`, `de`, `pt`, `ja`, etc.), it launches in **English**.

2. **Manual Override:**
   - **Graphical Interface (GUI):** Use the language dropdown in the top-right corner (`Español` / `English`). The interface updates instantly and persists your choice.
   - **Console Menu (CLI):** Select option `[13] Change language / Cambiar idioma`.
   - **Command Line:** Pass the `-Language en` or `-Language es` switch.
   - **Persistence:** Any manual selection is stored in `%APPDATA%\ClaudeMulti\config.json`, keeping your choice across future runs.

---

## Installation & Quick Start

### 1. Download the Project

> [!NOTE]
> As a PowerShell and Batch automation project, **compiled installers or GitHub Releases are not used**. To obtain the latest version:

1. On the GitHub repository main page, click the green **`<> Code`** button.
2. Select **`Download ZIP`** (or clone with `git clone https://github.com/rx32555/ClaudeDesktop_MultiInstancia.git`).
3. Extract the `.zip` archive into a permanent folder on your computer.

---

### 2. Included Files

| File | Description |
|------|-------------|
| `Setup-ClaudeMulti.ps1` | Core business logic, GUI, interactive CLI, and profile configuration |
| `Setup-ClaudeMulti.bat` | Direct launcher with environment language detection (bypasses execution policy) |

> Both files must stay in the same folder.

---

### 3. Graphical Mode (Recommended)

1. Open the extracted folder and double-click **`Setup-ClaudeMulti.bat`**.
2. The **native Windows Forms GUI** will open:
   - **Language Dropdown:** Located at the top right to switch between English and Spanish.
   - **Configured Profiles List:** Displays each profile along with its assigned note or email.
   - **Run / Update Instances:** Sets up or refreshes your desktop shortcuts.
   - **+ Add Profile:** Creates a new instance (`Work`, `Client`, `Personal`, etc.) while keeping existing profiles intact.
   - **Edit Note/Email:** Adds helpful labels (e.g. `work@company.com`, `personal@gmail.com`).
   - **Shared Memory (checkbox):** Configures common MCP servers for cross-instance context.
   - **Health Check:** Validates executables, desktop shortcuts, disk space usage, and detects orphan profile folders.
   - **Clean Cache:** Frees disk space by purging temporary caches and obsolete binary versions.
   - **Create / Restore Backup:** Backs up all account sessions and settings to a `.zip` archive (skipping heavy cache folders).
   - **Delete Profile:** Cleanly deletes the selected profile, its data, icon, and desktop shortcut.
   - **View Log:** Opens `last-run.log` in Notepad.

---

### 4. Command Line / Terminal Mode

If you prefer terminal commands or scripting:

```powershell
# Open interactive CLI menu
powershell -ExecutionPolicy Bypass -File .\Setup-ClaudeMulti.ps1 -CLI

# Force English or Spanish language
powershell -ExecutionPolicy Bypass -File .\Setup-ClaudeMulti.ps1 -Language en
powershell -ExecutionPolicy Bypass -File .\Setup-ClaudeMulti.ps1 -Language es

# Configure specific profiles and copy MCP servers from default profile
powershell -ExecutionPolicy Bypass -File .\Setup-ClaudeMulti.ps1 -Profiles 'Personal','Work','Client' -CopyMcpConfig

# Enable shared memory across instances
powershell -ExecutionPolicy Bypass -File .\Setup-ClaudeMulti.ps1 -Profiles 'Personal','Work','Client' -SharedMemory

# Dry run (simulate changes without modifying disk)
powershell -ExecutionPolicy Bypass -File .\Setup-ClaudeMulti.ps1 -Profiles 'Personal','Work' -WhatIf
```

---

## How It Works Internally

| Stage | Description |
|---|---|
| **1. Detection** | Finds the Claude Desktop installation (standard `.exe` or Microsoft Store MSIX package) and reads the active version. |
| **2. Portable Copy** | *(Store MSIX only)* Copies the app to `C:\ClaudePortable`. When Claude updates in the Microsoft Store, it stages a replacement copy without breaking running sessions. |
| **3. Icons** | Generates a multi-resolution `.ico` icon (256, 128, 64, 48, 32, 16 px) with a distinctive colored badge for each profile. |
| **4. Launcher** | Installs a launcher in `%APPDATA%\ClaudeMulti` that validates versions and processes before launching Claude. |
| **5. Shortcuts** | Creates desktop shortcuts (`.lnk`) configured with `--user-data-dir` for each profile. |

> **Note regarding the first profile:** The first profile always uses the default user data directory (`%APPDATA%\Claude`), preserving your existing session, history, and MCP settings. Additional profiles use `%APPDATA%\Claude-<Name>`.

---

## Color-Coded Profile Icons

Each profile is assigned a unique color icon in `%APPDATA%\ClaudeMulti\icons\`:

| Order | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|
| **Color** | Blue | Green | Purple | Cyan | Pink | Jet Black | Olive |

> The colors intentionally avoid orange/coral so that the badge contrasts sharply with Claude's official logo.

---

## Parameter Reference

| Parameter | Default | Description |
|-----------|---------|-------------|
| `-Profiles` | `'Cuenta1','Cuenta2','Cuenta3'` | List of profile names to configure. |
| `-GUI` | — | Opens the native Windows Forms interface. |
| `-CLI` | — | Forces interactive text console mode. |
| `-Language` | Auto (`en`/`es`) | Overrides interface and shortcut language (`en` or `es`). |
| `-PortableDir` | `C:\ClaudePortable` | Target folder for the portable copy (MSIX only). |
| `-CopyMcpConfig` | — | Copies MCP servers from the primary profile to new profiles without overwriting. |
| `-SharedMemory` | — | Sets up MCP servers (`shared-memory` and `shared-files`) pointing to a shared directory across all profiles. *(Requires Node.js)* |
| `-SharedDir` | `%APPDATA%\ClaudeShared` | Directory for shared memory storage. |
| `-NoLauncher` | — | Direct desktop shortcuts without version checking. |
| `-RemoveProfile` | — | Removes specific profiles while leaving the others untouched. |
| `-KeepData` | — | When removing a profile, preserves its user data folder as orphan for future re-adoption. |
| `-Revert` | — | Full uninstall: deletes desktop shortcuts, extra profiles, launcher, and portable copy. |
| `-GrantWindowsAppsRead` | — | Grants read access to `WindowsApps` unattended when required. |
| `-Force` | — | Forces portable recopy, overwrites shared MCP servers, and skips confirmation prompts. |
| `-WhatIf` / `-Confirm` | — | Standard PowerShell support for change simulation. |

---

## Shared Memory (`-SharedMemory`)

Allows multiple Claude accounts to share context via local MCP servers:

1. **`shared-memory`:** Knowledge graph persisted in `<SharedDir>\memory.json`. Context saved by one account can be queried by the others.
2. **`shared-files`:** Shared read/write folder for `.md` notes and working files across instances.

> **Requirement:** Requires **Node.js** installed and available on `PATH` to run tools via `npx`.

---

## Automated Tests

The repository includes a comprehensive Pester test suite to verify component stability:

```powershell
powershell.exe -ExecutionPolicy Bypass -Command "Invoke-Pester -Path .\tests"
```

---

## System Requirements

- **Operating System:** Windows 10 or Windows 11.
- **PowerShell:** Windows PowerShell 5.1 (bundled with Windows).
  - *Note:* PowerShell 7 does not fully support Appx/MSIX management cmdlets (`Get-AppxPackage`). The `.bat` launcher automatically ensures PowerShell 5.1 is used.
- **Claude Desktop:** Installed on the system.
- **Node.js:** Optional (only needed if using `-SharedMemory`).

---

## License

This project is licensed under the MIT License. See [LICENSE](./LICENSE) for details.
