# DaVinci Resolve Transcoder

A bash script that converts video and audio files to a format compatible with DaVinci Resolve using FFmpeg.

## What it does

This script transcodes media files using the following FFmpeg parameters:
- **Video Codec**: ProRes 422 HQ (`prores_ks` with profile 3)
- **Audio Codec**: PCM 16-bit little-endian (`pcm_s16le`)
- **Container**: QuickTime (.mov)

This combination ensures maximum compatibility and quality for video editing in DaVinci Resolve.

## Prerequisites

- **FFmpeg** must be installed on your system
- **Bash** shell (standard on most Linux distributions)

### Installing FFmpeg

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install ffmpeg

# CentOS/RHEL/Fedora
sudo dnf install ffmpeg

# Arch Linux
sudo pacman -S ffmpeg
```

## Installation

### Method 1: System-wide Installation (Recommended)

1. **Download the script** (or clone this repository)
2. **Make it executable**:
   ```bash
   chmod +x transcode.sh
   ```
3. **Create a symbolic link** for system-wide access:
   ```bash
   sudo ln -sf /path/to/transcode.sh /usr/local/bin/davinci-transcode
   ```
   Replace `/path/to/transcode.sh` with the actual path to your script.

4. **Verify installation**:
   ```bash
   davinci-transcode --help
   ```

Now you can use `davinci-transcode` from anywhere in your terminal!

### Method 2: Add to PATH

1. **Make the script executable**:
   ```bash
   chmod +x transcode.sh
   ```

2. **Add the script directory to your PATH**:
   ```bash
   echo 'export PATH="$PATH:/path/to/script/directory"' >> ~/.bashrc
   source ~/.bashrc
   ```
   Replace `/path/to/script/directory` with the actual directory containing the script.

3. **Test the installation**:
   ```bash
   transcode.sh --help
   ```

### Method 3: Local Installation

Simply make the script executable and run it from its directory:
```bash
chmod +x transcode.sh
./transcode.sh --help
```

## Usage

### Basic Usage
```bash
# If installed system-wide (Method 1)
davinci-transcode input_file.mp4

# If added to PATH (Method 2) 
transcode.sh input_file.mp4

# If running locally (Method 3)
./transcode.sh input_file.mp4
```

### Specify Output Directory
```bash
# System-wide installation
davinci-transcode input_file.mp4 /path/to/output/

# PATH method
transcode.sh input_file.mp4 /path/to/output/

# Local execution
./transcode.sh input_file.mp4 /path/to/output/
```

### Examples
```bash
# Convert a video file (output in same directory)
davinci-transcode vacation_video.mp4

# Convert with custom output directory
davinci-transcode wedding.avi ./transcoded_files/

# Convert audio file
davinci-transcode podcast.mp3 ./audio_for_davinci/
```

## Features

- ✅ **Input Validation**: Checks if input file exists and is readable
- ✅ **FFmpeg Detection**: Verifies FFmpeg is installed before proceeding
- ✅ **Progress Display**: Shows real-time transcoding progress
- ✅ **File Size Info**: Displays input and output file sizes
- ✅ **Overwrite Protection**: Asks before overwriting existing files
- ✅ **Error Handling**: Clear error messages and proper exit codes
- ✅ **Help Documentation**: Built-in help with `--help` option
- ✅ **Automatic Naming**: Adds `_davinci` suffix to output files

## Output Format Details

The script uses these specific FFmpeg parameters for DaVinci Resolve compatibility:

```bash
ffmpeg -i input_file.mp4 -c:v prores_ks -profile:v 3 -c:a pcm_s16le output_file.mov
```

- **`-c:v prores_ks`**: Uses ProRes encoder (high quality, editing-friendly)
- **`-profile:v 3`**: ProRes 422 HQ profile (best quality for editing)
- **`-c:a pcm_s16le`**: Uncompressed 16-bit PCM audio (no quality loss)
- **`.mov` container**: QuickTime format preferred by DaVinci Resolve

## Supported Input Formats

The script can handle most common video and audio formats including:
- **Video**: MP4, AVI, MKV, MOV, M4V, WMV, FLV, WebM
- **Audio**: WAV, MP3, AAC, FLAC, OGG

## File Size Considerations

ProRes files are significantly larger than compressed formats like H.264:
- **Typical increase**: 5-10x larger than original MP4 files
- **Benefits**: No generational loss, smooth playback, better editing performance
- **Storage**: Ensure adequate disk space before transcoding

## Troubleshooting

### FFmpeg Not Found
```bash
Error: ffmpeg is not installed or not in PATH
```
**Solution**: Install FFmpeg using your package manager (see Prerequisites section)

### Permission Denied
```bash
Error: Cannot read input file 'filename'
```
**Solution**: Check file permissions with `ls -la filename` and adjust if needed

### Disk Space Issues
```bash
Error: No space left on device
```
**Solution**: Free up disk space or specify a different output directory with more space

## Performance Tips

1. **Use SSD storage** for faster read/write speeds during transcoding
2. **Close unnecessary applications** to free up system resources
3. **For batch processing**, process files one at a time to avoid overwhelming the system

## License

This script is provided as-is for educational and professional use.