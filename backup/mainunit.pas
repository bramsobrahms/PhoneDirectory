unit mainunit;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus;

type

  { TFormMain }

  TFormMain = class(TForm)
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
  private

  public

  end;

var
  FormMain: TFormMain;

implementation

{$R *.lfm}

end.

