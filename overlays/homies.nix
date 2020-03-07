self: super:

let
  homies = import ./../homies/packages.nix;
in
{
  neovim = homies.neovim;
  tmux = homies.tmux;
}
