using SmartStoreAI.Domain.Entities;

namespace SmartStoreAI.Application.Interfaces;

public interface IEmpresaRepository
{
    Task<Empresa?> ObterPorIdAsync(Guid id);
    Task<Guid> CriarAsync(Empresa empresa);
}
