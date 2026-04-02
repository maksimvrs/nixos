# modules/home-manager/git.nix
{ variables, ... }: {
  programs.git = {
    enable    = true;
    userName  = variables.gitName;
    userEmail = variables.gitEmail;
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase        = true;
    };
  };
}
