unit unitEditContact;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, mysql80conn, SQLDB, DB, Forms, Controls, Graphics, Dialogs,
  DBGrids, StdCtrls;

type

  { TEditContact }

  TEditContact = class(TForm)
    Btn_Save: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Edit_Name: TEdit;
    Edit_Firstname: TEdit;
    Edit_NumGsm: TEdit;
    Edit_NumHome: TEdit;
    Label_EditPhonebook: TLabel;
    Label_Firstname: TLabel;
    Label_Name: TLabel;
    Label_NumGsm: TLabel;
    Label_NumHome: TLabel;
    MySQL80Connection1: TMySQL80Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Btn_SaveClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure LoadUserNumberbook;

  private

  public
    userId: Integer;
    OnDataUpdated: TNotifyEvent;
  end;

var
  EditContact: TEditContact;

implementation

{$R *.lfm}

{ TEditContact }

procedure TEditContact.LoadUserNumberbook;
begin
  // Check if the connection is well established
  if MySQL80Connection1.Connected then
    begin
      // Make the request to retrieve data
      // Show contacts user related information
      SQLQuery1.SQL.Text := 'SELECT id, name, firstname, num_gsm, num_home FROM book_numbers WHERE user_id = :userId';
      SQLQuery1.Params.ParamByName('userId').AsInteger := userId;  // Use the ID of the logged-in user

      try
        SQLQuery1.Open;  // Execute the query
        DataSource1.DataSet := SQLQuery1;  // Associate the DataSource with SQLQuery
      except
        on E: Exception do
          ShowMessage('Erreur lors de la récupération des données : ' + E.Message);
      end;
    end
  else
    ShowMessage('Connexion à la base de données non établie.');
end;

procedure TEditContact.Btn_SaveClick(Sender: TObject);
var idNumUser, nameInput, firstnameInput, numGsmInput, numHomeInput: string;
begin
  idNumUser := DBGrid1.Columns[0].Field.Text;
  nameInput := QuotedStr(Edit_Name.Text);
  firstnameInput := QuotedStr(Edit_Firstname.Text);
  numGsmInput := QuotedStr(Edit_NumGsm.Text);
  numHomeInput := QuotedStr(Edit_NumHome.Text);

  SQLQuery1.Close;
  SQLQuery1.SQL.Text := 'UPDATE book_numbers SET name = '+nameInput+', firstname = '+firstnameInput+', num_gsm = '+numGsmInput+', num_home = '+numHomeInput+ 'WHERE  id ='+idNumUser;
  SQLQuery1.ExecSQL;

  // Refresh list of contacts
  LoadUserNumberbook;

  // Close the windows editContact
  EditContact.Close;

end;

procedure TEditContact.DBGrid1CellClick(Column: TColumn);
begin
  // Show the data from DBGrid
  Edit_Name.Text := DBGrid1.Columns[1].Field.Text;
  Edit_Firstname.Text := DBGrid1.Columns[2].Field.Text;
  Edit_NumGsm.Text := DBGrid1.Columns[3].Field.Text;
  Edit_NumHome.Text := DBGrid1.Columns[4].Field.Text;
end;


end.

