page 70104 PromptTestResultCard
{
    ApplicationArea = All;
    Caption = 'Prompt Test Result';
    PageType = Card;
    UsageCategory = None;
    SourceTable = PromptTestResult;
    Editable = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(LineNo; Rec.LineNo) { }
                field(VersionNo; Rec.VersionNo) { }
                field(IsSuccess; Rec.IsSuccess) { }
                field(ErrorMessage; Rec.ErrorMessage) { }
                field(SystemCreatedAt; Rec.SystemCreatedAt) { Caption = 'Timestamp'; }
            }
            group(SystemPromptGroup)
            {
                Caption = 'System Prompt';

                field(SystemPrompt; _SystemPrompt)
                {
                    ShowCaption = false;
                    ExtendedDatatype = RichContent;
                    MultiLine = true;
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
        _Completion := Rec.GetCompletion();
    end;
}
