using Dapper;
using SmartStoreAI.Application.Interfaces;
using SmartStoreAI.Domain.Entities;
using SmartStoreAI.Infrastructure.Data;

namespace SmartStoreAI.Infrastructure.Repositories;

public class UsuarioRepository : IUsuarioRepository
{
    private readonly DapperContext _context;

    public UsuarioRepository(DapperContext context)
    {
        _context = context;
    }

    public async Task<Usuario?> ObterPorEmailAsync(string email)
    {
        const string sql = "SELECT * FROM usuarios WHERE Email = @Email LIMIT 1";
        using var conexao = _context.CriarConexao();
        return await conexao.QueryFirstOrDefaultAsync<Usuario>(sql, new { Email = email });
    }

    public async Task<Usuario?> ObterPorIdAsync(Guid id)
    {
        const string sql = "SELECT * FROM usuarios WHERE Id = @Id LIMIT 1";
        using var conexao = _context.CriarConexao();
        return await conexao.QueryFirstOrDefaultAsync<Usuario>(sql, new { Id = id });
    }

    public async Task<Guid> CriarAsync(Usuario usuario)
    {
        const string sql = @"INSERT INTO usuarios
            (Id, EmpresaId, Nome, Email, SenhaHash, Role, Ativo, CriadoEm)
            VALUES (@Id, @EmpresaId, @Nome, @Email, @SenhaHash, @Role, @Ativo, @CriadoEm)";

        using var conexao = _context.CriarConexao();
        await conexao.ExecuteAsync(sql, usuario);
        return usuario.Id;
    }
}
