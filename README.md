# SmartStore AI — MVP (Fase 1: Autenticação + Empresas)

SaaS de gestão para pequenas empresas. Este pacote contém a Fase 1 do MVP
descrito em `ROADMAP.md`: cadastro de conta (empresa + usuário admin), login
e emissão de JWT.

## Estrutura (Clean Architecture)
```
src/
  SmartStoreAI.Domain          -> Entidades (Empresa, Usuario)
  SmartStoreAI.Application     -> DTOs, interfaces, regras de negócio (AuthService)
  SmartStoreAI.Infrastructure  -> Dapper (MySQL), hashing de senha (BCrypt), JWT
  SmartStoreAI.API             -> ASP.NET Core Web API (Controllers, Program.cs)
database/
  schema.sql                   -> Schema completo do MVP (todas as tabelas)
```

## Como rodar

1. Crie o banco:
   ```
   mysql -u root -p < database/schema.sql
   ```
2. Ajuste `src/SmartStoreAI.API/appsettings.json`:
   - `ConnectionStrings:DefaultConnection`
   - `Jwt:SecretKey` (mínimo 32 caracteres, use algo aleatório em produção)
3. Restaurar e rodar:
   ```
   cd src/SmartStoreAI.API
   dotnet restore
   dotnet run
   ```
4. Swagger disponível em `https://localhost:PORTA/swagger`.

## Endpoints da Fase 1

### POST /api/auth/registrar
Cria a empresa e o usuário Admin.
```json
{
  "nomeEmpresa": "Loja Diamante",
  "cnpjEmpresa": null,
  "telefoneEmpresa": "(79) 99999-0000",
  "enderecoEmpresa": "Rua Exemplo, 123 - Aracaju/SE",
  "nomeUsuario": "Lucas",
  "email": "lucas@lojadiamante.com",
  "senha": "SenhaForte123"
}
```

### POST /api/auth/login
```json
{
  "email": "lucas@lojadiamante.com",
  "senha": "SenhaForte123"
}
```
Retorna o JWT (claims: `EmpresaId`, `sub` = UsuarioId, `role`).

## Próximos passos
Ver `ROADMAP.md` — Fase 2 (Categorias, Fornecedores, Clientes, Produtos).
