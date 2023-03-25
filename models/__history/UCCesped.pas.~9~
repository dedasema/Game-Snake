unit UCCesped;

interface
uses Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, JPEG;
type
  Cesped = class
  private
    imageWidth, imageHeight, f, c : cardinal;
    url : String;
    img:TJPegImage;
    public
    constructor Crear(width, height : integer);
    procedure Dibujar(t : Tcanvas);
    procedure SetFilCol(f, c : word);
  end;
implementation

{ Cesped }

constructor Cesped.Crear(width, height : integer);
begin
  Self.imageWidth := width;
  Self.imageHeight := height;
  Self.f := 0;
  self.c := 0;
  img := TJPegImage.Create;
  img.LoadFromFile('cespedverde.jpg');
end;

procedure Cesped.Dibujar(t: Tcanvas);
begin
  t.StretchDraw(
  RECT(c*imageWidth, f*imageHeight, c*imageWidth +imageWidth, f*imageHeight+imageHeight),
   Self.img);
end;

procedure Cesped.SetFilCol(f, c: word);
begin
  Self.f := f;
  Self.c := c;
end;

end.
