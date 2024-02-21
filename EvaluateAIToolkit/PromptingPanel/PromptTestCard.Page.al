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

                field(SystemPrompt; _SystemPrompt)
                {
                    ShowCaption = false;
                    ExtendedDatatype = RichContent;
                    MultiLine = true;

                    trigger OnValidate()
                    var
                        OutStr: OutStream;
                    begin
                        Clear(Rec.SystemPrompt);
                        Rec.SystemPrompt.CreateOutStream(OutStr);
                        OutStr.WriteText(_SystemPrompt);
                    end;
                }
            }
            group(UserPromptGroup)
            {
                Caption = 'User Prompt';

                field(UserPrompt; _UserPrompt)
                {
                    ShowCaption = false;
                    ExtendedDatatype = RichContent;
                    MultiLine = true;

                    trigger OnValidate()
                    var
                        OutStr: OutStream;
                    begin
                        Clear(Rec.UserPrompt);
                        Rec.UserPrompt.CreateOutStream(OutStr);
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
                    Editable = false;
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
                begin
                    _Completion := Rec.Complete();
                end;
            }
            action(TestPrompt)
            {
                Caption = 'Test Completion Structure';
                ToolTip = 'Compare the expected schema with the actual schema of the completion';
                Image = TestFile;

                trigger OnAction()
                var
                    IsSuccess: Boolean;
                begin
                    _Completion := Rec.Complete();
                    IsSuccess := Rec.TestCompletionWithSchema(_Completion);

                    Message('Test Completion Structure: %1', IsSuccess);
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
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(RunPrompt_Promoted; RunPrompt) { }
                actionref(TestPrompt_Promoted; TestPrompt) { }
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
        _UserPrompt := Rec.GetUserPrompt();
    end;
}