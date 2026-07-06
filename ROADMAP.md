# SmartStore AI — Roadmap do MVP

Baseado no escopo definido em `prompt.txt`. Ordem pensada para ter, a cada fase,
algo testável de ponta a ponta (API funcionando), evitando construir camadas
inteiras sem validação.

## Fase 1 — Fundação (ENTREGUE NESTA RODADA)
- Estrutura da solução (.NET Clean Architecture)
- Banco de dados: schema completo do MVP (`database/schema.sql`)
- Autenticação: cadastro, login, JWT
- Empresas (multiempresa): toda conta pertence a uma empresa; dados isolados por `EmpresaId`

## Fase 2 — Cadastros base
- Categorias (CRUD)
- Fornecedores (CRUD)
- Clientes (CRUD)
- Produtos (CRUD completo, vinculado a Categoria)

## Fase 3 — Estoque
- Movimentações de entrada/saída
- Histórico de movimentações
- Atualização automática de saldo do produto

## Fase 4 — Operações
- Compras (gera entrada de estoque + vincula fornecedor)
- Vendas (gera saída de estoque + calcula total)

## Fase 5 — Dashboard e Relatórios
- Totais (produtos, estoque baixo, valor de estoque, vendas/compras do mês)
- Relatórios: produtos em falta, abaixo do mínimo, vendas do mês, compras do mês

## Fase 6 — Autenticação avançada
- Recuperação de senha (e-mail)
- Alteração de senha
- Logout / revogação de refresh token

## Decisões de arquitetura (Fase 1)
- **Multiempresa por coluna `EmpresaId`** em todas as tabelas de negócio (mais simples
  que schema-per-tenant para MVP; migração para isolamento físico é possível depois).
- **Senhas**: hash com BCrypt.
- **Autenticação**: JWT com claims `EmpresaId`, `UsuarioId`, `Role`.
- **Acesso a dados**: Dapper (SQL explícito, sem overhead de EF Core — mesma escolha
  do projeto Estoque Loja).
- **Roles no MVP**: `Admin` (dono da conta) e `User` (funcionário), já pensando na
  Fase de Funcionários do sistema completo.

## Próximo passo sugerido
Fase 2 (Categorias → Fornecedores → Clientes → Produtos), pois todo o resto do MVP
(Estoque, Compras, Vendas) depende de Produtos existir.
