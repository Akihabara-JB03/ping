[Setup]
AppName=ピンポン [beta 0.021]
AppVersion=beta 0.021
DefaultDirName={autopf}\PingPongGame
DefaultGroupName=Ping Pong
OutputBaseFilename=PingPong_Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
Encryption=yes
Password=0000
LicenseFile="C:\Users\Owner\Desktop\c_edu\c\pingpong\pingpong-\License"

[Files]
; 1. 必要な3つのzipファイルだけをインストーラーに入れます（全部入りzipは除外！）
Source: "C:\Users\Owner\Desktop\c_edu\c\pingpong\pingpong.zip";                 DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Owner\Desktop\c_edu\c\pingpong\pingpong-kyouryoku2.zip";      DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Owner\Desktop\c_edu\c\pingpong\pingpong-kyouryoku2-hard.zip"; DestDir: "{app}"; Flags: ignoreversion
[Icons]
; WorkingDir（作業フォルダ）を指定して、ゲームがmp3を見つけられるようにします！
Name: "{autodesktop}\ピンポン 通常版";      Filename: "{app}\Normal\pingpong.exe";      WorkingDir: "{app}\Normal"
Name: "{autodesktop}\ピンポン 協力モード";  Filename: "{app}\Kyouryoku\pingpong-\pingpong.exe";  WorkingDir: "{app}\Kyouryoku\pingpong-"
Name: "{autodesktop}\ピンポン 協力ハード";  Filename: "{app}\Hard\pingpong-\pingpong.exe";      WorkingDir: "{app}\Hard\pingpong-"

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
    // まだフォルダがない場合は自動で作る
    ForceDirectories(TargetSubPath);
    
    ZipFile := ShellApp.NameSpace(ZipPath);
    TargetFolder := ShellApp.NameSpace(TargetSubPath);
    
    // 専用フォルダの中に解凍するから、名前が同じ「pingpong.exe」でも絶対に安全！
    TargetFolder.CopyHere(ZipFile.Items, 4 or 16);
    
    // 解凍が終わったらゴミになったzipを消す
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

      // それぞれ「Normal」「Kyouryoku」「Hard」という別々のフォルダに全自動で解凍！
      UnzipToSubFolder(ShellApp, AppPath, 'pingpong.zip', 'Normal');
      UnzipToSubFolder(ShellApp, AppPath, 'pingpong-kyouryoku2.zip', 'Kyouryoku');
      UnzipToSubFolder(ShellApp, AppPath, 'pingpong-kyouryoku2-hard.zip', 'Hard');

    except
      MsgBox('zipファイルの自動展開中にエラーが発生しました。', mbError, MB_OK);
    end;
  end;
end;

