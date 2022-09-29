{ ... }:

{
  programs.bat = {
    enable = true;

    config = {
      color = "always";
      pager = "less";
    };
  };
}
