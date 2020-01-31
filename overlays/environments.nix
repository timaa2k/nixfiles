self: super: {

  awsEnv = self.buildEnv {
    name = "aws";
    paths = with self; [
      awscli
      awslogs
      terraform
      kubectl
    ];
  };

  nodeEnv = self.buildEnv {
    name = "node";
    paths = with self; [
      nodejs
      yarn
      nodePackages.prettier
    ];
  };
    
  pythonEnv = (self.python36.withPackages(ps: with ps; [
    virtualenvwrapper
  ]));
}
