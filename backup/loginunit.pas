unit LoginUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  unitMain, unitCreateAccount,
  mysql80conn, SQLDB, DB;

type

  { TForm1 }

  TForm1 = class(TForm)
    Btn_Connect: TButton;
    Btn_Disconnecte: TButton;
    DataSource1: TDataSource;
    Edit_Username: TEdit;
    Edit_Password: TEdit;
    Label_Create_Account: TLabel;
    Label_Title: TLabel;
    Label_Username: TLabel;
    Label_Password: TLabel;
    MySQL80Connection1: TMySQL80Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Btn_ConnectClick(Sender: TObject);
    procedure Btn_DisconnecteClick(Sender: TObject);
    procedure Label_Create_AccountClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Btn_ConnectClick(Sender: TObject);
var usernameInput, passwordInput : string;
    userId: Integer;
begin
     usernameInput := Edit_Username.Text;
     passwordInput := Edit_Password.Text;

     try
       SQLQuery1.SQL.Text := 'SELECT id_user FROM users WHERE username = :username AND password = :password';
       SQLQuery1.Params.ParamByName('username').AsString := usernameInput;
       SQLQuery1.Params.ParamByName('password').AsString := passwordInput;

       SQLQuery1.Open;

       if not SQLQuery1.Eof then
       begin
          // Take id from the request to send MainForm with the right id.
          userId := SQLQuery1.FieldByName('id_user').AsInteger;
          // Sent Id to MainForm
          MainForm.userId := userId;
          // Open the new windows unitMain
          MainForm.Show;
          // Call the procedure for the next windows
          MainForm.LoadUserData;

          // Change the button disconnect from unvisible to visible
          Btn_Disconnecte.Visible := True;
          // Change the button connect from visible to unvisible
          Btn_Connect.Visible := False;
       end
       else
         ShowMessage('Username or password are wrong !');
     finally
       SQLQuery1.Close;
     end;
end;

procedure TForm1.Btn_DisconnecteClick(Sender: TObject);
begin
  // Close the MainForm
  MainForm.Close;

  // Change the button connect from unvisible to visible
  Btn_Connect.Visible := True;
  // Change the button disconnect from visible to unvisible
  Btn_Disconnecte.Visible := false;

  // Delete all datas inside the input
  Edit_Username.Text := '';
  Edit_Password.Text := '';

end;

procedure TForm1.Label_Create_AccountClick(Sender: TObject);
begin
  // Open a new windows for registration
     createAccount.Show
end;

end.

