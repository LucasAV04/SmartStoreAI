using SmartStoreAI.Domain.Entities;

namespace SmartStoreAI.Application.Interfaces;

public interface IJwtTokenGenerator
{
    (string Token, DateTime ExpiraEm) Gerar(Usuario usuario);
}
