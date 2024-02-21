codeunit 70104 ExecuteTestPrompt implements ISimplePrompt
{
    procedure IsShowPromptPart(): Boolean
    begin
        exit(false);
    end;

    procedure ExecutePrompt(SysPrompt: Text; UserPrompt: Text) Completion: Text
    var
        AOAIWrapper: Codeunit AOAIWrapper;
    begin
        Completion := AOAIWrapper.GenerateResponse(SysPrompt, UserPrompt);
    end;

    internal procedure RunDialog(var _Completion: Text; PromptTest: Record PromptTest)
    var
        ExecuteTestPrompt: Codeunit ExecuteTestPrompt;
        RunPromptDialog: Page RunPromptDialog;
    begin
        RunPromptDialog.SetPrompts(PromptTest.GetSystemPrompt(), PromptTest.GetDefaultUserPrompt());
        RunPromptDialog.SetPromptType(ExecuteTestPrompt);
        if RunPromptDialog.RunModal() = Action::OK then
            _Completion := RunPromptDialog.GetCompletion();
    end;
}