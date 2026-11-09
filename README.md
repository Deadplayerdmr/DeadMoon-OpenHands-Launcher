# 🌙 DeadMoon OpenHands Launcher

![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Docker](https://img.shields.io/badge/Engine-Docker%20Desktop-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Shell](https://img.shields.io/badge/Script-Batch%20%2B%20PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-9B59B6?style=for-the-badge)

> **A zero-friction, all-in-one Windows launcher and installer for [OpenHands](https://github.com/All-Hands-AI/OpenHands)** — powered by the **DeadMoon `[Moonlight Engine]`** kinetic ASCII interface and engineered to eliminate Windows Docker sandbox port collisions (`500: Failed to start container`).

---

## ✨ Terminal Preview

```text
      *   d~~b  .        .================.        .   d~~b   *
   .    d  b      .==='  .------------.  '===.      d  b     .
      *     /   .-'    .      o    '-.   \     d  b   *
               /  .'   o       .      .   '.  \        .
    *         [===]  .    /        \    .  [===]   .       *
        (( .--[===]     \____/    \____/   [===]--. ))   d~b
        ((    [===]   o       .---.      O [===]    ))   d b
    .    '--- [===]    .    /      \   .   [===] ---'
       *       \  '.     .            o  .'  /       *
    .           '.  '-.    o   .   .  .-'  .'     .       *
         *        '===='--------------'===='          .

  ============================================================================
    🌙  D E A D M O O N   O P E N H A N D S   L A U N C H E R  🌙
  ============================================================================
```

---

## 🚀 Key Features

* **🌙 Kinetic ASCII Boot Splash (`[Moonlight Engine]`)**
  Renders a smooth 12-frame animated DeadMoon splash screen with pulsing headphone soundwaves, floating musical notes, and a live progress bar — using native Windows utilities with zero external dependencies.
* **⚡ True One-Click `.cmd` Execution**
  No PowerShell `ExecutionPolicy` blocks, UTF-8 batch offset crashes, or manual terminal setup. Double-click `DeadMoon-OpenHands-Launcher.cmd` to install, configure, and launch OpenHands in one seamless flow.
* **🐳 Smart Docker Detection & Auto-Start**
  * Automatically checks if `docker.exe` is installed on your machine and opens the official [Docker Desktop download page](https://www.docker.com/products/docker-desktop/) if missing.
  * Detects if the Docker Desktop daemon is asleep, launches `Docker Desktop.exe` automatically, and waits until the engine is online.
* **📂 Persistent AI Workspace & Automatic POSIX Volume Translation**
  * Prompts you for your preferred workspace directory on first launch (or defaults to `C:\AI_Workspace` when you press `Enter`).
  * Saves your choice to `.openhands_launcher.cfg` and automatically converts Windows drive paths (`C:\AI_Workspace\workspace`) into the POSIX path format (`/c/AI_Workspace/workspace:/workspace:rw`) required by OpenHands sandbox volumes.
* **🛡️ Built-In Fix for Windows `"500: Failed to start container"` Errors**
  * **Orphaned Sandbox Purge:** Automatically removes leftover `openhands-app` and `oh-agent-server-*` containers before each session.
  * **Single-Mount SQLite Stability:** Avoids duplicate `.openhands` bind mounts that cause database file-locking errors across WSL2.
  * **Windows NAT (`winnat`) Port Flush:** When run as Administrator, automatically restarts the `winnat` service to release locked Hyper-V ephemeral TCP port ranges (`49152–65535`).

---

## 🛠️ Quick Start

### 1. Download
Clone this repository or download `DeadMoon-OpenHands-Launcher.cmd` directly:
```bash
git clone https://github.com/Deadplayerdmr/DeadMoon-OpenHands-Launcher.git
```

### 2. Run the Launcher
Double-click **`DeadMoon-OpenHands-Launcher.cmd`** (or right-click and choose **Run as administrator** to enable automatic Windows NAT port flushing).

1. **First Run:**
   * If Docker Desktop isn't installed, your browser will open to the download page.
   * Enter your desired workspace path or press **Enter** to use `C:\AI_Workspace`.
   * The launcher will create your `workspace` and `.openhands` directories, pull `ghcr.io/openhands/openhands:latest`, and start the server.
2. **Subsequent Runs:**
   * A 3-second quick menu appears before auto-launching OpenHands:
     * **`[R]`** 🚀 Launch OpenHands immediately *(default after 3 seconds)*
     * **`[C]`** 📂 Change your AI Workspace directory
     * **`[U]`** ⬇️ Force-pull the latest OpenHands Docker image update

### 3. Open the Web UI
Once the container starts, open your browser and navigate to:
```text
http://localhost:3000
```

---

## 🔧 Troubleshooting

| Symptom | Cause | Solution |
| :--- | :--- | :--- |
| **`500: Failed to start container`** on a new conversation | Windows `winnat` / Hyper-V reserved a random high TCP port needed by `oh-agent-server-*` | Right-click `DeadMoon-OpenHands-Launcher.cmd` and select **Run as administrator**. The script will automatically restart `winnat` and clear stuck port bindings. |
| **Docker engine timeout on startup** | WSL2 backend or Docker Desktop needs extra time to boot | Start Docker Desktop manually, wait for the whale icon in your system tray to turn steady, and run the launcher again. |
| **Want to switch project folders** | Workspace path is saved from initial setup | Press **`C`** during the 3-second startup menu (or delete `.openhands_launcher.cfg`) to pick a new workspace directory. |

---

## 📚 Citations & Acknowledgements

This launcher is built for **[OpenHands](https://github.com/All-Hands-AI/OpenHands)** (formerly OpenDevin), an open platform for AI software developers as generalist agents.

* **OpenHands GitHub Repository:** [https://github.com/All-Hands-AI/OpenHands](https://github.com/All-Hands-AI/OpenHands)
* **OpenHands Documentation:** [https://docs.all-hands.dev](https://docs.all-hands.dev)
* **Research Paper (ICLR 2025):** [*OpenHands: An Open Platform for AI Software Developers as Generalist Agents*](https://arxiv.org/abs/2407.16741)

If you use OpenHands in your research or projects, please cite the official paper:

```bibtex
@inproceedings{wang2025openhands,
  title={{OpenHands: An Open Platform for AI Software Developers as Generalist Agents}},
  author={Xingyao Wang and Boxuan Li and Yufan Song and Frank F. Xu and Xiangru Tang and Mingchen Zhuge and Jiayi Pan and Yueqi Song and Bowen Li and Jaskirat Singh and Hoang H. Tran and Fuqiang Li and Ren Ma and Mingzhang Zheng and Bill Qian and Yanjun Shao and Niklas Muennighoff and Yizhe Zhang and Binyuan Hui and Junyang Lin and Robert Brennan and Hao Peng and Heng Ji and Graham Neubig},
  booktitle={International Conference on Learning Representations (ICLR)},
  year={2025},
  url={https://arxiv.org/abs/2407.16741}
}
```

---

## 👤 Author

Created with 🌙 by **[deadplayerdmr](https://github.com/deadplayerdmr)**

## 📄 License

This project is licensed under the **MIT License** — see the `LICENSE` file for details.
