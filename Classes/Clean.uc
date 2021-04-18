class Clean extends Commandlet;


event int Main(string Parms)
{
  class'Utility'.static.EditPackages(Parms, true);

  // this can be used for error handling
  // but right now its used to avoid compiler errors
  return 0;
}


defaultproperties
{
  HelpCmd="Restores vanilla EditPackages"
  HelpWebLink="https://github.com/InsultingPros/KFCmdlet"
  HelpUsage="run UCC.exe KFCmdlet.Clean"
}