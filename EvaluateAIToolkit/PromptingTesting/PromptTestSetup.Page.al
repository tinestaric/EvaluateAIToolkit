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
                field(AcceptablePassRate; Rec.AcceptablePassRate) { }
                field(Deployment; Rec.Deployment) { Editable = Rec.AIFeature = Rec.AIFeature::None; }
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
                        Rec.SetValidationPrompt(_ValidationPrompt);
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
                    Completion: Text;
                    OrgPrompt: Text;
                    UserPrompt: Text;
                begin
                    UserPrompt := Rec.GetDefaultUserPrompt();
                    OrgPrompt := Rec.GetSystemPrompt() + ' ' + UserPrompt;
                    Completion := Rec.Complete(UserPrompt);
                    IsSuccess := ValidationPromptCheck.ValidateCompletion(Completion, Rec.GetValidationPrompt(), OrgPrompt, ErrorMessage);
                    Message('Is Test Successful: %1\\ Error Message: %2', IsSuccess, ErrorMessage);
                end;
            }
            action(GetResponseSchema)
            {
                Caption = 'Extract Response Schema';
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
                Caption = 'Create Validation Prompt';
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
            group(Category_New)
            {
                Caption = 'New';

                actionref(GetResponseSchema_Promoted; GetResponseSchema) { }
                actionref(GetValidationPrompt_Promoted; GetValidationPrompt) { }
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