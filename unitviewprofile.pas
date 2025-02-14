unit unitViewProfile;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, mysql80conn, SQLDB, DB, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls;

type

  { TViewProfileUser }

  TViewProfileUser = class(TForm)
    Btn_Save: TButton;
    Btn_Cancel: TButton;
    DataSource1: TDataSource;
    Firstname: TLabeledEdit;
    MySQL80Connection1: TMySQL80Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    Username: TLabeledEdit;
    Password: TLabeledEdit;
    Lastname: TLabeledEdit;
    LabelProfile: TLabel;
    procedure LoadUserEdit;
    procedure Btn_CancelClick(Sender: TObject);
  private

  public
    userId: Integer;
  end;

var
  ViewProfileUser: TViewProfileUser;

implementation

{$R *.lfm}

{ TViewProfileUser }

procedure TViewProfileUser.LoadUserEdit;
begin
  // Check if the connection is well established
  if MySQL80Connection1.Connected then
    begin
      // Make the request to retrieve data
      // Show contacts user related information
      SQLQuery1.SQL.Text := 'SELECT name, firstname, username, password FROM users WHERE id_user = :userId';
      SQLQuery1.Params.ParamByName('userId').AsInteger := userId;  // Use the ID of the logged-in user

      try
        SQLQuery1.Open;  // Execute the query
        if not SQLQuery1.Eof then
          begin
            Lastname.Text := SQLQuery1.FieldByName('name').AsString;
            Firstname.Text := SQLQuery1.FieldByName('firstname').AsString;
            Username.Text := SQLQuery1.FieldByName('username').AsString;
            Password.Text := SQLQuery1.FieldByName('password').AsString;
          end
        else
          ShowMessage('No user found with this ID.');
      except
        on E: Exception do
          ShowMessage('Error while retrieving data : ' + E.Message);
      end;
    end
  else
    ShowMessage('Database connection not established.');
end;

procedure TViewProfileUser.Btn_CancelClick(Sender: TObject);
begin
  // Close the windows without update data
  ViewProfileUser.Close;
end;

end.

