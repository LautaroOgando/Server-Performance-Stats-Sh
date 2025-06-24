#!/bin/bash
os_name=$(grep 'PRETTY' /etc/os-release | cut -d = -f2);
echo -e "$os_name\n";

disk_total=$(df -h --total | grep 'total' | awk '{print $2}');
disk_used=$(df -h --total | grep 'total' | awk '{print $3}');
disk_free=$(df -h --total | grep 'total' | awk '{print $4}');
disk_free_percent=$(df -h --total | grep 'total' | awk '{print $5}' | tr -d '%');

mem_total=$(free -h | grep 'Mem:' | awk '{print $2}');
mem_used=$(free -h | grep 'Mem:' | awk '{print $3}');
mem_free=$(free -h | grep 'Mem:' | awk '{print $4}');
mem_available=$(free -h | grep 'Mem:' | awk '{print $7}')

cpu_usage=$(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')

top_five_processes_by_cpu=$( 
    printf '%-10s %-8s %-6s %-6s %-s\n' "USER" "PID" "%CPU" "%MEM" "COMMAND"
    ps aux --sort=-%cpu | awk 'NR>1 {printf "%-10s %-8s %-6s %-6s %-s\n", $1, $2, $3, $4, $11}' | head -n 5
)
top_five_processes_by_mem=$( 
    printf '%-10s %-8s %-6s %-6s %-s\n' "USER" "PID" "%CPU" "%MEM" "COMMAND"
    ps aux --sort=-%mem | awk 'NR>1 {printf "%-10s %-8s %-6s %-6s %-s\n", $1, $2, $3, $4, $11}' | head -n 5 )

mem_total_percent=$(echo $mem_total | tr -d '[:alpha:]')

mem_used_percent=$(echo $mem_used | tr -d '[:alpha:]')
mem_used_percent=$(echo "scale=2; $mem_used_percent * 100 / $mem_total_percent" | bc)

mem_free_percent=$(echo $mem_free | tr -d '[:alpha:]')
mem_free_percent=$(echo "scale=2; $mem_free_percent * 100 / $mem_total_percent" | bc)

mem_available_percent=$(echo $mem_available | tr -d '[:alpha:]')
mem_available_percent=$(echo "scale=2; $mem_available_percent * 100 / $mem_total_percent" | bc)

echo "Memory Total: $mem_total ";
echo "Memory Used: $mem_used / ($mem_used_percent%)";
echo "Memory Free: $mem_free / ($mem_free_percent%)";
echo "Memory Available: $mem_available / ($mem_available_percent%)";
echo -e "\n";

echo "Disk Total: $disk_total";
echo "Disk Used: $disk_used / ($((100 - disk_free_percent))%)";
echo -e "Disk Free: $disk_free / ($disk_free_percent%)\n";


echo -e "CPU Usage: $cpu_usage%\n";
echo -e "Top 5 Processes by CPU Usage:\n";
echo -e "$top_five_processes_by_cpu\n";

echo -e "Top 5 Processes by Memory Usage:\n";
echo "$top_five_processes_by_mem";  
