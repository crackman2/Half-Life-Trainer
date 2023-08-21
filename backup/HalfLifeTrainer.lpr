program HalfLifeTrainer;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, Main, CProcMem, CgameMM, CgameOP, CgameBS, Cgame
  { you can add units after this };

{$R *.res}

begin
  Application.Title:='Half-Life Trainer';
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

