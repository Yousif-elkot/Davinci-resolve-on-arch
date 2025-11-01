#!/usr/bin/bash

# Transcoder script for DaVinci Resolve
# Converts video/audio files to DNxHR/ProRes format compatible with DaVinci Resolve

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Default codec (can be changed with --codec option)
CODEC_CHOICE="dnxhr_sq"

# Function to display usage
show_usage() {
    echo -e "${BLUE}DaVinci Resolve Transcoder${NC}"
    echo ""
    echo "Usage: $0 [options] <input_file> [output_directory]"
    echo ""
    echo "Options:"
    echo "  --codec <codec>  - Choose codec (default: dnxhr_sq)"
    echo "                     Available: dnxhr_sq, dnxhr_hq, dnxhr_hqx, prores_lt, prores_422, prores_hq"
    echo "  --help, -h       - Show this help message"
    echo ""
    echo "Parameters:"
    echo "  input_file       - Video or audio file to transcode"
    echo "  output_directory - (Optional) Directory for output file. Default: same as input"
    echo ""
    echo "Codec Comparison (1080p footage):"
    echo -e "  ${CYAN}dnxhr_sq${NC}     - FASTEST, smallest (2-3x original size) - Recommended!"
    echo -e "  ${CYAN}dnxhr_hq${NC}     - Balanced quality/size (4-5x original)"
    echo -e "  ${CYAN}dnxhr_hqx${NC}    - High quality (6-8x original)"
    echo -e "  ${CYAN}prores_lt${NC}    - ProRes Light, smaller (3-4x original)"
    echo -e "  ${CYAN}prores_422${NC}   - ProRes Standard (5-7x original)"
    echo -e "  ${CYAN}prores_hq${NC}    - ProRes HQ, largest/slowest (10-15x original)"
    echo ""
    echo "Examples:"
    echo "  $0 video.mp4                              # Use DNxHR SQ (fastest)"
    echo "  $0 --codec dnxhr_hq video.mp4             # Use DNxHR HQ"
    echo "  $0 --codec prores_lt video.mp4 ~/Videos/  # Use ProRes LT"
    echo ""
    echo "Supported formats: mp4, avi, mkv, mov, m4v, wmv, flv, webm, wav, mp3, aac, etc."
}

# Function to check if ffmpeg is installed
check_ffmpeg() {
    if ! command -v ffmpeg &> /dev/null; then
        echo -e "${RED}Error: ffmpeg is not installed or not in PATH${NC}"
        echo "Please install ffmpeg first:"
        echo "  Ubuntu/Debian: sudo apt install ffmpeg"
        echo "  CentOS/RHEL: sudo yum install ffmpeg"
        echo "  Arch: sudo pacman -S ffmpeg"
        exit 1
    fi
}

# Function to validate input file
validate_input() {
    local input_file="$1"
    
    if [[ -z "$input_file" ]]; then
        echo -e "${RED}Error: No input file specified${NC}"
        show_usage
        exit 1
    fi
    
    if [[ ! -f "$input_file" ]]; then
        echo -e "${RED}Error: Input file '$input_file' does not exist${NC}"
        exit 1
    fi
    
    if [[ ! -r "$input_file" ]]; then
        echo -e "${RED}Error: Cannot read input file '$input_file'${NC}"
        exit 1
    fi
}

# Function to create output directory if it doesn't exist
ensure_output_dir() {
    local output_dir="$1"
    
    if [[ ! -d "$output_dir" ]]; then
        echo -e "${YELLOW}Creating output directory: $output_dir${NC}"
        mkdir -p "$output_dir"
        if [[ $? -ne 0 ]]; then
            echo -e "${RED}Error: Cannot create output directory '$output_dir'${NC}"
            exit 1
        fi
    fi
}

# Function to get file size in human readable format
get_file_size() {
    local file="$1"
    if [[ -f "$file" ]]; then
        du -h "$file" | cut -f1
    else
        echo "N/A"
    fi
}

# Function to get ffmpeg codec parameters based on choice
get_codec_params() {
    local codec="$1"
    case "$codec" in
        dnxhr_sq)
            echo "-c:v dnxhd -profile:v dnxhr_sq"
            ;;
        dnxhr_hq)
            echo "-c:v dnxhd -profile:v dnxhr_hq"
            ;;
        dnxhr_hqx)
            echo "-c:v dnxhd -profile:v dnxhr_hqx"
            ;;
        prores_lt)
            echo "-c:v prores_ks -profile:v 1"
            ;;
        prores_422)
            echo "-c:v prores_ks -profile:v 2"
            ;;
        prores_hq)
            echo "-c:v prores_ks -profile:v 3"
            ;;
        *)
            echo "-c:v dnxhd -profile:v dnxhr_sq"
            ;;
    esac
}

# Function to perform the transcoding
transcode_file() {
    local input_file="$1"
    local output_file="$2"
    local codec="$3"
    
    echo -e "${BLUE}Starting transcoding...${NC}"
    echo "Codec:  $codec"
    echo "Input:  $input_file ($(get_file_size "$input_file"))"
    echo "Output: $output_file"
    echo ""
    
    # Get codec parameters
    local codec_params=$(get_codec_params "$codec")
    
    # Show ffmpeg progress and capture any errors
    ffmpeg -i "$input_file" \
           $codec_params \
           -c:a pcm_s16le \
           -y \
           "$output_file" 2>&1 | while IFS= read -r line; do
        
        # Show progress information
        if [[ "$line" =~ frame=.*fps=.*time= ]]; then
            echo -ne "\r${YELLOW}$line${NC}"
        fi
        
        # Show any error messages
        if [[ "$line" =~ Error|error|failed|Failed ]]; then
            echo -e "\n${RED}$line${NC}"
        fi
    done
    
    echo "" # New line after progress
    
    # Check if transcoding was successful
    if [[ $? -eq 0 && -f "$output_file" ]]; then
        echo -e "${GREEN}✓ Transcoding completed successfully!${NC}"
        echo "Output file: $output_file ($(get_file_size "$output_file"))"
        return 0
    else
        echo -e "${RED}✗ Transcoding failed!${NC}"
        return 1
    fi
}

# Main script execution
main() {
    local codec="$CODEC_CHOICE"
    local input_file=""
    local output_dir=""
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help|help)
                show_usage
                exit 0
                ;;
            --codec)
                codec="$2"
                shift 2
                ;;
            *)
                if [[ -z "$input_file" ]]; then
                    input_file="$1"
                else
                    output_dir="$1"
                fi
                shift
                ;;
        esac
    done
    
    # Validate codec choice
    case "$codec" in
        dnxhr_sq|dnxhr_hq|dnxhr_hqx|prores_lt|prores_422|prores_hq)
            # Valid codec
            ;;
        *)
            echo -e "${RED}Error: Invalid codec '$codec'${NC}"
            echo "Valid options: dnxhr_sq, dnxhr_hq, dnxhr_hqx, prores_lt, prores_422, prores_hq"
            exit 1
            ;;
    esac
    
    # Check prerequisites
    check_ffmpeg
    validate_input "$input_file"
    
    # Get absolute path of input file
    input_file=$(readlink -f "$input_file")
    
    # Determine output directory and filename
    if [[ -z "$output_dir" ]]; then
        output_dir=$(dirname "$input_file")
    else
        ensure_output_dir "$output_dir"
        output_dir=$(readlink -f "$output_dir")
    fi
    
    # Generate output filename
    local basename=$(basename "$input_file")
    local filename="${basename%.*}"
    local output_file="$output_dir/${filename}_davinci.mov"
    
    # Check if output file already exists
    if [[ -f "$output_file" ]]; then
        echo -e "${YELLOW}Warning: Output file already exists: $output_file${NC}"
        read -p "Do you want to overwrite it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Transcoding cancelled."
            exit 0
        fi
    fi
    
    # Perform the transcoding
    echo -e "${BLUE}=== DaVinci Resolve Transcoder ===${NC}"
    echo ""
    
    transcode_file "$input_file" "$output_file" "$codec"
    
    if [[ $? -eq 0 ]]; then
        echo ""
        echo -e "${GREEN}All done! Your file is ready for DaVinci Resolve.${NC}"
        
        # Display codec info
        case "$codec" in
            dnxhr_*)
                echo "Format: DNxHR (${codec#dnxhr_}) with PCM 16-bit audio"
                ;;
            prores_*)
                echo "Format: Apple ProRes (${codec#prores_}) with PCM 16-bit audio"
                ;;
        esac
        exit 0
    else
        exit 1
    fi
}

# Run the main function with all arguments
main "$@"