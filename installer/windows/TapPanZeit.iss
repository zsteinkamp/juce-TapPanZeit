; Inno Setup script: installs TapPanZeit.vst3 into the standard
; C:\Program Files\Common Files\VST3 folder.
;   iscc /DAppVersion=1.0 installer\windows\TapPanZeit.iss

#ifndef AppVersion
  #define AppVersion "0.0.0"
#endif

[Setup]
AppId={{F6C0C2E4-61D3-4635-8F95-DDB373C9CDB3}
AppName=TapPanZeit
AppVersion={#AppVersion}
AppPublisher=Zack Steinkamp
AppPublisherURL=https://github.com/zsteinkamp/juce-TapPanZeit
DefaultDirName={commoncf64}\VST3
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyPage=no
UsePreviousAppDir=no
; Keep the uninstaller out of the VST3 folder so DAW scanners don't trip on it.
UninstallFilesDir={commonpf64}\Zack Steinkamp\TapPanZeit
UninstallDisplayName=TapPanZeit (VST3)
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin
WizardStyle=modern
Compression=lzma2
SolidCompression=yes
OutputDir=..\..\dist
OutputBaseFilename=TapPanZeit-{#AppVersion}-Windows-Setup

[Files]
Source: "..\..\build\TapPanZeit_artefacts\Release\VST3\TapPanZeit.vst3\*"; DestDir: "{commoncf64}\VST3\TapPanZeit.vst3"; Flags: ignoreversion recursesubdirs createallsubdirs

[UninstallDelete]
Type: filesandordirs; Name: "{commoncf64}\VST3\TapPanZeit.vst3"

[Messages]
FinishedLabel=TapPanZeit has been installed into C:\Program Files\Common Files\VST3.%n%nRescan plug-ins in your DAW; it's listed under Zack Steinkamp.
