unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, Forms, Menus, Dialogs,  SynEdit,
  SynFacilHighlighter;

type

  { TForm1 }

  TForm1 = class(TForm)
    ed1: TSynEdit;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    mnSyntax: TMenuItem;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure itClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation
{$R *.lfm}
//crea espacio para almacenar token
var hlt1 : TSynFacilSyn;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  it: TMenuItem;
  fResult: LongInt;
  fFile: TSearchRec;
begin
  //configure highlighters
  hlt1 := TSynFacilSyn.Create(self);  //my highlighter
  ed1.Highlighter := hlt1;
  hlt1.LoadFromFile('ObjectPascal.xml');
  ed1.Lines.LoadFromFile('ObjectPascal_sample.txt');

  //load the syntax files
  fResult :=  FindFirst('*.xml', faAnyFile, fFile );
  while fResult = 0 do begin
    it := TMenuItem.Create(self);
    it.Caption:=fFile.Name;
    it.OnClick:=@itClick;
    mnSyntax.Add(it);
    fResult := FindNext(fFile);
  end;
  FindClose(fFile);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  hlt1.Free;
end;

procedure TForm1.itClick(Sender: TObject);
begin
  hlt1.LoadFromFile(TMenuItem(Sender).Caption);
  ed1.Invalidate;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  OpenDialog1.Filter:='Samples|*.txt';
  if not OpenDialog1.Execute then exit;    //se canceló
  ed1.Lines.LoadFromFile(OpenDialog1.FileName);
  self.Caption:=OpenDialog1.FileName;
end;

end.

