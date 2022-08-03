// Eduardo - 02/08/2022
unit PPEditor.Principal;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls, 
  Vcl.ExtDlgs;

type
  TPrincipal = class(TForm)
    lbxImagens: TListBox;
    OpenDialog: TOpenDialog;
    sbarInformacao: TStatusBar;
    pnlTop: TPanel;
    btnAbrir: TButton;
    lbArquivo: TLabel;
    btnSalvar: TButton;
    sptDivisor: TSplitter;
    pnlClient: TPanel;
    imgImagem: TImage;
    pnlTopImagem: TPanel;
    btnLimpar: TButton;
    btnSalvarImagem: TButton;
    SavePictureDialog: TSavePictureDialog;
    btnSubstituir: TButton;
    procedure btnAbrirClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbxImagensClick(Sender: TObject);
    procedure btnLimparClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnSalvarImagemClick(Sender: TObject);
    procedure btnSubstituirClick(Sender: TObject);
    function FormHelp(Command: Word; Data: NativeInt; var CallHelp: Boolean): Boolean;
  private
    FImg: TObjectDictionary<String, TMemoryStream>;
  end;

var
  Principal: TPrincipal;

implementation

uses
  System.Zip,
  System.StrUtils,
  System.Math,
  System.Types,
  Vcl.Imaging.pngimage,
  Winapi.ShellAPI,
  Winapi.Windows;

{$R *.dfm}

procedure TPrincipal.FormCreate(Sender: TObject);
begin
  FImg := TObjectDictionary<String, TMemoryStream>.Create([doOwnsValues]);
end;

procedure TPrincipal.FormDestroy(Sender: TObject);
begin
  FImg.DisposeOf;
end;

function TPrincipal.FormHelp(Command: Word; Data: NativeInt; var CallHelp: Boolean): Boolean;
begin
  ShellExecute(Handle, 'open', PChar('https://github.com/e-delphi/PPEditor'), nil, nil, SW_SHOW);
  Result := True;
end;

procedure TPrincipal.btnAbrirClick(Sender: TObject);
var
  zip: TZipFile;
  dados: TBytes;
  stream: TMemoryStream;
begin
  OpenDialog.Filter := 'Microsoft Power Point|*.pptx';
  if not OpenDialog.Execute then
    Exit;

  lbArquivo.Caption := OpenDialog.FileName;

  FImg.Clear;
  lbxImagens.Items.Clear;
  
  zip := TZipFile.Create;
  try
    zip.Open(OpenDialog.FileName, zmRead);
    for var Item in zip.FileNames do
    begin
      if not MatchStr(ExtractFileExt(Item), ['.bmp', '.jpg', '.jpeg', '.png']) then
        Continue;

      zip.Read(Item, dados);

      stream := TMemoryStream.Create;
      if length(dados) > 0 then
        stream.WriteBuffer(dados[0], Length(dados));

      FImg.AddOrSetValue(Item, stream);
      
      lbxImagens.Items.Add(Item);
    end;
    if lbxImagens.Count > 0 then
    begin
      lbxImagens.Selected[0] := True;
      lbxImagensClick(lbxImagens);
    end;

    zip.Close;
  finally
    zip.DisposeOf;
  end;
end;

function ConvertBytes(Bytes: Int64): string;
const
  Description: Array [0 .. 8] of string = ('Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB');
var
  i: Integer;
begin
  i := 0;

  while Bytes > Power(1024, i + 1) do
    Inc(i);

  Result := FormatFloat('###0.##', Bytes / Power(1024, i)) + #32 + Description[i];
end;

procedure TPrincipal.lbxImagensClick(Sender: TObject);
var
  stream: TMemoryStream;
  wic: TWICImage;
begin
  if FImg.Count = 0 then
    Exit;
    
  if not FImg.TryGetValue(lbxImagens.Items[lbxImagens.ItemIndex], stream) then 
    Exit;

  if not Assigned(stream) then
    Exit;

  wic := TWICImage.Create;
  try
    wic.LoadFromStream(stream);
    imgImagem.Picture.Assign(wic);
    
    sbarInformacao.Panels[1].Text := wic.Width.ToString +'x'+ wic.Height.ToString; 
    sbarInformacao.Panels[3].Text := ConvertBytes(stream.Size); 

    btnSalvarImagem.Enabled := True;
    btnSubstituir.Enabled := True;
    btnLimpar.Enabled := True;
  finally
    wic.DisposeOf;
  end;
end;

procedure TPrincipal.btnLimparClick(Sender: TObject);
var
  stream: TMemoryStream;
  png: TPngImage;
  Size: TStringDynArray;
begin
  if FImg.Count = 0 then
    Exit;

  Size := SplitString(sbarInformacao.Panels[1].Text, 'x');
    
  png := TPngImage.CreateBlank(COLOR_PALETTE, 1, Size[0].ToInteger, Size[1].ToInteger);
  try
    png.TransparentColor := clBlack;
    png.Transparent := True;
    stream := TMemoryStream.Create;
    png.SaveToStream(stream);
    FImg.AddOrSetValue(lbxImagens.Items[lbxImagens.ItemIndex], stream);
  finally
    png.DisposeOf;
  end; 

  btnSalvar.Enabled := True;

  lbxImagensClick(lbxImagens);
end;

procedure TPrincipal.btnSalvarClick(Sender: TObject);
var
  izip: TZipFile;
  ozip: TZipFile;
  dados: TBytes;
  stream: TMemoryStream;
begin
  izip := TZipFile.Create;
  ozip := TZipFile.Create;
  try
    izip.Open(lbArquivo.Caption, zmRead);
    ozip.Open(ExtractFilePath(lbArquivo.Caption) +'novo-'+ ExtractFileName(lbArquivo.Caption), zmWrite);

    for var Item in izip.FileNames do
    begin
      izip.Read(Item, dados);

      if not MatchStr(ExtractFileExt(Item), ['.bmp', '.jpg', '.jpeg', '.png']) then
      begin
        ozip.Add(dados, Item);
        Continue;
      end;

      if FImg.TryGetValue(Item, stream) then
      begin
        dados := [];
        stream.Position := 0;
        SetLength(dados, stream.Size);
        stream.ReadBuffer(Pointer(dados)^, stream.Size)
      end;

      ozip.Add(dados, Item)
    end;

    izip.Close;
    ozip.Close;
  finally
    izip.DisposeOf;
    ozip.DisposeOf;
  end;
  
  btnSalvar.Enabled := False;
end;

procedure TPrincipal.btnSalvarImagemClick(Sender: TObject);
begin
  SavePictureDialog.FileName := ExtractFileName(lbxImagens.Items[lbxImagens.ItemIndex].Replace('/', '\'));
  SavePictureDialog.Filter := 'Original (*'+ ExtractFileExt(SavePictureDialog.FileName) +')|*'+ ExtractFileExt(SavePictureDialog.FileName);

  if not SavePictureDialog.Execute then
    Exit;

  imgImagem.Picture.SaveToFile(SavePictureDialog.FileName);
end;

procedure TPrincipal.btnSubstituirClick(Sender: TObject);
var
  stream: TMemoryStream;
  wic: TWICImage;
begin
  OpenDialog.Filter := 'Imagens|*.bmp;*.jpg;*.jpeg;*.png';
  if not OpenDialog.Execute then
    Exit;

  wic := TWICImage.Create;
  try
    wic.LoadFromFile(OpenDialog.FileName);
    stream := TMemoryStream.Create;
    wic.SaveToStream(stream);
    FImg.AddOrSetValue(lbxImagens.Items[lbxImagens.ItemIndex], stream);
  finally
    wic.DisposeOf;
  end;

  btnSalvar.Enabled := True;

  lbxImagensClick(lbxImagens);
end;

end.
