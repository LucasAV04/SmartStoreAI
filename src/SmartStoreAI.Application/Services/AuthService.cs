using SmartStoreAI.Application.DTOs;
using SmartStoreAI.Application.Interfaces;
using SmartStoreAI.Domain.Entities;

namespace SmartStoreAI.Application.Services;

public class AuthService : IAuthService
{
    private readonly IUsuarioRepository _usuarioRepository;
    private readonly IEmpresaRepository _empresaRepository;
    private readonly IPasswordHasher _passwordHasher;
    private readonly IJwtTokenGenerator _jwtTokenGenerator;

    public AuthService(
        IUsuarioRepository usuarioRepository,
        IEmpresaRepository empresaRepository,
        IPasswordHasher passwordHasher,
        IJwtTokenGenerator jwtTokenGenerator)
    {
        _usuarioRepository = usuarioRepository;
        _empresaRepository = empresaRepository;
        _passwordHasher = passwordHasher;
        _jwtTokenGenerator = jwtTokenGenerator;
    }

    public async Task<EmpresaResponse> RegistrarContaAsync(RegistrarContaRequest request)
    {
        var usuarioExistente = await _usuarioRepository.ObterPorEmailAsync(request.Email);
        if (usuarioExistente is not null)
            throw new InvalidOperationException("Já existe uma conta com este e-mail.");

        var empresa = new Empresa
        {
            Id = Guid.NewGuid(),
            Nome = request.NomeEmpresa,
            Cnpj = request.CnpjEmpresa,
            Telefone = request.TelefoneEmpresa,
            Email = request.Email,
            Endereco = request.EnderecoEmpresa
        };
        await _empresaRepository.CriarAsync(empresa);

        var usuario = new Usuario
        {
            Id = Guid.NewGuid(),
            EmpresaId = empresa.Id,
            Nome = request.NomeUsuario,
            Email = request.Email,
            SenhaHash = _passwordHasher.Hash(request.Senha),
            Role = "Admin"
        };
        await _usuarioRepository.CriarAsync(usuario);

        return new EmpresaResponse(empresa.Id, empresa.Nome, empresa.Cnpj, empresa.Telefone, empresa.Email, empresa.Endereco);
    }

    public async Task<LoginResponse> LoginAsync(LoginRequest request)
    {
        var usuario = await _usuarioRepository.ObterPorEmailAsync(request.Email);
        if (usuario is null || !usuario.Ativo || !_passwordHasher.Verificar(request.Senha, usuario.SenhaHash))
            throw new UnauthorizedAccessException("E-mail ou senha inválidos.");

        var (token, expiraEm) = _jwtTokenGenerator.Gerar(usuario);

        return new LoginResponse(token, expiraEm, usuario.Id, usuario.EmpresaId, usuario.Nome, usuario.Role);
    }
}
