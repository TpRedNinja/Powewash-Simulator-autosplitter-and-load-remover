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
    var loading = Instance.Get("FuturLab.PW2.UI:FuturLab.PW2.UI:LoadingScreen", "m_visible");

    vars.Helper["TotalCompletion"] = vars.Helper.Make<int>(levelcompletion.Base, levelcompletion.Offsets);
    vars.Helper["Loading"] = vars.Helper.Make<bool>(loading.Base, loading.Offsets);

}

update
{
    vars.Helper.Update();
    vars.Helper.MapPointers();
}

start
{
    if (!current.Loading && old.Loading)
        return true;   
}

split
{
    if (current.TotalCompletion == 100 && old.TotalCompletion != 100)
        return true;
}

isLoading
{
    if (current.Loading)
        return true;
    else
        return false;
}
