# macOS launchd Task Setup Guide

This guide will help you convert your original cron tasks to the macOS recommended launchd system.

## 📋 Original Cron Tasks

```bash
# Execute once every 12 hours to delete recording files
0 */12 * * * /bin/zsh /Users/tomlord/dotfiles/delete_record.sh

# Execute once every 3 days at midnight to clean up Heptabase backups
0 0 */3 * * /bin/zsh /Users/tomlord/dotfiles/delete_hepta_backup.sh
```

## 🚀 Advantages of launchd

Compared to cron, launchd offers the following advantages:

- **More Reliable**: Automatically resumes tasks after system restart
- **Better Logging**: Built-in logging system for easier debugging
- **Environment Variables**: Better support for environment variables
- **Resource Management**: Better system resource management
- **Native to macOS**: Deeply integrated with the macOS system

## 📁 File Structure

```
/Users/tomlord/dotfiles/
├── delete_record.sh                      # Original script
├── delete_hepta_backup.sh               # Original script
├── com.tomlord.delete-record.plist      # launchd configuration file
├── com.tomlord.delete-hepta-backup.plist # launchd configuration file
├── setup_launchd.sh                     # Management script
└── LAUNCHD_README.md                    # This documentation file
```

## ⚙️ Configuration Explanation

### 1. delete-record Task
- **Execution Frequency**: Every 12 hours
- **Function**: Deletes the SuperWhisper recording directory
- **Log Location**: `/Users/tomlord/dotfiles/delete_record.out/err`

### 2. delete-hepta-backup Task
- **Execution Frequency**: Every 3 days
- **Function**: Cleans up old Heptabase backup files (keeping the latest 2)
- **Log Location**: `/Users/tomlord/dotfiles/delete_hepta_backup.out/err`

## 🛠️ Usage

### Installing Tasks

```bash
# Method 1: Using the management script (Recommended)
./setup_launchd.sh install

# Method 2: Manual installation
cp com.tomlord.delete-record.plist ~/Library/LaunchAgents/
cp com.tomlord.delete-hepta-backup.plist ~/Library/LaunchAgents/
launchctl load ~/Library/LaunchAgents/com.tomlord.delete-record.plist
launchctl load ~/Library/LaunchAgents/com.tomlord.delete-hepta-backup.plist
```

### Checking Status

```bash
# Using the management script
./setup_launchd.sh status

# Manual check
launchctl list | grep com.tomlord
```

### Uninstalling Tasks

```bash
# Using the management script
./setup_launchd.sh uninstall

# Manual uninstallation
launchctl unload ~/Library/LaunchAgents/com.tomlord.delete-record.plist
launchctl unload ~/Library/LaunchAgents/com.tomlord.delete-hepta-backup.plist
rm ~/Library/LaunchAgents/com.tomlord.delete-record.plist
rm ~/Library/LaunchAgents/com.tomlord.delete-hepta-backup.plist
```

### Reloading Tasks

```bash
./setup_launchd.sh reload
```

## 📦 Management Script Usage

The `setup_launchd.sh` script provides complete task management functionality:

```bash
# Display help
./setup_launchd.sh help

# Install all tasks
./setup_launchd.sh install

# Check task status
./setup_launchd.sh status

# Uninstall all tasks
./setup_launchd.sh uninstall

# Reload tasks
./setup_launchd.sh reload
```

## 🔍 Troubleshooting

### Checking if Tasks are Running

```bash
# View all user tasks
launchctl list | grep com.tomlord

# View specific task details
launchctl list com.tomlord.delete-record
```

### Viewing Logs

```bash
# View standard output
cat /Users/tomlord/dotfiles/delete_record.out
cat /Users/tomlord/dotfiles/delete_hepta_backup.out

# View error output
cat /Users/tomlord/dotfiles/delete_record.err
cat /Users/tomlord/dotfiles/delete_hepta_backup.err

# View script built-in logs
cat /Users/tomlord/dotfiles/crontab.log
```

### Manually Testing Tasks

```bash
# Manually execute tasks
launchctl start com.tomlord.delete-record
launchctl start com.tomlord.delete-hepta-backup
```

### Common Issues

1. **Tasks Not Executing**
   - Check the plist file syntax for correctness
   - Ensure the script has execution permissions
   - View error logs

2. **Permission Issues**
   - Ensure script path is correct
   - Check file permission settings

3. **Environment Variable Issues**
   - The plist file sets the PATH environment variable
   - Use absolute paths in the script

## 📝 Notes

1. **First Run**: Tasks will start executing according to schedule after installation
2. **System Restart**: launchd tasks will automatically resume after system restart
3. **Configuration Changes**: Tasks need to be reloaded after modifying the plist file
4. **Log Management**: Regularly check and clean up log files
5. **Testing Recommendation**: Test script functionality manually before actual use

## 🔄 Steps to Migrate from Cron

1. **Backup Existing Cron Tasks**
   ```bash
   crontab -l > cron_backup.txt
   ```

2. **Install launchd Tasks**
   ```bash
   ./setup_launchd.sh install
   ```

3. **Verify Task Normal Operation**
   ```bash
   ./setup_launchd.sh status
   ```

4. **Remove Cron Tasks** (After verifying launchd tasks are working correctly)
   ```bash
   crontab -r
   ```

This way, you have successfully migrated your cron tasks to the macOS recommended launchd system! 