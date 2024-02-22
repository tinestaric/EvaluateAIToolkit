codeunit 70110 ResultLogger
{
    var
        PromptTestResult: Record PromptTestResult;

    internal procedure Initialize(PromptTest: Record PromptTest; Completion: Text; UserPrompt: Text)
    begin
        PromptTestResult.Init();
        PromptTestResult.PromptCode := PromptTest.PromptCode;
        PromptTestResult.VersionNo := PromptTest.VersionNo;
        PromptTestResult.Deployment := PromptTest.Deployment;
        PromptTestResult.SetSystemPrompt(PromptTest.GetSystemPrompt());
        PromptTestResult.SetCompletion(Completion);
        PromptTestResult.SetUserPrompt(UserPrompt);
        PromptTestResult.SetValidationPrompt(PromptTest.GetValidationPrompt());
    end;

    internal procedure LogSchemaValidationResult(IsSuccess: Boolean; ErrorMessage: Text)
    begin
        PromptTestResult.LineNo := 0;
        PromptTestResult.Type := PromptTestResult.Type::SchemaValidation;
        PromptTestResult.IsSuccess := IsSuccess;
        PromptTestResult.ErrorMessage := CopyStr(ErrorMessage, 1, MaxStrLen(PromptTestResult.ErrorMessage));
        PromptTestResult.Insert(true);
    end;

    internal procedure LogValidationPromptResult(IsSuccess: Boolean; ErrorMessage: Text)
    begin
        PromptTestResult.LineNo := 0;
        PromptTestResult.Type := PromptTestResult.Type::ValidationPrompt;
        PromptTestResult.IsSuccess := IsSuccess;
        PromptTestResult.ErrorMessage := CopyStr(ErrorMessage, 1, MaxStrLen(PromptTestResult.ErrorMessage));
        PromptTestResult.Insert(true);
    end;
}