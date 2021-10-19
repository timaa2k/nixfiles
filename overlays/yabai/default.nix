self: super:
{
  yabai = super.yabai.overrideAttrs (old: rec {
    pname = "yabai";
    version = "3.3.10";
    src = self.fetchFromGitHub {
      owner = "koekeishiya";
      repo = pname;
      rev = "v${version}";
      sha256 = "1gd88s3a05qvvyjhk5wpw1crb7p1gik1gdxn7pv2vq1x7zyvzvph";
    };
  });
}
