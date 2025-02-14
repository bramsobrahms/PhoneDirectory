unit unitMain;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, mysql80conn, SQLDB, DB, Forms, Controls, Graphics, Dialogs,
  Menus, DBGrids, StdCtrls,
  unitFAQ, unitEditContact, unitViewProfile,
  csvdocument;

type

  { TMainForm }

  TMainForm = class(TForm)
    Btn_Save: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Edit_Name: TEdit;
    Edit_Firstname: TEdit;
    Edit_NumGsm: TEdit;
    Edit_NumHome: TEdit;
    Label_Name: TLabel;
    Label_Firstname: TLabel;
    Label_NumGsm: TLabel;
    Label_NumHome: TLabel;
    LabelPhonebook: TLabel;
    MainMenu1: TMainMenu;
    Export: TMenuItem;
    MenuItem_EditProfile: TMenuItem;
    MenuItemRefresh: TMenuItem;
    MenuItem_EditContact: TMenuItem;
    MenuItemAbout: TMenuItem;
    MenuItem_AboutFaq: TMenuItem;
    MenuItem_AboutExit: TMenuItem;
    MenuProfile: TMenuItem;
    MenuCarnet: TMenuItem;
    MySQL80Connection1: TMySQL80Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Btn_SaveClick(Sender: TObject);
    procedure ExportClick(Sender: TObject);
    procedure MenuCarnetClick(Sender: TObject);
    procedure LoadUserData;
    procedure MenuItem_EditContactClick(Sender: TObject);
    procedure MenuItem_AboutFaqClick(Sender: TObject);
    procedure MenuItem_AboutExitClick(Sender: TObject);
    procedure MenuItemRefreshClick(Sender: TObject);
    procedure MenuItem_EditProfileClick(Sender: TObject);

  private

  public
    userId: Integer;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.LoadUserData;
begin
  // Check if the connection is well established
  if MySQL80Connection1.Connected then
    begin
      // Make the request to retrieve data
      // Show contacts user related information
      SQLQuery1.SQL.Text := 'SELECT id, name, firstname, num_gsm, num_home  FROM book_numbers WHERE user_id = :userId';
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

procedure TMainForm.MenuItem_EditContactClick(Sender: TObject);
begin
  // Sent Id to MainForm
  EditContact.userId := userId;

  // Call the procedure for the next windows
  EditContact.LoadUserNumberbook;

  // Redirect to EditContact -> unitEditContact
  EditContact.Show;
end;

procedure TMainForm.MenuItem_AboutFaqClick(Sender: TObject);
begin
  MainFAQ.Show;
end;

procedure TMainForm.MenuItem_AboutExitClick(Sender: TObject);
begin
  SQLQuery1.Close;
  MainForm.Close;
end;

procedure TMainForm.MenuItemRefreshClick(Sender: TObject);
begin
  SQLQuery1.SQL.Text := 'SELECT id, name, firstname, num_gsm, num_home  FROM book_numbers WHERE user_id = :userId';
      SQLQuery1.Params.ParamByName('userId').AsInteger := userId;  // Use the ID of the logged-in user
      SQLQuery1.Open;  // Execute the query
        DataSource1.DataSet := SQLQuery1;  // Associate the DataSource with SQLQuery
end;

procedure TMainForm.MenuItem_EditProfileClick(Sender: TObject);
begin
  // Sent Id to MainForm
  ViewProfileUser.userId := userId;

  // Redirect to edit profile user
  ViewProfileUser.LoadUserEdit;

  // Redirect to editProfil
  ViewProfileUser.Show;
end;

procedure TMainForm.MenuCarnetClick(Sender: TObject);
begin

end;

procedure TMainForm.Btn_SaveClick(Sender: TObject);
var nameInput, firstnameInput, numGsmInput, numHomeInput, userIdConnected : string;
begin

  // Variables with data from input
  nameInput := QuotedStr(Edit_Name.TEXT);
  firstnameInput := QuotedStr(Edit_Firstname.TEXT);
  numGsmInput := QuotedStr(Edit_NumGsm.TEXT);
  numHomeInput := QuotedStr(Edit_NumHome.TEXT);
  userIdConnected := QuotedStr(userId.ToString());

  // Check if the name and firstname are not empty
  if (Edit_Name.TEXT = '') OR (Edit_Firstname.TEXT = '') then
    begin
      ShowMessage('Please, Enter the name and firstname the contact');
      Exit;
    end;

  // Check if the numGsm or numHome are empty
  if ( Edit_NumGsm.TEXT = '') AND (Edit_NumHome.TEXT = '') then
    begin
      ShowMessage('Please enter a number phone');
      Exit;
    end;

  // Query to insert data inside the database
  MySQL80Connection1.ExecuteDirect('INSERT INTO book_numbers (name, firstname, num_gsm, num_home, user_id) VALUE('+nameInput+', '+firstnameInput+ ',' +numGsmInput+','+numHomeInput+','+userIdConnected+')');
  ShowMessage('number added with succes');
  SQLTransaction1.Commit;

  // Delete data before to exit the program
  Edit_Name.TEXT := '';
  Edit_Firstname.TEXT := '';
  Edit_NumGsm.TEXT := '';
  Edit_NumHome.TEXT := '';

  // Reussie
  LoadUserData;
end;

procedure TMainForm.ExportClick(Sender: TObject);
var
  CSVFile: TextFile;
  Line: String;
begin
  // Vérifier si les données sont chargées
  if SQLQuery1.Active then
  begin
    // Ouvrir le fichier CSV en écriture
    AssignFile(CSVFile, 'Contacts.csv');
    Rewrite(CSVFile);
    try
      // Ajouter les en-têtes
      Line := 'Nom,Prénom,Numéro de GSM,Numéro fixe';
      WriteLn(CSVFile, Line);

      // Ajouter les contacts au fichier CSV
      SQLQuery1.First;
      while not SQLQuery1.EOF do
      begin
        Line := SQLQuery1.FieldByName('name').AsString + ',' +
                SQLQuery1.FieldByName('firstname').AsString + ',' +
                SQLQuery1.FieldByName('num_gsm').AsString + ',' +
                SQLQuery1.FieldByName('num_home').AsString;
        WriteLn(CSVFile, Line);
        SQLQuery1.Next;
      end;
    finally
      // Fermer le fichier CSV
      CloseFile(CSVFile);
    end;
  end
  else
    ShowMessage('Aucune donnée chargée.');
end;

end.

