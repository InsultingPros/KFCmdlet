class Utility extends Object;


// vanilla EditPackages, used both for cleanup and addition
var array<string> defpack;


final static function EditPackages(string input, bool clean)
{
  local int i;
  local array<string> wordsArray;

  // restore default EditPackages to avoid duplicates and empty lines
  class'EditorEngine'.default.EditPackages.Length = 0;
  class'EditorEngine'.default.EditPackages = default.defpack;

  if (!clean)
  {
    // fill the string array
    // divider is comma
    split(input, ",", wordsArray);

    for (i = 0; i < wordsArray.Length; ++i)
    {
      log("> KFCmdlet: Adding " $ wordsArray[i] $ " to `EditPackages`"); 
      class'EditorEngine'.default.EditPackages[class'EditorEngine'.default.EditPackages.Length] = wordsArray[i];
    }
  }

  // save it
  class'EditorEngine'.static.StaticSaveConfig();
}


defaultproperties
{
  defpack(0)="Core"
  defpack(1)="Engine"
  defpack(2)="Fire"
  defpack(3)="Editor"
  defpack(4)="UnrealEd"
  defpack(5)="IpDrv"
  defpack(6)="UWeb"
  defpack(7)="GamePlay"
  defpack(8)="UnrealGame"
  defpack(9)="XGame"
  defpack(10)="XInterface"
  defpack(11)="XAdmin"
  defpack(12)="XWebAdmin"
  defpack(13)="GUI2K4"
  defpack(14)="xVoting"
  defpack(15)="UTV2004c"
  defpack(16)="UTV2004s"
  defpack(17)="ROEffects"
  defpack(18)="ROEngine"
  defpack(19)="ROInterface"
  defpack(20)="Old2k4"
  defpack(21)="KFMod"
  defpack(22)="KFChar"
  defpack(23)="KFGui"
  defpack(24)="GoodKarma"
  defpack(25)="KFMutators"
  defpack(26)="KFStoryGame"
  defpack(27)="KFStoryUI"
  defpack(28)="SideShowScript"
  defpack(29)="FrightScript"
}