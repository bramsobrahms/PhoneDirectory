unit unitFAQ;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Menus, ComCtrls;

type

  { TMainFAQ }

  TMainFAQ = class(TForm)
    Label_answerCreateContact: TLabel;
    Label_AnswerUpdateOrDelete: TLabel;
    Label_UpdateOrDelete: TLabel;
    Label_AnswerUpdateProfile: TLabel;
    Label_UpdateProfile: TLabel;
    LabelFaq: TLabel;
    Label_NewContact: TLabel;
  private

  public

  end;

var
  MainFAQ: TMainFAQ;

implementation

{$R *.lfm}

end.

