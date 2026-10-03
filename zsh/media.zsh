# Media conversion / renaming helpers (require: jpegoptim, pngquant,
# ghostscript, imagemagick - see Brewfile).

function jpegoptim-recursive() {
  find . -type f -name "*.jpg" -exec jpegoptim -m 80 --all-progressive -s -p {} \;
}

function pngquant-recursive() {
  find . -type f -name "*.png" -exec pngquant --quality=70-80 --ext=.png -f {} \;
}

# Usage: pdfoptim file.pdf
function pdfoptim() {
  if [[ $# -eq 0 ]]; then
    echo 'Missing input PDF File.\nUsage:\n$ pdfoptim input.pdf'
    return 0
  fi
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile="${1%.*}-compressed.pdf" "$1"
}

# Rename every file matching extension $1 to a sequential 3-digit name (001.jpg, ...)
function renumber() {
  if [[ "$1" != "" ]]; then
    local i=0
    for f (*.$1) zmv $f '${(l:3::0:)$((++i))}'.$1
  else
    echo "Specify file extension"
    echo "ie.: renumber jpg"
  fi
}

# Change extension of every file in a folder from $1 to $2
function changeext() {
  if [[ "$1" != "" ]] || [[ "$2" != "" ]]; then
    for f in *.$1; do
      mv -- "$f" "${f%.$1}.$2"
    done
  else
    echo "Specify starting and destination extensions"
    echo "ie.: changeext png jpg"
  fi
}

function convert-towebp() {
  local recursive=false
  if [[ "$1" == "-r" ]]; then
    recursive=true
    shift
  fi
  local quality="${1:-80}"
  mkdir -p out

  if $recursive; then
    find . -not -path "./out/*" -type f | while IFS= read -r file; do
      local reldir="$(dirname "$file")"
      local dir="out/${reldir#./}"
      mkdir -p "$dir"
      local base="$(basename "$file")"
      cp "$file" "$dir/$base"
      case "$base" in
        *.png|*.jpg|*.jpeg)
          local output="${base%.*}.webp"
          magick "$dir/$base" -quality "$quality" "$dir/$output" && rm "$dir/$base"
          ;;
      esac
    done
  else
    find . -maxdepth 1 -not -path "./out" -not -path "." -type f -exec cp {} out/ \;
    cd out || return
    for file in *.{png,jpg,jpeg}(N); do
      [[ -e $file ]] || continue
      local output="${file%.*}.webp"
      magick "$file" -quality "$quality" "$output" && rm "$file"
    done
    cd ..
  fi
}

function convert-tojpg() {
  local recursive=false
  if [[ "$1" == "-r" ]]; then
    recursive=true
    shift
  fi
  local quality="${1:-90}"
  mkdir -p out

  if $recursive; then
    find . -not -path "./out/*" -type f | while IFS= read -r file; do
      local reldir="$(dirname "$file")"
      local dir="out/${reldir#./}"
      mkdir -p "$dir"
      local base="$(basename "$file")"
      cp "$file" "$dir/$base"
      case "$base" in
        *.png|*.webp)
          local output="${base%.*}.jpg"
          magick "$dir/$base" -quality "$quality" "$dir/$output" && rm "$dir/$base"
          ;;
      esac
    done
  else
    find . -maxdepth 1 -not -path "./out" -not -path "." -type f -exec cp {} out/ \;
    cd out || return
    for file in *.{png,webp}(N); do
      [[ -e $file ]] || continue
      local output="${file%.*}.jpg"
      magick "$file" -quality "$quality" "$output" && rm "$file"
    done
    cd ..
  fi
}

# https://gist.github.com/Hecsall/f857b15ef1c97abe489c2c22d16be4c9
function m3ugen() {
  if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ -z "$1" ]]; then
    echo ""
    echo "M3Ugen"
    echo "Create an .m3u8 playlist with all the files contained in the root of the specified directory."
    echo "Scanned files: .flac, .mp3, .mp4, .wav, .aac, .ogg, .m4a"
    echo ""
    echo "Usage:"
    echo "  $(basename $0) -f <music_folder_path>"
    echo "  $(basename $0) -f <music_folder_path> [-n <playlist_title>]"
    echo "  $(basename $0) -f <music_folder_path> [-o <ordering>] [-n <playlist_title>]"
    echo ""
    echo "Options:"
    printf '%-25s %-40s\n' "  -h, --help" "Display this message"
    printf '%-25s %-40s\n' "  -f"         "Folder where the songs are"
    printf '%-25s %-40s\n' "  -o"         "Songs order, default: -date"
    printf '%-25s %-40s\n' ""             "Possible values: date, -date, name, -name"
    printf '%-25s %-40s\n' "  -n"         "Name of the .m3u file but without extension, default: playlist"
    return 0
  fi

  local songs_path order playlist_name
  while getopts f:o:n:h option; do
    case "$option" in
      f) songs_path=$(echo $OPTARG | sed 's:/*$::') ;;
      o)
        if [[ "$OPTARG" == "name" ]] || [[ "$OPTARG" == "-name" ]] || [[ "$OPTARG" == "date" ]] || [[ "$OPTARG" == "-date" ]]; then
          order=$OPTARG
        else
          echo "\nInvalid value for option -o \nPossible values: \nname, -name, date, -date"
          return 0
        fi
        ;;
      n) playlist_name=$OPTARG ;;
      *)
        echo "Invalid option received, use -h for help."
        return
        ;;
    esac
  done

  [[ -z "$playlist_name" ]] && playlist_name="playlist"
  if [[ -z "$songs_path" ]]; then
    echo "Missing songs path (-f <your_path>)"
    return
  fi
  [[ -z "$order" ]] && order="-date"

  [[ -f "$songs_path/$playlist_name.m3u8" ]] && rm -f "$songs_path/$playlist_name.m3u8"

  case "$order" in
    name)  ls -1 "$songs_path"  | grep -i -E ".flac$|.mp3$|.mp4$|.wav$|.aac$|.ogg$|.m4a$" > "$songs_path/$playlist_name.m3u8" ;;
    -name) ls -r1 "$songs_path" | grep -i -E ".flac$|.mp3$|.mp4$|.wav$|.aac$|.ogg$|.m4a$" > "$songs_path/$playlist_name.m3u8" ;;
    date)  ls -tr1 "$songs_path" | grep -i -E ".flac$|.mp3$|.mp4$|.wav$|.aac$|.ogg$|.m4a$" > "$songs_path/$playlist_name.m3u8" ;;
    -date) ls -t1 "$songs_path" | grep -i -E ".flac$|.mp3$|.mp4$|.wav$|.aac$|.ogg$|.m4a$" > "$songs_path/$playlist_name.m3u8" ;;
  esac
}
