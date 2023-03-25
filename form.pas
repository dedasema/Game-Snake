﻿unit form;
interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, UCEscenario, UControllerGame,
  Vcl.StdCtrls;
type
  TForm1 = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormOnPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Timer2Timer(Sender: TObject);
    procedure FormDblClick(Sender: TObject);


  private
    esc :  Escenario;
    ctrl: ControllerGame;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.Width:= 1280;
  Self.Height:= 720;
  self.esc := Escenario.Crear(Self.Width, Self.Height);
  self.ctrl:=ControllerGame.crear(self.esc, self.Timer2);

end;

procedure TForm1.FormDblClick(Sender: TObject);
begin
    self.ctrl.setbool(false);
    showMessage('😀 ESPERO HAYA DISFRUTADO EL JUEGO 😃');
    application.Terminate;
end;

Procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   self.ctrl.Moverse(key); //cambia la dirección de la serpiente
end;

Procedure TForm1.FormOnPaint(Sender: TObject);
begin
  esc.Dibujar(self.Canvas);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Self.Repaint;
end;

Procedure TForm1.Timer2Timer(Sender: TObject);
begin

    self.ctrl.controller;    //Llamo al controlador principal

    if self.ctrl.obtpuntos <> -1 then
    label1.Caption:='PUNTOS: ' + inttostr(self.ctrl.obtpuntos) + '     '  + 'VIDAS: ' + inttostr(self.ctrl.obtvidas);  //mueve la serpiente automaticamente

    if (self.ctrl.obtpuntos = 5) or (self.ctrl.obtpuntos = 10) or (self.ctrl.obtpuntos = 15) then
      self.Label1.Caption:='¡¡¡🥳 FELICITACIONES 🥳!!! AVANZASTE AL SIGUIENTE NIVEL'
    Else if self.ctrl.obtpuntos = 0 then
      self.Label1.Caption:='😭 PERDISTE 😭'
    Else if self.ctrl.obtpuntos = 20 then
    Begin
      self.ctrl.setbool(false);
      self.Label1.Caption:='🐍💥 GANASTE 💥🐍';
    End;

    if self.ctrl.obtvidas = 0 then
    Begin
    self.ctrl.setbool(false);
    self.Label1.Caption:= '🐍❌ GAME OVER ❌🐍'
    End;
end;



//Width=1366
//Heigth=768
end.

//La resolución de tu pantalla tiene que estar en 1280 x 720 para la fecha de presentación
