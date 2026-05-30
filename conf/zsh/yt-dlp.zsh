# yt-dlp — iCloud Media/youtube (macOS)
#
#   Media/youtube/video/
#   Media/youtube/audio/
#
#   ytd-video <url>
#   ytd-video --no-playlist <url>
#   ytd-audio <url>

export YTD_MEDIA_BASE="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Media"
export YTD_VIDEO_DIR="$YTD_MEDIA_BASE/youtube/video"
export YTD_AUDIO_DIR="$YTD_MEDIA_BASE/youtube/audio"

ytd-video() {
  if (( $# == 0 )); then
    echo "Usage: ytd-video [--no-playlist] <url>" >&2
    return 1
  fi
  command -v yt-dlp &>/dev/null || {
    echo "ytd-video: yt-dlp not found (brew install yt-dlp)" >&2
    return 1
  }
  mkdir -p "$YTD_VIDEO_DIR" || return 1
  yt-dlp -i \
    -f "bestvideo+bestaudio/best" --merge-output-format mp4 \
    -o "$YTD_VIDEO_DIR/%(playlist_index)03d - %(title)s.%(ext)s" \
    "$@"
}

ytd-audio() {
  if (( $# == 0 )); then
    echo "Usage: ytd-audio [--no-playlist] <url>" >&2
    return 1
  fi
  command -v yt-dlp &>/dev/null || {
    echo "ytd-audio: yt-dlp not found (brew install yt-dlp)" >&2
    return 1
  }
  mkdir -p "$YTD_AUDIO_DIR" || return 1
  yt-dlp -i -x --audio-format m4a \
    -o "$YTD_AUDIO_DIR/%(playlist_index)03d - %(title)s.%(ext)s" \
    "$@"
}
