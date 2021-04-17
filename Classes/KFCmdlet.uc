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
    class'EditorEngine'.default.EditPackages[class'EditorEngine'.default.EditPackages.Length] = PackageName;
    class'EditorEngine'.static.StaticSaveConfig();
  }
  else
  {
    Log("Removing" @ PackageName, Name);
    for (i = 0; i < class'EditorEngine'.default.EditPackages.Length; ++ i)
    {
      if (class'EditorEngine'.default.EditPackages[i] ~= PackageName)
      {
        class'EditorEngine'.default.EditPackages.Remove( i, 1 );
        break;
      }
    }
    class'EditorEngine'.static.StaticSaveConfig();
  }

  // this can be used for error handling
  // but right now its used to avoid compiler errors
  return 0;
}


defaultproperties{}