#!/usr/bin/env bash
# Title: SystemMetricsCollector.sh
# Description: This script collects and displays system metrics including load, memory, and storage. It offers an interactive way for users to specify what metrics they want to retrieve.
# Author: Jay-Alexander Elliot
# Date: 2024-01-23
# Usage: Execute this script with one of the following arguments: load, memory, or storage. 
#        For example, 'sudo ./SystemMetricsCollector.sh load' to get system load metrics.

# Validate if user is root
if [[ $(id -u) -ne 0 ]]; then
  echo "Please run this script as root or use sudo."
  exit 1
fi

# Function to get system load metrics.
# User inputs time span (1, 5, or 15 minutes), and the script returns the average system load for that duration.
get_load() {
  read -p "Enter time span of system load (1,5,15): " time_span
  case $time_span in
    1|5|15)
      load=$(awk '{print $'"$time_span"'}' /proc/loadavg)
      echo "The average system load for the last $time_span minute(s) is $load."
      ;;
    *)
      echo "Invalid input. Please enter 1, 5, or 15."
      exit 1
      ;;
  esac
}

# Function to get system memory metrics.
# User inputs memory category (total, used, or free), and the script returns the corresponding memory metric in MB.
get_memory() {
  read -p "Enter category of system memory (total,used,free): " category
  case $category in
    total|used|free)
      mem_info=$(free -m | awk '/^Mem/ {print $2, $3, $4}')
      output=$(echo $mem_info | awk -v category=$category '{
        if (category == "total") print $1 " MB"
        else if (category == "used") print $2 " MB"
        else if (category == "free") print $3 " MB"
      }')
      echo "The $category system memory is $output."
      ;;
    *)
      echo "Invalid input. Please enter total, used, or free."
      exit 1
      ;;
  esac
}

# Function to get system storage metrics.
# User inputs storage category (total, used, or free), and the script returns the corresponding storage metric in GB.
get_storage() {
  read -p "Enter category of system storage (total,used,free): " category
  case $category in
    total|used|free)
      storage_info=$(df -Th | awk '/\/dev\/sda1/ {print $3, $4, $5}' | sed 's/G//g')
      output=$(echo $storage_info | awk -v category=$category '{
        if (category == "total") print $1 " GB"
        else if (category == "used") print $2 " GB"
        else if (category == "free") print $3 " GB"
      }')
      echo "The $category system storage is $output."
      ;;
    *)
      echo "Invalid input. Please enter total, used, or free."
      exit 1
      ;;
  esac
}

# Main execution block
# Validates the input argument and calls the corresponding function to display the requested system metrics.
case $1 in
  load)
    get_load
    ;;
  memory)
    get_memory
    ;;
  storage)
    get_storage
    ;;
  *)
    echo "Usage: $0 {load|memory|storage}"
    echo "Example: $0 load"
    exit 1
    ;;
esac
