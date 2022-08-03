program PPEditor;

uses
  Vcl.Forms,
  PPEditor.Principal in 'PPEditor.Principal.pas' {Principal};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TPrincipal, Principal);
  Application.Run;
end.
