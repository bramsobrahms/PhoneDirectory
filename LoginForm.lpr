program LoginForm;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, LoginUnit, unitMain, unitCreateAccount, unitFAQ, unitEditContact,
  unitViewProfile;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  {$PUSH}{$WARN 5044 OFF}
  Application.MainFormOnTaskbar:=True;
  {$POP}
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TcreateAccount, createAccount);
  Application.CreateForm(TMainFAQ, MainFAQ);
  Application.CreateForm(TEditContact, EditContact);
  Application.CreateForm(TViewProfileUser, ViewProfileUser);
  Application.Run;
end.

