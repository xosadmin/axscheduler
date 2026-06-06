# AXScheduler
AXScheduler is a lightweight cross-platform YAML-based task scheduler with second-level interval support.

### Supported command shells

- Bash
- CMD
- PowerShell
- WSL

### How to deploy?

1. Clone this project.
2. Run the installer.
   - For **Linux**, use `install.sh` to install the program and systemd service.
   - For **Windows**, install `python 3` first, then use `windows_installer.ps1` to install the program and register it with Windows Task Scheduler.
3. Edit `config.yaml`. For examples, please refer to [example_config.yaml](https://github.com/xosadmin/axschedule/blob/main/example_config.yaml).
4. Restart the scheduler after modifying `config.yaml`.

### Config file location
- Linux: `/opt/axscheduler/config.yaml`
- Windows: `C:\axscheduler\config.yaml`

### Task modification and reload process
#### Task modification
Add or modify task entries in `config.yaml`. For examples, please refer to [example_config.yaml](https://github.com/xosadmin/axschedule/blob/main/example_config.yaml).
#### Reload on Linux
```bash
systemctl restart axscheduler
```
#### Reload on Windows
```cmd
schtasks /End /TN "AXScheduler"
schtasks /Run /TN "AXScheduler"
```
