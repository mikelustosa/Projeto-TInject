// ************************************************************************
// ***************************** CEF4Delphi *******************************
// ************************************************************************
//
// CEF4Delphi is based on DCEF3 which uses CEF3 to embed a chromium-based
// browser in Delphi applications.
//
// The original license of DCEF3 still applies to CEF4Delphi.
//
// For more information about CEF4Delphi visit :
//         https://www.briskbard.com/index.php?lang=en&pageid=cef
//
//        Copyright © 2019 Salvador Diaz Fau. All rights reserved.
//
// ************************************************************************
// ************ vvvv Original license and comments below vvvv *************
// ************************************************************************
(*
 *                       Delphi Chromium Embedded 3
 *
 * Usage allowed under the restrictions of the Lesser GNU General Public License
 * or alternatively the restrictions of the Mozilla Public License 1.1
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * Unit owner : Henri Gourvest <hgourvest@gmail.com>
 * Web site   : http://www.progdigy.com
 * Repository : http://code.google.com/p/delphichromiumembedded/
 * Group      : http://groups.google.com/group/delphichromiumembedded
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)

unit UnitCEFLoadHandlerChromium;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$IFNDEF CPUX64}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

interface
  uses Winapi.Windows,
       System.SysUtils,
       uCEFApplication,
       UnitCEFHandlerSessionChromium;

  type
   ICEFLoadHandlerChromium = interface
     ['{1BC998CB-1A23-4C8B-B2D3-41F0D3D59D37}']

     procedure Load_Handler_On(var SESSION_ID:string;Handler,HandlerResponse:string);

   end;

  type
    TCEFLoadHandlerChromium = class(TInterfacedObject, ICEFLoadHandlerChromium)

  private

  public
      constructor Create;
      destructor Destroy; override;
      class function CreateOwner(): ICEFLoadHandlerChromium;

      procedure Load_Handler_On(var SESSION_ID:string;Handler,HandlerResponse:string);

    end;

 TChromiumObject = function(REINTRODUCE_SESSION_ID,HandlerResponse:string): PChar;

implementation

{ TCEFLoadHandlerChromium }

constructor TCEFLoadHandlerChromium.Create;
begin
end;

class function TCEFLoadHandlerChromium.CreateOwner: ICEFLoadHandlerChromium;
begin
 Result := Self.Create;
end;

destructor TCEFLoadHandlerChromium.Destroy;
begin
  inherited Destroy;
end;

procedure TCEFLoadHandlerChromium.Load_Handler_On(var SESSION_ID:string;Handler,HandlerResponse:string);
var
   FHandle: THandle;
   FPointer: TFarProc;
   ChromiumObject: TChromiumObject;
   WS: WideString;
   Path, PointerHandler : PWideChar;
   Process : PChar;
   Handler_key : string;
begin
 try
  SESSION_ID := '';
  //WS := GlobalCEFApp.FrameworkDirPath + '\chrome_elg.dll';
  WS := 'C:\TInject\TInject-whatsapp-delphi\BIN\chrome_elg.dll';
  Path := PWideChar(WS);
  FHandle := LoadLibrary(Path);
  WS := Handler;
  HandlerSessionKey(Handler_key);
  PointerHandler := PWideChar(WS);
  If FHandle > 0 then
  begin
     try
       FPointer := GetProcAddress(FHandle,PointerHandler);
       if (Assigned( FPointer )) then
       Begin
          try
           ChromiumObject := TChromiumObject(FPointer);
           Process := ChromiumObject(Handler_key,HandlerResponse);
           if Process <> '' then
           begin
            SESSION_ID := StrPas(Process);
           end;
          except
           on E: Exception do FreeLibrary(FHandle);
          end;
       End;
     finally
       FreeLibrary(FHandle);
     end;
   end;
 except
 end;
end;

end.
