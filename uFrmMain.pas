unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, uFrmExpecific;

type

  Bounds = record
    XIni: integer;
    XFim: integer;
    YIni: integer;
    YFim: integer;
  end;

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
    procedure iniciar(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  frm: TForm1;
  obj : TObject;
  objs : array of TObject;
  objBounds, objStaticBounds : Bounds;
  acao : procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;
  objMouseC : procedure(Sender: TObject) of object;
  objMouseDU : array[0..1] of procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  objMouseL : procedure(Sender: TObject) of object;
  objMouseM : procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;

procedure objsAppend(const value: TObject);
begin
    SetLength(objs, length(objs) + 1);
    objs[high(objs)] := value;
end;

procedure TForm1.iniciar(Sender: TObject);
begin
    frm := TForm1(Sender);

    objsAppend(frm.Button2);
    objsAppend(frm.Label1);
end;

function getLocation(Sender: TObject) : integer;
var X, Y, local, borda : integer;
begin

    local := 0;
    borda := 7;

    X := TButton(Sender).ScreenToClient(Mouse.CursorPos).X;
    Y := TButton(Sender).ScreenToClient(Mouse.CursorPos).Y;

    if (X < borda) then begin
        local := 1;
    end
    else
    begin
      if (X > TButton(Sender).Width - borda) then begin
          local := 3;
      end
      else
          local := 2;
    end;

    if (Y < borda) then begin
        local := local;
    end
    else
    begin
      if (Y > TButton(Sender).Height - borda) then begin
          local := local + 6;
      end
      else
          local := local + 3;
    end;

    Result := local;
end;

function getBounds(Sender: TObject) : Bounds;
begin

    Result.XIni := TButton(Sender).Left;
    Result.YIni := TButton(Sender).Top;
    Result.XFim := TButton(Sender).Left + TButton(Sender).Width;
    Result.YFim := TButton(Sender).Top + TButton(Sender).Height;

end;

function getStaticBounds(const XIni, YIni, XFim, YFim: integer) : Bounds;
begin

    Result.XIni := XIni;
    Result.YIni := YIni;
    Result.XFim := XFim;
    Result.YFim := YFim;

end;

procedure setFuncao(local: integer);
begin
    case local of

      1: begin
        Screen.Cursor := crSizeNWSE;
        objStaticBounds := getStaticBounds(0, 0, 1, 1);
        acao := frm.resizeObject;
      end;
      2: begin
        Screen.Cursor := crSizeNS;
        objStaticBounds := getStaticBounds(1, 0, 1, 1);
        acao := frm.resizeObject;
      end;
      3: begin
        Screen.Cursor := crSizeNESW;
        objStaticBounds := getStaticBounds(1, 0, 0, 1);
        acao := frm.resizeObject;
      end;
      4: begin
        Screen.Cursor := crSizeWE;
        objStaticBounds := getStaticBounds(0, 1, 1, 1);
        acao := frm.resizeObject;
      end;
      5: begin
        Screen.Cursor := crSize;
        acao := frm.moveObject;
      end;
      6: begin
        Screen.Cursor := crSizeWE;
        objStaticBounds := getStaticBounds(1, 1, 0, 1);
        acao := frm.resizeObject;
      end;
      7: begin
        Screen.Cursor := crSizeNESW;
        objStaticBounds := getStaticBounds(0, 1, 1, 0);
        acao := frm.resizeObject;
      end;
      8: begin
        Screen.Cursor := crSizeNS;
        objStaticBounds := getStaticBounds(1, 1, 1, 0);
        acao := frm.resizeObject;
      end;
      9: begin
        Screen.Cursor := crSizeNWSE;
        objStaticBounds := getStaticBounds(1, 1, 0, 0);
        acao := frm.resizeObject;
      end;
    end;
end;

procedure objsSetEnabled(enabled: boolean);
var i : integer;
begin

    for i := Low(objs) to High(objs) do begin

        if not (objs[i] = obj) then
            TButton(objs[i]).Enabled := enabled;
    end;
end;

procedure TForm1.resizeObject(Sender: TObject; Shift : TShiftState; X, Y: Integer);
begin

    if (objStaticBounds.XIni = 0) then begin
        TButton(obj).Width := objBounds.XFim - frm.ScreenToClient(Mouse.CursorPos).X;
        TButton(obj).Left := objBounds.XFim - TButton(obj).Width;
    end;

    if (objStaticBounds.XFim = 0) then begin
        TButton(obj).Width := frm.ScreenToClient(Mouse.CursorPos).X - objBounds.XIni;
    end;

    if (objStaticBounds.YIni = 0) then begin
        TButton(obj).Height := objBounds.YFim - frm.ScreenToClient(Mouse.CursorPos).Y;
        TButton(obj).Top := objBounds.YFim - TButton(obj).Height;
    end;

    if (objStaticBounds.YFim = 0) then begin
        TButton(obj).Height := frm.ScreenToClient(Mouse.CursorPos).Y - objBounds.YIni;
    end;
end;

procedure TForm1.moveObject(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
    TButton(obj).Left := frm.ScreenToClient(Mouse.CursorPos).X - Trunc(TButton(obj).Width / 2);
    TButton(obj).Top := frm.ScreenToClient(Mouse.CursorPos).Y - Trunc(TButton(obj).Height / 2);
end;

procedure TForm1.startConfig(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if Button = mbRight then begin

        obj := Sender;

        objsSetEnabled(false);

        objMouseC := TButton(obj).OnClick;
        objMouseDU[0] := TButton(obj).OnMouseDown;
        objMouseDU[1] := TButton(obj).OnMouseUp;
        objMouseL := TButton(obj).OnMouseLeave;
        objMouseM := TButton(obj).OnMouseMove;

        TButton(obj).OnClick := nil;
        TButton(obj).OnMouseDown := doAction;
        TButton(obj).OnMouseUp := stopAction;
        TButton(obj).OnMouseLeave := resetCursor;
        TButton(obj).OnMouseMove := gerenciarFuncoes;

        Form2.Left := frm.Left + frm.Width -10;
        Form2.Top := frm.Top;
        Form2.Show;
    end;
end;

procedure stopConfig;
begin
    Screen.Cursor := crDefault;

    objsSetEnabled(true);

    TButton(obj).OnClick := objMouseC;
    TButton(obj).OnMouseDown := objMouseDU[0];
    TButton(obj).OnMouseUp := objMouseDU[1];
    TButton(obj).OnMouseLeave := objMouseL;
    TButton(obj).OnMouseMove := objMouseM;

    obj := nil;
end;

procedure TForm1.doAction(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    case Button of

        mbLeft: begin
            objBounds := getBounds(obj);
            TButton(obj).OnMouseMove := acao;
        end;
        mbRight: begin
            stopConfig;
        end;
    end;
end;

procedure TForm1.stopAction(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    TButton(obj).OnMouseMove := gerenciarFuncoes;
end;

procedure TForm1.resetCursor(Sender: TObject);
begin
    Screen.Cursor := crDefault;
end;

procedure TForm1.gerenciarFuncoes(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var local : integer;
begin
    local := getLocation(Sender);
    setFuncao(local);
end;

end.
