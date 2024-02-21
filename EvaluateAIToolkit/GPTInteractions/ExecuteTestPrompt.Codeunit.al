codeunit 70104 ExecuteTestPrompt
{
    procedure Call(SysPrompt: Text; UserPrompt: Text) Completion: Text
    var
        AOAIWrapper: Codeunit AOAIWrapper;
    begin
        Completion := AOAIWrapper.GenerateResponse(SysPrompt, UserPrompt);
    end;
}