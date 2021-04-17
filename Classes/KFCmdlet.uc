class KFCmdlet Extends Commandlet;
 
 
event int Main(string Parms)
{
  local bool bAdd;
  local string PackageName;
  local int i;
 
  Log(Parms, Name);
  bAdd = Left(Parms, 1) == "1";
  PackageName = Mid(Parms, 2);
  if (bAdd)
  {
    Log( "Adding" @ PackageName, Name );
    class'EditorEngine'.Default.EditPackages[class'EditorEngine'.Default.EditPackages.Length] = PackageName;
    class'EditorEngine'.Static.StaticSaveConfig();
  }
  else
  {
    Log("Removing" @ PackageName, Name);
    for (i = 0; i < class'EditorEngine'.Default.EditPackages.Length; ++ i)
    {
      if (class'EditorEngine'.Default.EditPackages[i] ~= PackageName)
      {
        class'EditorEngine'.Default.EditPackages.Remove( i, 1 );
        break;
      }
    }
    class'EditorEngine'.Static.StaticSaveConfig();
  }
}


defaultproperties{}