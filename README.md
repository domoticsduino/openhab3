# OpenHAB3 Config and Support Tools

## /backup-script/oh3-full-backup.sh

Backup script for OpenHAB and Influxdb (running on docker).

**Credit to oliranks https://github.com/oliranks/openHAB3-full_backup_and_restore**

For remote copy to work (using SCP), you have to copy ssh key from RPI to NAS, using ssh-copy-id script. See https://www.ssh.com/academy/ssh/copy-id

## Control panel pages YAML source

You can find YAML source for pages used by my tablet wall mounted control panel in /pages folder, organized by page type.

To import a page, simply create a new page in Openhab UI (use the desired page type) and paste the yaml source code in *code* tab. Then, you can change personal details (as labels and item name for example...) in the *design* tab or directly in the yaml source