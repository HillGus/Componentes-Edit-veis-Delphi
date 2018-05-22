unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, uFrmExpecific, unitTeste;

type

  TForm1 = class(TForm)
    Button2: TButton;
    Label1: TLabel;
    procedure gerenciarFuncoes(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure resizeObject(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure moveObject(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure doAction(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure stopAction(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ResetCursor(Sender: TObject);
    procedure startConfig(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

  implementation

{$R *.dfm}

end.
