/*
Lies of P Autosplitter + Load Remover
Made by CactusDuper with help from: Mysterion, TheDementedSalad and diggity
CactusDuper: @CactusDuper on Discord. All pointers for splits/load removal
Mysterion: @mysterion352 on Discord. Help with ASL creation
TheDementedSalad: @thedementedsalad on Discord. Help with ASL creation
Diggity: @diggitydingdong on Discord. Help with ASL creation

https://www.speedrun.com/lies_of_p

Last updated: 10/05/23

Currently steam only
*/

state("LOP-Win64-Shipping", "1.2.0.0")
{
    bool bPlayInputLock					: 0x71E7EB0, 0x110; // 1 when loading
byte menuBuffer						: 0x71E7EB0, 0x80; // 1 when loading
    bool levelLoad					: 0x71E7EE0, 0xb4; // 0 when not in level, !0 when level is loaded (main menu to game, not for use during other loading screens)
    long QuestsData					: 0x729BBC8, 0xD28, 0x38, 0x0, 0x30, 0x220, 0xDB8, 0x4E0; // Used for checking quests
    int introStart					: 0x729BBC8, 0xD28, 0x38, 0x0, 0x30, 0x220, 0xDB8, 0x4F0, 0x8; // Good pointer for when the game actually starts
    string128 TransitionDescription			: 0x729BBC8, 0x8B0, 0x0; // level/zone name
    int propShapeArraySize				: 0x71E7E98, 0x418;
    long propShapeArray					: 0x71E7E98, 0x410;
    long AsyncLoadingWidget				: 0x71E7EB8, 0x1d0;
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.Settings.CreateFromXml("Components/LoP.Settings.xml");
}

init
{
	vars.completedSplits = new HashSet<string>();
	vars.exSplits = new bool[50];
	
    // this function is a helper for checking splits that may or may not exist in settings,
    // and if we want to do them only once
    vars.CheckSplit = (Func<string, bool>)(key =>
    {
        // if the split doesn't exist, or it's off, or we've done it already
        if (!settings.ContainsKey(key) || !settings[key] || vars.completedSplits.Contains(key))
        {
            return false;
        }

        vars.completedSplits.Add(key);
        vars.Log("Completed: " + key);
        return true;
    });

    string md5 = "";
    md5 = (string)vars.Helper.GetMD5Hash();

    switch (md5)
    {
        case "355661BF57D607C65564EE818CDDFB7B":
            version = "1.2.0.0";
			vars.itemInfo = 0x72B01A8;
            break;
        default:
            print("Unknown version detected");
            return false;
    }

	current.itemsInfo = new string[100].Select((_, i) => {
	StringBuilder sb = new StringBuilder(300);
	IntPtr ptr;
	new DeepPointer(vars.itemInfo, 0x188, 0x180, 0x1A0, 0x0 + (i * 8), 0x38, 0x30, 0x34).DerefOffsets(memory, out ptr);
	memory.ReadString(ptr, sb);
	return sb.ToString();
	}).ToArray();
}

onStart
{
    vars.completedSplits.Clear();
	vars.exSplits = new bool[50];
}

start
{
    if (current.TransitionDescription == "/Game/MapRelease/LV_Zone_S/LV_Zone_S_P" && current.bPlayInputLock == false && current.menuBuffer != 3)
    {
        vars.resetFunction = 0;

        // print(current.TransitionDescription);
        return true;
    }
}

update
{
	if (timer.CurrentPhase == TimerPhase.NotRunning){ 
		vars.completedSplits.Clear();
		vars.exSplits = new bool[50];
	}
	
	current.itemsInfo = new string[100].Select((_, i) => {
	StringBuilder sb = new StringBuilder(300);
	IntPtr ptr;
	new DeepPointer(vars.itemInfo, 0x188, 0x180, 0x1A0, 0x0 + (i * 8), 0x38, 0x30, 0x34).DerefOffsets(memory, out ptr);
	memory.ReadString(ptr, sb);
	return sb.ToString();
	}).ToArray();
}

split
{
	string[] currentitemsInfo = (current.itemsInfo as string[]);
	string[] olditemsInfo = (old.itemsInfo as string[]); // throws error first update, will be fine afterwards.
	
	var removedItems = olditemsInfo.Except(currentitemsInfo);
	
	if(settings["Survive"] && removedItems.Contains("_Mask_Stalker_Survivor_local_text_item_name-korean") && !vars.exSplits[3])	{return vars.exSplits[3]  = true;}
	
	
    for (var i = 0; i < 243; i++)
    {
        var questState = vars.Helper.Read<byte>((IntPtr)(current.QuestsData + i * 0x18 + 0x8));
        var key = "quest_" + i;

        if (questState == 0x2)
        {

            if (vars.CheckSplit(key))
            {
                return true;
            }
        }
    }
}

isLoading
{
    if (current.TransitionDescription == "/Game/Map/Title2_P" || current.TransitionDescription == "/Game/Map/Title3_P" || current.TransitionDescription == "/Game/Map/Title_P" || current.TransitionDescription == "/Game/Map/Loading_P" || current.AsyncLoadingWidget != 0xFFFFFFFF ||
		current.menuBuffer == 3 || current.menuBuffer == 2)
    {
        return true;
    }
    else
    {
        return false;
    }
}

reset
{
    // check gameStartType + isStarted?
}
