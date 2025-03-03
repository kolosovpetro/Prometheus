# Windows PromQL queries

## CPU usage time series windows

- `(100 - (avg by (instance) (rate(windows_cpu_time_total{mode="idle"}[$__rate_interval])) * 100))`

## RAM usage time series windows

- `((windows_memory_physical_total_bytes - windows_memory_available_bytes) / windows_memory_physical_total_bytes) * 100`
