unit Unit7;

interface

uses
  HtmlParser_XE3UP,
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Platform,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  FMX.StdCtrls, FMX.Edit, FMX.Layouts, FMX.TreeView, FMX.Memo;

type
  TForm7 = class(TForm)
    IdHTTP1: TIdHTTP;
    TreeView1: TTreeView;
    Layout1: TLayout;
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    btn1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
    FNodes: IHtmlElement;
    FSource: string;
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

{$R *.fmx}

procedure NodesToTree1(ATreeView: TTreeView; ANode: IHtmlElement;
  AParentNode: TTreeViewItem);
var
  i: Integer;
  Node: TTreeViewItem;
  m: Integer;
begin

  Node := TTreeViewItem.Create(AParentNode);
  Node.Parent := AParentNode;
  Node.Text := Format('[%d]%s', [ANode.GetSourceLineNum, ANode.TagName]);
  m := ANode.ChildrenCount - 1;
  // if m > 1000 then
  // m := 1000;

  // OutputDebugString(PChar(Format('LineNum--->:%d;Level:%d;TagName:%s;Text:%s',[ANode.GetSourceLineNum,Level, ANode.TagName, ANode.GetOrignal])));
  for i := 0 to m do
  begin
    NodesToTree1(ATreeView, ANode[i], Node);
  end;
end;

procedure TForm7.btn1Click(Sender: TObject);
var
  ss: string;
begin
  // ShowMessage(Inttostr(FNodes.SimpleCSSSelector('div#wrapper').Count));
  ss := FNodes.InnerHtml;


  if FSource = ss then
    ShowMessage('一样');
end;

procedure TForm7.Button1Click(Sender: TObject);
var
  root: TTreeViewItem;
begin
  IdHTTP1.Request.UserAgent :=
    'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:23.0) Gecko/20100101 Firefox/23.0';
  FSource := StrPas(PChar(IdHTTP1.Get(Edit1.Text)));
  Memo1.Lines.Text := FSource;
  ShowMessage('下载网页完毕!');
  FNodes := ParserHTML(FSource);
  ShowMessage('解析网页完毕!后面解析到Tree有点慢啊.');
  //

  root := TTreeViewItem.Create(TreeView1);
  TreeView1.BeginUpdate;
  TreeView1.Clear;
  root.Parent := TreeView1;
  NodesToTree1(TreeView1, FNodes, root);
  TreeView1.EndUpdate;
end;

end.
