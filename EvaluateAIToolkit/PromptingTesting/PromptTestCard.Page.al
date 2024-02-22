page 70101 PromptTestCard
{
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

                field(PromptCode; Rec.PromptCode) { }
                field(AIFeature; Rec.AIFeature) { }
                field(VersionNo; Rec.VersionNo)
                {
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        OpenTestResults();
                    end;
                }
            }
            group(DescriptionGroup)
            {
                ShowCaption = false;

                field(Description; Rec.Description)
                {
                    MultiLine = true;
                }
            }
            group(SystemPromptGroup)
            {
                Caption = 'System Prompt';
                Editable = Rec.AIFeature = Enum::AIFeature::None;

                field(SystemPrompt; _SystemPrompt)
                {
                    ShowCaption = false;
                    ExtendedDatatype = RichContent;
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        Rec.SetSystemPrompt(_SystemPrompt);
                    end;
                }
            }
            group(UserPromptGroup)
            {
                Caption = 'Default User Prompt';

                field(UserPrompt; _UserPrompt)
                {
                    ShowCaption = false;
                    ExtendedDatatype = RichContent;
                    MultiLine = true;

                    trigger OnValidate()
                    var
                        OutStr: OutStream;
                    begin
                        Clear(Rec.DefaultUserPrompt);
                        Rec.DefaultUserPrompt.CreateOutStream(OutStr);
                        OutStr.WriteText(_UserPrompt);
                    end;
                }
            }
            Group(CompletionGroup)
            {
                Caption = 'Completion';

                field(Completion; _Completion)
                {
                    ShowCaption = false;
                    ExtendedDatatype = RichContent;
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(RunPrompt)
            {
                Caption = 'Run Prompt';
                ToolTip = 'Runs the prompt and captures the response';
                Image = SparkleFilled;

                trigger OnAction()
                var
                    ExecuteTestPrompt: Codeunit ExecuteTestPrompt;
                begin
                    ExecuteTestPrompt.RunDialog(_Completion, Rec);
                end;
            }
            action(TestCompletion)
            {
                Caption = 'Test Completion';
                ToolTip = 'Compare the expected schema with the actual schema of the completion';
                Image = TestFile;

                trigger OnAction()
                var
                    IsSuccess: Boolean;
                    UserPrompt: Text;
                begin
                    UserPrompt := Rec.GetRandomUserPrompt();
                    _Completion := Rec.Complete(UserPrompt);

                    IsSuccess := Rec.TestCompletion(_Completion, UserPrompt);

                    Message('Prompt Validation Passed: %1', IsSuccess);
                end;
            }

            action(BatchTest)
            {
                Caption = 'Batch Test';
                ToolTip = 'Send multiple prompts to the system and compare the expected schema with the actual schema of the completion';
                Image = ChangeBatch;

                trigger OnAction()
                var
                    BCPTSetupList: Page "BCPT Setup List";
                begin
                    Rec.PrepareBCPTSuiteForPrompt();
                    BCPTSetupList.Run();
                end;
            }
            action(TestSetup)
            {
                Caption = 'Test Setup';
                ToolTip = 'Setup Technical and Semantical testing of completions';
                Image = Setup;
                RunObject = Page PromptTestSetup;
                RunPageOnRec = true;
            }
            action(SetupAltUserPrompts)
            {
                Caption = 'Setup Alt User Prompts';
                ToolTip = 'Setup alternative user prompts';
                Image = SetupLines;
                RunObject = Page AltUserPrompts;
                RunPageLink = PromptCode = field(PromptCode);
            }
            action(Results)
            {
                Caption = 'Results';
                ToolTip = 'View the results of the prompt tests';
                Image = ErrorLog;

                trigger OnAction()
                begin
                    OpenTestResults();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(RunPrompt_Promoted; RunPrompt) { }
                actionref(TestPrompt_Promoted; TestCompletion) { }
                actionref(BatchTest_Promoted; BatchTest) { }
            }
        }
    }

    var
        _SystemPrompt: Text;
        _UserPrompt: Text;
        _Completion: Text;

    trigger OnAfterGetCurrRecord()
    begin
        GetTextFromBlobs();
    end;

    local procedure GetTextFromBlobs()
    begin
        _SystemPrompt := Rec.GetSystemPrompt();
        _UserPrompt := Rec.GetDefaultUserPrompt();
    end;

    local procedure OpenTestResults()
    var
        PromptTestResult: Record PromptTestResult;
    begin
        PromptTestResult.SetRange(PromptCode, Rec.PromptCode);
        PromptTestResult.SetRange(VersionNo, Rec.VersionNo);
        Page.Run(Page::PromptTestResultList, PromptTestResult);
    end;
}