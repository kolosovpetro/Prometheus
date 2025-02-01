# Create persistent volume for your data
sudo docker volume create prometheus-data
# Start Prometheus container
sudo docker run -d -p 9090:9090 -v /home/razumovsky_r/prometheus.yml:/etc/prometheus/prometheus.yml -v prometheus-data:/home/razumovsky_r/prometheus prom/prometheus