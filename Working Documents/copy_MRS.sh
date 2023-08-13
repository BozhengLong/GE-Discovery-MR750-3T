#!/bin/bash

# 1. Check if a USB drive is inserted
if [ -d "/run/media/$USER" ]; then
  usb_name=$(ls /run/media/$USER)
  echo "Detected USB drive: ${usb_name}"
else
  echo "No USB drive detected"
  exit 1
fi

# 2. Filter out files with suffix ".7" at specified time point
read -p "Please enter the start time (format: HH:MM): " start_time
read -p "Please enter the end time (format: HH:MM): " end_time
filter_date=$(date +'%Y-%m-%d')
start_datetime="${filter_date} ${start_time}:00"
end_datetime="${filter_date} ${end_time}:00"
echo "Filter time range is from ${start_datetime} to ${end_datetime}"
files=$(find /usr/g/mrraw/ -name "*.7" -newermt "${start_datetime}" ! -newermt "${end_datetime}" -printf "%f\n")
if [ -z "$files" ]; then
  echo "No files found that match the filter criteria"
  exit 1
else
  echo "Found the following files:"
  echo "$files"
fi

# 3. If only one file is found, ask user if they want to copy it to the USB drive
if [ "$(echo "$files" | wc -l)" -eq 1 ]; then
  read -p "Do you want to copy ${files} to the USB drive? (Press Enter to confirm, or enter anything else to cancel)" confirm
  if [ -z "$confirm" ]; then
    echo "Copying file to USB drive..."
  else
    echo "Cancelled copying file to USB drive"
    exit 1
  fi
else
  echo "Multiple files found that match the filter criteria. Please copy them manually to the USB drive."
  exit 1
fi

# 4. Copy the file to a new folder on the USB drive and rename it
read -p "Please enter the new filename for the copied file on the USB drive: " new_filename
usb_dir="/run/media/$USER/${usb_name}/Image_MRS"
mkdir -p "$usb_dir"
cp "/usr/g/mrraw/$files" "$usb_dir/$new_filename"

# 5. Open Nautilus browser and navigate to the new folder on the USB drive
nautilus "$usb_dir"
