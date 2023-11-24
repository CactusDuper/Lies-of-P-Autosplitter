/*
Lies of P Autosplitter + Load Remover
Made by CactusDuper with help from: Mysterion, TheDementedSalad and diggity
CactusDuper: @CactusDuper on Discord. All pointers for splits/load removal
Mysterion: @mysterion352 on Discord. Help with ASL creation
TheDementedSalad: @thedementedsalad on Discord. Autosplit logic for items and testing, all splits
Diggity: @diggitydingdong on Discord. Autosplit logic for quest arrary

https://www.speedrun.com/lies_of_p

Last updated: 24 Nov 2023

*/

state("LOP-Win64-Shipping", "1.3.0.0 Steam")
{
	float X							: 0x071CBEB0, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x250;
	float Y							: 0x071CBEB0, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x258;
	float Z							: 0x071CBEB0, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x254;
	byte menuBuffer						: 0x07204770, 0x80;
	bool bPlayInputLock					: 0x07204770, 0x110; // 1 when loading
	long AsyncLoadingWidget					: 0x07204778, 0x1D0;
	long QuestsData						: 0x072B8528, 0xD28, 0x38, 0x0, 0x30, 0x220, 0xDC8, 0x4E0; // Used for checking quests
	string128 TransitionDescription				: 0x072B8528, 0x8B0, 0x0; // level/zone name
}

state("LOP-Win64-Shipping", "1.2.0.0 Steam")
{
	float X								: 0x71AF5E8, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x250;
	float Y								: 0x71AF5E8, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x258;
	float Z								: 0x71AF5E8, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x254; 
	byte menuBuffer						: 0x71E7EB0, 0x80;
    bool bPlayInputLock					: 0x71E7EB0, 0x110; // 1 when loading
	long AsyncLoadingWidget				: 0x71E7EB8, 0x1D0;
    long QuestsData						: 0x729BBC8, 0xD28, 0x38, 0x0, 0x30, 0x220, 0xDB8, 0x4E0; // Used for checking quests
    string128 TransitionDescription		: 0x729BBC8, 0x8B0, 0x0; // level/zone name
}

state("LOP-WinGDK-Shipping", "1.2.0.0 Xbox")
{
	float X								: 0x69BFB78, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x250;
	float Y								: 0x69BFB78, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x258;
	float Z								: 0x69BFB78, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x254;
	byte menuBuffer						: 0x69F4680, 0x80;
    bool bPlayInputLock					: 0x69F4680, 0x110; // 1 when loading
	long AsyncLoadingWidget				: 0x69F4678, 0x1D0;
    long QuestsData						: 0x6AA3640, 0xD28, 0x38, 0x0, 0x30, 0x220, 0xDB8, 0x4E0; // Used for checking quests
	string128 TransitionDescription		: 0x6AA3640, 0x8B0, 0x0; // level/zone name
}

startup
{
    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
    vars.Helper.Settings.CreateFromXml("Components/LoP.Settings.xml");
}

init
{
	vars.completedSplits = new HashSet<string>();
	vars.XYZSplits = new bool[27];
	
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
    try {
        md5 = (string)vars.Helper.GetMD5Hash();
    } catch {
        // Failed to open file for MD5 computation.
    }
	
	switch (md5) {
			case "355661BF57D607C65564EE818CDDFB7B":
            version = "1.2.0.0 Steam";
			vars.itemInfo = 0x72B01A8;
            break;
        default:
            // No version found with hash, fallback to memorySize
            switch ((int)vars.Helper.GetMemorySize()) {
			case (410910720):
				version = "1.2.0.0 Xbox";
				vars.itemInfo = 0x6AB87D8;
				break;
		}
        break;
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
	vars.XYZSplits = new bool[27];
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
		vars.XYZSplits = new bool[27];
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
	if (!currentitemsInfo.SequenceEqual(olditemsInfo)){
		string[] delta = (currentitemsInfo as string[]).Where((v, i) => v != olditemsInfo[i]).ToArray();
		
		foreach (string item in delta){
			if (!vars.completedSplits.Contains(item)){
				vars.completedSplits.Add(item);
				return settings[item];
			}
		}
	}
	
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
	
	if(settings["Isa"] && current.X > 27500f && current.X < 27700f && current.Y > 7670f && current.Y < 7690f && current.Z > 10300f && current.Z < 10500f && !vars.XYZSplits[0]) {return vars.XYZSplits[0]  = true;}
	if(settings["Grand"] && current.X > 56594f && current.X < 56610f && current.Y > 8055f && current.Y < 8065f && current.Z > 65207f && current.Z < 65223f && !vars.XYZSplits[1]) {return vars.XYZSplits[1]  = true;}
	if(settings["Barr"] && current.X > 56700f && current.X < 56900f && current.Y > 8265f && current.Y < 8275f && current.Z > 76000f && current.Z < 76200f && !vars.XYZSplits[2]) {return vars.XYZSplits[2]  = true;}
	if(settings["Alch"] && current.X > 7600f && current.X < 7800f && current.Y > 850f && current.Y < 900f && current.Z > 119000f && current.Z < 120000f && !vars.XYZSplits[3]) {return vars.XYZSplits[3]  = true;}
	if(settings["ArchI"] && current.X > 4060f && current.X < 4200f && current.Y > 41713f && current.Y < 41733f && current.Z > -4940f && current.Z < -4800f && !vars.XYZSplits[4]) {return vars.XYZSplits[4]  = true;}
	if(settings["Outer"] && current.X > 10192f && current.X < 10193f && current.Y > 4915f && current.Y < 4925f && current.Z > 47704f && current.Z < 47708f && !vars.XYZSplits[5]) {return vars.XYZSplits[5]  = true;}
	if(settings["Elys"] && current.X > 21240f && current.X < 21250f && current.Y > 6830f && current.Y < 6850f && current.Z > 7780f && current.Z < 7800f && !vars.XYZSplits[6]) {return vars.XYZSplits[6]  = true;}
	if(settings["Work"] && current.X > 47750f && current.X < 47800f && current.Y > 7790f && current.Y < 7800f && current.Z > -45000f && current.Z < -44600f && !vars.XYZSplits[7]) {return vars.XYZSplits[7]  = true;}
	if(settings["Veni"] && current.X > 56250f && current.X < 56270f && current.Y > 8147f && current.Y < 8157f && current.Z > -36750f && current.Z < -36500f && !vars.XYZSplits[8]) {return vars.XYZSplits[8]  = true;}
	if(settings["Moon"] && current.X > 46600f && current.X < 46920f && current.Y > 3250f && current.Y < 3450f && current.Z > -52350f && current.Z < -51900f && !vars.XYZSplits[9]) {return vars.XYZSplits[9]  = true;}
	if(settings["Path"] && current.X > 56750f && current.X < 56850f && current.Y > 18110f && current.Y < 18120f && current.Z > -70000f && current.Z < -69500f && !vars.XYZSplits[10]) {return vars.XYZSplits[10]  = true;}
	if(settings["Chap"] && current.X > 26660f && current.X < 26845f && current.Y > 19843f && current.Y < 19853f && current.Z > -63720f && current.Z < -63385f && !vars.XYZSplits[11]) {return vars.XYZSplits[11]  = true;}
	if(settings["Lib"] && current.X > 20250f && current.X < 20550f && current.Y > 14853f && current.Y < 14860f && current.Z > -65690f && current.Z < -65520f && !vars.XYZSplits[12]) {return vars.XYZSplits[12]  = true;}
	if(settings["Pilg"] && current.X > 12978f && current.X < 13115f && current.Y > 12570f && current.Y < 12595f && current.Z > -48110f && current.Z < -48050f && !vars.XYZSplits[13]) {return vars.XYZSplits[13]  = true;}
	if(settings["Tomb"] && current.X > 1833f && current.X < 1945f && current.Y > 8940f && current.Y < 8960f && current.Z > -31900f && current.Z < -31200f && !vars.XYZSplits[14]) {return vars.XYZSplits[14]  = true;}
	if(settings["Malum"] && current.X > 10029f && current.X < 10220f && current.Y > 3950f && current.Y < 3965f && current.Z > -11550f && current.Z < -11250f && !vars.XYZSplits[15]) {return vars.XYZSplits[15]  = true;}
	if(settings["Opera"] && current.X > 62300f && current.X < 62440f && current.Y > 8560f && current.Y < 8570f && current.Z > 12400f && current.Z < 12710f && !vars.XYZSplits[16]) {return vars.XYZSplits[16]  = true;}
	if(settings["Char"] && current.X > 80464f && current.X < 80520f && current.Y > 8448f && current.Y < 8458f && current.Z > 13786f && current.Z < 14380f && !vars.XYZSplits[17]) {return vars.XYZSplits[17]  = true;}
	if(settings["Arc"] && current.X > 72540f && current.X < 72630f && current.Y > 6045f && current.Y < 6055f && current.Z > 27514f && current.Z < 27782f && !vars.XYZSplits[18]) {return vars.XYZSplits[18]  = true;}
	if(settings["GrandE"] && current.X > 54310f && current.X < 54520f && current.Y > 8665f && current.Y < 8675f && current.Z > 54820f && current.Z < 54870f && !vars.XYZSplits[19]) {return vars.XYZSplits[19]  = true;}
	if(settings["Ravine"] && current.X > 24600f && current.X < 24900f && current.Y > 6730f && current.Y < 6780f && current.Z > 90800f && current.Z < 91397f && !vars.XYZSplits[20]) {return vars.XYZSplits[20]  = true;}
	if(settings["Station"] && current.X > 12575f && current.X < 12705f && current.Y > 4035f && current.Y < 4110f && current.Z > 66830f && current.Z < 67165f && !vars.XYZSplits[21]) {return vars.XYZSplits[21]  = true;}
	if(settings["Outer2"] && current.X > 10050f && current.X < 10295f && current.Y > 4915f && current.Y < 4925f && current.Z > 47604f && current.Z < 47715f && !vars.XYZSplits[22]) {return vars.XYZSplits[22]  = true;}
	if(settings["Collapse"] && current.X > 24930f && current.X < 25060f && current.Y > 5145f && current.Y < 5156f && current.Z > 45219f && current.Z < 45277f && !vars.XYZSplits[23]) {return vars.XYZSplits[23]  = true;}
	if(settings["CollTow"] && current.X > 23370f && current.X < 23434f && current.Y > 5297f && current.Y < 5307f && current.Z > 30300f && current.Z < 30800f && !vars.XYZSplits[24]) {return vars.XYZSplits[24]  = true;}
	if(settings["Tris"] && current.X > -7450f && current.X < -7330f && current.Y > -6543f && current.Y < -6537f && current.Z > 13760f && current.Z < 13890f && !vars.XYZSplits[25]) {return vars.XYZSplits[25]  = true;}
	if(settings["ArchW"] && current.X > 12840f && current.X < 13250f && current.Y > 16207f && current.Y < 16217f && current.Z > 15930f && current.Z < 16120f && !vars.XYZSplits[26]) {return vars.XYZSplits[26]  = true;}
	if(settings["ArchR"] && current.X > 14070f && current.X < 14360f && current.Y > 26220f && current.Y < 26240f && current.Z > 10800f && current.Z < 10990f && !vars.XYZSplits[27]) {return vars.XYZSplits[27]  = true;}
	
	
	
}

isLoading
{
    if (current.TransitionDescription == "/Game/Map/PSO_P" || current.TransitionDescription == "/Game/Map/Init_P" || current.TransitionDescription == "/Game/Map/Title2_P" || current.TransitionDescription == "/Game/Map/Title3_P" || current.TransitionDescription == "/Game/Map/Title_P" || current.TransitionDescription == "/Game/Map/Loading_P" || current.AsyncLoadingWidget != 0xFFFFFFFF ||
		current.menuBuffer < 5)
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

exit
{
    //pauses timer if the game crashes
	timer.IsGameTimePaused = true;
}
