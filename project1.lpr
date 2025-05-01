program project1;

{$mode objfpc}{$H+}

uses
  SysUtils, Windows, Classes, ActiveX, ComObj, Variants, fpjson, jsonparser;

function GetWMIValue(const WMIClass, PropertyName: string): string;
var
  WMIService, WbemLocator, Results, Item: OleVariant;
  i: Integer;
begin
  Result := '';
  try
//    WbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
//    WMIService := WbemLocator.ConnectServer(WideString('.'), WideString('root\\CIMV2'));
//    WbemObjectSet := WMIService.ExecQuery('SELECT * FROM ' + WMIClass);

    WbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
    WMIService := WbemLocator.ConnectServer(WideString('.'), WideString('root\\CIMV2'));

    // Abfrage: Alle Betriebssysteme
    Results := WMIService.ExecQuery('SELECT * FROM Win32_OperatingSystem');

    // Indexbasierter Zugriff statt for-in
    for i := 0 to Results.Count - 1 do
    begin
      Item := Results.ItemIndex(i);
      Writeln('OS: ', Item.Caption);
      Writeln('Version: ', Item.Version);
      Writeln('Build: ', Item.BuildNumber);
    end;
  except
    on E: Exception do
      Writeln('WMI Error: ', E.Message);
  end;
end;

function CollectSystemInfo: TJSONObject;
var
  json: TJSONObject;
begin
  json := TJSONObject.Create;
  json.Add('OS_Name', GetWMIValue('Win32_OperatingSystem', 'Caption'));
  json.Add('OS_Version', GetWMIValue('Win32_OperatingSystem', 'Version'));
  json.Add('BuildNumber', GetWMIValue('Win32_OperatingSystem', 'BuildNumber'));
  json.Add('RegisteredUser', GetWMIValue('Win32_OperatingSystem', 'RegisteredUser'));
  json.Add('ComputerName', GetWMIValue('Win32_ComputerSystem', 'Name'));
  json.Add('Manufacturer', GetWMIValue('Win32_ComputerSystem', 'Manufacturer'));
  json.Add('Model', GetWMIValue('Win32_ComputerSystem', 'Model'));
  json.Add('Processor', GetWMIValue('Win32_Processor', 'Name'));
  json.Add('SerialNumber', GetWMIValue('Win32_BIOS', 'SerialNumber'));
  Result := json;
end;

procedure SaveJsonToFile(JsonObj: TJSONObject; const FileName: string);
var
  Output: TStringList;
begin
  Output := TStringList.Create;
  try
    Output.Text := JsonObj.FormatJSON;
    Output.SaveToFile(FileName);
  finally
    Output.Free;
  end;
end;

begin
  CoInitialize(nil);
  try
    SaveJsonToFile(CollectSystemInfo, 'systeminfo.json');
    Writeln('✅ Systeminfo gespeichert als systeminfo.json');
  finally
    CoUninitialize;
  end;
end.

