{
  perSystem =
    {
      pkgs,
      ...
    }:
    let
      lazymoji = pkgs.writeShellApplication {
        name = "lazymoji";

        runtimeInputs = builtins.attrValues {
          inherit (pkgs) git gum;
        };

        text = ''
          export GUM_CHOOSE_CURSOR_FOREGROUND=3
          export GUM_CHOOSE_HEADER_FOREGROUND=6
          export GUM_CHOOSE_ITEM_FOREGROUND=7
          export GUM_CHOOSE_SELECTED_FOREGROUND=4

          export GUM_INPUT_PROMPT_FOREGROUND=7
          export GUM_INPUT_PLACEHOLDER_FOREGROUND=15
          export GUM_INPUT_CURSOR_FOREGROUND=3
          export GUM_INPUT_HEADER_FOREGROUND=6

          TYPE=$(gum choose --header="Choose a commit type:" \
            "feat: A new feature for the user" \
            "fix: A bug fix for the user" \
            "docs: Documentation only changes" \
            "style: Changes that do not affect the meaning of the code" \
            "refactor: A code change that neither fixes a bug nor adds a feature" \
            "perf: A code change that improves performance" \
            "test: Adding missing tests or correcting existing ones" \
            "build: Changes that affect the build system or external dependencies" \
            "ci: Changes to our CI configuration files and scripts" \
            "chore: Other changes that don't modify src or test files" \
            "revert: Reverts a previous commit" \
          )

          TYPE=''${TYPE%%:*}

          BREAKING_CHANGE=$(gum choose --header "Is it a breaking change?" "Yes!" || echo "")

          EMOJI=""

          if [ "''${BREAKING_CHANGE}" == "Yes!" ]; then
            BREAKING_CHANGE="!"
            EMOJI="💥"
          else
            case $TYPE in
              "feat")
                EMOJI=$(gum choose --header="Choose a subtype:" \
                  "✨ Introduce new features" \
                  "🎉 Begin a project" \
                  "🚀 Deploy stuff" \
                  "📈 Add or update analytics or track code" \
                  "🌐 Internationalization and localization" \
                  "♿️ Improve accessibility" \
                  "🚸 Improve user experience / usability" \
                  "🏗️ Make architectural changes" \
                  "📱 Work on responsive design" \
                  "🥚 Add or update an easter egg" \
                  "🚩 Add, update, or remove feature flags" \
                  "💫 Add or update animations and transitions" \
                  "💸 Add sponsorships or money related infrastructure" \
                )
                ;;
              "fix")
                EMOJI=$(gum choose --header="Choose a subtype:" \
                  "🐛 Fix a bug" \
                  "🚑 Critical hotfix" \
                  "🔒 Fix security or privacy issues" \
                  "🥅 Catch errors" \
                  "🩹 Simple fix for a non-critical issue" \
                  "🧐 Data exploration/inspection" \
                  "🦺 Add or update code related to validation" \
                )
                ;;
              "docs")
                EMOJI=$(gum choose --header="Choose a subtype:" \
                  "📝 Add or update documentation" \
                  "💡 Add or update comments in source code" \
                  "📄 Add or update license" \
                )
                ;;
              "style")
                EMOJI=$(gum choose --header="Choose a subtype:" \
                  "🎨 Improve structure / format of the code" \
                  "💄 Add or update the UI and style files" \
                  "💬 Add or update text and literals" \
                  "🍱 Add or update assets" \
                )
                ;;
              "refactor")
                EMOJI=$(gum choose --header="Choose a subtype:" \
                  "♻️ Refactor code" \
                  "🚚 Move or rename resources (e.g., files, paths, routes)" \
                  "⚰️ Remove dead code" \
                  "🗑️ Deprecate code that needs to be cleaned up" \
                )
                ;;
              "perf")
                EMOJI=$(gum choose --header="Choose a subtype:" \
                  "⚡️ Improve performance" \
                  "🔍 Improve SEO" \
                )
                ;;
              "test")
                EMOJI=$(gum choose --header="Choose a subtype:" \
                  "✅ Add, update, or pass tests" \
                  "🧪 Add a failing test" \
                  "📸 Add or update snapshots" \
                  "🤡 Mock things" \
                )
                ;;
              "build")
                EMOJI=$(gum choose --header="Choose a subtype:" \
                  "📦 Add or update compiled files or packages" \
                  "➕ Add a dependency" \
                  "➖ Remove a dependency" \
                  "⬆️ Upgrade dependencies" \
                  "⬇️ Downgrade dependencies" \
                  "📌 Pin dependencies to specific versions" \
                  "🧱 Infrastructure related changes" \
                )
                ;;
              "ci")
                EMOJI=$(gum choose --header="Choose a subtype:" \
                  "👷 Add or update CI build system" \
                  "💚 Fix CI Build" \
                )
                ;;
              "chore")
                EMOJI=$(gum choose --header="Choose a subtype:" \
                  "🔧 Add or update configuration files" \
                  "🔨 Add or update development scripts" \
                  "✏️ Fix typos" \
                  "💩 Write bad code that needs to be improved" \
                  "👽 Update code due to external API changes" \
                  "🗃️ Perform database related changes" \
                  "🔊 Add or update logs" \
                  "🔇 Remove logs" \
                  "👥 Add or update contributor(s)" \
                  "🙈 Add or update a .gitignore file" \
                  "⚗️ Perform experiments" \
                  "🌱 Add or update seed files" \
                  "🏷️ Add or update types" \
                  "🛂 Work on code related to authorization, roles, and permissions" \
                  "👔 Add or update business logic" \
                  "🩺 Add or update healthcheck" \
                  "🧑‍💻 Improve developer experience" \
                  "🧵 Add or update code related to multithreading or concurrency" \
                )
                ;;
              "revert")
                EMOJI="⏪"
                ;;
            esac

            EMOJI=''${EMOJI%% *}
          fi

          MESSAGE="''${EMOJI} ''${TYPE}''${BREAKING_CHANGE:+''$BREAKING_CHANGE}: "

          getopts "l" OPT || echo "''${MESSAGE}$(gum input --width 50 --placeholder 'Summary of changes')"

          if [ "''${OPT}" == "l" ]; then
            echo "''${MESSAGE}"  > "$(git rev-parse --git-dir)/LAZYGIT_PENDING_COMMIT"
          fi
        '';
      };
    in
    {
      nixpkgs.overlays = [
        (_: _: { inherit lazymoji; })
      ];

      packages = { inherit lazymoji; };
    };
}
