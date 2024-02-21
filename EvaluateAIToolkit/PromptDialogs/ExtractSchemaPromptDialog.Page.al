page 70106 ExtractSchemaPromptDialog
{
    Caption = 'Extract Schema';
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
            field(UserPrompt; _UserPrompt)
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
            field(SchemaType; _SchemaType) { Caption = 'Schema Type'; }
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
        _PromptTest: Record PromptTest;
        _UserPrompt: Text;
        _GenerationIdInputText: Text;
        _Completion: Text;
        _SchemaType: Enum ExpectedResponseType;

    trigger OnAfterGetCurrRecord()
    begin
        _GenerationIdInputText := Rec."Value Long";
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = CloseAction::Ok then begin
            _PromptTest.SetExpectedResponseSchema(_Completion);
            _PromptTest.ExpectedResponseType := _SchemaType;
            _PromptTest.Modify(true);
        end;

    end;

    internal procedure SetPromptTest(PromptTest: Record PromptTest)
    begin
        _PromptTest := PromptTest;
        _UserPrompt := _PromptTest.GetDefaultUserPrompt();
    end;

    internal procedure GetCompletion(): Text
    begin
        exit(_Completion);
    end;

    local procedure GenerateCompletion()
    var
        ExtractResponseSchema: Codeunit ExtractResponseSchema;
    begin
        ExtractResponseSchema.ExecutePrompt(_PromptTest.GetSystemPrompt(), _PromptTest);
        _Completion := _PromptTest.GetExpectedResponseSchema();
        _SchemaType := _PromptTest.ExpectedResponseType;
    end;
}