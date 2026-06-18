state("PowerWash Simulator 2") {}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    Assembly.Load(File.ReadAllBytes("Components/uhara10")).CreateInstance("Main");
    vars.Uhara.EnableDebug();

    //set text taken from Poppy Playtime C2
    Action<string, string> SetTextComponent = (id, text) => {
        var textSettings = timer.Layout.Components.Where(x => x.GetType().Name == "TextComponent").Select(x => x.GetType().GetProperty("Settings").GetValue(x, null));
        var textSetting = textSettings.FirstOrDefault(x => (x.GetType().GetProperty("Text1").GetValue(x, null) as string) == id);
        if (textSetting == null)
        {
            var textComponentAssembly = Assembly.LoadFrom("Components\\LiveSplit.Text.dll");
            var textComponent = Activator.CreateInstance(textComponentAssembly.GetType("LiveSplit.UI.Components.TextComponent"), timer);
            timer.Layout.LayoutComponents.Add(new LiveSplit.UI.Components.LayoutComponent("LiveSplit.Text.dll", textComponent as LiveSplit.UI.Components.IComponent));

            textSetting = textComponent.GetType().GetProperty("Settings", BindingFlags.Instance | BindingFlags.Public).GetValue(textComponent, null);
            textSetting.GetType().GetProperty("Text1").SetValue(textSetting, id);
        }

        if (textSetting != null)
            textSetting.GetType().GetProperty("Text2").SetValue(textSetting, text);
    };
    vars.SetTextComponent = SetTextComponent;
}

init
{
    var Instance = vars.Uhara.CreateTool("Unity", "IL2CPP", "Instance");
    var completion = Instance.Get("FuturLab.PW2.UI:FuturLab.PW2:GameplayScreen", "m_previousProgress");
    var completion2 = Instance.Get("FuturLab.PW2:FuturLab.PW2.Telemetry:LevelProgressionSender", "m_currentPercentage");
    var loadingFloat = Instance.Get("FuturLab.PW2.UI:FuturLab.PW2.UI:LoadingScreenWidget", "m_progress");

    vars.Helper["ItemCompletion"] = vars.Helper.Make<float>(completion.Base, completion.Offsets);
    vars.Helper["TotalCompletion"] = vars.Helper.Make<int>(completion2.Base, completion2.Offsets);
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