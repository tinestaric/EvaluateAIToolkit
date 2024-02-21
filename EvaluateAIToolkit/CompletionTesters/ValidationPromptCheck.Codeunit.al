codeunit 70113 ValidationPromptCheck
{
    var
        _ShowUI: Boolean;

    internal procedure ValidateCompletion(CompletionToValidate: Text; ValidationPrompt: Text; var ErrorMessage: Text) IsSuccess: Boolean
    var
        ExecuteValidationPrompt: Codeunit ExecuteValidationPrompt;
        ValidationPromptDialog: Page ValidationPromptDialog;
        Completion: Text;
    begin
        if _ShowUI then begin
            ValidationPromptDialog.SetPrompts(ValidationPrompt, CompletionToValidate);
            ValidationPromptDialog.RunModal();
            Completion := ValidationPromptDialog.GetCompletion();
        end else
            Completion := ExecuteValidationPrompt.ExecutePrompt(ValidationPrompt, CompletionToValidate);

        if CheckIfValidCompletion(Completion) then
            IsSuccess := ParseCompletion(Completion, ErrorMessage);
    end;

    internal procedure SetShowUI(ShowUI: Boolean)
    begin
        _ShowUI := ShowUI;
    end;

    [TryFunction]
    local procedure CheckIfValidCompletion(Completion: Text)
    var
        JsonObject: JsonObject;
    begin
        JsonObject.ReadFrom(Completion);
    end;

    local procedure ParseCompletion(Completion: Text; var ErrorMessage: Text) IsSuccess: Boolean
    var
        JSONManagement: Codeunit "JSON Management";
        valueText: Text;
    begin
        JSONManagement.InitializeObject(Completion);

        JSONManagement.GetStringPropertyValueByName('isValid', valueText);
        Evaluate(IsSuccess, valueText);

        JSONManagement.GetStringPropertyValueByName('errorMessage', ErrorMessage);
    end;
}