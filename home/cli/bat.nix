{ config, ... }:

{
  programs.bat = {
    enable = true;

    config = {
      color = "always";
      pager = "less";
      theme = config.theme.name;
    };
  };
}
