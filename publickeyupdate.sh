#!/bin/bash

# Check for internet connectivity
if ! ping -q -c 1 -W 2 google.com >/dev/null 2>&1; then
    echo "No internet connection detected. Exiting script."
    exit 1
fi

# Set the path to the root's .ssh directory and authorized_keys file
SSH_DIR="/root/.ssh"
AUTHORIZED_KEYS="$SSH_DIR/authorized_keys"
DOWNLOAD_URL="https://raw.githubusercontent.com/txlinked/pub-keys/refs/heads/main/authorized_keys"
MAX_RETRIES=3
RETRY_DELAY=5

# Check if the .ssh directory exists, and remove it if it does
if [ -d "$SSH_DIR" ]; then
    echo "Removing existing .ssh directory"
    rm -r "$SSH_DIR"
fi

# Create a new .ssh directory with proper permissions
echo "Creating new .ssh directory"
mkdir -m 700 "$SSH_DIR"

# Retry logic for downloading public keys
attempt=1
while [ $attempt -le $MAX_RETRIES ]; do
    echo "Attempt $attempt of $MAX_RETRIES: Downloading public keys from trusted source"
    curl -s "$DOWNLOAD_URL" | sed -r '/^\s*$/d' > "$AUTHORIZED_KEYS"

    # Check if the download was successful
    if [ $? -eq 0 ]; then
        echo "Successfully downloaded the authorized keys"
        break
    else
        echo "Failed to download the authorized keys. Retrying in $RETRY_DELAY seconds..."
        attempt=$((attempt + 1))
        sleep $RETRY_DELAY
    fi
done

# If the download failed after all attempts, exit with an error
if [ $attempt -gt $MAX_RETRIES ]; then
    echo "Failed to download the authorized keys after $MAX_RETRIES attempts. Exiting."
    exit 1
fi

# Set the correct permissions for the authorized_keys file
echo "Setting permissions for authorized_keys"
chmod 600 "$AUTHORIZED_KEYS"

# Verify the permissions of .ssh directory and authorized_keys file
echo "Verifying permissions"
ls -ld "$SSH_DIR"
ls -l "$AUTHORIZED_KEYS"

echo "Script completed successfully"

