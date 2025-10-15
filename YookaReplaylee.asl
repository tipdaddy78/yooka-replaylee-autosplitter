/*
	Yooka-Replaylee (Released October 9, 2025) https://s.team/a/2448020
	ASL originally by Ansiando & tipdaddy78
*/

state("ReplayleeWin64", "Unknown - Using Latest"){
	byte Loading : "UnityPlayer.dll", 0x1F10318, 0xB4;
}
state("ReplayleeWin64", "Steam 1.00 (2025)"){
	byte Loading : "UnityPlayer.dll", 0x1F10318, 0xB4;
}
state("ReplayleeWin64", "Non-Steam 1.00 (2025)"){
	byte Loading : "UnityPlayer.dll", 0x1F10318, 0xB4;
}
state("ReplayleeWin64", "Steam 1.01 (2025)"){
	byte Loading : "UnityPlayer.dll", 0x1F10318, 0xB4;
	//int  Pagies  : "UnityPlayer.dll", 0x0, 0x0, 0x0, 0x0; this shit doesn't exist
}

// TODO - Determine memory location for # of Pagies in-game.  When done, uncomment all locations below.

startup{
//	vars.PagiesSplitSettingName = "(Unavailable) Split for quantities of total Pagies";
	vars.LoadsSplitSettingName = "Split on # of Loads";
	
	//This code creates all the settings for splitting on collecting pagies
//	settings.Add(vars.PagiesSplitSettingName, false);
//	for(int i=1; i<301; i++){
//		settings.Add(i.ToString() + " pagies", false, i.ToString() + " pagies", vars.PagiesSplitSettingName);
//	}
	
	//This code creates all the settings for splitting on loads
	settings.Add(vars.LoadsSplitSettingName, false);
	for(int i=1; i<51; i++){
		settings.Add(i.ToString() + " loads", false, i.ToString() + " loads", vars.LoadsSplitSettingName);
	}

} 

init{
	//This code identifies different game versions with MD5 checksum on GameAssembly.dll.
	byte[] exeMD5HashBytes = new byte[0];
	using (var md5 = System.Security.Cryptography.MD5.Create()){
		using (var s = File.Open(modules.First().FileName.Substring(0, modules.First().FileName.Length-18)
		+ "GameAssembly.dll", FileMode.Open, FileAccess.Read, FileShare.ReadWrite)){
			exeMD5HashBytes = md5.ComputeHash(s);
		} 
	}
	vars.MD5Hash = exeMD5HashBytes.Select(x => x.ToString("X2")).Aggregate((a, b) => a + b);
	print("MD5Hash: " + vars.MD5Hash.ToString()); // Prints detected MD5 once to see from DebugView, so I don't need to enable logging to get the MD5.
	
	if(vars.MD5Hash == "DEAD1") version = "Steam 1.00 (2025)";
	else if(vars.MD5Hash == "86439CB7F8851AE8D077F5F7CC520EAD") version = "Non-Steam 1.00 (2025)";
	else if(vars.MD5Hash == "B2A8352260D80FD19138502D8F025882") version = "Steam 1.01 (2025)";
	else version = "Unknown - Using Latest";
	
	vars.accumulativeLoads = 0;
}

onStart{
	vars.accumulativeLoads = 0;
}

start{
	if(current.Loading == 69){		//Needs more checks.
		vars.accumulativeLoads = 0;		//Resets totals when starting new run
		return true;	//Starts timer
	}
}

shutdown{
	
}

isLoading{
	return current.Loading == 2;		//Stops timer when Loading
}

split{
	//Split on Load
	if(current.Loading == 2 && old.Loading == 0){       					//If loading starts
		vars.accumulativeLoads++;											//total number of loads increases
		if(settings[vars.accumulativeLoads.ToString() + " loads"]){ 		//if total loads is a selected number
			return true;													//split
		}
	}
}

update{	
	
}