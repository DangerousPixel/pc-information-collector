# 🖥️ System Information Collector

## What is this?

Are you the lone IT hero in your workspace, drowning in a sea of unorganized PC specs? Fear not, brave SysAdmin! This PowerShell script is your trusty sidekick, designed to gather all those pesky system details from Windows PCs effortlessly.

## Why did we make this?

Ever tried to take inventory of every machine in your domain and thought, “There has to be a better way!”? Well, here it is. This script was crafted with love (and a bit of frustration) to help IT administrators and support teams manage and monitor their fleet of computers without losing their sanity.

## How to use it?

1. **Download the Script:**
   - Clone this repository or download the `collect_system_info.ps1` file.
   
2. **Run the Script:**
   - Open PowerShell as Administrator.
   - Navigate to the script’s directory.
   - Execute the script: `./collect_system_info.ps1`

3. **Profit:**
   - Sit back, relax, and watch as all the juicy details get collected and stored in a neatly organized JSON file.

## How it works?

- **Runs on Windows:** Uses PowerShell to extract system information.
- **Collects:**
  - Device specs (PC name, device ID, serial number, product ID)
  - OS details (version, edition, activation status)
  - Hardware info (CPU, RAM, storage type, and size)
  - Domain status
- **Stores Data:** Outputs everything in JSON format for easy reading and processing.

## Example JSON Output:

```json
{
  "pc_name": "WORKSTATION1",
  "device_id": "12345-ABCDE-67890-FGHIJ",
  "serial_number": "SN123456789",
  "product_id": "00330-80000-00000-AA570",
  "windows_version": "Microsoft Windows 10 Pro, 10.0.19042 N/A Build 19042",
  "windows_edition": "Professional",
  "activation_status": "Licensed",
  "total_storage": "512 GB",
  "storage_type": "SSD",
  "ram": "16 GB",
  "cpu": "Intel(R) Core(TM) i7-9700K CPU @ 3.60GHz",
  "domain_status": "Connected to Domain"
}
```
## Why should you care?
- **Save Time:** Automate the tedious task of gathering system info.
- **Stay Organized:** Keep all your machine specs in one place.
- **Improve Efficiency:** Quickly identify issues or inventory needs.
- **Look Like a Pro:** Impress your colleagues with your automation skills.

----

Feel free to copy and paste this into your GitHub repository description!

