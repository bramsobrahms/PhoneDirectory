unit unitCreateAccount;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, mysql80conn, SQLDB, Forms, Controls, Graphics, Dialogs,
  StdCtrls;

type

  { TcreateAccount }

  TcreateAccount = class(TForm)
    Btn_Save: TButton;
    DataSource1: TDataSource;
    Edit1_Create_Name: TEdit;
    Edit_Create_Firstname: TEdit;
    Edit_Create_Username: TEdit;
    Edit_Create_Password: TEdit;
    Label_Name: TLabel;
    Label_Firstname: TLabel;
    Label_Username: TLabel;
    Label_Password: TLabel;
    Label_Title: TLabel;
    MySQL80Connection1: TMySQL80Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Btn_SaveClick(Sender: TObject);
  private

  public

  end;

var
  createAccount: TcreateAccount;

implementation

{$R *.lfm}

{ TcreateAccount }

procedure TcreateAccount.Btn_SaveClick(Sender: TObject);
var nameInput, firstnameInput, usernameInput, passwordInput : string;
    isActive : boolean;
begin

  // Variables with texte from input
  nameInput := QuotedStr(Edit1_Create_Name.TEXT);
  firstnameInput := QuotedStr(Edit_Create_Firstname.TEXT);
  usernameInput := QuotedStr(Edit_Create_Username.TEXT);
  passwordInput := QuotedStr(Edit_Create_Password.TEXT);
  isActive := TRUE;

  try
    // Query to see if the username is a duplicate
    SQLQuery1.SQL.TEXT := 'SELECT COUNT(*) AS Count FROM users WHERE username = '+ usernameInput;
    SQLQuery1.Open;

    if SQLQuery1.FieldByName('Count').AsInteger > 0 then
       begin
         ShowMessage('This username exists, please chosse another one');
         SQLQuery1.Close;
         Exit;
       end;
  finally
    SQLQuery1.Close;
  end;

  // Query to insert data from input to database
  MySQL80Connection1.ExecuteDirect('INSERT INTO users (name, firstname, username, password,isActive) VALUES ('+nameInput+','+firstnameInput+','+usernameInput+','+passwordInput+','+BoolToStr(isActive, True)+')');
  ShowMessage('Account created successfully');
  SQLTransaction1.Commit;

  // Delete data before to exit the program
  Edit1_Create_Name.TEXT := '';
  Edit_Create_Firstname.TEXT := '';
  Edit_Create_Username.TEXT := '';
  Edit_Create_Password.TEXT := '';

  // Close the windows create account
  createAccount.Close;
end;

end.

