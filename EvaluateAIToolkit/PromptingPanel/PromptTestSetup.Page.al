page 70102 PromptTestSetup
{
    Caption = 'Prompt Test Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = PromptTest;

    layout
    {
        area(Content)
        {
            group(PromptGeneral)
            {
                Caption = 'Prompt';

                field(PromptCode; Rec.PromptCode) { Editable = false; }
                field(ExpectedResponseType; Rec.ExpectedResponseType) { }
                field(NoOfTestRuns; Rec.NoOfTestRuns) { }
            }
            group(ResponseSchemaGroup)
            {
                Caption = 'Expected Response Schema';

                field(ExpectedResponseSchema; _ExpectedResponseSchema)
                {
                    ShowCaption = false;
                    ExtendedDatatype = RichContent;
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        Rec.SetExpectedResponseSchema(_ExpectedResponseSchema);
                    end;
                }
            }
            group(ValidationPromptGroup)
            {
                Caption = 'Validation Prompt';

                field(ValidationPrompt; _ValidationPrompt)
                {
                    ShowCaption = false;
                    ExtendedDatatype = RichContent;
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        Rec.SetExpectedResponseSchema(_ExpectedResponseSchema);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(TestSchema)
            {
                Caption = 'Test Schema';
                ToolTip = 'Tests the completion against the expected schema';
                Image = TestDatabase;

                trigger OnAction()
                var
                    ErrorMessage: Text;
                    IsSuccess: Boolean;
                begin
                    IsSuccess := Rec.TestCompletionWithSchema(Rec.Complete(Rec.GetDefaultUserPrompt()), ErrorMessage);
                    Message('Is Test Successful: %1\\ Error Message: %2', IsSuccess, ErrorMessage);
                end;
            }
            action(TestValidationPrompt)
            {
                Caption = 'Test Validation Prompt';
                ToolTip = 'Tests the completion against the validation prompt';
                Image = TestFile;

                trigger OnAction()
                var
                    ValidationPromptCheck: Codeunit ValidationPromptCheck;
                    IsSuccess: Boolean;
                    ErrorMessage: Text;
                begin
                    ValidationPromptCheck.SetShowUI(true);
                    IsSuccess := ValidationPromptCheck.ValidateCompletion(Rec.Complete(Rec.GetDefaultUserPrompt()), Rec.GetValidationPrompt(), ErrorMessage);
                    Message('Is Test Successful: %1\\ Error Message: %2', IsSuccess, ErrorMessage);
                end;
            }
            action(GetResponseSchema)
            {
                Caption = 'Get Response Schema';
                ToolTip = 'Uses GPT to extract the expected schema out of the system prompt';
                Image = SparkleFilled;

                trigger OnAction()
                var
                    ExtractSchemaPromptDialog: Page ExtractSchemaPromptDialog;
                begin
                    ExtractSchemaPromptDialog.SetPromptTest(Rec);
                    ExtractSchemaPromptDialog.RunModal();
                end;
            }
            action(GetValidationPrompt)
            {
                Caption = 'Get Validation Prompt';
                ToolTip = 'Uses GPT to extract the validation prompt out of the system prompt';
                Image = SparkleFilled;

                trigger OnAction()
                var
                    CreateValidationPrompt: Codeunit CreateValidationPrompt;
                begin
                    CreateValidationPrompt.RunPrompt(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(TestSchema_Promoted; TestSchema) { }
                actionref(TestValidationPrompt_Promoted; TestValidationPrompt) { }
            }
        }
    }

    var
        _ExpectedResponseSchema: Text;
        _ValidationPrompt: Text;

    trigger OnAfterGetCurrRecord()
    begin
        GetTextFromBlobs();
    end;

    local procedure GetTextFromBlobs()
    begin
        _ExpectedResponseSchema := Rec.GetExpectedResponseSchema();
        _ValidationPrompt := Rec.GetValidationPrompt();
    end;
}