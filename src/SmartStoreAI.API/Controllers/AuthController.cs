using Microsoft.AspNetCore.Mvc;
using SmartStoreAI.Application.DTOs;
using SmartStoreAI.Application.Interfaces;

namespace SmartStoreAI.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;

    public AuthController(IAuthService authService)
    {
        _authService = authService;
    }

    [HttpPost("registrar")]
    public async Task<IActionResult> Registrar([FromBody] RegistrarContaRequest request)
    {
        try
        {
            var empresa = await _authService.RegistrarContaAsync(request);
            return CreatedAtAction(nameof(Registrar), new { id = empresa.Id }, empresa);
        }
        catch (InvalidOperationException ex)
        {
            return Conflict(new { mensagem = ex.Message });
        }
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        try
        {
            var resultado = await _authService.LoginAsync(request);
            return Ok(resultado);
        }
        catch (UnauthorizedAccessException ex)
        {
            return Unauthorized(new { mensagem = ex.Message });
        }
    }
}
