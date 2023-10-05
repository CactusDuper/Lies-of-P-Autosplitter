/*

                                                                                                                 █
    █                                                                                                          ███                                    
    ███                                                                                                       ████       ████████████████████████     
    ████                                                                                                    ██████     ████████████████████████       
     ██████                                                                                               ████████    ████████████████████████        
      ███████                                                                                           ██████████   ████████████████████████         
       █████████                                                                                      ██████████████████████████████████████          
        ████████                                                                                       █████████████████████████████████████          
         ███████                                                                                        ██████████████          ███████████           
         ███████                                                                                        ████████████            ██████████            
         ███████                                                                                        ██████████             ███████████            
         ███████                                                                                        ██████████             ██████████             
         ███████                     ████████       ███████████████       ███████████████               ██████████            ███████████             
         ███████                      ███████       ██████████████       ███████████████                ██████████            ███████████             
         ███████                      ███████       ███████    ██       ███████████████                 ██████████            ███████████             
        █████████                     ███████       ███████            ████████                         ██████████            ██████████              
         ███████                      ███████       ███████            ██████                           ██████████            ██████████              
         ███████                      ███████       ███████    ██      ███████                          ██████████            ██████████              
         ███████                      ███████       █████████████       ████████                        ██████████            ██████████              
         ███████                     █████████    ███████████████        ██████████                     ██████████            ██████████              
         ███████                      ███████       █████████████          ███████████                  ██████████            ██████████              
         ███████           ███        ███████       ███████    ██             ██████████                ██████████            ██████████              
         ███████            ████      ███████       ███████                      ████████               ███████████████       ███████████             
         ███████            █████     ███████       ███████                       ████████              ███████████████████   ███████████             
         ███████████        █████     ████████      ███████           ██           ███████             ██████████████████████ ███████████             
         ████████████████  ███████     ██████       ███████      ██   ██         ████████           █████████████████████████████████████            
      ████████████████████████████     ██████       ███████       ██    ████   ██████████          █████████████████████████████████████████          
     █████████████████████████████      ████        █████████████████   ████████████████         █████████████████████████████████████████            
   ████             ███████████████       ██        ██████████████████    ████████████         ████████████████████████████████████████               
                                                                              ████             ██       ██████████      ████████████                  
                                                                                                        ██████████         ███████                    
                                                                                                        ██████████          ████                      
                                                                                                        ██████████           ██                       
                                                                                                        ██████████                                    
                                                            ███        ███████████████████            █████████████                                   
                                                          ██████         ███████████████              ██████████████                                  
                                                        ██████████       ██████████████                 ██████████                                    
                                                    ██████████████       ██████     ██                  ██████████                                    
                                                ██████████████████       ██████                         ██████████                                    
                                                 █████████████████       ██████                         ██████████                                    
                                                 ████████   ██████      █████████████                   ██████████                                    
                                                  ███████   ██████     ██████████████                   ██████████                                    
                                                  ███████   ██████     ██████████████                   ██████████                                    
                                                  ███████   ██████      ████████   ██                   ██████████                                    
                                                 ████████   ███████      ██████                         ██████████                                    
                                                  ███████   ██████       ██████                         ██████████                                    
                                                  ███████   ██████       ██████                         ██████████                                    
                                                  ███████   ██████       ██████                         ██████████                                    
                                                  ███████   ███████      ██████                        ███████████                                    
                                                 ████████   ███████      ██████                        ███████████                                    
                                                  ████████████████       ██████                        █████████                                      
                                                    ████████████         ██████                                                                       
                                                      █████████          ██████                                                                       
                                                        █████            ███████                                                                      
                                                         ███             ██████                                                                       
                                                                         ████████                                                                     
                                                                         █████                                                                        
                                                                         ████                                                                         
                                                                         ███                                                                          
                                                                         █                                                                            



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
    bool bPlayInputLock 			: 0x071E7EB0, 0x110; // 1 when loading
    bool levelLoad 				: 0x071E7EE0, 0xb4; // 0 when not in level, !0 when level is loaded (main menu to game, not for use during other loading screens)
    // bool isStarted 				: 0x0733FF68, 0x18, 0x20, 0xe8, 0x238, 0x240, 0x360, 0x3c0; // when you start a new game or continue
    // int gameStartType 			: 0x0733FF68, 0x18, 0x20, 0xe8, 0x238, 0x240, 0x360, 0x3a8; // fname
    long QuestsData 				: 0x0729BBC8, 0xD28, 0x38, 0x0, 0x30, 0x220, 0xDB8, 0x4E0; // Used for checking quests
    int introStart 				: 0x0729BBC8, 0xD28, 0x38, 0x0, 0x30, 0x220, 0xDB8, 0x4F0, 0x8; // Good pointer for when the game actually starts
    string128 TransitionDescription 		: 0x0729BBC8, 0x8B0, 0x0; // level/zone name
    int propShapeArraySize 			: 0x071E7E98, 0x418;
    long propShapeArray 			: 0x071E7E98, 0x410;
    long AsyncLoadingWidget 			: 0x071E7EB8, 0x1d0;
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
            break;
        default:
            print("Unknown version detected");
            return false;
    }

    /*
    function calculateGObjectValue(address)
        -- Read the value from the provided address
        value = readInteger(address.getCurrentAddress())
        -- Extract the first and last 2 bytes as array indices
        index1 = (value >> 16) & 0xFFFF
        index2 = value & 0xFFFF

        -- Calculate the offset in the "GObjects" array
        gObjectChunk = readPointer(GObjects.getCurrentAddress() + (index1 * 0x8))
        gObjectValue = getAddress(gObjectChunk + (index2 * 0x18))

        return gObjectValue
    end
    */

    // vars.GObjects = game.ReadValue<IntPtr>(modules.First().BaseAddress + 0x06F11D30);

    vars.ptrFromGObjects = (Func<int, ulong>)((idx) =>
    {
        var addr = new DeepPointer(
            0x06F11D30,
            ((idx >> 16) & 0xFFFF) * 0x8,
            (idx & 0xFFFF) * 0x18
        ).Deref<ulong>(game);

        return addr;
    });

    vars.shapeDict = new Dictionary<int, IntPtr>();
    vars.propSize = 0;
    vars.hotelLoadFix = false;
}

onStart
{
    vars.completedSplits.Clear();
}

start
{
    if (current.TransitionDescription == "/Game/MapRelease/LV_Zone_S/LV_Zone_S_P" && current.bPlayInputLock == false && current.introStart == 1)
    {
        vars.resetFunction = 0;

        // print(current.TransitionDescription);
        return true;
    }
}

update
{
    if (current.propShapeArraySize != vars.propSize && current.propShapeArraySize > 0)
    {
        vars.shapeDict.Clear();
        vars.propSize = current.propShapeArraySize;
        for (var i = 0; i < current.propShapeArraySize; i++)
        {
            var shapePointer = (IntPtr)vars.ptrFromGObjects(game.ReadValue<int>((IntPtr)(current.propShapeArray + i * 0x8)));
            var instanceID = game.ReadValue<int>(shapePointer + 0x1f4); // string at 1f8 but im having issues reading it :/
            vars.shapeDict[instanceID] = shapePointer;
        }
    }
}

split
{
    for (var i = 0; i < 243; i++)
    {
        var questState = vars.Helper.Read<byte>((IntPtr)(current.QuestsData + i * 0x18 + 0x8));
        var key = "quest_" + i;

        if (questState == 0x2)
        {

            if (i == 9)
            {
                vars.hotelLoadFix = true;
            }

            if (vars.CheckSplit(key))
            {
                return true;
            }
        }
    }
}

isLoading
{
    if (current.bPlayInputLock == true || current.TransitionDescription == "/Game/Map/Title_P" || current.TransitionDescription == "/Game/Map/Loading_P" || current.AsyncLoadingWidget != 0xFFFFFFFF ||
        (game.ReadValue<int>((IntPtr)vars.shapeDict[15] + 0x2c8) == 1 && !vars.hotelLoadFix))
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
