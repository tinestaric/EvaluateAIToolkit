page 70105 RunPromptDialog
{
    Caption = 'Run a Prompt Dialog';
    DataCaptionExpression = _GenerationIdInputText;
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

    layout
    {
        area(Prompt)
        {
            field(UserPromptField; _UserPrompt)
            {
                ShowCaption = false;
                MultiLine = true;

                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
        }
        area(Content)
        {
            field(Completion; _Completion)
            {
                ShowCaption = false;
                MultiLine = true;
            }
        }
    }
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
            systemaction(Regenerate)
            {
                Caption = 'Regenerate';
                Tooltip = 'Regenerates an Email';
                trigger OnAction()
                begin
                    GenerateCompletion();
                end;
            }
            systemaction(Cancel)
            {
                ToolTip = 'Discards all suggestions and dismisses the dialog';
            }
            systemaction(Ok)
            {
                Caption = 'Keep it';
                ToolTip = 'Accepts the current suggestion, send the email and dismisses the dialog';
            }
        }
    }

    var
        _ISimplePrompt: Interface ISimplePrompt;
        _UserPrompt: Text;
        _SystemPrompt: Text;
        _GenerationIdInputText: Text;
        _Completion: Text;

    trigger OnAfterGetCurrRecord()
    begin
        _GenerationIdInputText := Rec."Value Long";
    end;

    internal procedure SetPrompts(SystemPrompt: Text; UserPrompt: Text)
    begin
        _SystemPrompt := SystemPrompt;
        _UserPrompt := UserPrompt;
    end;

    internal procedure SetPromptType(ISimplePrompt: Interface ISimplePrompt)
    begin
        _ISimplePrompt := ISimplePrompt;
    end;

    internal procedure GetCompletion(): Text
    begin
        exit(_Completion);
    end;

    local procedure GenerateCompletion()
    begin
        _Completion := _ISimplePrompt.ExecutePrompt(_SystemPrompt, _UserPrompt);
        SaveCompletionHistory();
    end;

    local procedure SaveCompletionHistory()
    begin
        Rec.ID += 1;
        Rec."Value Long" := CopyStr(_UserPrompt, 1, MaxStrLen(Rec."Value Long"));
        Rec.Insert(true);
    end;
}