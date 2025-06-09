{
  hm,
  ...
}:
hm {
  programs.eza = {
    enable = true;

    colors = "auto";
    icons = "auto";

    extraOptions = [ "--group-directories-first" ];
  };
}
