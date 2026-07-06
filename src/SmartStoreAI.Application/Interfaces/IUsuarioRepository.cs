using SmartStoreAI.Domain.Entities;

namespace SmartStoreAI.Application.Interfaces;

public interface IUsuarioRepository
{
    Task<Usuario?> ObterPorEmailAsync(string email);
    Task<Usuario?> ObterPorIdAsync(Guid id);
    Task<Guid> CriarAsync(Usuario usuario);
}
