using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;

namespace PrometheusMetrics.Controllers;

[ApiController]
[Route("[controller]")]
public class PrometheusController : ControllerBase
{
    [HttpGet]
    [Route("random-result-code")]
    public async Task<IActionResult> GetRandomResultCode()
    {
        var result = new Random().Next(1, 5);

        if (result == 1)
        {
            return await Task.FromResult<IActionResult>(Ok());
        }

        if (result == 2)
        {
            return await Task.FromResult<IActionResult>(NotFound());
        }

        if (result == 3)
        {
            return await Task.FromResult<IActionResult>(BadRequest());
        }

        return await Task.FromResult<IActionResult>(StatusCode(500));
    }
}
