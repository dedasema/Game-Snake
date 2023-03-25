unit UControllerGame;

interface
 uses   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, System.ImageList,
  Vcl.ImgList, UCEscenario, URecord, UCMatriz, UCFood, UCSnake;

type

  ControllerGame = class
    private
        time, delay: Cardinal;
        ancho, alto : integer;
        esc: Escenario;
        m : Matriz;
        f: Food;
        snk : Snake;
        puntos: integer;
        vidas: byte;
        b: Boolean;
        bool : Boolean;
        t : TTimer;
    public

    constructor crear(x:Escenario; timer: TTimer);
    procedure Moverse(k:word);
    procedure accioncabeza;
    procedure accioncola;
    procedure controller;
    function getbool():boolean;
    procedure setbool(bool:boolean);
    function getb():boolean;
    procedure setb(b:boolean);
    procedure reiniciarSnake();
    procedure reiniciarSnakesignivel();
    procedure reiniciarSnakesignivel2();
    procedure reiniciarSnakesignivel3();
    function obtpuntos:integer;
    function obtvidas:byte;
    procedure setvidas(v:byte);
  end;
implementation

{ ControllerGame }

 procedure ControllerGame.accioncola;
var
  dat: dato;
begin

    //dat-> lo que hay en la matriz
    dat := self.esc.getMatriz.ObtValor(
    self.esc.getCola.GetFil,
    self.esc.getCola.GetCol
    );

    //modificamos la direccion de la cola
    self.esc.getCola.SetDirection(dat.direccion);

    //Desde aqu� para que crezca

    //modificar matriz, limpiando el dato de la cola
    self.esc.getMatriz.ModValor(
    self.esc.getCola.GetFil,
    self.esc.getCola.GetCOl,
    0,
    Direction.null
    );

    //la cola avanza
    self.esc.getCola.SetNextPos(
    self.esc.getMatriz.GetFilas,
    self.esc.getMatriz.GetColumnas
    );
end;

procedure ControllerGame.controller;
var
    f,c : word;
    d : Direction;
Begin
   if (getbool = true) then //Preguntamos si la serpiente se puede mover
   Begin
   f := self.esc.getCabeza.GetFil;
   c := self.esc.getCabeza.GetCol;
   d := self.esc.getCabeza.GetDirection;

       //PREGUNTAMOS SI HAY COMIDA
       if ((d = derecha) and (m.ObtValor(f,c+1).valor = 3)) or
          ((d = izquierda) and (m.ObtValor(f,c-1).valor = 3)) or
          ((d = superior) and (m.ObtValor(f-1,c).valor = 3)) or
          ((d = inferior) and (m.ObtValor(f+1,c).valor = 3)) then
       Begin
             accioncabeza; //Si hay comida solo avanza la cabeza

             //Donde estaba la comida dibujo cesped y luego pido fila y columna
             //Pregunto si en esa fila y columna hay cesped, si es as� dibujo la comida
             //Sino pido de nuevo fila y columan hasta que all� haya cesped
             m.ModValor(self.f.GetFil,self.f.GetCol,0,Direction.null);
             repeat
              self.f.CrearFilaColumna;
             until (m.ObtValor(self.f.GetFil,self.f.GetCol).valor = 0);
             m.ModValor(self.f.GetFil,self.f.GetCol,3,Direction.null);

            //Aumento el puntaje
            if self.puntos =-1 then
              self.puntos:= self.puntos + 2
            Else
              self.puntos:= self.puntos +1;

            //Pregunto si ya alcanzo el puntaje para avanzar al siguiente nivel
            if (self.puntos = 5) then
                reiniciarSnakesignivel
            Else if (self.puntos = 10) then
                reiniciarSnakesignivel2
            Else if (self.puntos = 15) then
                 reiniciarSnakesignivel3;


       End

        //PREGUNTAMOS SI CHOCA CON LA PARED

        Else if ((d = derecha) and (m.ObtValor(f,c+1).valor = 1)) or
          ((d = izquierda) and (m.ObtValor(f,c-1).valor = 1)) or
          ((d = superior) and (m.ObtValor(f-1,c).valor = 1)) or
          ((d = inferior) and (m.ObtValor(f+1,c).valor = 1)) then
        Begin
           self.puntos:=0;               //Se reinician los puntos
           self.vidas:=self.vidas-1;     //Se resta una vida
           self.t.Interval:=150;         //Se reinicia la velocidad
           self.setbool(false);          //Deja de avanzar la serpiente
           reiniciarSnake();             //Reiniciamos el juego
        End

        //PREGUNTAMOS SI CHOCO CON SU PROPIO CUERPO
        Else if ((d = derecha) and (m.ObtValor(f,c+1).valor = 2)) or
          ((d = izquierda) and (m.ObtValor(f,c-1).valor = 2)) or
          ((d = superior) and (m.ObtValor(f-1,c).valor = 2)) or
          ((d = inferior) and (m.ObtValor(f+1,c).valor = 2)) then
        Begin
           self.puntos:=0;               //Se reinician los puntos
           self.vidas:=self.vidas-1;     //Se resta una vida
           self.t.Interval:=150;         //Se reinicia la velocidad
           self.setbool(false);          //Deja de avanzar la serpiente
           reiniciarSnake();             //Reiniciamos el juego
        End


        Else
        Begin
          accioncabeza;
          accioncola;
       End;

End;
End;

constructor ControllerGame.crear(x: Escenario; timer: TTimer);
begin
   self.t := timer;
   Self.esc:= x;

   Self.m:= Self.esc.getMatriz;
   Self.f:= Self.esc.getComida;

   setbool(true);    //La serpiente est� en movimiento
   setb(false);      //La serpiente est� viva

   self.puntos:=-1;
   self.vidas:=3;    //Empieza con 3 vidas

end;

function ControllerGame.getb: boolean;
begin
    Result:=self.b; //para ver si la serpiente muri�
end;

function ControllerGame.getbool:boolean;
begin
    Result:=self.bool;  //para el avance de la serpiente
end;

procedure ControllerGame.Moverse(k: word);
begin
    self.esc.getCabeza.Moverse(k); //mueve la cabeza
end;

function ControllerGame.obtpuntos: integer;
begin
    Result:=self.puntos;
end;

function ControllerGame.obtvidas: byte;
begin
    Result:=self.vidas;
end;

procedure ControllerGame.reiniciarSnake;
var
  i,j:byte;
begin
  //Reinicio la matriz
  m.reiniciar;
  m.SetFilas(20);
  m.SetColumnas(20);

  //Reinicio la comida
  m.ModValor(f.GetFil,f.GetCol, 3, Direction.null);

  //Reinicio la serpiente
  m.ModValor(3, 3, 2, Direction.derecha);
  m.ModValor(3, 2, 2, Direction.derecha);
  m.ModValor(3, 1, 2, Direction.derecha);

  esc.getCabeza.SetFilCol(3,3);
  esc.getCola.SetFilCol(3,1);
  esc.getCabeza.SetDirection(Direction.derecha);
  esc.getCola.SetDirection(Direction.derecha);

  //Reinicio la pared
  for j := 0 to m.GetColumnas-1 do begin
    m.ModValor(1, j, 1, Direction.null);
    m.ModValor(m.GetFilas-1, j, 1, Direction.null);
  end;

  for i := 1 to m.GetFilas-1 do begin
    m.ModValor(i, 0, 1, Direction.null);
    m.ModValor(i, m.GetColumnas-1, 1, Direction.null);
  end;

  setbool(true);

end;

procedure ControllerGame.reiniciarSnakesignivel;
var
  i,j,k:byte;
begin

 //Reinicio la matriz
  m.reiniciar;
  m.SetFilas(20);
  m.SetColumnas(20);

  //Reinicio la comida
  m.ModValor(f.GetFil,f.GetCol, 3, Direction.null);


  m.ModValor(3, 3, 2, Direction.derecha);
  m.ModValor(3, 2, 2, Direction.derecha);
  m.ModValor(3, 1, 2, Direction.derecha);

  esc.getCabeza.SetFilCol(3,3);
  esc.getCola.SetFilCol(3,1);
  esc.getCabeza.SetDirection(Direction.derecha);
  esc.getCola.SetDirection(Direction.derecha);

  //Reinicio la pared
  for j := 0 to m.GetColumnas-1 do begin
    m.ModValor(1, j, 1, Direction.null);
    m.ModValor(m.GetFilas-1, j, 1, Direction.null);
  end;

  for i := 1 to m.GetFilas-1 do begin
    m.ModValor(i, 0, 1, Direction.null);
    m.ModValor(i, m.GetColumnas-1, 1, Direction.null);
  end;

  //izquierda superior
  j:=1;   i:=2;  k:=1;
  while (j<=7) and (i<=8) do
  Begin
    if k=1 then
    Begin
    m.ModValor(i, j, 1, Direction.null);
    End;
    inc(j);
    inc(i);
    k:=k*(-1);
  End;

  //Derecha inferior
  j:=12;   i:=12;  k:=1;
  while (j<=18) and (i<=18) do
  Begin
    if k=1 then
    Begin
    m.ModValor(i, j, 1, Direction.null);
    End;
    inc(j);
    inc(i);
    k:=k*(-1);
  End;

  //Izquierda inferior
  i:=18;   j:=1;  k:=1;
  while (i>=11) and (j<=7) do
  Begin
    if k=1 then
    Begin
    m.ModValor(i, j, 1, Direction.null);
    End;
    inc(j);
    dec(i);
    k:=k*(-1);
  End;

  //Derecha superior
  i:=8;   j:=12;  k:=1;
  while (i>=2) and (j<=18) do
  Begin
    if k=1 then
    Begin
    m.ModValor(i, j, 1, Direction.null);
    End;
    inc(j);
    dec(i);
    k:=k*(-1);
  End;
  self.t.Interval:=100;

end;

procedure ControllerGame.reiniciarSnakesignivel2;
var
  i,j,k:byte;
begin

  reiniciarSnakesignivel;

  i:=4;   j:=9;  k:=1;
  while (i<=8) do
  Begin
    if k=1 then
    Begin
    m.ModValor(i, j, 1, Direction.null);
    m.ModValor(i, j+1, 1, Direction.null);
    End;
    inc(i);
    k:=k*(-1);
  End;

  i:=16;   j:=10;  k:=1;
  while (i>=12) do
  Begin
    if k=1 then
    Begin
    m.ModValor(i, j, 1, Direction.null);
    m.ModValor(i, j-1, 1, Direction.null);
    End;
    dec(i);
    k:=k*(-1);
  End;

  //self.t.Interval:=100;

end;


procedure ControllerGame.reiniciarSnakesignivel3;
var
  i,j,k:byte;
begin

  reiniciarSnakesignivel2;

  i:=10;   j:=3;  k:=1;
  while (j<=7) do
  Begin
    if k=1 then
    Begin
    m.ModValor(i, j, 1, Direction.null);
    End;
    inc(j);
    k:=k*(-1);
  End;

  i:=10;   j:=12;  k:=1;
  while (j<=16) do
  Begin
    if k=1 then
    Begin
    m.ModValor(i, j, 1, Direction.null);
    End;
    inc(j);
    k:=k*(-1);
  End;

  self.t.Interval:=100;
end;

procedure ControllerGame.setb(b: boolean);
begin
   self.b:=b;
end;

procedure ControllerGame.setbool(bool: boolean);
begin
    self.bool:=bool;
end;

procedure ControllerGame.setvidas(v: byte);
begin
    self.vidas:=v;
end;

procedure ControllerGame.accioncabeza;
var  f, c : byte;
     d: Direction;
     dat : dato;
begin

  //cabeza
  f := self.esc.getCabeza.GetFil;
  c := self.esc.getCabeza.GetCol;
  d := self.esc.getCabeza.GetDirection;

  //modificar matriz, dejando datos de la cabeza
  self.esc.getMatriz.ModValor(f,c,2,d);

  //avanza cabeza
  self.esc.getCabeza.SetNextPos(
    self.esc.getMatriz.GetFilas,
    self.esc.getMatriz.GetColumnas
  );

  //avanza cola

end;


end.
