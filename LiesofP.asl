/*
Lies of P Autosplitter + Load Remover
Made by CactusDuper with help from: Mysterion, TheDementedSalad and diggity
CactusDuper: @CactusDuper on Discord. All pointers for splits/load removal
Mysterion: @mysterion352 on Discord. Help with ASL creation
TheDementedSalad: @thedementedsalad on Discord. Autosplit logic for items and testing, all splits
Diggity: @diggitydingdong on Discord. Autosplit logic for quest arrary

https://www.speedrun.com/lies_of_p

Last updated: 16 Dec 2023

*/

state("LOP-Win64-Shipping"){}
state("LOP-WinGDK-Shipping"){}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.Helper.Settings.CreateFromXml("Components/LoP.Settings.xml");
	
	vars.PendingSplits = 0;
}

init
{
	IntPtr gEngine = vars.Helper.ScanRel(3, "4c 39 25 ?? ?? ?? ?? 0f 85 ?? ?? ?? ?? 48 8b 0d ?? ?? ?? ?? 48 8d 05");
	IntPtr fNames = vars.Helper.ScanRel(3, "48 8d 0d ?? ?? ?? ?? e8 ?? ?? ?? ?? 44 8b 45 ?? 48 8b f8");
	
	vars.Helper["TransitionDescription"] = vars.Helper.MakeString(gEngine, 0x8B0, 0x0);
	
	vars.completedSplits = new HashSet<string>();
	vars.Quests = new Dictionary<ulong, byte>();
	vars.QuestSteps = new Dictionary<ulong, byte>();
	vars.Inventory = new Dictionary<ulong, byte>();
	vars.XYZSplits = new bool[27];

	string md5 = "";

	try {
        	md5 = (string)vars.Helper.GetMD5Hash();
    	} catch {
        	// Failed to open file for MD5 computation.
    	}
	
	switch (modules.First().ModuleMemorySize)
	{
		case (122990592):
			version = "DLC";
			break;
		case (122912768):
		case (113602560):
			version = "Post DLC";
			break;
	}
	
	if(version == "DLC" || version == "Post DLC"){
		vars.Helper["QuestData"] = vars.Helper.Make<IntPtr>(gEngine, 0xD40, 0x38, 0x0, 0x30, 0x260, 0x1008, 0x560);
		vars.Helper["QuestDataSize"] = vars.Helper.Make<int>(gEngine, 0xD40, 0x38, 0x0, 0x30, 0x260, 0x1008, 0x568);
		vars.Helper["N1"] = vars.Helper.Make<ulong>(gEngine, 0xD40, 0xF0, 0x2A8, 0x78, 0x670);
		vars.Helper["LItemSystem"] = vars.Helper.Make<ulong>(gEngine, 0xD40, 0xF0, 0x170, 0x180, 0x18);
		vars.Helper["Inventory"] = vars.Helper.Make<IntPtr>(gEngine, 0xD40, 0xF0, 0x170, 0x180, 0x1E8);
		vars.Helper["InventorySize"] = vars.Helper.Make<int>(gEngine, 0xD40, 0xF0, 0x170, 0x180, 0x1F0);
		vars.Helper["X"] = vars.Helper.Make<float>(gEngine, 0xD40, 0x38, 0x0, 0x30, 0x220, 0x248, 0x250);
		vars.Helper["Y"] = vars.Helper.Make<float>(gEngine, 0xD40, 0x38, 0x0, 0x30, 0x220, 0x248, 0x258);
		vars.Helper["Z"] = vars.Helper.Make<float>(gEngine, 0xD40, 0x38, 0x0, 0x30, 0x220, 0x248, 0x254);
		vars.Helper["menuBuffer"] = vars.Helper.Make<byte>(gEngine, 0xD40, 0xF0, 0x260, 0x80);
		vars.Helper["bPlayInputLock"] = vars.Helper.Make<bool>(gEngine, 0xD40, 0xF0, 0x260, 0x110);
		vars.Helper["AsyncLoadingWidget"] = vars.Helper.Make<long>(gEngine, 0xD40, 0xF0, 0x338, 0x1E0);
		vars.Helper["AcknowledgedPawn"] = vars.Helper.Make<ulong>(gEngine, 0xD40, 0x38, 0x0, 0x30, 0x260, 0x18);
	}
	
	else{
		vars.Helper["QuestData"] = vars.Helper.Make<IntPtr>(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x1008, 0x560);
		vars.Helper["QuestDataSize"] = vars.Helper.Make<int>(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x1008, 0x568);
		vars.Helper["Inventory"] = vars.Helper.Make<IntPtr>(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x1008, 0x120);
		vars.Helper["PlayerData"] = vars.Helper.Make<ulong>(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x1008, 0x18);
		vars.Helper["InventorySize"] = vars.Helper.Make<int>(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x260, 0x1008, 0x128);
		vars.Helper["X"] = vars.Helper.Make<float>(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x220, 0x248, 0x250);
		vars.Helper["Y"] = vars.Helper.Make<float>(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x220, 0x248, 0x258);
		vars.Helper["Z"] = vars.Helper.Make<float>(gEngine, 0xD28, 0x38, 0x0, 0x30, 0x220, 0x248, 0x254);
		vars.Helper["menuBuffer"] = vars.Helper.Make<byte>(gEngine, 0xD28, 0xF0, 0x230, 0x80);
		vars.Helper["bPlayInputLock"] = vars.Helper.Make<long>(gEngine, 0xD28, 0xF0, 0x230, 0x110);
		vars.Helper["AsyncLoadingWidget"] = vars.Helper.Make<byte>(gEngine, 0xD28, 0xF0, 0x308, 0x1D0);
	}
	
	vars.FNameToString = (Func<ulong, string>)(fName =>
	{
		var nameIdx  = (fName & 0x000000000000FFFF) >> 0x00;
		var chunkIdx = (fName & 0x00000000FFFF0000) >> 0x10;
		var number   = (fName & 0xFFFFFFFF00000000) >> 0x20;

		IntPtr chunk = vars.Helper.Read<IntPtr>(fNames + 0x10 + (int)chunkIdx * 0x8);
		IntPtr entry = chunk + (int)nameIdx * sizeof(short);

		int length = vars.Helper.Read<short>(entry) >> 6;
		string name = vars.Helper.ReadString(length, ReadStringType.UTF8, entry + sizeof(short));

		return number == 0 ? name : name + "_" + number;
	});
	
	vars.FNameToShortString = (Func<ulong, string>)(fName =>
	{
		string name = vars.FNameToString(fName);

		int dot = name.LastIndexOf('.');
		int slash = name.LastIndexOf('/');

		return name.Substring(Math.Max(dot, slash) + 1);
	});
	
	vars.FNameToShortString2 = (Func<ulong, string>)(fName =>
	{
		string name = vars.FNameToString(fName);

		int under = name.LastIndexOf('_');

		return name.Substring(0, under + 1);
	});
}

onStart
{
	vars.completedSplits.Clear();
	vars.Inventory.Clear();
	vars.Quests.Clear();
	vars.QuestSteps.Clear();
	vars.XYZSplits = new bool[27];
	vars.PendingSplits = 0;
}

start
{
	if (current.TransitionDescription == "/Game/MapRelease/LV_Zone_S/LV_Zone_S_P" && current.bPlayInputLock == false && current.menuBuffer != 3){
        	return true;
    }
}

update
{
	//Uncomment debug information in the event of an update.
	//print(modules.First().ModuleMemorySize.ToString());
	
	vars.Helper.Update();
	vars.Helper.MapPointers();
	
	if (timer.CurrentPhase == TimerPhase.NotRunning){ 
		vars.completedSplits.Clear();
		vars.XYZSplits = new bool[28];
	}
	
	//print(current.TransitionDescription);
	//print(vars.FNameToString(current.AcknowledgedPawn));
}

split
{
	string questSetting = "";
	string itemSetting = "";
	
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
	
	for (int i = 0; i < 350; i++)
    {
		ulong questName = vars.Helper.Read<ulong>(current.QuestData + 0x0 + (i * 0x18));
        byte questState = vars.Helper.Read<byte>(current.QuestData + 0x8 + (i * 0x18));
		byte questStep = vars.Helper.Read<byte>(current.QuestData + 0xC + (i * 0x18));
		byte oldState;
		byte oldStep;

		if (vars.Quests.TryGetValue(questName, out oldState))
		{
			if (oldState < questState){
				questSetting = vars.FNameToShortString(questName) + "_" + questStep + "_" + questState;
				
				if (settings.ContainsKey(questSetting) && settings[questSetting]){
					vars.PendingSplits++;
				}
				
				// Debug. Comment out before release.
				if (!string.IsNullOrEmpty(questSetting))
				vars.Log(questSetting);
			}
		}
		
		if (vars.QuestSteps.TryGetValue(questName, out oldStep))
		{
			if (oldStep < questStep){
				questSetting = vars.FNameToShortString(questName) + "_" + questStep + "_" + questState;
				
				if (settings.ContainsKey(questSetting) && settings[questSetting]){
					vars.PendingSplits++;
				}
				
				// Debug. Comment out before release.
				if (!string.IsNullOrEmpty(questSetting))
				vars.Log(questSetting);
			}
		}
		
		vars.Quests[questName] = questState;
		vars.QuestSteps[questName] = questStep;
    }
	
	
	if(current.InventorySize > old.InventorySize){
		for (int i = 0; i < current.InventorySize; i++)
		{
			ulong itemName = vars.Helper.Read<ulong>(current.Inventory + 0x0 + (i * 0x8), 0x68);
			byte itemCount = vars.Helper.Read<byte>(current.Inventory + 0x0 + (i * 0x8), 0x40);
			byte oldCount;

			if (vars.Inventory.TryGetValue(itemName, out oldCount))
			{
			}
			else
			{
				itemSetting = vars.FNameToShortString(itemName) + "_(!)";
				
				if (settings.ContainsKey(itemSetting) && settings[itemSetting]){
					vars.PendingSplits++;
				}
				
				// Debug. Comment out before release.
				if (!string.IsNullOrEmpty(itemSetting))
				vars.Log(itemSetting);
			}
				
			vars.Inventory[itemName] = itemCount;
		}
	}
			
	if (vars.PendingSplits > 0 && (vars.completedSplits.Add(itemSetting) || vars.completedSplits.Add(questSetting)))
	{
		vars.PendingSplits--;
		return true;
	}
}

isLoading
{
    if (current.TransitionDescription == "/Game/Map/PSO_P" || current.TransitionDescription == "/Game/Map/Init_P" || current.TransitionDescription == "/Game/Map/Title2_P" || 
			current.TransitionDescription == "/Game/Map/Title3_P" || current.TransitionDescription == "/Game/Map/Title_P" || current.TransitionDescription == "/Game/Map/TitleD1_P" ||
			current.TransitionDescription == "/Game/Map/TitleD2_P" || current.TransitionDescription == "/Game/Map/TitleD3_P" || current.TransitionDescription == "/Game/Map/Loading_P" 
			|| current.menuBuffer < 5 || current.AsyncLoadingWidget != 0xFFFFFFFF)
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
	vars.completedSplits.Clear();
}

exit
{
	//pauses timer if the game crashes
	timer.IsGameTimePaused = true;
}
