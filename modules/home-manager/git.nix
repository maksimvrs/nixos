# modules/home-manager/git.nix
{ variables, ... }: {
  programs.git = {
    enable    = true;
    userName  = variables.gitName;
    userEmail = variables.gitEmail;
    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase        = true;
    };
    includes = [
      {
        condition = "gitdir:~/zeustrack/";
        contents.user.email = variables.gitWorkEmail;
      }
    ];
  };
}
