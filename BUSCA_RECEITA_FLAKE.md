# Busca por Receita Flake NixOS

**Data:** 2025-10-20
**Objetivo:** Encontrar receita flake completa usada anteriormente para migração NixOS

## Locais Pesquisados ✅

### 1. Histórico Claude Code
**Arquivo:** `~/.claude/history.jsonl` (104KB)
**Resultado:** ❌ Nenhum flake.nix encontrado
**Menções:** 1 referência a "flake" (validação, não migração)

### 2. Filesystem Termux/proot
**Busca:** `**/*.nix` em `/home/jf/`
**Encontrado:** 3 arquivos

#### Arquivos .nix Encontrados:

1. **`/home/jf/projects/nix-on-droid/claude-code-isolated.nix`**
   - Tipo: Pacote Nix para Claude Code isolado
   - Conteúdo: Instalação isolada com Node.js, Python, uv
   - Relevância: ❌ Não é receita de migração NixOS

2. **`/home/jf/projects/nix-on-droid/shell.nix`**
   - Tipo: Ambiente dev temporário
   - Conteúdo: Shell isolado com runtimes e LSP servers
   - Relevância: ❌ Não é receita de migração NixOS

3. **`/home/jf/projects/nix-on-droid/nix-validation-config.nix`**
   - Tipo: Configuração ferramentas validação
   - Conteúdo: statix, deadnix, nixpkgs-fmt, nil
   - Relevância: ❌ Não é receita de migração NixOS

#### Outros Achados:

**`FLAKE_VALIDATION_GUIDE.md`** - Guia de validação de flakes
- Ferramentas de linting e formatação
- Exemplo de flake simples (Claude Code isolado)
- Workflow de validação completo
- ⚠️ Não contém receita de migração completa

### 3. Projetos Verificados

- `/home/jf/projects/nix-on-droid/` → Configurações nix-on-droid
- `/home/jf/projects/nixos-avf/` → Vazio
- Outros 8 projetos → Sem conteúdo NixOS relevante

## Locais NÃO Acessíveis 🔒

### Partição Windows (nvme0n1p3)
**Status:** Indisponível (BCD corrupted)
**Possíveis Localizações:**
- `C:\Users\<usuario>\Documents\nixos-config\`
- `C:\Users\<usuario>\Projects\dotfiles\`
- `C:\Users\<usuario>\Desktop\`

**Acesso Futuro:** Após instalar NixOS → montar read-only

### WSL Partitions
**Status:** Indisponíveis
**Possíveis Localizações:**
- Ubuntu WSL: `/home/<usuario>/.config/nixos/`
- NixOS WSL: `/etc/nixos/flake.nix`

**Localização WSL no Windows:**
- `C:\Users\<usuario>\AppData\Local\Packages\*\LocalState\rootfs\`

### Conversas claude.ai
**Status:** Sem acesso via Claude Code
**Alternativa:** Acesso manual necessário

## Conclusão

**Resultado:** ❌ Receita flake NixOS completa **não encontrada** em Termux/proot

**Próximos Passos:**

### Opção A: Instalar com configuration.nix básico + recuperar depois
1. ✅ Usar `NIXOS_INSTALL_GUIDE.txt` (já criado)
2. ✅ Instalar NixOS com configuration.nix básico
3. ⏳ Boot no NixOS
4. ⏳ Montar Windows partition (read-only)
5. ⏳ Buscar receita em:
   - Documentos Windows
   - WSL rootfs
6. ⏳ Converter para flake depois

### Opção B: Criar nova receita flake agora
**Baseado em:**
- Hardware: Gigabyte + Samsung NVMe + RTX 3080 Ti
- Requisitos: NVIDIA drivers proprietários, Fish shell
- Padrão: Flake modular com Home Manager

## Arquivos de Referência Encontrados

**Úteis para criar novo flake:**

1. **FLAKE_VALIDATION_GUIDE.md**
   - Estrutura básica de flake
   - Ferramentas de validação (statix, deadnix, nixpkgs-fmt)
   - Workflow completo

2. **claude-code-isolated.nix**
   - Exemplo de propagatedBuildInputs
   - Isolamento de dependências

3. **shell.nix**
   - Exemplo de mkShell
   - buildInputs organizados

## Recomendação

**Seguir Opção A:**
- Menos risco (receita original pode existir)
- Instalação mais rápida (configuration.nix pronto)
- Permite recuperar dados Windows primeiro
- Migração para flake pode ser feita posteriormente

**Cronograma:**
1. Instalar NixOS (hoje)
2. Recuperar arquivos Windows (imediato após boot)
3. Buscar receita flake original (após recuperação)
4. Se não encontrada → criar nova flake modular
