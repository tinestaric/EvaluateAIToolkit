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
                var
                    ExecuteTestPrompt: Codeunit ExecuteTestPrompt;
                begin
                    _Completion := ExecuteTestPrompt.Call(Rec.GetSystemPrompt(), Rec.GetUserPrompt());
                end;
            }

            action(TechnicalTest)
            {
                Caption = 'Technical Test';
                ToolTip = 'Tests the completions for technical compatibility. (i.e. does it return a valid JSON format).';
                Image = TestDatabase;
                RunObject = Page PromptTechnicalTest;
                RunPageOnRec = true;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(RunPrompt_Promoted; RunPrompt) { }
                actionref(TechnicalTest_Promoted; TechnicalTest) { }
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