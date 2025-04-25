using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using OpenTelemetry.Logs;
using OpenTelemetry.Metrics;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;

var serviceName = "DemoApi";

var builder = WebApplication.CreateBuilder(args);

// Configure OpenTelemetry Tracing
builder.Services.AddOpenTelemetry()
    .ConfigureResource(resource => resource.AddService(serviceName))
    .WithTracing(tracing => tracing
        .AddAspNetCoreInstrumentation() // Trace incoming HTTP requests
        .AddHttpClientInstrumentation() // Trace outgoing HTTP requests
        .AddConsoleExporter()) // Export traces to the console
    .WithMetrics(metrics => metrics
        .AddAspNetCoreInstrumentation()
        .AddHttpClientInstrumentation()
        .AddPrometheusExporter() // Add exporter: dotnet add package --prerelease OpenTelemetry.Exporter.Prometheus.AspNetCore
        .AddConsoleExporter());

builder.Logging.AddOpenTelemetry(options =>
{
    options
        .SetResourceBuilder(ResourceBuilder.CreateDefault().AddService(serviceName))
        .AddConsoleExporter();
});

// Configure Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddControllers();

var app = builder.Build();


app.UseSwagger();
app.UseSwaggerUI();

app.UseAuthorization();

app.MapControllers();
app.MapPrometheusScrapingEndpoint();

app.Run();
