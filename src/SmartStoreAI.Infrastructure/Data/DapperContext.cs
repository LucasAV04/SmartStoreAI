using System.Data;
using Microsoft.Extensions.Configuration;
using MySqlConnector;

namespace SmartStoreAI.Infrastructure.Data;

public class DapperContext
{
    private readonly string _connectionString;

    public DapperContext(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Connection string 'DefaultConnection' não configurada.");
    }

    public IDbConnection CriarConexao() => new MySqlConnection(_connectionString);
}
