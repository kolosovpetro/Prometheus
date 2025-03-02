curl -X POST -H 'Content-Type: application/json' --data '{
  "alerts": [{
    "status": "firing",
    "labels": {
      "alertname": "HighCPUUsage",
      "severity": "critical"
    },
    "annotations": {
      "summary": "Test High CPU Usage",
      "description": "Test alert for high CPU"
    }
  }]
}' http://prometheus-master.razumovsky.me:9093/api/v2/alerts
