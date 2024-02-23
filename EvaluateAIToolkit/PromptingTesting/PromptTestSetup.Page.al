page 70102 PromptTestSetup
{
    Caption = 'Prompt Test Setup';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = PromptTest;
    AboutTitle = 'Prompt Test Setup';
    AboutText = 'This is where you setup your validation prompt and expected response schema for the prompt test.';


    layout
    {
        area(Content)
        {
            group(PromptGeneral)
            {
                Caption = 'Prompt';

                field(PromptCode; Rec.PromptCode) { Editable = false; }
                field(ExpectedResponseType; Rec.ExpectedResponseType) { }
                field(NoOfTestRuns; Rec.NoOfTestRuns)
                {
                    AboutTitle = 'No of Test Runs';
                    AboutText = 'Here is where you specify a number of parallel sessions that should be set in BCPT suite for this prompt test.';
                }
                field(AcceptablePassRate; Rec.AcceptablePassRate) { }
                field(Deployment; Rec.Deployment)
                {
                    Editable = Rec.AIFeature = Rec.AIFeature::None;
                    AboutTitle = 'Deployment';
                    AboutText = 'You can select different OpenAI deployments for testing prompts. This setting has no effect if you''re testing existing features.';
                }
            }
            group(ResponseSchemaGroup)
            {
                Caption = 'Expected Response Schema';
                AboutTitle = 'Expected Response Schema';
                AboutText = 'This is where you specify the expected response schema for the prompt test. This schema will be used to validate the completion. You can automatically extract the schema from the system prompt by clicking on the "Extract Response Schema" action.';

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
                AboutTitle = 'Validation Prompt';
                AboutText = 'This is where you specify the validation prompt for the prompt test. This prompt will be used to validate the completion. You can automatically extract the prompt from the system prompt by clicking on the "Create Validation Prompt" action.';

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
                AboutTitle = 'Test Schema';
                AboutText = 'This action will only test the completion against the expected schema. It will not test the validation prompt.';

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
                AboutTitle = 'Test Validation Prompt';
                AboutText = 'This action will only test the completion against the validation prompt. It will not test the expected schema.';

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
                AboutTitle = 'Extract Response Schema';
                AboutText = 'This action will use GPT to extract the expected response schema out of the system prompt.';

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
                ToolTip = 'Uses GPT to propose the validation prompt for the system prompt';
                Image = SparkleFilled;
                AboutTitle = 'Create Validation Prompt';
                AboutText = 'This action will use GPT to propose the validation prompt for validating the completion.';

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