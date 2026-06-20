state("PowerWash Simulator 2") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
    vars.Uhara.EnableDebug();
}

init
{
    var Instance = vars.Uhara.CreateTool("Unity", "IL2CPP", "Instance");
    var levelcompletion = Instance.Get("FuturLab.PW2:FuturLab.PW2.Telemetry:LevelProgressionSender", "m_currentPercentage");
    var loadingFloat = Instance.Get("FuturLab.PW2.UI:FuturLab.PW2.UI:LoadingScreenWidget", "m_progress");

    vars.Helper["TotalCompletion"] = vars.Helper.Make<int>(levelcompletion.Base, levelcompletion.Offsets);
    vars.Helper["LoadingFloat"] = vars.Helper.Make<float>(loadingFloat.Base, loadingFloat.Offsets);

}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();
}

start
{
    if (current.LoadingFloat == 1 && old.LoadingFloat < 1)
        return true;   
}

split
{
    if (current.TotalCompletion == 100 && old.TotalCompletion != 100)
        return true;
}

isLoading
{
    if (current.LoadingFloat < 1 && current.LoadingFloat != 0)
        return true;
    else
        return false;
}
