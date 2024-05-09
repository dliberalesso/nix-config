{...}: {
  programs.git = {
    enable = true;

    userName = "Douglas Liberalesso";
    userEmail = "dliberalesso@gmail.com";

    extraConfig = {
      init.defaultBranch = "main";
      url."https://github.com/".insteadOf = "git://github.com/";
    };

    lfs.enable = true;

    ignores = [".direnv" "result"];
  };
}
