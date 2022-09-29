{ ... }:

{
  programs.lazygit = {
    enable = true;

    settings = {
      git = {
        paging = {
          colorArg = "always";
          pager = "delta --dark --paging=never";
        };
      };

      update = {
        method = "never";
      };
    };
  };
}
