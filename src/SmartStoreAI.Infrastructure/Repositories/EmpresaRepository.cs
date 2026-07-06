using Dapper;
using SmartStoreAI.Application.Interfaces;
using SmartStoreAI.Domain.Entities;
using SmartStoreAI.Infrastructure.Data;

namespace SmartStoreAI.Infrastructure.Repositories;

public class EmpresaRepository : IEmpresaRepository
{
    private readonly DapperContext _context;

    public EmpresaRepository(DapperContext context)
    {
        _context = context;
    }

    public async Task<Empresa?> ObterPorIdAsync(Guid id)
    {
        const string sql = "SELECT * FROM empresas WHERE Id = @Id LIMIT 1";
        using var conexao = _context.CriarConexao();
        return await conexao.QueryFirstOrDefaultAsync<Empresa>(sql, new { Id = id });
    }

    public async Task<Guid> CriarAsync(Empresa empresa)
    {
        const string sql = @"INSERT INTO empresas
            (Id, Nome, Cnpj, Telefone, Email, Endereco, Ativa, CriadoEm)
            VALUES (@Id, @Nome, @Cnpj, @Telefone, @Email, @Endereco, @Ativa, @CriadoEm)";

        using var conexao = _context.CriarConexao();
        await conexao.ExecuteAsync(sql, empresa);
        return empresa.Id;
    }
}
