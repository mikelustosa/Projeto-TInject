unit uTInject.Diversos;

interface

function PrettyJSON(JsonString: String):String;

implementation

uses
  System.JSON, REST.Json;


function PrettyJSON(JsonString: String):String;
var
  AObj: TJSONObject;
begin
    AObj   := TJSONObject.ParseJSONValue(JsonString) as TJSONObject;
    result := TJSON.Format(AObj);
    AObj.Free;
end;

end.
