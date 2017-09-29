unit UfrmInfo;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, VssDockForm, NumUtils, mp3parser, Menus;

type
  TfrmInfo = class(TVssDockForm)
    InfoBox: TListBox;
    pmList: TPopupMenu;
    mpeCopy: TMenuItem;
    mpeCopyAll: TMenuItem;
    procedure BCloseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure InfoBoxDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormHide(Sender: TObject);
    procedure mpeCopyClick(Sender: TObject);
    procedure mpeCopyAllClick(Sender: TObject);
    procedure pmListPopup(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    TabOffset:integer;
    procedure CopyToClipboard(All : Boolean);

  public
    { Public declarations }
    procedure UpdateInfo;
    procedure DoLocalize ; override;
  end;

var
  frmInfo: TfrmInfo;


implementation
uses Locale, UfrmMain, mplayer, ClipBrd;

{$R *.dfm}

function FormatAspectRatio(const Aspect:real):string;
var Numerator,Denominator:integer;
begin
  str(Aspect:0:2,Result); Result:=Result+':1';
  for Denominator:=1 to 50 do begin
    Numerator:=CorrectRound(Aspect*Denominator);
    if abs(Numerator/Denominator-Aspect)<0.01 then begin

      Result:=IntToStr(Numerator)+':'+IntToStr(Denominator) +
              '  ('+Result+')';

      exit;
    end;
  end;
end;




procedure TfrmInfo.CopyToClipboard(All: Boolean);
var txt, line : string;
  i : integer;
begin
  if All then begin
    txt := '';
    for i := 0 to InfoBox.Items.Count - 1 do begin
      line := InfoBox.Items[i];
      if line[1]='!' then
      line := ^M+^J + copy(line,2,length(line)-1);
      txt := txt + line +^M+^J;
    end;
  end else begin
    if InfoBox.ItemIndex >= 0 then
      txt := InfoBox.Items[infobox.ItemIndex];
  end;

 Clipboard.AsText := txt;
end;

procedure TfrmInfo.DoLocalize;
begin
  inherited;
  Font.Charset:=CurrentLocaleCharset;
  Caption:=LOCstr.InfoFormCaption;
  //BClose.Caption:=LOCstr.InfoFormClose;
  //BCopy.Caption :=LOCstr.InfoFormCopy;
  self.UpdateInfo;
end;

procedure TfrmInfo.BCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmInfo.UpdateInfo;
var HaveTagHeader,HaveVideoHeader,HaveAudioHeader, HaveSubHeader : boolean;
    W,i:integer; st, audioheader, subheader :string;
    Streaminfo : Tstreaminfo;
    Mp3Info : TMp3info;
  procedure AddHeader(var Flag:boolean; const Caption:WideString); begin
    if Flag then exit;
    InfoBox.Items.Add('!'+Caption);
    Flag:=true;
  end;
  procedure AddItem(const Key:WideString; const Value:string); begin
    W:=Canvas.TextWidth(Key);
    if W>TabOffset then TabOffset:=W;
    InfoBox.Items.Add(Key+^I+Value);
  end;
  procedure T(const Key:WideString; const Value:string);
    begin AddHeader(HaveTagHeader,LOCstr.InfoTags); AddItem(Key,Value); end;
  procedure V(const Key:WideString; const Value:string);
    begin AddHeader(HaveVideoHeader,LOCstr.InfoVideo); AddItem(Key,Value); end;
  procedure A(const Key:WideString; const Value:string);
    begin AddHeader(HaveAudioHeader,audioheader); AddItem(Key,Value); end;
  procedure S(const Key:WideString; const Value:string);
    begin AddHeader(HaveSubHeader,subheader); AddItem(Key,Value); end;
begin
  Streaminfo := frmMain.mpo.StreamInfo;
  Mp3Info := frmMain.mpo.Mp3Info;
  with Streaminfo do begin
    if not Visible then exit;
    InfoBox.Items.Clear;
    TabOffset:=0;
    if not frmMain.mpo.ValidFileInfo  then begin
      InfoBox.Items.Add(LOCstr.NoInfo);
      exit;
    end;
    HaveTagHeader:=false;
    HaveVideoHeader:=false;
    HaveAudioHeader:=false;
    HaveSubHeader := false;
    InfoBox.Items.Add(FileName);
    if length(FileFormat)>0 then
      InfoBox.Items.Add(LOCstr.InfoFileFormat+^I+FileFormat);
    if length(DurationString)>0 then
      InfoBox.Items.Add(LOCstr.InfoPlaybackTime+^I+DurationString);
    InfoBox.Items.Add(LOCstr.InfoFilesize +^I+ GetSizeString(stream.length) + 'b ('
                        + formatCurr(',0', stream.length) +' bytes)');

    i := frmMain.mpo.AudioIDS.ActualIndex +1;

    audioheader := LOCstr.InfoAudio + '    ('+
                   LOCstr.InfoTrack + ': ' + inttostr(i) + '/' +
                                              inttostr(frmMain.mpo.AudioIDS.Count) +')';

    for i:=0 to 9 do
      with ClipInfo[i] do
        if (length(Key)>0) AND (length(Value)>0) then
          T(Key, Value);
    if length(Video.Decoder)>0 then
      V(LOCstr.InfoDecoder, Video.Decoder);
    if length(Video.Codec)>0 then
      V(LOCstr.InfoCodec, Video.Codec);
    if length(Video.Fourcc) > 0 then
      V('Fourcc',Video.Fourcc);
    if Video.Bitrate<>0 then
      V(LOCstr.InfoBitrate, IntToStr(Video.Bitrate DIV 1000)+' kbps');
    if (Video.Width<>0) AND (Video.Height<>0) then begin
      V(LOCstr.InfoVideoSize, IntToStr(Video.Width)+' x '+IntToStr(Video.Height));
      if Video.Interlaced  then
        st := LOCstr.InfoVideoInt
      else
        st := LOCstr.InfoVideoPro;
      V(LOCstr.InfoInterlace,st);
    end;
    if (Video.FPS>0.01) then begin
      str(Video.FPS:0:3,st); V(LOCstr.InfoVideoFPS, st+' fps'); end;


    if (Video.Autoaspect >0.01) then begin
      V(LOCstr.InfoVideoAspect, FormatAspectRatio(Video.Autoaspect)); end;
    if length(Audio.Decoder)>0 then
      A(LOCstr.InfoDecoder, Audio.Decoder);
    if length(Audio.Codec)>0 then
      A(LOCstr.InfoCodec, Audio.Codec);

    st := '';
    if Audio.Bitrate<>0 then
      st := IntToStr(Audio.Bitrate DIV 1000);
    if IsMp3 and (not Havevideo) and (Mp3Info.VbrBitRate > 0) then
      st := st + ' (' + inttostr(mp3info.VbrBitRate div 1000) + ' VBR)' ;
    if st <>'' then
      A(LOCstr.InfoBitrate, st +' kbps');


    if Audio.Rate<>0 then
      A(LOCstr.InfoAudioRate, IntToStr(Audio.Rate)+' Hz');
    if Audio.Channels<>0 then
      A(LOCstr.InfoAudioChannels, IntToStr(Audio.Channels));


    if frmMain.mpo.SubIDS.Count >0 then begin
      i := frmMain.mpo.SubIDS.ActualIndex;
      subheader := LOCstr.InfoSub + '    ('+
                   LOCstr.InfoTrack + ': ' + inttostr(i) + '/' +
                                              inttostr(frmMain.mpo.SubIDS.Count-1) +')';

      for i := 1 to frmMain.mpo.SubIDS.Count-1 do begin
        st := frmMain.mpo.SubIDS.Items[i].Text;
        if frmMain.mpo.SubIDS.Items[i].lang <> '' then
          st := st + ' - (' + frmMain.mpo.SubIDS.Items[i].lang  + ')';
      
        S(inttostr(i), st);
      end;
    end;

  end;
end;

procedure TfrmInfo.FormShow(Sender: TObject);
begin
  UpdateInfo;
  frmMain.MStreamInfo.Checked:=True;
  frmMain.BStreamInfo.Down:=True;
end;

procedure TfrmInfo.FormHide(Sender: TObject);
begin
  frmMain.MStreamInfo.Checked:=False;
  frmMain.BStreamInfo.Down:=False;
end;

procedure TfrmInfo.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if ord(Key) = VK_ESCAPE then
    Close;
end;

procedure TfrmInfo.InfoBoxDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var s:string; p:integer;
begin with InfoBox.Canvas do begin
  s:=InfoBox.Items[Index];
  if s[1]='!' then begin
    Brush.Color:=clBtnFace;
    Font.Color:=clBtnText;
    Font.Style:=Font.Style+[fsBold];
    FillRect(Rect);
    TextOut(Rect.Left+2, Rect.Top+1, Copy(s,2,length(s)));
    exit;
  end;
  p:=Pos(^I,s);
  FillRect(Rect);
  if p>0 then begin
    TextOut(Rect.Left+2, Rect.Top+1, Copy(s,1,p-1));
    TextOut(Rect.Left+TabOffset+10, Rect.Top+1, Copy(s,p+1,length(s)));
  end else
    TextOut(Rect.Left+2, Rect.Top+1, s);
end; end;




procedure TfrmInfo.mpeCopyAllClick(Sender: TObject);
begin
  CopyToClipboard(True);
end;

procedure TfrmInfo.mpeCopyClick(Sender: TObject);
begin
  CopyToClipboard(False);
end;

procedure TfrmInfo.pmListPopup(Sender: TObject);
begin
  mpeCopy.Enabled := InfoBox.ItemIndex >= 0;
  mpeCopyAll.Enabled := InfoBox.Items.Count> 0;

end;

end.