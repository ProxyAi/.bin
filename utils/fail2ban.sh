#!/bin/bash

# Function to perform backup
backup_fail2ban() {
    echo "Backing up Fail2Ban configuration and database..."
    sudo tar -czvf /var/backups/fail2ban-config-backup.tar.gz /etc/fail2ban/
    sudo tar -czvf /var/backups/fail2ban-db-backup.tar.gz /var/lib/fail2ban/fail2ban.sqlite3
    echo "Backup completed."
}

# Function to perform restore
restore_fail2ban() {
    echo "Restoring Fail2Ban configuration and database..."
    sudo tar -xzvf /var/backups/fail2ban-config-backup.tar.gz -C /
    sudo tar -xzvf /var/backups/fail2ban-db-backup.tar.gz -C /
    sudo systemctl restart fail2ban
    echo "Restore completed."
}

# Function to ask user for action if no argument is provided
ask_user_action() {
    echo "Please select an action:"
    echo "1) Backup Fail2Ban"
    echo "2) Restore Fail2Ban"
    read -p "Enter your choice (1 or 2): " choice

    if [ "$choice" -eq 1 ]; then
        backup_fail2ban
    elif [ "$choice" -eq 2 ]; then
        restore_fail2ban
    else
        echo "Invalid choice. Exiting."
        exit 1
    fi
}

mkdir -p /var/backups/

# Check if an argument was provided
if [ "$#" -eq 1 ]; then
    case "$1" in
        --backup)
            backup_fail2ban
            ;;
        --restore)
            restore_fail2ban
            ;;
        *)
            echo "Invalid argument. Use --backup or --restore."
            exit 1
            ;;
    esac
else
    ask_user_action
fi
