page 70107 ValidationPromptDialog
{
    Caption = 'Generating...';
    PageType = PromptDialog;
    IsPreview = true;
    Extensible = false;
    PromptMode = Generate;
    ApplicationArea = All;
    Editable = true;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;
    InherentPermissions = X;
    InherentEntitlements = X;

    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Tooltip = 'Generates an Email';
                trigger OnAction()
                begin
                    GenerateCompletion();
                end;
            }
        }
    }

    var
        _Completion: Text;
        _ValidationPrompt: Text;
        _CompletionToValidate: Text;

    trigger OnAfterGetCurrRecord()
    begin
    end;

    internal procedure SetPrompts(ValidationPrompt: Text; CompletionToValidate: Text)
    begin
        _ValidationPrompt := ValidationPrompt;
        _CompletionToValidate := CompletionToValidate;
    end;

    internal procedure GetCompletion(): Text
    begin
        exit(_Completion);
    end;

    local procedure GenerateCompletion()
    var
        ExecuteValidationPrompt: Codeunit ExecuteValidationPrompt;
    begin
        _Completion := ExecuteValidationPrompt.ExecutePrompt(_ValidationPrompt, _CompletionToValidate);
        CurrPage.Close();
    end;
}