self: super:
{
  yabai = super.yabai.overrideAttrs (old: rec {
    pname = "yabai";
    version = "3.2.1";
    src = self.fetchFromGitHub {
      owner = "koekeishiya";
      repo = pname;
      rev = "v${version}";
      sha256 = "11rsi6z2z7ynfqs1xq3bvf187k5xnwm0d45a8ai9hrqdsf3f1j19";
    };
  });
}
