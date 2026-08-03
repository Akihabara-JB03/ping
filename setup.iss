[Setup]
AppName=ピンポン [beta 0.03]
AppVersion=beta 0.03
DefaultDirName={autopf}\PingPongGame
DefaultGroupName=Ping Pong
OutputBaseFilename=PingPong_Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
Encryption=yes
Password=0000
; 【修正】相対パスで直接指定します。これで自分のPCでもGitHubでも正しく読み込めます！
LicenseFile=License

[Files]
; 【修正】Filesセクションもシンプルに相対パスに直しました！
Source: "pingpong.zip";                 DestDir: "{app}"; Flags: ignoreversion
Source: "pingpong-kyouryoku2.zip";      DestDir: "{app}"; Flags: ignoreversion
Source: "pingpong-kyouryoku2-hard.zip"; DestDir: "{app}"; Flags: ignoreversion
; 🆕 Luaオンライン版のzipを追加！
Source: "online-Pingpong.zip";          DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autodesktop}\ピンポン 通常版";     Filename: "{app}\Normal\pingpong.exe";     WorkingDir: "{app}\Normal"
Name: "{autodesktop}\ピンポン 協力モード"; Filename: "{app}\Kyouryoku\pingpong-\pingpong.exe"; WorkingDir: "{app}\Kyouryoku\pingpong-"
Name: "{autodesktop}\ピンポン 協力ハード"; Filename: "{app}\Hard\pingpong-\pingpong.exe";     WorkingDir: "{app}\Hard\pingpong-"
; 🆕 オンライン版のショートカットを追加！
; (※zip内のexeの相対パスに合わせて `pingpong.exe` または `pingpong-\pingpong.exe` に調整してください)
Name: "{autodesktop}\ピンポン オンライン版"; Filename: "{app}\Online\pingpong.exe";     WorkingDir: "{app}\Online"

[Code]
// =======================================================
// 【上書き対策】指定した専用のサブフォルダに解凍して、zipを消す関数
// =======================================================
procedure UnzipToSubFolder(ShellApp: Variant; AppPath: String; ZipFileName: String; FolderName: String);
var
  ZipPath: String;
  TargetSubPath: String;
  ZipFile: Variant;
  TargetFolder: Variant;
begin
  ZipPath := AppPath + '\' + ZipFileName;
  TargetSubPath := AppPath + '\' + FolderName;
  
  if FileExists(ZipPath) then
  begin
    ForceDirectories(TargetSubPath);
    
    ZipFile := ShellApp.NameSpace(ZipPath);
    TargetFolder := ShellApp.NameSpace(TargetSubPath);
    
    TargetFolder.CopyHere(ZipFile.Items, 4 or 16);
    
    DeleteFile(ZipPath);
  end;
end;

// =======================================================
// ファイルコピー完了後に動く自動展開イベント
// =======================================================
procedure CurStepChanged(CurStep: TSetupStep);
var
  ShellApp: Variant;
  AppPath: String;
begin
  if CurStep = ssPostInstall then
  begin
    AppPath := ExpandConstant('{app}');

    try
      ShellApp := CreateOleObject('Shell.Application');

      UnzipToSubFolder(ShellApp, AppPath, 'pingpong.zip', 'Normal');
      UnzipToSubFolder(ShellApp, AppPath, 'pingpong-kyouryoku2.zip', 'Kyouryoku');
      UnzipToSubFolder(ShellApp, AppPath, 'pingpong-kyouryoku2-hard.zip', 'Hard');
      // 🆕 オンライン版の解凍処理を追加！
      UnzipToSubFolder(ShellApp, AppPath, 'online-Pingpong.zip', 'Online');

    except
      MsgBox('zipファイルの自動展開中にエラーが発生しました。', mbError, MB_OK);
    end;
  end;
end;
