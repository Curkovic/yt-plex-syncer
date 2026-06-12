#!/usr/bin/env bash

# ==============================================================================
# CONFIGURATION
# ==============================================================================

# Define your YouTube channels here. Use Channel URLs.
CHANNELS=(
    "https://www.youtube.com/@SmarterEveryDay"
    "https://www.youtube.com/@MarkRober"
)

# Root directory where you want to store your Plex YouTube videos
DOWNLOAD_DIR="$HOME/Downloads/YT"
# Maximum video resolution height (1080p)
MAX_HEIGHT="1080"

# ==============================================================================
# SYSTEM CHECKS & SYSTEM CONFIGURATION
# ==============================================================================

# Ensure ffmpeg is installed (system dependency)
if ! command -v ffmpeg &> /dev/null; then
    echo "Error: 'ffmpeg' is not installed. Please install it first:"
    echo "sudo apt update && sudo apt install ffmpeg"
    exit 1
fi

# Setup folders
mkdir -p "$DOWNLOAD_DIR"
ARCHIVE_FILE="$DOWNLOAD_DIR/downloaded_history.txt"
touch "$ARCHIVE_FILE"

# Manage a local, up-to-date copy of yt-dlp to bypass outdated system packages and 403 errors
LOCAL_YTDLP="$DOWNLOAD_DIR/yt-dlp"

if [ ! -f "$LOCAL_YTDLP" ]; then
    echo "Downloading the latest official yt-dlp binary..."
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o "$LOCAL_YTDLP"
    chmod +x "$LOCAL_YTDLP"
else
    echo "Checking for yt-dlp updates..."
    # Auto-update the local binary (runs without sudo)
    "$LOCAL_YTDLP" -U --no-backups >/dev/null 2>&1 || true
fi

echo "Starting YouTube synchronization..."
echo "Destination: $DOWNLOAD_DIR"
echo "Using yt-dlp version: $("$LOCAL_YTDLP" --version)"
echo "----------------------------------------"

# Loop through each channel
for CHANNEL_URL in "${CHANNELS[@]}"; do
    # Strip trailing slash and target only the main /videos tab to bypass Shorts/Live
    CLEAN_URL="${CHANNEL_URL%/}"
    if [[ "$CLEAN_URL" != */videos ]]; then
        TARGET_URL="${CLEAN_URL}/videos"
    else
        TARGET_URL="$CLEAN_URL"
    fi

    echo "Processing: $TARGET_URL"
   
    # Run our local, updated yt-dlp
    "$LOCAL_YTDLP" \
        --rm-cache-dir \
        --playlist-end 3 \
        --download-archive "$ARCHIVE_FILE" \
        -f "bestvideo[height<=${MAX_HEIGHT}]+bestaudio/best[height<=${MAX_HEIGHT}]/best" \
        --merge-output-format mp4 \
        --embed-metadata \
        --embed-thumbnail \
        --write-thumbnail \
        --convert-thumbnails jpg \
        -o "$DOWNLOAD_DIR/%(uploader)s/%(title)s [%(id)s].%(ext)s" \
        "$TARGET_URL"

    echo "Finished channel processing."
    echo "----------------------------------------"
done

echo "Sync complete!"
