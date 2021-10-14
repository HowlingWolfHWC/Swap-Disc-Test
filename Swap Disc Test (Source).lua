Font.fmLoad();

ErrorString = ""

pad = Pads.get();
oldpad=pad;

temporaryVar = System.openFile("rom0:ROMVER", FREAD)
temporaryVar_size = System.sizeFile(temporaryVar)
ROMVER = System.readFile(temporaryVar, temporaryVar_size)
ROMVERRegion = string.sub(ROMVER,5,5)
System.closeFile(temporaryVar)

if ROMVERRegion~="E" then
	Screen.setMode(NTSC, 640, 448)
	imanoVideoMode="NTSC"
else
	Screen.setMode(PAL, 640, 512)
	imanoVideoMode="PAL"
end

function readCDVD()
	infoDisco={};
	infoDisco[0]=System.checkDiscTray();
	if infoDisco[0]==1 then
		infoDisco[1]=-100;
		infoDisco[2]=-100;
	else
		infoDisco[1]=System.checkESR();
		infoDisco[2]=System.getDiscType();
	end
	return infoDisco;
end

function getGameCodeOK()
	GameCodeOK = "???"
	System.printDebugString("Reading %s\n", "cdfs:\\SYSTEM.CNF")
	if System.doesFileExist("cdfs:\\SYSTEM.CNF") then
		for line in io.lines("cdfs:\\SYSTEM.CNF") do
			if string.sub(line,1,4) == "BOOT" then
				System.printDebugString("%s\n", line)
				GameCodeOK = line;
			end
		end
	else
		GameCodeOK = "???"
	end
	GameCodeOK = GameCodeOK:gsub("cdrom:\\", "")
	GameCodeOK = GameCodeOK:gsub("cdrom0:\\", "")
	GameCodeOK = GameCodeOK:gsub("cdrom0:/", "")
	GameCodeOK = GameCodeOK:gsub("cdrom0;\\", "")
	GameCodeOK = GameCodeOK:gsub("cdrom0;/", "")
	GameCodeOK = GameCodeOK:gsub("cdrom0:", "")
	GameCodeOK = GameCodeOK:gsub("cdrom0;", "")
	GameCodeOK = GameCodeOK:gsub("TEKKEN3\\", "")
	GameCodeOK = GameCodeOK:gsub("TEKKEN2\\", "")
	GameCodeOK = GameCodeOK:gsub("TEKKEN\\", "")
	GameCodeOK = GameCodeOK:gsub("cdrom:/", "")
	GameCodeOK = GameCodeOK:gsub("cdrom:", "")
	GameCodeOK = GameCodeOK:gsub("cdrom;\\", "")
	GameCodeOK = GameCodeOK:gsub("cdrom;/", "")
	GameCodeOK = GameCodeOK:gsub("cdrom;", "")
	GameCodeOK = GameCodeOK:gsub("cdrom", "")
	GameCodeOK = GameCodeOK:gsub("cdrom0", "")
	GameCodeOK = GameCodeOK:gsub("BOOT2", "")
	GameCodeOK = GameCodeOK:gsub("BOOT", "")
	GameCodeOK = GameCodeOK:gsub(" = ", "")
	GameCodeOK = GameCodeOK:gsub("= ", "")
	GameCodeOK = GameCodeOK:gsub(" =", "")
	GameCodeOK = GameCodeOK:gsub("=", "")
	GameCodeOK = GameCodeOK:gsub(" ", "")
	GameCodeOK = GameCodeOK:gsub("	", "")
	GameCodeOK = GameCodeOK:gsub(";1", "")
	GameCodeOK = GameCodeOK:gsub(";2", "")
	GameCodeOK = GameCodeOK:gsub(";3", "")
	GameCodeOK = GameCodeOK:gsub(";4", "")
	GameCodeOK = GameCodeOK:gsub(";5", "")
	GameCodeOK = GameCodeOK:gsub(";6", "")
	GameCodeOK = GameCodeOK:gsub(";7", "")
	GameCodeOK = GameCodeOK:gsub(";8", "")
	GameCodeOK = GameCodeOK:gsub(";9", "")
	GameCodeOK = GameCodeOK:gsub(";0", "")
	System.printDebugString("%s\n", GameCodeOK)
	return GameCodeOK;
end

DiscInfoName = "No media"
DiscInfoDescription = "There's no disc in the drive";
DiscInfoLaunchable = false;

function setCDVD()
	DiscInfoName = "No media"
	DiscInfoDescription = "There's no disc in the drive";
	DiscInfoLaunchable = false;
	if infoDisco[0]==1 then
		DiscInfoName = "No media"
		DiscInfoDescription = "Tray is open";
		DiscInfoLaunchable = false;
	elseif infoDisco[2]==2 then
		DiscInfoName = "Reading disc"
		DiscInfoDescription = "Please, wait... (SCECdDETCT)";
		DiscInfoLaunchable = false;
	elseif infoDisco[0]==-1 then
		DiscInfoName = "No media";
		DiscInfoDescription = "Tray is open";
		DiscInfoLaunchable = false;
	elseif infoDisco[2]==3 then
		DiscInfoName = "Reading disc";
		DiscInfoDescription = "Please, wait... (SCECdDETCTCD)";
		DiscInfoLaunchable = false;
	elseif infoDisco[2]==4 then
		DiscInfoName = "Reading disc";
		DiscInfoDescription = "Please, wait... (SCECdDETCTDVDS)";
		DiscInfoLaunchable = false;
	elseif infoDisco[2]==5 then
		DiscInfoName = "Reading disc";
		DiscInfoDescription = "Please, wait... (SCECdDETCTDVDD)";
		DiscInfoLaunchable = false;
	elseif infoDisco[2]==16 then
		DiscInfoName = "Unsupported media";
		DiscInfoDescription = "Nothing to do with this disc...";
		DiscInfoLaunchable = false;
	elseif infoDisco[2]==6 then
		DiscInfoName = "Unknown";
		DiscInfoDescription = "I have no clue what this disc is";
		DiscInfoLaunchable = false;
	elseif infoDisco[2]==7 then --PS1 CD
		DiscInfoName = "PlayStation game";
		DiscInfoDescription = getGameCodeOK();
		DiscInfoLaunchable = true;
	elseif infoDisco[2]==8 then --PS1 CDDA
		DiscInfoName = "PlayStation game";
		DiscInfoDescription = getGameCodeOK();
		DiscInfoLaunchable = true;
	elseif infoDisco[2]==9 then --PS2 CD
		DiscInfoName = "PlayStation 2 (CD)"
		DiscInfoDescription = getGameCodeOK();
		DiscInfoLaunchable = true;
	elseif infoDisco[2]==10 then --PS2 CDDA
		DiscInfoName = "PlayStation 2 (CD)"
		DiscInfoDescription = getGameCodeOK();
		DiscInfoLaunchable = true;
	elseif infoDisco[2]==11 then --PS2 DVD
		DiscInfoName = "PlayStation 2 (DVD)"
		DiscInfoDescription = getGameCodeOK();
		DiscInfoLaunchable = true;
	elseif infoDisco[2]==12 then --PS2 DVD ESR OFF
		DiscInfoName = "PlayStation 2 (DVD ESR OFF)"
		DiscInfoDescription = "You should launch this game via ESR";
		DiscInfoLaunchable = false;
	elseif infoDisco[2]==13 then --PS2 DVD ESR ON
		DiscInfoName = "PlayStation 2 (DVD ESR ON)"
		DiscInfoDescription = getGameCodeOK();
		DiscInfoLaunchable = true;
	elseif infoDisco[2]==14 then --AudioCD
		DiscInfoName = "Audio CD"
		DiscInfoDescription = "Disc with audio tracks";
		DiscInfoLaunchable = false;
	elseif infoDisco[2]==15 then --DVDVideo
		DiscInfoName = "DVD Video";
		DiscInfoDescription = "Movie in DVD format";
		if infoDisco[1] == 1 then
			DiscInfoName = "PlayStation 2 (DVD ESR OFF)"
			DiscInfoDescription = "You should launch this game via ESR";
		end
		DiscInfoLaunchable = false;
	end
end

InfoDisc = readCDVD()
oldInfoDisc = InfoDisc;
oldInfoDisc[0] = 20000;
if InfoDisc[0] ~= oldInfoDisc[0] then
	setCDVD()
elseif InfoDisc[1] ~= oldInfoDisc[1] then
	setCDVD()
elseif InfoDisc[2] ~= oldInfoDisc[2] then
	setCDVD()
end
oldInfoDisc = InfoDisc;

while true do
	pad = Pads.get();
	
	InfoDisc = readCDVD()
	if InfoDisc[0] ~= oldInfoDisc[0] then
		setCDVD()
	elseif InfoDisc[1] ~= oldInfoDisc[1] then
		setCDVD()
	elseif InfoDisc[2] ~= oldInfoDisc[2] then
		setCDVD()
	end
	oldInfoDisc = InfoDisc;
	
	Screen.clear();
	Graphics.drawRect(0, 0, 1280, 960, Color.new(0, 0, 0, 255))
	Font.fmPrint(30, 30, 0.57, "CROSS: Launch Disc\nSQUARE: Change video mode\n\n"..DiscInfoName.."\n"..DiscInfoDescription.."\n\n"..ErrorString.."\n\n")
	Screen.waitVblankStart()
	Screen.flip()
	
	if Pads.check(pad, PAD_CROSS) and DiscInfoLaunchable == true and not Pads.check(oldpad, PAD_CROSS) then
		Font.fmUnload();
		System.launchCDVD();
		ErrorString = "Error: Can't launch disc";
		Font.fmLoad();
	elseif Pads.check(pad, PAD_SQUARE) and not Pads.check(oldpad, PAD_SQUARE) then
		if imanoVideoMode=="PAL" then
			Screen.setMode(NTSC, 640, 448)
			imanoVideoMode="NTSC"
		else
			Screen.setMode(PAL, 640, 512)
			imanoVideoMode="PAL"
		end
	end
	
	oldpad=pad;
end