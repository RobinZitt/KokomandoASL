state("Kokomando")
{
	byte IsLevel : 0x00D829C, 0x180;
	string7 Level : 0x0061A00, 0x338;
	byte IsLoading : 0x00D829C, 0x108, 0x18;
	int Cutscene : 0x0061A00, 0x568;


}

init
{
	vars.CutsceneNumber = 0;
	vars.Enter = true;
	vars.CutsceneCurrent = 0;
	vars.FinalCut = false;
	vars.CutsceneLimit = 3;
	vars.LastLevel = true;
}

startup
{
	settings.Add("option1", true, "Loading");
	settings.SetToolTip("option1", "Stops Game Time during the loading screen");
	settings.Add("option2", true, "LastSplit");
	settings.SetToolTip("option2", "This option splits on the final cutscene but only works if the number of activated cutscenes on the last level is correct. Only check one option");
	settings.CurrentDefaultParent = "option2";
	settings.Add("option2.0", false, "No Cutscene");
	settings.SetToolTip("option2.0", "Should be enabled if the final cutscene is the only cutscene in the last level");
	settings.Add("option2.1", true, "1 Cutscene");
	settings.SetToolTip("option2.1", "Should be enabled if one additional cutscene will be activated in the last level. Currently the default");
	settings.Add("option2.2", false, "2 Cutscenes");
	settings.SetToolTip("option2.2", "Should be enabled if all cutscenes in the last level will be activated");
}

start
{
	if(current.Level == "level1" && old.Level == "menu"){
		return true;
	}
}

split{
	if(current.Level != old.Level && current.Level != "menu" && old.Level != "menu" && old.Level != "level15"){
		return true;
	}
	if(current.Level == "menu" && !vars.LastLevel){
		vars.LastLevel = true;
	}
	//Code for split on final cutscene
	if(current.Level == "level20" || current.Level == "Level20"){
		if(vars.LastLevel){
			vars.Enter = true;
			vars.CutsceneNumber = 0;
			vars.FinalCut = false;
			vars.CutsceneLimit = 3;
			vars.LastLevel = false;
		}
		if(current.IsLoading != 224 && vars.Enter && settings["option2"]){
			if(settings["option2.0"]){
				vars.CutsceneLimit = 1;
			}
			if(settings["option2.2"]){
				vars.CutsceneLimit = 5;
			}
			if(settings["option2.1"]){
				vars.CutsceneLimit = 3;
			}
			vars.CutsceneCurrent = current.Cutscene;
			vars.Enter = false;
		}
		if(!vars.Enter){
			if(vars.CutsceneCurrent != current.Cutscene){
				vars.CutsceneNumber++;
				vars.CutsceneCurrent = current.Cutscene;
			}
			if(vars.CutsceneNumber == vars.CutsceneLimit && !vars.FinalCut){
				vars.FinalCut = true;
				return true;
			}
		}
	}
	
}

isLoading
{
    if(settings["option1"] && current.IsLoading == 224){
		return true;
	}
	else{
		return false;
	}
}
