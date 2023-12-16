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


state("LOP-Win64-Shipping", "1.4.0.0 Steam")
{
	float X                                 : 0x071C8EB0, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x250;
	float Y                                 : 0x071C8EB0, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x258;
	float Z                                 : 0x071C8EB0, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x254;
	byte menuBuffer                         : 0x07201788, 0x80;
	bool bPlayInputLock                     : 0x07201788, 0x110; // 1 when loading
	long AsyncLoadingWidget                 : 0x07201790, 0x1D0;
	long QuestsData                         : 0x072B5558, 0xD28, 0x38, 0x0, 0x30, 0x220, 0xDC8, 0x4E0; // Used for checking quests
	string128 TransitionDescription         : 0x072B5558, 0x8B0, 0x0; // level/zone name
    // Right now using GEngine for QuestsData, see bottom of the file for other options
}

state("LOP-Win64-Shipping", "1.3.0.0 Steam")
{
	float X                                 : 0x071CBEB0, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x250;
	float Y                                 : 0x071CBEB0, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x258;
	float Z                                 : 0x071CBEB0, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x254;
	byte menuBuffer                         : 0x07204770, 0x80;
	bool bPlayInputLock                     : 0x07204770, 0x110; // 1 when loading
	long AsyncLoadingWidget                 : 0x07204778, 0x1D0;
	long QuestsData                         : 0x072B8528, 0xD28, 0x38, 0x0, 0x30, 0x220, 0xDC8, 0x4E0; // Used for checking quests
	string128 TransitionDescription         : 0x072B8528, 0x8B0, 0x0; // level/zone name
}

state("LOP-Win64-Shipping", "1.2.0.0 Steam")
{
	float X                                 : 0x71AF5E8, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x250;
	float Y                                 : 0x71AF5E8, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x258;
	float Z                                 : 0x71AF5E8, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x254; 
	byte menuBuffer                         : 0x71E7EB0, 0x80;
	bool bPlayInputLock                     : 0x71E7EB0, 0x110; // 1 when loading
	long AsyncLoadingWidget                 : 0x71E7EB8, 0x1D0;
	long QuestsData                         : 0x729BBC8, 0xD28, 0x38, 0x0, 0x30, 0x220, 0xDB8, 0x4E0; // Used for checking quests
	string128 TransitionDescription         : 0x729BBC8, 0x8B0, 0x0; // level/zone name
}

state("LOP-WinGDK-Shipping", "1.2.0.0 Xbox")
{
	float X                                 : 0x69BFB78, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x250;
	float Y                                 : 0x69BFB78, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x258;
	float Z                                 : 0x69BFB78, 0x180, 0x38, 0x0, 0x30, 0x220, 0x248, 0x254;
	byte menuBuffer                         : 0x69F4680, 0x80;
	bool bPlayInputLock                     : 0x69F4680, 0x110; // 1 when loading
	long AsyncLoadingWidget                 : 0x69F4678, 0x1D0;
	long QuestsData                         : 0x6AA3640, 0xD28, 0x38, 0x0, 0x30, 0x220, 0xDB8, 0x4E0; // Used for checking quests
	string128 TransitionDescription         : 0x6AA3640, 0x8B0, 0x0; // level/zone name
}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.Helper.Settings.CreateFromXml("Components/LoP.Settings.xml");
}

init
{
	vars.completedSplits = new HashSet<string>();
	vars.XYZSplitsStatus = new bool[28];
	
	// this function is a helper for checking splits that may or may not exist in settings,
	// and if we want to do them only once
	vars.CheckSplit = (Func<string, bool>)(key => {
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
			vars.LItemSystem = 0x72B01A8;
			break;
		case "5FB74D8903618EB40C350B71499357AC":
			version = "1.3.0.0 Steam";
			vars.LItemSystem = 0x07204700;
			break;
        case "723AB07D07AE1DBD5073561D4D957D57":
            version = "1.4.0.0 Steam";
            vars.LItemSystem = 0x07201748;
            break;
		default:
			// No version found with hash, fallback to memorySize
			switch ((int)vars.Helper.GetMemorySize()) {
				case (410910720):
					version = "1.2.0.0 Xbox";
					vars.LItemSystem = 0x6AB87D8;
					break;
			}
		break;
	}

	var allItemsSize = new DeepPointer(vars.LItemSystem, 0x180, 0x1A8).Deref<int>(game); // TArray size for allItems
	var itemCheck = Math.Max(0, allItemsSize - 5); // To go through the 5 most recent items
	
	current.itemsInfo = Enumerable.Range(itemCheck, Math.Min(5, allItemsSize)).Select(i => {
		IntPtr ptr;
		new DeepPointer(vars.LItemSystem, 0x180, 0x1A0, 0x0 + (i * 8), 0x38, 0x30, 0x0).DerefOffsets(memory, out ptr);
		return memory.ReadString(ptr, 300);
	}).ToArray();
	
	vars.questIdx = new int[] { 2, 6, 7, 32, 33, 41, 105, 120, 126, 133, 140, 146, 161, 164, 167, 171, 185, 198 };
	
	vars.xyzSplits = new Tuple<string, int, float[]>[] {
		Tuple.Create("Isa",       0, new float[] { 27500f, 27700f,  7670f,  7690f,  10300f,  10500f }),
		Tuple.Create("Grand",     1, new float[] { 56594f, 56610f,  8055f,  8065f,  65207f,  65223f }),
		Tuple.Create("Barr",      2, new float[] { 56700f, 56900f,  8265f,  8275f,  76000f,  76200f }),
		Tuple.Create("Alch",      3, new float[] {  7600f,  7800f,   850f,   900f, 119000f, 120000f }),
		Tuple.Create("ArchI",     4, new float[] {  4060f,  4200f, 41713f, 41733f,  -4940f,  -4800f }),
		Tuple.Create("Outer",     5, new float[] { 10192f, 10193f,  4915f,  4925f,  47704f,  47708f }),
		Tuple.Create("Elys",      6, new float[] { 21240f, 21250f,  6830f,  6850f,   7780f,   7800f }),
		Tuple.Create("Work",      7, new float[] { 47750f, 47800f,  7790f,  7800f, -45000f, -44600f }),
		Tuple.Create("Veni",      8, new float[] { 56250f, 56270f,  8147f,  8157f, -36750f, -36500f }),
		Tuple.Create("Moon",      9, new float[] { 46600f, 46920f,  3250f,  3450f, -52350f, -51900f }),
		Tuple.Create("Path",     10, new float[] { 56750f, 56850f, 18110f, 18120f, -70000f, -69500f }),
		Tuple.Create("Chap",     11, new float[] { 26660f, 26845f, 19843f, 19853f, -63720f, -63385f }),
		Tuple.Create("Lib",      12, new float[] { 20250f, 20550f, 14853f, 14860f, -65690f, -65520f }),
		Tuple.Create("Pilg",     13, new float[] { 12978f, 13115f, 12570f, 12595f, -48110f, -48050f }),
		Tuple.Create("Tomb",     14, new float[] {  1833f,  1945f,  8940f,  8960f, -31900f, -31200f }),
		Tuple.Create("Malum",    15, new float[] { 10029f, 10220f,  3950f,  3965f, -11550f, -11250f }),
		Tuple.Create("Opera",    16, new float[] { 62300f, 62440f,  8560f,  8570f,  12400f,  12710f }),
		Tuple.Create("Char",     17, new float[] { 80464f, 80520f,  8448f,  8458f,  13786f,  14380f }),
		Tuple.Create("Arc",      18, new float[] { 72540f, 72630f,  6045f,  6055f,  27514f,  27782f }),
		Tuple.Create("GrandE",   19, new float[] { 54310f, 54520f,  8665f,  8675f,  54820f,  54870f }),
		Tuple.Create("Ravine",   20, new float[] { 24600f, 24900f,  6730f,  6780f,  90800f,  91397f }),
		Tuple.Create("Station",  21, new float[] { 12575f, 12705f,  4035f,  4110f,  66830f,  67165f }),
		Tuple.Create("Outer2",   22, new float[] { 10050f, 10295f,  4915f,  4925f,  47604f,  47715f }),
		Tuple.Create("Collapse", 23, new float[] { 24930f, 25060f,  5145f,  5156f,  45219f,  45277f }),
		Tuple.Create("CollTow",  24, new float[] { 23370f, 23434f,  5297f,  5307f,  30300f,  30800f }),
		Tuple.Create("Tris",     25, new float[] { -7450f, -7330f, -6543f, -6537f,  13760f,  13890f }),
		Tuple.Create("ArchW",    26, new float[] { 12840f, 13250f, 16207f, 16217f,  15930f,  16120f }),
		Tuple.Create("ArchR",    27, new float[] { 14070f, 14360f, 26220f, 26240f,  10800f,  10990f })
	};
	
}

onStart
{
	vars.completedSplits.Clear();
	vars.XYZSplitsStatus = new bool[28];
}

start
{
	if (current.TransitionDescription == "/Game/MapRelease/LV_Zone_S/LV_Zone_S_P" && current.bPlayInputLock == false && current.menuBuffer != 3) {
		vars.resetFunction = 0;
		// print(current.TransitionDescription);
		return true;
	}
}

update
{
	if (timer.CurrentPhase == TimerPhase.NotRunning) { 
		vars.completedSplits.Clear();

		foreach (var xyzSplit in vars.xyzSplits)
		{
			vars.XYZSplitsStatus[xyzSplit.Item2] = false;
		}
	}

	var allItemsSize = new DeepPointer(vars.LItemSystem, 0x180, 0x1A8).Deref<int>(game); // TArray size for allItems
	var itemCheck = Math.Max(0, allItemsSize - 5); // To go through the 5 most recent items
	
	current.itemsInfo = Enumerable.Range(itemCheck, Math.Min(5, allItemsSize)).Select(i => {
		IntPtr ptr;
		new DeepPointer(vars.LItemSystem, 0x180, 0x1A0, 0x0 + (i * 8), 0x38, 0x30, 0x0).DerefOffsets(memory, out ptr);
		return memory.ReadString(ptr, 300);
	}).ToArray();
}

split
{
	string[] currentitemsInfo = (current.itemsInfo as string[]);
	string[] olditemsInfo = (old.itemsInfo as string[]); // throws error first update, will be fine afterwards.
	if (!currentitemsInfo.SequenceEqual(olditemsInfo)) {
		string[] delta = (currentitemsInfo as string[]).Where((v, i) => v != olditemsInfo[i]).ToArray();
		
		foreach (var item in delta) {
			if (vars.CheckSplit(item)) {
				return true;
			}
		}
	}
	
	foreach (var idx in vars.questIdx) {
		var questState = vars.Helper.Read<byte>((IntPtr)(current.QuestsData + idx * 0x18 + 0x8));
		if (questState == 0x2) {
			var key = "quest_" + idx;
			if (vars.CheckSplit(key)) {
				return true;
			}
		}
	}
	
	foreach (var xyzSplit in vars.xyzSplits) {
		string splitName = xyzSplit.Item1;
		float[] splitValues = xyzSplit.Item3;

		if (settings[splitName] && !vars.XYZSplitsStatus[xyzSplit.Item2] &&
		current.X > splitValues[0] && current.X < splitValues[1] &&
		current.Y > splitValues[2] && current.Y < splitValues[3] &&
		current.Z > splitValues[4] && current.Z < splitValues[5]) {
			return vars.XYZSplitsStatus[xyzSplit.Item2] = true;
		}
	}


}

isLoading
{
	if (current.TransitionDescription == "/Game/Map/PSO_P" || current.TransitionDescription == "/Game/Map/Init_P" ||
	current.TransitionDescription == "/Game/Map/Title2_P" || current.TransitionDescription == "/Game/Map/Title3_P" ||
	current.TransitionDescription == "/Game/Map/Title_P" || current.TransitionDescription == "/Game/Map/Loading_P" ||
	current.AsyncLoadingWidget != 0xFFFFFFFF || current.menuBuffer < 5) {
		return true;
	} else {
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





/*

	float X                                 : GWorld, OwningGameInstance, LocalPlayers[0], PlayerController, Character, CharacterMovement, LastUpdateLocation.X;
	float Y                                 : GWorld, OwningGameInstance, LocalPlayers[0], PlayerController, Character, CharacterMovement, LastUpdateLocation.Y;
	float Z                                 : GWorld, OwningGameInstance, LocalPlayers[0], PlayerController, Character, CharacterMovement, LastUpdateLocation.Z;
	long QuestsData                         : GWorld, OwningGameInstance, LocalPlayers[0], PlayerController, Character, PlayingGameData, QuestSaveData;
	byte menuBuffer                         : LPlayInputSystem, OnChangePlayInput + 0x8;
	bool bPlayInputLock                     : LPlayInputSystem, bPlayInputLock;
	long AsyncLoadingWidget                 : LUISystem, AsyncLoadingWidget;
	string128 TransitionDescription         : GEngine, TransitionDescription;


    vars.LItemSystem = LItemSystem, LPlayerInventory, AllItemList[i], CommonInfo, _local_text_item_name

    I could make everything GEngine to avoid needing GWorld offsets.
    Could also go directly to LocalPlayers[0], just would require another offset and more testing.
*/
