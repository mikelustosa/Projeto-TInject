unit ImageViewer.Helper;

interface

uses
  FMX.ExtCtrls;

type
  TImageViewerHelper = class helper for TImageViewer
public
  procedure LoadFromURL(const AURL: string; const AWidth, AHeight: Integer);
end;

implementation

uses System.Classes, IdHTTP;

procedure TImageViewerHelper.LoadFromURL(const AURL: string; const AWidth, AHeight: Integer);
var
  FStream: TMemoryStream;
  FIdHTTP : TIdHTTP;
begin
  FStream := TMemoryStream.Create;
  FIdHTTP := TIdHTTP.Create(nil);
  try
    FIdHTTP.Get(AURL, FStream);
    if (FStream.Size > 0) then
    begin
      FStream.Position := 0;
      Self.Bitmap.LoadFromStream(FStream);

      Self.Bitmap.Resize(AWidth, AHeight);
    end;

    finally
      FStream.Free;
      FIdHTTP.Free;
  end;
end;

end.
