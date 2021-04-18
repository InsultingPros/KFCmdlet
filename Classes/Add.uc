class Add extends Commandlet;


event int Main(string Parms)
{
  class'Utility'.static.EditPackages(Parms, false);

  // this can be used for error handling
  // but right now its used to avoid compiler errors
  return 0;
}


defaultproperties
{
  HelpCmd="Adds your package array to EditPackages"
  HelpWebLink="https://github.com/InsultingPros/KFCmdlet"
  HelpUsage="run UCC.exe KFCmdlet.Add package_1,package_2,package_3,etc"
}