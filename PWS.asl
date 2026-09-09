state("PowerWashSimulator") 
{
    int Completion: "GameAssembly.dll", 0x0440D1E8, 0xB8, 0x28, 0x20, 0x28, 0x148, 0x20, 0x30;
    float Credits: "GameAssembly.dll", 0x0440A2C8, 0xB8, 0x18, 0x68, 0x38, 0x20, 0x28;
    bool Loading: "GameAssembly.dll", 0x042FDA58, 0xB8, 0x0, 0xB0, 0x20, 0x60, 0x78, 0x30, 0x28, 0x3C;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    //Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
    //vars.Uhara.EnableDebug();

    settings.Add("Percentage", false, "Split on Percentage");
    settings.SetToolTip("Percentage", "This will split when the in game percentage reaches 100%\n" +
    "useful for individual level runs");
    settings.Add("Job", false, "Split on Job Change");
    settings.SetToolTip("Job", "This will split when entering the loading screen to any job\n" +
    "useful for career% or multilevel runs");
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        var GSM = mono["PWS", "GameStateManager", 1];

        var GJ = mono["PWS", "GameJob"];
        vars.Helper["CurrentJob"] = GSM.MakeString("s_instance", "m_currentGameJob", GJ["m_uniqueName"]);

        /*var SM = mono["PWS", "ScreenManager"];
        vars.Helper["LoadingProgress"] = GSM.Make<IntPtr>("s_instance", "m_screenManager", SM["m_currentScreen"]);*/
        vars.Helper["CurrentlyPlayingJob"] = GSM.Make<bool>("s_instance", "CurrentlyPlayingJob");
        vars.Helper["GameMode"] = GSM.Make<int>("s_instance", "m_gameMode");
        return true;
    });
    /*var Instance = vars.Uhara.CreateTool("Unity", "IL2CPP", "Instance");
    var Completion = Instance.Get("PWS:PWS:HUDGameJobCleanPercentageView", "m_previousCompletionTotal");
    var Credits = Instance.Get("PWS:PWS:PlayerCreditsView", "m_currentCredits");
    var Loading = Instance.Get("PWS:PWS:LoadingScreen", "m_visible");
    
    vars.Helper["Completion"] = vars.Helper.Make<int>(Completion.Base, Completion.Offsets);
    vars.Helper["Credits"] = vars.Helper.Make<float>(Credits.Base, Credits.Offsets);
    vars.Helper["Loading"] = vars.Helper.Make<bool>(Loading.Base, Loading.Offsets);
    print("How many offsets: " + Completion.Offsets.Length);
    for(int i = 0; i < Completion.Offsets.Length; i++)
    {m
        print("Completion base: " + Loading.Base.ToString("X") + " offsets: " + string.Join(", ", Loading.Offsets));
    }
    */
}

update
{
    //vars.Helper.Update();
    //vars.Helper.MapPointers();
}

start
{
    if (!old.CurrentlyPlayingJob && current.CurrentlyPlayingJob)
    {
        return true;
    }
}

split
{
    // split when the completion reaches 100%
    if (current.Completion == 100 && old.Completion != 100 && settings["Percentage"])
    {
        return true;
    }
    
    if(current.CurrentJob != old.CurrentJob && settings["Job"])
    {
        return true;
    }
}

isLoading
{
    return current.Loading || !current.CurrentlyPlayingJob;
}
