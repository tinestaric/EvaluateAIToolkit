codeunit 70113 ValidationPromptCheck
{
    internal procedure ValidateCompletion(
        CompletionToValidate: Text;
        ValidationPrompt: Text;
        OriginalPrompt: Text;
        var ErrorMessage: Text
    ) IsSuccess: Boolean
    var
        ExecuteValidationPrompt: Codeunit ValidateCompletion;
        ValidationPromptDialog: Page ValidationPromptDialog;
        Completion: Text;
    begin
        if GuiAllowed then begin
            ValidationPromptDialog.SetPrompts(ValidationPrompt, CompletionToValidate, OriginalPrompt);
            ValidationPromptDialog.RunModal();
            Completion := ValidationPromptDialog.GetCompletion();
        end else
            Completion := ExecuteValidationPrompt.ExecutePrompt(ValidationPrompt, CompletionToValidate, OriginalPrompt);

        if CheckIfValidCompletion(Completion) then
            IsSuccess := ParseCompletion(Completion, ErrorMessage)
        else begin
            IsSuccess := false;
            ErrorMessage := GetLastErrorText();
        end;
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