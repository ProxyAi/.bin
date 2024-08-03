# ~/.bin/utils

A collection utility scripts.


## memory_usage_percentage.sh

A simple script to display memory usage percentage, normally used with `$ watch ./memory_usage_percentage.sh`.

```bash
[code@code-here utils]$ ./memory_usage_percentage.sh
Memory usage: 59.00%
```


## memory_usage_stats.sh

Displays memory usage as a progress bar and keeps tracks of lowest and highest memory usage.

```bash
[code@code-here utils]$ ./memchart.sh
Memory Usage: |##############################                    | 59.00%
Highest Memory Usage: 18649.1 MB
Lowest Memory Usage: 18644.1 MB
Press 'q' to quit
```


## memchart2.sh

BROKEN, not finished.


## cpu_usage_percentage.sh

A simple script to display cpu usage percentage, normally used with `$ watch ./memory_usage_percentage.sh`.

```bash
[code@code-here utils]$ ./memory_usage_percentage.sh
CPU usage: 2.30%
```

## force_wifi_on.sh

basically a alias in file format

```bash
$ sudo iw dev wlp1s0 set power_save off
```


## github_repo_update.sh

Bare bones of a github api update script


## gitlab_repo_update.sh

Bare bones of a gitlab api update script


## spinner.sh

A script to display a spinner for processes


