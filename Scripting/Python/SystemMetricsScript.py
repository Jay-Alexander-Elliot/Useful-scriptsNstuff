#!/usr/bin/env python3
# SystemMetricsScript

import os
import sys
import subprocess
import psutil

# Ensure the script is run as root
if os.geteuid() != 0:
    print("Please run this script as root or sudo.")
    sys.exit(1)

# Get system load metrics
def load():
    time_span = input("Enter time span of system load (1, 5, 15): ")
    try:
        time_span = int(time_span)
        if time_span in [1, 5, 15]:
            output = os.getloadavg()[int(time_span / 5)]
            print(f"The average system load for the last {time_span} minutes is {output}.")
        else:
            raise ValueError
    except ValueError:
        print("OOPS! Invalid input.")
        sys.exit(1)

# Get system memory metrics using psutil
def memory():
    memory_info = psutil.virtual_memory()
    mem_metrics = {
        'total': memory_info.total / (1024 ** 2),
        'used': memory_info.used / (1024 ** 2),
        'free': memory_info.free / (1024 ** 2)
    }
    
    usage = input("Enter usage category of system memory (total, used, free): ").lower()
    if usage in mem_metrics:
        print(f"The {usage} system memory is {mem_metrics[usage]:.2f} MB.")
    else:
        print("OOPS! Invalid input.")
        sys.exit(1)

# Get system storage metrics using psutil
def storage():
    partitions = psutil.disk_partitions()
    for partition in partitions:
        if '/dev/sda1' in partition.device:
            usage = psutil.disk_usage(partition.mountpoint)
            storage_metrics = {
                'total': usage.total / (1024 ** 3),
                'used': usage.used / (1024 ** 3),
                'free': usage.free / (1024 ** 3)
            }

            category = input("Enter usage category of system storage (total, used, free): ").lower()
            if category in storage_metrics:
                print(f"The {category} system storage is {storage_metrics[category]:.2f} GB.")
                break
    else:
        print("/dev/sda1 not found.")
        sys.exit(1)

# Main function to choose a system metric
def main():
    if len(sys.argv) > 1:
        metric_type = sys.argv[1].lower()
        if metric_type == 'load':
            load()
        elif metric_type == 'memory':
            memory()
        elif metric_type == 'storage':
            storage()
        else:
            print("Usage: ./system_metrics_script.py {load|memory|storage}")
            sys.exit(1)
    else:
        print("No argument provided.")
        print("Usage: ./system_metrics_script.py {load|memory|storage}")
        sys.exit(1)

if __name__ == "__main__":
    main()
