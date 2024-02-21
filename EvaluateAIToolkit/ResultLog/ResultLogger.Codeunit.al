codeunit 70110 ResultLogger
{
    var
        PromptTestResult: Record PromptTestResult;

    internal procedure Initialize(PromptTest: Record PromptTest; Completion: Text; UserPrompt: Text)
    begin
        PromptTestResult.Init();
        PromptTestResult.PromptCode := PromptTest.PromptCode;
        PromptTestResult.VersionNo := PromptTest.VersionNo;
        PromptTestResult.SetSystemPrompt(PromptTest.GetSystemPrompt());
        PromptTestResult.SetCompletion(Completion);
        PromptTestResult.SetUserPrompt(UserPrompt);
    end;

    internal procedure LogResult(IsSuccess: Boolean; ErrorMessage: Text)
    begin
        PromptTestResult.IsSuccess := IsSuccess;
        PromptTestResult.ErrorMessage := CopyStr(ErrorMessage, 1, MaxStrLen(PromptTestResult.ErrorMessage));
        PromptTestResult.Insert(true);
    end;
}