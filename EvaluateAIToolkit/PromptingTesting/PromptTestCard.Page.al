page 70101 PromptTestCard
{
    PageType = Card;
    Caption = 'Prompt Test';
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = PromptTest;
    AboutTitle = 'About Prompt Tester';
    AboutText = 'The Prompt Tester is used to test the prompt and its completion according to the schema and validation rules.';

    layout
    {
        area(Content)
        {
            group(PromptGeneral)
            {
                Caption = 'Prompt';

                field(PromptCode; Rec.PromptCode) { }
                field(AIFeature; Rec.AIFeature)
                {
                    AboutTitle = 'Test existing features';
                    AboutText = 'If you want to test an existing AI feature instead of manual prompts, you can extend the AIFeature enum and use the AI feature to test the existing feature''s prompts.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
                field(VersionNo; Rec.VersionNo)
                {
                    Editable = false;
                    AboutTitle = 'Prompt versioning';
                    AboutText = 'Every time you change the system prompt, the version number is incremented. This is used to easily track test results to a specific system prompt.';

                    trigger OnDrillDown()
                    begin
                        OpenTestResults();
                    end;
                }
                field(PassRate; _PassRate)
                {
                    Editable = false;
                    Caption = 'Pass Rate';
                    StyleExpr = _PassRateStyle;
                    AboutTitle = 'Pass Rate';
                    AboutText = 'The pass rate is calculated based on the number of successful tests. The pass rate is compared to the acceptable pass rate to determine if the prompt is acceptable.';

                    trigger OnDrillDown()
                    begin
                        OpenTestResults();
                    end;
                }
                field(SchemaPassRate; _SchemaPassRate)
                {
                    Editable = false;
                    Caption = 'Schema Pass Rate';
                }
                field(ValidationPassRate; _ValidationPassRate)
                {
                    Editable = false;
                    Caption = 'Validation Pass Rate';
                }

                group(DescriptionGroup)
                {
                    Caption = 'Description';

                    field(Description; Rec.Description)
                    {
                        ShowCaption = false;
                        MultiLine = true;
                    }
                }
            }
            group(SystemPromptGroup)
            {
                Caption = 'System Prompt';
                Editable = Rec.AIFeature = Enum::AIFeature::None;
                AboutTitle = 'System Prompt';
                AboutText = 'The system prompt that you want to test. If you want to test an existing AI feature, you can select the AI feature and the system prompt will be automatically set.';

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
                AboutText = 'The default user prompt that is used in tests. You can specify alternative user prompts in the Alt User Prompts page to simulate different user responses.';

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
                ToolTip = 'This action runs a simple prompt and captures the response. No tests are performed.';
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
                AboutTitle = 'Test Completion';
                AboutText = 'This action tests the completion of the prompt. The completion is compared to the expected schema and validation rules.';

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
                AboutTitle = 'Batch Test';
                AboutText = 'This action prepares a test suite in BCPT Setup to run multiple prompts in parallel. The action opens the list of suites and you have to start the suite manually.';

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
                AboutTitle = 'Test Setup';
                AboutText = 'This action opens the Test Setup page where you can specify the expected schema and validation rules for the prompt.';
            }
            action(SetupAltUserPrompts)
            {
                Caption = 'Setup Alt User Prompts';
                ToolTip = 'Setup alternative user prompts';
                Image = SetupLines;
                RunObject = Page AltUserPrompts;
                RunPageLink = PromptCode = field(PromptCode);
                AboutTitle = 'Setup Alt User Prompts';
                AboutText = 'This action opens the Alt User Prompts page where you can specify alternative user prompts to simulate different user responses.';
            }
            action(Results)
            {
                Caption = 'Results';
                ToolTip = 'View the results of the prompt tests';
                Image = ErrorLog;
                AboutTitle = 'Results';
                AboutText = 'This action opens the Prompt Test Results page where you can view the results of the prompt tests.';

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
            group(Category_Category4)
            {
                Caption = 'Navigate';

                actionref(Results_Promoted; Results) { }
            }
            group(Category_Category5)
            {
                Caption = 'Setup';

                actionref(TestSetup_Promoted; TestSetup) { }
                actionref(SetupAltUserPrompts_Promoted; SetupAltUserPrompts) { }
            }
        }
    }

    var
        _SystemPrompt: Text;
        _UserPrompt: Text;
        _Completion: Text;
        _PassRate: Decimal;
        _SchemaPassRate: Decimal;
        _ValidationPassRate: Decimal;
        _PassRateStyle: Text;

    trigger OnAfterGetCurrRecord()
    begin
        GetTextFromBlobs();
        Rec.CalcPassRates(_PassRate, _SchemaPassRate, _ValidationPassRate);
        SetPassRateStyle();
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

    local procedure SetPassRateStyle()
    begin
        if _PassRate < Rec.AcceptablePassRate then
            _PassRateStyle := 'Unfavorable'
        else
            _PassRateStyle := 'Favorable';
    end;
}