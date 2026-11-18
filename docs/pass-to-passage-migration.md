# pass → passage migration and old GPG commit validation

Repo signing is SSH-only (`modules/programs/git.nix:48`,
`modules/programs/jujutsu.nix:148`) and `passage` + `age` are the global
secret tooling (`modules/toplevel/secrets.nix:6-8`). Nothing below needs a
flake change — these are the user-owned runtime steps.

## pass → passage

If gpg/pass are already gone from PATH, bootstrap them for the migration
only:

    nix-shell -p pass gnupg

Generate the age identity:

    age-keygen >> ~/.passage/identities

Passphrase-protected variant — warning: a passphrase-protected identity
makes age prompt for the passphrase in the terminal on every use:

    KEY="$(age-keygen)"
    echo "$KEY" | age -p -a >> ~/.passage/identities
    echo "$KEY" | age-keygen -y >> ~/.passage/store/.age-recipients

Record the recipient (needed for both variants — with the plain identity
above, derive it from the identity file):

    age-keygen -y ~/.passage/identities >> ~/.passage/store/.age-recipients

Reinsert each entry, reading from pass show (loop per the passage README):

    cd "${PASSWORD_STORE_DIR:-$HOME/.password-store}"
    find . -path '*/.git' -prune -o -iname '*.gpg' -print0 |
      while IFS= read -r -d '' gpg_file; do
        name="${gpg_file#./}"; name="${name%.gpg}"
        [ -e "$HOME/.passage/store/$name.age" ] && continue
        pass show "$name" | passage insert -m "$name"
      done

Check every secretspec.toml for the pass provider — the repo tree has
none, but user-local configs (~/.config/secretspec.toml and per-project
copies) still need the check; switch any hit to passage:

    grep -r 'provider.*"pass"' ~/.config/secretspec.toml 2>/dev/null

## Post-migration checks

    passage show <entry>          # sample entries; plaintexts must match the old pass show output
    diff <(find ~/.password-store -name '*.gpg' -printf '%P\n' | sed 's/\.gpg$//' | sort) \
         <(find ~/.passage/store -name '*.age' -printf '%P\n' | sed 's/\.age$//' | sort)  # entry names carried over
