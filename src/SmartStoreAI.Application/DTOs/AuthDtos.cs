namespace SmartStoreAI.Application.DTOs;

public record RegistrarContaRequest(
    string NomeEmpresa,
    string? CnpjEmpresa,
    string? TelefoneEmpresa,
    string? EnderecoEmpresa,
    string NomeUsuario,
    string Email,
    string Senha
);

public record LoginRequest(string Email, string Senha);

public record LoginResponse(
    string Token,
    DateTime ExpiraEm,
    Guid UsuarioId,
    Guid EmpresaId,
    string Nome,
    string Role
);

public record EmpresaResponse(
    Guid Id,
    string Nome,
    string? Cnpj,
    string? Telefone,
    string? Email,
    string? Endereco
);
