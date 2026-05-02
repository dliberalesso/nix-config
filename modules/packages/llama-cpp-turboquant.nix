{
  perSystem =
    {
      pkgs,
      ...
    }:
    let
      llama-cpp = pkgs.llama-cpp.overrideAttrs (_oa: {
        pname = "llama-cpp-turboquant";
        version = "0";

        src = pkgs.fetchFromGitHub {
          owner = "ggml-org";
          repo = "llama.cpp";
          rev = "69d8e4be47243e83b3d0d71e932bc7aa61c644dc";

          # hash = lib.fakeHash;
          hash = "sha256-JuyuYmewKWwYbNjBVcIB1mmgEMHibAm+tHzU+8R9pFw=";

          leaveDotGit = true;
          postFetch = ''
            git -C "$out" rev-parse --short HEAD > $out/COMMIT
            find "$out" -name .git -print0 | xargs -0 rm -rf
          '';
        };

        # npmDepsHash = lib.fakeHash;
        npmDepsHash = "sha256-RAFtsbBGBjteCt5yXhrmHL39rIDJMCFBETgzId2eRRk=";
      });

      llama-cpp-vulkan = llama-cpp.override { vulkanSupport = true; };
    in
    {
      overlayAttrs = { inherit llama-cpp llama-cpp-vulkan; };

      packages = { inherit llama-cpp llama-cpp-vulkan; };
    };

  unify.modules.laptop.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        llama-cpp-vulkan
      ];
    };

  unify.modules.wsl.home =
    {
      pkgs,
      ...
    }:
    {
      home.packages = with pkgs; [
        llama-cpp
      ];
    };
}
