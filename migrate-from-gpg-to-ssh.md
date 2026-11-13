Migre a assinatura de commits do Git e do Jujutsu de GPG para SSH neste repositório (nix-config), com uma chave por host, e remova o GPG da configuração, trocando o `pass` por `passage`.

## Problema

Commits assinados com GPG travam a interface de lazygit, jjui e agentes de terminal (pi, claude-code, codex) quando o gpg-agent pede a senha da chave. Em um shell comum funciona. Causa provável, não verificada: o pinentry (curses, o padrão) disputa o TTY com a TUI. Com ssh-agent a assinatura não pede senha: a chave é carregada uma vez por sessão e, se não estiver carregada, a assinatura falha na hora em vez de travar.

## Objetivo

- Assinar commits (git e jj) com chaves ed25519 SSH, uma por host, sem prompt de senha ao assinar.
- nixwsl: a chave privada fica só no ssh-agent do Windows, exposto ao WSL pelo módulo `wsl.ssh-agent` do NixOS-WSL.
- nixavell: a chave privada fica em um ssh-agent comum (`programs.ssh.startAgent`). O gpg-agent deixa de ser agente SSH.
- Remover o GPG da configuração (agent, pinentry, pacote) e substituir o `pass` por `passage` (age).

## Estado atual (já verificado no repo)

- `modules/programs/git.nix`: `signing = { format = "openpgp"; key = "EABBB5191B42D726"; signByDefault = true; }` (global, via `unify.home`)
- `modules/programs/jujutsu.nix`: `signing = { behavior = "keep"; backend = "gpg"; key = "EABBB5191B42D726"; }` e `git.sign-on-push = true` (o jj só assina no push)
- `modules/toplevel/secrets.nix` (GLOBAL, vale para nixavell, nixwsl e testvm): instala `pass` (ou `pass-wayland` se hyprland estiver ativo) e `secretspec`, e habilita `programs.gnupg.agent = { enable = true; enableSSHSupport = true; }`. Não há `pinentryPackage` configurado em lugar nenhum.
- `modules/toplevel/wsl.nix`: perfil `unify.modules.wsl.nixos`, com bloco `wsl`, `wslConf.interop.appendWindowsPath = false` e `automount.root = "/mnt"`
- `hosts/nixavell/nixavell.nix`: laptop nativo (módulos facter, gui, laptop, podman, niride, work), sem Windows
- `hosts/nixwsl/nixwsl.nix`: módulos podman e wsl
- `hosts/testvm/testvm.nix`: VM descartável, sem módulos gui/wsl; recebe as configs globais de git/jj
- `modules/meta/user.nix`: identidade centralizada (`email`, `name`, `username`), tipo `attrsOf str`
- `modules/services/openssh.nix`: sshd na 2222 do WSL (não relacionado, não tocar)
- `git.nix` usa `git-credential-libsecret` (não relacionado ao GPG, não tocar)

## Chaves públicas

- nixwsl: `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAHhLqJ4I7F3MPh+yv01+3AIlAhrMCuFm1kMi0DXYJNK jfrs\dli50@HP-BRJ514R324
` (gerada no Windows e adicionada por mim ao ssh-agent do Windows)
- nixavell: essa chave ainda não existe, pois não tenho acesso ao nixavell no momento
  São públicas, podem entrar no repo. Nenhuma privada entra.

## Mudanças (um commit lógico por item, nesta ordem)

1. Assinatura SSH por host. Descubra como o `unify` expõe dados do host aos módulos `unify.home` (hoje `hostConfig`; leia `.rpiv/guidance/hosts/architecture.md` e `.rpiv/guidance/modules/architecture.md`) e escolha o mecanismo que siga os padrões do repo, de modo que cada host use a sua chave em `signing.key`.
   - `git.nix`: `signing.format = "ssh"`, `signByDefault = true`, `key` = chave pública literal do host. Adicionar `settings.gpg.ssh.allowedSignersFile` apontando para um `allowed_signers` gerado pelo Nix em `${config.xdg.configHome}/git/allowed_signers`, com uma linha `<email> namespaces="git" <chave pública>` para cada host (as duas chaves).
   - `jujutsu.nix`: `signing.backend = "ssh"`, `key` = a chave do host, `signing.backends.ssh.allowed-signers` apontando para o mesmo arquivo. Manter `behavior = "keep"`, `sign-on-push = true` e `show-cryptographic-signatures`.
   - testvm não tem chave e precisa continuar avaliando e buildando. Provavelmente a assinatura já não funcionava lá; desabilitá-la nesse host é aceitável. Registre a decisão.
2. `wsl.nix` (perfil wsl): `wsl.ssh-agent.enable = true`.
3. Agente SSH no nixavell: `programs.ssh.startAgent = true`, no perfil gui (AGENTS.md diz que preocupações gráficas compartilhadas pertencem ao `gui`) ou onde o guia indicar. Não pode ir em módulo global: conflitaria com o `wsl.ssh-agent` no nixwsl. Não implementar carregamento automático da chave (askpass, gcr-ssh-agent etc.); o carregamento é um `ssh-add` manual por login. Se tiver uma sugestão, ponha no relatório final.
4. Remover o GPG de `secrets.nix`: apagar `programs.gnupg` inteiro e trocar `pass`/`pass-wayland` por `passage` (mais `age`, se o pacote não o trouxer). Verifique no nixpkgs que `passage` existe, como ele lida com a área de transferência no Wayland (o `pass-wayland` existe por causa do `wl-clipboard`) e se a lógica `waylandEnabled` ainda é necessária. Mantenha `secretspec`. Procure no repo inteiro qualquer outra referência a gpg, gnupg e pinentry e remova.
5. Atualizar `.rpiv/guidance/modules/toplevel/architecture.md` (cita "GPG agent with SSH support") e qualquer outro guia que mencione GPG, `pass` ou assinatura, descrevendo o desenho por host.

## Pontos a verificar antes de escrever (não assuma)

- Como o pacote `wsl2-ssh-agent` do nixpkgs chega ao agente do Windows. Pelo README, ele sobe um servidor de socket Unix e executa `PowerShell.exe` via interop do WSL para repassar o tráfego ao named pipe do `ssh-agent.exe`. Risco: o serviço systemd de usuário tem PATH mínimo, e `appendWindowsPath = false` tira o diretório do PowerShell do PATH. Leia a derivação para ver se o `PowerShell.exe` é encontrado. Se não for, adicione `/mnt/c/Windows/System32/WindowsPowerShell/v1.0` apenas ao PATH do serviço `wsl2-ssh-agent`, sem mexer no PATH global, e justifique.
- O backend SSH do jj chama `ssh-keygen -Y sign -n git -f <chave>` sem `-U`; uma chave pública literal funciona com agente. Confirme que `signing.backends.ssh.program` resolve para `ssh-keygen`.
- O git aceita chave pública literal em `user.signingKey` (com ou sem o prefixo `key::`). Se falhar, a alternativa é gerar um `.pub` via `home.file` e apontar `key` para ele.
- `programs.ssh.startAgent` e `wsl.ssh-agent` definem `SSH_AUTH_SOCK`; confirme que nenhum host recebe os dois.

## Restrições

- Seguir o `AGENTS.md` e os guias em `.rpiv/guidance/`. Comentários mínimos, `inherit` onde fizer sentido, indentação de 2 espaços.
- Rodar `just fmt` e `just lint`. Validar as builds sem trocar de geração, para nixwsl, nixavell e testvm (por exemplo `nix build .#nixosConfigurations.<host>.config.system.build.toplevel --dry-run`, ou `nh os build`). Não rodar `just rebuild` nem `switch`; o switch é meu.
- VCS é Jujutsu. Commits seguem Conventional Commits + Gitmoji, sem escopo (ex.: `🔐 feat: ...`).
- Não fazer push nem abrir PR.
- Não ler, copiar nem tocar em segredos: nada de `~/.password-store`, `~/.gnupg`, `~/.ssh` ou `~/.passage`. Nenhuma chave privada, senha ou segredo no repo (o pre-commit usa gitleaks). A migração do `pass` para o `passage` é minha; você só descreve os passos.

## Critérios de aceite

- `just fmt` sem diff pendente, `just lint` passa, e as builds de nixwsl, nixavell e testvm passam.
- Nenhum host tem gnupg agent; nenhuma referência a gpg/gnupg/pinentry/`pass` sobra no repo (exceto a documentação histórica, se houver).
- nixwsl usa `wsl.ssh-agent`; nixavell usa `programs.ssh.startAgent`; nenhum host tem dois agentes.
- git e jj usam a chave do próprio host; o `allowed_signers` contém as duas chaves.
- A documentação em `.rpiv/guidance/` reflete o desenho.

## Ao terminar

Relate as decisões tomadas (mecanismo da chave por host, tratamento do testvm, solução do PATH do PowerShell se foi necessária, detalhes do passage no Wayland). Depois imprima, nesta ordem:

A. Migração do pass para o passage, a fazer ANTES do switch (o gpg só desaparece depois dele; se já tiver sumido, use `nix shell nixpkgs#pass nixpkgs#gnupg`). Descreva os passos, verificando os comandos contra o README do passage: gerar a identidade age (`age-keygen`), gravar o recipient em `~/.passage/store/.age-recipients`, e reinserir cada entrada lendo do `pass show`. Avise que uma identidade protegida por senha faz o `age` pedir a senha no terminal. Lembre também de checar se algum `secretspec.toml` meu usa o provedor `pass`.

B. Checklist nixwsl, após o switch:

1. `echo $SSH_AUTH_SOCK` aponta para `$XDG_RUNTIME_DIR/wsl2-ssh-agent.sock`, e `ssh-add -L` lista a chave.
2. `systemctl --user status wsl2-ssh-agent` ativo, sem erros no `journalctl --user -u wsl2-ssh-agent`.
3. Em repositório de teste: `git commit` assinado e `git verify-commit HEAD` válido; assinatura pelo jj (`jj sign` ou push de teste em branch descartável) e conferência em `jj show`/`jj log`.
4. Repetir o commit assinado de dentro do lazygit, do jjui e do pi, sem prompt de senha.

C. Checklist nixavell, após o switch:

1. `echo $SSH_AUTH_SOCK` aponta para o socket do ssh-agent; `ssh-add ~/.ssh/<chave de assinatura>` (senha digitada uma vez) e `ssh-add -L` lista a chave.
2. Commit assinado no git e no jj, verificação válida, inclusive de dentro do lazygit, jjui e pi.
3. `passage` funcionando com as entradas migradas.

D. No GitHub, ambas as chaves cadastradas como Signing Key (Settings → SSH and GPG keys). Commits antigos assinados com GPG continuam Verified enquanto a chave GPG estiver na conta; localmente aparecerão como desconhecidos sem o gpg.
