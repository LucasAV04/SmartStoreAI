using SmartStoreAI.Application.DTOs;

namespace SmartStoreAI.Application.Interfaces;

public interface IAuthService
{
    Task<EmpresaResponse> RegistrarContaAsync(RegistrarContaRequest request);
    Task<LoginResponse> LoginAsync(LoginRequest request);
}
