unit UCFood;

interface
uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ExtCtrls, pngimage, UCMatriz;
  type
    Food = class
    protected
      imageWidth, imageHeight, f, c : word;
      img: TPNGImage;
      b: boolean;
      m: Matriz;

    public
      constructor Crearcomida(width, height : integer);
      procedure Dibujar(t:TCanvas);  virtual ; //abstract;
      procedure SetFil(f :word);
      procedure SetCol(c :word);
      procedure SetFilCol(f, c : word);
      procedure CrearFilaColumna;
      function GetFil():word;
      function GetCol():word;
    end;
implementation

{ Food }

constructor Food.Crearcomida(width, height: integer);
begin
  img := TPNGImage.Create;
  img.LoadFromFile('food.png');
  Self.imageWidth := width;
  Self.imageHeight := height;
  CrearFilaColumna;
end;

procedure Food.CrearFilaColumna;
begin
     Randomize;        //Para que no repita los números
     f:=Random(15)+3;
     c:=Random(17)+1;
     setFil(f);        //Seteo la fila con el random
     setCol(c);        //Seteo la columan con el random
end;

procedure Food.Dibujar(t: TCanvas);
begin
    t.StretchDraw(
  RECT(c*imageWidth, f*imageHeight, c*imageWidth +imageWidth, f*imageHeight+imageHeight),
   Self.img);
end;

function Food.GetCol: word;
begin
   Result := Self.c;
end;

function Food.GetFil: word;
begin
   Result := Self.f;
end;

procedure Food.SetCol(c: word);
begin
  Self.c := c;
end;

procedure Food.SetFil(f: word);
begin
  Self.f := f;
end;

procedure Food.SetFilCol(f, c: word);
begin
  Self.f := f;
  Self.c := c;
end;

end.
