; RubyInstaller - InnoSetup Script (base)
; This script is used to build Ruby Installers for Windows

; PRE-CHECK
; Verify that RubyPath, RubyVersion, and RubyPath are defined by ISCC using
; /d command line arguments.
;
; Usage:
;  iscc rubyinstaller.iss /dRubyVersion=X.Y.Z /dRubyPatch=123; \
;                         /dRubyPath=sandbox/ruby
;                         [/dInstVersion=26-OCT-2009]

#if Defined(RubyVersion) == 0
  #error Please provide a RubyVersion definition using a /d parameter.
#endif

#if Defined(RubyPatch) == 0
  #error Please provide a RubyPatch level definition using a /d parameter.
#endif

#if Defined(RubyPath) == 0
  #error Please provide a RubyPath value to the Ruby files using a /d parameter.
#else
  #if FileExists(RubyPath + '\bin\ruby.exe') == 0
    #error No Ruby installation (bin\ruby.exe) found inside defined RubyPath. Please verify.
  #endif
#endif

#if Defined(InstVersion) == 0
  #define InstVersion GetDateTimeString('dd-mmm-yy"T"hhnn', '', '')
#endif

; Grab MAJOR.MINOR info from RubyVersion (1.8)
#define RubyMajorMinor Copy(RubyVersion, 1, 3)
#define RubyFullVersion RubyVersion + '-p' + RubyPatch

; Build Installer details using above values
#define InstallerName "Ruby " + RubyFullVersion
#define InstallerPublisher "RubyInstaller Team"
#define InstallerHomepage "http://rubyinstaller.org"

#define CurrentYear GetDateTimeString('yyyy', '', '')

; INCLUDE
; Include dynamically created version specific definitions
#define InstallerConfigFile "config-" + RubyVersion + ".iss"
#include InstallerConfigFile

#define RubyInstallerBaseId "MRI"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications!
AppName={#InstallerName}
AppVerName={#InstallerName}
AppPublisher={#InstallerPublisher}
AppPublisherURL={#InstallerHomepage}
AppVersion={#RubyFullVersion}
DefaultGroupName={#InstallerName}
DisableProgramGroupPage=true
LicenseFile=LICENSE.txt
Compression=lzma2/ultra64
SolidCompression=true
AlwaysShowComponentsList=false
DisableReadyPage=true
InternalCompressLevel=ultra64
VersionInfoCompany={#InstallerPublisher}
VersionInfoCopyright=(c) {#CurrentYear} {#InstallerPublisher}
VersionInfoDescription=Ruby Programming Language for Windows
VersionInfoTextVersion={#RubyFullVersion}
VersionInfoVersion={#RubyVersion}.{#RubyPatch}
UninstallDisplayIcon={app}\bin\ruby.exe
WizardImageFile={#SourcePath}\images\wizard-large.bmp
WizardSmallImageFile={#SourcePath}\images\wizard-logo.bmp
PrivilegesRequired=lowest
ChangesAssociations=yes
ChangesEnvironment=yes
MinVersion=0,5.1.2600
#if Defined(SignPackage) == 1
SignTool=risigntool sign /a /d $q{#InstallerName}$q /du $q{#InstallerHomepage}$q /t $qhttp://timestamp.comodoca.com/authenticode$q $f
#endif

[Languages]
Name: en; MessagesFile: compiler:Default.isl

[Messages]
en.WelcomeLabel1=Welcome to the [name] Installer
en.WelcomeLabel2=This will install [name/ver] on your computer. Please close all other applications before continuing.
en.WizardLicense={#InstallerName} License Agreement
en.LicenseLabel=
en.LicenseLabel3=Please read the following License Agreement and accept the terms before continuing the installation.
en.LicenseAccepted=I &accept the License
en.LicenseNotAccepted=I &decline the License
en.WizardSelectDir=Installation Destination and Optional Tasks
en.SelectDirDesc=
en.SelectDirLabel3=Setup will install [name] into the following folder. Click Install to continue or click Browse to use a different one.
en.SelectDirBrowseLabel=Please avoid any folder name that contains spaces (e.g. Program Files).
en.DiskSpaceMBLabel=Required free disk space: ~[mb] MB

[Files]
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: {#RubyPath}\*; DestDir: {app}; Flags: recursesubdirs createallsubdirs
Source: ..\..\sandbox\book\bookofruby.pdf; DestDir: {app}\doc
Source: setrbvars.bat; DestDir: {app}\bin

[Registry]
; .rb file for admin
Root: HKLM; Subkey: Software\Classes\.rb; ValueType: string; ValueName: ; ValueData: RubyFile; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsAdmin and IsAssociated
Root: HKLM; Subkey: Software\Classes\RubyFile; ValueType: string; ValueName: ; ValueData: Ruby File; Flags: uninsdeletekey; Check: IsAdmin and IsAssociated
Root: HKLM; Subkey: Software\Classes\RubyFile\DefaultIcon; ValueType: string; ValueName: ; ValueData: {app}\bin\ruby.exe,0; Check: IsAdmin and IsAssociated
Root: HKLM; Subkey: Software\Classes\RubyFile\shell\open\command; ValueType: string; ValueData: """{app}\bin\ruby.exe"" ""%1"" %*"; Check: IsAdmin and IsAssociated

; .rbw file for admin
Root: HKLM; Subkey: Software\Classes\.rbw; ValueType: string; ValueName: ; ValueData: RubyWFile; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsAdmin and IsAssociated
Root: HKLM; Subkey: Software\Classes\RubyWFile; ValueType: string; ValueName: ; ValueData: RubyW File; Flags: uninsdeletekey; Check: IsAdmin and IsAssociated
Root: HKLM; Subkey: Software\Classes\RubyWFile\DefaultIcon; ValueType: string; ValueName: ; ValueData: {app}\bin\rubyw.exe,0; Check: IsAdmin and IsAssociated
Root: HKLM; Subkey: Software\Classes\RubyWFile\shell\open\command; ValueType: string; ValueName: ; ValueData: """{app}\bin\rubyw.exe"" ""%1"" %*"; Check: IsAdmin and IsAssociated

; .rb file for non-admin
Root: HKCU; Subkey: Software\Classes\.rb; ValueType: string; ValueName: ; ValueData: RubyFile; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsNotAdmin and IsAssociated
Root: HKCU; Subkey: Software\Classes\RubyFile; ValueType: string; ValueName: ; ValueData: Ruby File; Flags: uninsdeletekey; Check: IsNotAdmin and IsAssociated
Root: HKCU; Subkey: Software\Classes\RubyFile\DefaultIcon; ValueType: string; ValueName: ; ValueData: {app}\bin\ruby.exe,0; Check: IsNotAdmin and IsAssociated
Root: HKCU; Subkey: Software\Classes\RubyFile\shell\open\command; ValueType: string; ValueName: ; ValueData: """{app}\bin\ruby.exe"" ""%1"" %*"; Check: IsNotAdmin and IsAssociated

; .rbw file for non-admin
Root: HKCU; Subkey: Software\Classes\.rbw; ValueType: string; ValueName: ; ValueData: RubyWFile; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsNotAdmin and IsAssociated
Root: HKCU; Subkey: Software\Classes\RubyWFile; ValueType: string; ValueName: ; ValueData: RubyW File; Flags: uninsdeletekey; Check: IsNotAdmin and IsAssociated
Root: HKCU; Subkey: Software\Classes\RubyWFile\DefaultIcon; ValueType: string; ValueName: ; ValueData: {app}\bin\rubyw.exe,0; Check: IsNotAdmin and IsAssociated
Root: HKCU; Subkey: Software\Classes\RubyWFile\shell\open\command; ValueType: string; ValueData: """{app}\bin\rubyw.exe"" ""%1"" %*"; Check: IsNotAdmin and IsAssociated

; RubyInstaller identification for admin
Root: HKLM; Subkey: Software\RubyInstaller; ValueType: string; ValueName: ; ValueData: ; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsAdmin
Root: HKLM; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}; ValueType: string; ValueName: ; ValueData: ; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsAdmin
Root: HKLM; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: ; ValueData: ; Flags: uninsdeletekey; Check: IsAdmin
Root: HKLM; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: InstallLocation ; ValueData: {app}; Check: IsAdmin
Root: HKLM; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: InstallDate ; ValueData: {code:GetInstallDate}; Check: IsAdmin
Root: HKLM; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: PatchLevel ; ValueData: {#RubyPatch}; Check: IsAdmin
Root: HKLM; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: BuildPlatform ; ValueData: {#RubyBuildPlatform}; Check: IsAdmin

; RubyInstaller identification for non-admin
Root: HKCU; Subkey: Software\RubyInstaller; ValueType: string; ValueName: ; ValueData: ; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsNotAdmin
Root: HKCU; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}; ValueType: string; ValueName: ; ValueData: ; Flags: uninsdeletevalue uninsdeletekeyifempty; Check: IsNotAdmin
Root: HKCU; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: ; ValueData: ; Flags: uninsdeletekey; Check: IsNotAdmin
Root: HKCU; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: InstallLocation ; ValueData: {app}; Check: IsNotAdmin
Root: HKCU; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: InstallDate ; ValueData: {code:GetInstallDate}; Check: IsNotAdmin
Root: HKCU; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: PatchLevel ; ValueData: {#RubyPatch}; Check: IsNotAdmin
Root: HKCU; Subkey: Software\RubyInstaller\{#RubyInstallerBaseId}\{#RubyVersion}; ValueType: string; ValueName: BuildPlatform ; ValueData: {#RubyBuildPlatform}; Check: IsNotAdmin

[Icons]
Name: {group}\Documentation\The Book of Ruby; Filename: {app}\doc\bookofruby.pdf; Flags: createonlyiffileexists
Name: {group}\Interactive Ruby; Filename: {app}\bin\irb.bat; IconFilename: {app}\bin\ruby.exe; Flags: createonlyiffileexists
Name: {group}\RubyGems Documentation Server; Filename: {app}\bin\gem.bat; Parameters: server --launch; IconFilename: {app}\bin\ruby.exe; Flags: createonlyiffileexists runminimized
Name: {group}\Start Command Prompt with Ruby; Filename: {sys}\cmd.exe; Parameters: /E:ON /K {app}\bin\setrbvars.bat; WorkingDir: {%HOMEDRIVE}{%HOMEPATH}; IconFilename: {sys}\cmd.exe; Flags: createonlyiffileexists
Name: {group}\{cm:UninstallProgram,{#InstallerName}}; Filename: {uninstallexe}

[Code]
#include "util.iss"
#include "ri_gui.iss"

function GetInstallDate(Param: String): String;
begin
  Result := GetDateTimeString('yyyymmdd', #0 , #0);
end;

procedure CurStepChanged(const CurStep: TSetupStep);
begin

  // TODO move into ssPostInstall just after install completes?
  if CurStep = ssInstall then
  begin
    if UsingWinNT then
    begin
      Log(Format('Selected Tasks - Path: %d, Associate: %d', [PathChkBox.State, PathExtChkBox.State]));

      if IsModifyPath then
        ModifyPath([ExpandConstant('{app}') + '\bin']);

      if IsAssociated then
        ModifyFileExts(['.rb', '.rbw']);

    end else
      MsgBox('Looks like you''ve got on older, unsupported Windows version.' #13 +
             'Proceeding with a reduced feature set installation.',
             mbInformation, MB_OK);
  end;
end;

procedure RegisterPreviousData(PreviousDataKey: Integer);
begin
  {* store install choices so we can use during uninstall *}
  if IsModifyPath then
    SetPreviousData(PreviousDataKey, 'PathModified', 'yes');
  if IsAssociated then
    SetPreviousData(PreviousDataKey, 'FilesAssociated', 'yes');

  SetPreviousData(PreviousDataKey, 'RubyInstallerId', ExpandConstant('{#RubyInstallerBaseId}\{#RubyVersion}'));
end;

procedure CurUninstallStepChanged(const CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
  begin
    if UsingWinNT then
    begin
      if GetPreviousData('PathModified', 'no') = 'yes' then
        ModifyPath([ExpandConstant('{app}') + '\bin']);

      if GetPreviousData('FilesAssociated', 'no') = 'yes' then
        ModifyFileExts(['.rb', '.rbw']);

    end;
  end;
end;
