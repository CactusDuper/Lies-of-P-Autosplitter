/*

 ▄█         ▄█     ▄████████    ▄████████       ▄██████▄     ▄████████         ▄███████▄ 
███        ███    ███    ███   ███    ███      ███    ███   ███    ███        ███    ███ 
███        ███▌   ███    █▀    ███    █▀       ███    ███   ███    █▀         ███    ███ 
███        ███▌  ▄███▄▄▄       ███             ███    ███  ▄███▄▄▄            ███    ███ 
███        ███▌ ▀▀███▀▀▀     ▀███████████      ███    ███ ▀▀███▀▀▀          ▀█████████▀  
███        ███    ███    █▄           ███      ███    ███   ███               ███        
███▌    ▄  ███    ███    ███    ▄█    ███      ███    ███   ███               ███        
█████▄▄██  █▀     ██████████  ▄████████▀        ▀██████▀    ███              ▄████▀      
▀                                                                                       

Lies of P Autosplitter + Load Remover
Made by CactusDuper with help from: Mysterion, TheDementedSalad and diggity
https://www.speedrun.com/lies_of_p

10/04/23

Currently steam only
*/

state("LOP-Win64-Shipping","1.2.0.0")
{
	bool bPlayInputLock   				: 0x071E7EB0, 0x110;						                    //1 when loading
	bool levelLoad 		    			: 0x071E7EE0, 0xb4;						                    	//0 when not in level, !0 when level is loaded (main menu to game, not for use during other loading screens)
    //bool isStarted          			: 0x0733FF68, 0x18, 0x20, 0xe8, 0x238, 0x240, 0x360, 0x3c0;   	//when you start a new game or continue
    //int gameStartType       			: 0x0733FF68, 0x18, 0x20, 0xe8, 0x238, 0x240, 0x360, 0x3a8;   	//fname
    long QuestsData						: 0x0729BBC8, 0xD28, 0x38, 0x0, 0x30, 0x220, 0xDB8, 0x4E0;		//Used for checking quests
    int introStart						: 0x0729BBC8, 0xD28, 0x38, 0x0, 0x30, 0x220, 0xDB8, 0x4F0, 0x8; //Good pointer for when the game actually starts
	string128 TransitionDescription		: 0x0729BBC8, 0x8B0, 0x0;                          				//level/zone name
}

startup
{
	Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Basic");
	vars.Helper.Settings.CreateFromXml("Components/LoP.Settings.xml");
	vars.completedSplits = new HashSet<string>();	
}

init
{
	// this function is a helper for checking splits that may or may not exist in settings,
	// and if we want to do them only once
	vars.CheckSplit = (Func<string, bool>)(key => {
		// if the split doesn't exist, or it's off, or we've done it already
		if (!settings.ContainsKey(key) || !settings[key] || vars.completedSplits.Contains(key)
		) {
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
			break;
		default:
			print("Unknown version detected");
			return false;
	}
}

onStart
{
	vars.completedSplits.Clear();
}

start
{
    if(current.TransitionDescription == "/Game/MapRelease/LV_Zone_S/LV_Zone_S_P" && current.bPlayInputLock == false && current.introStart == 1){
        vars.resetFunction = 0;

		print(current.TransitionDescription);
        return true;
    }
}

update
{
}

split
{
	for (var i = 0; i < 243; i++) 
	{
		var questState = vars.Helper.Read<byte>((IntPtr)(current.QuestsData + i * 0x18 + 0x8));
		var key = "quest_" + i;

		if (questState == 0x2 && vars.CheckSplit(key)) {
		  return true;
		}
	}
}

isLoading
{
    if(current.bPlayInputLock == true || current.TransitionDescription == "/Game/Map/Title_P"){
        return true;
    }else{
		return false;
	}
}
reset
{
	//check gameStartType + isStarted?
}
