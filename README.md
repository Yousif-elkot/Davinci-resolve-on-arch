# DaVinci Resolve on Arch Linux (Hyprland)

![Arch Linux](https://img.shields.io/badge/Arch%20Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=white)
![DaVinci Resolve](https://img.shields.io/badge/DaVinci%20Resolve-233A51?style=for-the-badge&logo=davinci-resolve&logoColor=white)
![Hyprland](https://img.shields.io/badge/Hyprland-00B4D8?style=for-the-badge&logo=wayland&logoColor=white)
![FFmpeg](https://img.shields.io/badge/FFmpeg-007808?style=for-the-badge&logo=ffmpeg&logoColor=white)

A complete guide for installing and configuring DaVinci Resolve on Arch Linux, specifically tested on Hyprland. This repository includes installation steps, troubleshooting solutions, and a transcoding script for media compatibility.

## ✨ Features

- ✅ **Complete installation guide** for Arch Linux (Hyprland tested)
- ✅ **GPU driver setup** with OpenCL support
- ✅ **Common issues solved** with step-by-step fixes
- ✅ **Automated transcoding script** for media compatibility
- ✅ **ProRes 422 HQ conversion** for optimal editing performance
- ✅ **Codec licensing explained** - why H.264/H.265 don't work on Linux

## 🎬 Video Tutorial

A complete video tutorial is coming soon, demonstrating the entire installation and setup process on Hyprland!

## Table of Contents

- [Quick Start](#quick-start)
- [Installation](#installation)
  - [1. Download DaVinci Resolve](#1-download-davinci-resolve)
  - [2. Install GPU Drivers (OpenCL)](#2-install-gpu-drivers-opencl)
  - [3. Install DaVinci Resolve](#3-install-davinci-resolve)
- [Troubleshooting](#troubleshooting)
  - [Symbol Lookup Error Fix](#symbol-lookup-error-fix)
  - [Media Compatibility Issues](#media-compatibility-issues)
- [Transcoding Script](#transcoding-script)
- [Usage](#usage)

---

## Quick Start

For those who want to get started immediately:

```bash
# 1. Install OpenCL drivers (choose based on your GPU)
sudo pacman -S opencl-nvidia  # For NVIDIA
# OR
sudo pacman -S opencl-amd     # For AMD
# OR
sudo pacman -S intel-compute-runtime  # For Intel

# 2. Download and install DaVinci Resolve from:
# https://www.blackmagicdesign.com/products/davinciresolve

# 3. Fix library conflicts (if you get symbol lookup errors)
cd /opt/resolve/libs
sudo mkdir disabled-libraries
sudo mv libglib* libgio* libgmodule* disabled-libraries

# 4. Install FFmpeg for media transcoding
sudo pacman -S ffmpeg

# 5. Clone this repo and set up the transcode script
git clone https://github.com/Yousif-elkot/Davinci-resolve-on-arch.git
cd Davinci-resolve-on-arch
chmod +x transcode.sh
sudo ln -sf $(pwd)/transcode.sh /usr/local/bin/davinci-transcode

# 6. Transcode your media files
davinci-transcode your_video.mp4
```

For detailed instructions and explanations, continue reading below.

---

## Installation

### 1. Download DaVinci Resolve

Download DaVinci Resolve from the official Blackmagic Design website:

**[Download DaVinci Resolve](https://www.blackmagicdesign.com/products/davinciresolve)**

Choose either the free version or DaVinci Resolve Studio depending on your needs.

> **Note:** This guide works for both the free and Studio versions. However, be aware that the free version has codec limitations on Linux (see [Media Compatibility Issues](#media-compatibility-issues)).

### 2. Install GPU Drivers (OpenCL)

DaVinci Resolve requires OpenCL support for GPU acceleration. Follow the Arch Wiki guide for your specific GPU:

**[Arch Wiki - DaVinci Resolve](https://wiki.archlinux.org/title/DaVinci_Resolve)**

#### For NVIDIA users:
```bash
sudo pacman -S opencl-nvidia
```

#### For AMD users:
```bash
sudo pacman -S opencl-amd
```

#### For Intel users:
```bash
sudo pacman -S intel-compute-runtime
```

### 3. Install DaVinci Resolve

After downloading the `.zip` file from the Blackmagic Design website:

1. Extract the archive
2. Run the installer script (usually requires root privileges)
3. Follow the installation prompts

```bash
unzip DaVinci_Resolve_*_Linux.zip
cd DaVinci_Resolve_*_Linux
sudo ./DaVinci_Resolve_*_Linux.sh
```

After installation, you can launch DaVinci Resolve from your application menu or by running:
```bash
/opt/resolve/bin/resolve
```

---

## Troubleshooting

### Symbol Lookup Error Fix

If you encounter this error when launching DaVinci Resolve:

```
/opt/resolve/bin/resolve: symbol lookup error: /usr/lib/libpango-1.0.so.0: undefined symbol: g_once_init_leave_pointer
```

**Solution:** Disable conflicting libraries bundled with DaVinci Resolve:

```bash
cd /opt/resolve/libs
sudo mkdir disabled-libraries
sudo mv libglib* disabled-libraries
sudo mv libgio* disabled-libraries
sudo mv libgmodule* disabled-libraries
```

This forces DaVinci Resolve to use your system's versions of these libraries instead of the bundled ones.

### Media Compatibility Issues

**Problem:** The free version of DaVinci Resolve on Linux doesn't support:
- H.264/H.265 video codecs
- AAC audio codec

**Why?** This is due to codec licensing restrictions for commercial use. FFMPEG and x264 are only licensed for personal use, and H.264/H.265 aren't commercially licensed on Linux distributions.

**Solution:** Transcode your media files to a compatible format using the included script. This script converts media to ProRes 422 HQ, which is fully supported and provides excellent editing performance.

> **Note:** While DNxHR is also a compatible format, this script uses ProRes 422 HQ for its superior quality and broad compatibility.

---

## Transcoding Script

This repository includes a bash script that converts video and audio files to a format fully compatible with DaVinci Resolve.

### What it does

The script transcodes media files using the following FFmpeg parameters:
- **Video Codec**: ProRes 422 HQ (`prores_ks` with profile 3)
- **Audio Codec**: PCM 16-bit little-endian (`pcm_s16le`)
- **Container**: QuickTime (.mov)

This combination ensures maximum compatibility and quality for video editing in DaVinci Resolve on Linux.

### Prerequisites

- **FFmpeg** must be installed on your system
- **Bash** shell (standard on most Linux distributions)

#### Installing FFmpeg on Arch Linux

```bash
sudo pacman -S ffmpeg
```

---

## Usage

### Installing the Transcode Script

#### Method 1: System-wide Installation (Recommended)

1. **Clone this repository**:
   ```bash
   git clone https://github.com/Yousif-elkot/Davinci-resolve-on-arch.git
   cd Davinci-resolve-on-arch
   ```

2. **Make it executable**:
   ```bash
   chmod +x transcode.sh
   ```

3. **Create a symbolic link** for system-wide access:
   ```bash
   sudo ln -sf $(pwd)/transcode.sh /usr/local/bin/davinci-transcode
   ```

4. **Verify installation**:
   ```bash
   davinci-transcode --help
   ```

Now you can use `davinci-transcode` from anywhere in your terminal!

#### Method 2: Local Usage

Simply make the script executable and run it from its directory:
```bash
chmod +x transcode.sh
./transcode.sh --help
```

### Basic Usage

```bash
# If installed system-wide
davinci-transcode input_file.mp4

# If running locally
./transcode.sh input_file.mp4
```

### Specify Output Directory

```bash
# System-wide installation
davinci-transcode input_file.mp4 /path/to/output/

# Local execution
./transcode.sh input_file.mp4 /path/to/output/
```

### Examples

```bash
# Convert a video file (output in same directory)
davinci-transcode vacation_video.mp4

# Convert with custom output directory
davinci-transcode wedding.avi ~/Videos/transcoded/

# Convert audio file
davinci-transcode podcast.mp3 ~/Audio/for_davinci/

# Process multiple files
for file in *.mp4; do davinci-transcode "$file"; done
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

---

## Alternative Solutions

If you prefer other transcoding tools, you can also use:

- **[Shutter Encoder](https://www.shutterencoder.com/)** - GUI application with preset profiles
- **Custom FFmpeg scripts** - Many available online for specific workflows

The advantage of this script is its simplicity, automation, and optimized settings for DaVinci Resolve.

---

## Contributing

Found an issue or have a suggestion? Feel free to:
- Open an issue on GitHub
- Submit a pull request
- Share your experience in the discussions

---

## Credits

Created by [Yousif Elkot](https://github.com/Yousif-elkot)

Special thanks to the Arch Linux community and the Blackmagic Design team.

---

## Additional Resources

- [DaVinci Resolve Official Website](https://www.blackmagicdesign.com/products/davinciresolve)
- [Arch Wiki - DaVinci Resolve](https://wiki.archlinux.org/title/DaVinci_Resolve)
- [FFmpeg Documentation](https://ffmpeg.org/documentation.html)
- [ProRes Codec Information](https://en.wikipedia.org/wiki/Apple_ProRes)

---

## License

This project is provided as-is for educational and professional use. Feel free to modify and distribute as needed.