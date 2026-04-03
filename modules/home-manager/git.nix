# modules/home-manager/git.nix
{ variables, ... }: {
  programs.git = {
    enable = true;
    settings = {
      user.name          = variables.gitName;
      user.email         = variables.gitEmail;
      init.defaultBranch = "master";
      pull.rebase        = true;
    };
    includes = [
      {
        condition = "gitdir:~/zeustrack/";
        contents.user.email = variables.gitZeustrackEmail;
      }
    ];
  };
}
