unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, sgcWebSocket_Classes,
  sgcWebSocket_Classes_Indy, sgcWebSocket_Client, sgcWebSocket, sgcBase_Classes,
  sgcSocket_Classes, sgcTCP_Classes, sgcWebSocket_API_Discord,
  sgcWebSocket_APIs,
  Vcl.StdCtrls, sgcWebSocket_Classes_WinHTTP, sgcWebSocket_Client_WinHTTP;

type
  TForm1 = class(TForm)
    sgcWSAPI_Discord1: TsgcWSAPI_Discord; // Discord API component
    Button1: TButton; // Button to send a message
    sgcWebSocketClient1: TsgcWebSocketClient; // WebSocket client
    Memo1: TMemo; // Display area for messages and logs
    GroupBox1: TGroupBox; // Group box for organizing UI elements
    Label1: TLabel; // Label for user guidance
    Edit1: TEdit; // Edit box for entering the bot token
    Edit2: TEdit; // Edit box for entering the bot name
    Label2: TLabel; // Label for additional user guidance
    Edit3: TEdit; // Edit box for the message content
    Label3: TLabel; // Label for the message field
    Label4: TLabel; // Label for the channel ID field
    Edit4: TEdit; // Edit box for entering the channel ID
    Button2: TButton; // Button to fetch messages from a channel
    procedure Button1Click(Sender: TObject); // Event handler for sending a message
    procedure FormCreate(Sender: TObject); // Event handler for form creation
    procedure sgcWSAPI_Discord1DiscordDispatch(Sender: TObject; const Event, RawData: string); // Event handler for Discord events
    procedure Button2Click(Sender: TObject); // Event handler for fetching messages
  private
    { Private declarations }
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

// Sends a message to a Discord channel when Button1 is clicked
procedure TForm1.Button1Click(Sender: TObject);
begin
  self.Button1.Enabled := false; // Disable the button to prevent multiple clicks
  try
    // Send a POST request with the message content to the specified channel
    Memo1.Lines.Add(self.sgcWSAPI_Discord1.POST_Request('/channels/' + self.Edit4.text + '/messages', '{"content":"' + self.Edit3.text + '"}'));
  except
    on E: Exception do // Handle exceptions
    begin
      showmessage('You must type a message to send!'); // Alert user if no message is typed
    end;
  end;
  self.Button1.Enabled := true; // Re-enable the button after processing
end;

// Fetches messages from a channel when Button2 is clicked
procedure TForm1.Button2Click(Sender: TObject);
var
  commandstring: string; // Variable to hold the fetched messages
begin
  Memo1.Lines.Clear; // Clear previous messages
  // Send a GET request to retrieve specific messages from the channel
  Memo1.Lines.Add(self.sgcWSAPI_Discord1.GET_Request('/channels/' + Edit4.text + '/messages/' + '1201205973642133585'));//Example Channel ID 1201205973642133585 PUT YOUR OWN!
  commandstring := self.Memo1.text; // Store the fetched messages

  // Check if the fetched messages contain a specific command
  if commandstring.Contains('./command') then
  begin
    // Send a response message if the command is found
    Memo1.Lines.Add(self.sgcWSAPI_Discord1.POST_Request('/channels/' + self.Edit4.text + '/messages', '{"content":"' + 'You Requested Help Menu!' + '"}'));
  end;
end;

// Initializes the form and sets up Discord API options
procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo1.Clear; // Clear the memo on startup
  // Set the bot token and name from the edit boxes
  sgcWSAPI_Discord1.DiscordOptions.BotOptions.Token := self.Edit1.text;
  self.sgcWSAPI_Discord1.DiscordOptions.BotOptions.BotName := self.Edit2.text;
end;

// Handles Discord events and displays them
procedure TForm1.sgcWSAPI_Discord1DiscordDispatch(Sender: TObject; const Event, RawData: string);
begin
  showmessage(Event); // Show a message when an event is dispatched
end;

end.

