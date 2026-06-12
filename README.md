# yt-plex-syncer

A lightweight, automated Bash script designed to synchronize the latest videos from your favorite YouTube channels directly into a structured Plex media library. 

It maintains a local, auto-updating binary of `yt-dlp` to avoid outdated system package issues and HTTP 403 errors, ensuring seamless, hands-off downloads.

## Features

* **Plex-Ready Formatting:** Automatically organizes files into `Uploader/Title [ID].ext` directory structures.
* **Media Enrichment:** Embeds metadata, extracts and converts thumbnails (`.jpg`), and embeds them directly into the output file.
* **Targeted Syncing:** Forces channel URLs to the `/videos` tab to deliberately skip YouTube Shorts and Live streams.
* **Efficient Archiving:** Utilizes a download history archive to prevent duplicate downloads and only scans the last 3 videos per channel per run.
* **Self-Updating Dependencies:** Automatically checks and updates its local `yt-dlp` binary on every run without requiring `sudo` privileges.

To read the full deployment guide and system intelligence log, visit the official project page:
[INTEL_VIEWPORT // YT_PLEX_SYNCER](https://itechie.eu/yt-plex-syncer/index.html)

## Prerequisites

The script relies on `ffmpeg` for merging high-quality video and audio streams.

```bash
sudo apt update && sudo apt install ffmpeg
