#!/bin/bash

PATCH_EXTENSION=".patch"
PATCH_OPTIONS="-p1"

while getopts "p:" opt; do
  case "$opt" in
    p)
      PATCH_DIR="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      _usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      _usage
      exit 1
      ;;
  esac
done
shift $((OPTIND-1)) # Shift off the parsed options

_usage() {
  echo "Usage: $(basename "$0") [-p <patch_directory>]"
  echo ""
  echo "  Applies patch files from the specified directory"
  echo "  Patches are applied to the current working directory."
  echo ""
  echo "Options:"
  echo "  -p <patch_directory>  Specify the directory containing patch files."
  echo ""
  echo "Example:"
  echo "  $(basename "$0") -p /path/to/my_patches"
}

echo "Starting patch application from directory: ${PATCH_DIR}"
echo "Applying patches in the current directory: $(pwd)"

# Check if the patch directory exists
if [ ! -d "${PATCH_DIR}" ]; then
  echo "Error: Patch directory '${PATCH_DIR}' not found."
  _usage # Show usage if patch dir is missing when specified
  exit 1
fi

# Loop through all files in the patch directory that end with the specified extension
find "${PATCH_DIR}" -maxdepth 1 -name "*${PATCH_EXTENSION}" -print0 | while IFS= read -r -d $'\0' patch_file; do
  echo "Applying patch: ${patch_file}"

  # Apply the patch using the 'patch' command in the current directory
  if patch ${PATCH_OPTIONS} < "${patch_file}"; then
    echo "  Patch applied successfully."
  else
    echo "  Error applying patch: ${patch_file}"
    echo "  Please check the patch file and your project structure."
    echo "  You may need to manually apply this patch or investigate the errors."
  fi
  echo "-------------------------"
done

echo "Patch application process finished."
