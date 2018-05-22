program Project1;

uses
  Forms,
  uFrmMain in 'uFrmMain.pas' {Form1},
  uFrmExpecific in 'uFrmExpecific.pas' {Form2},
  unitTeste in 'unitTeste.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
