page 70103 PromptTestResultList
{
    ApplicationArea = All;
    Caption = 'Prompt Test Results';
    PageType = List;
    SourceTable = PromptTestResult;
    UsageCategory = None;
    Editable = false;
    CardPageId = PromptTestResultCard;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(LineNo; Rec.LineNo) { }
                field(VersionNo; Rec.VersionNo) { }
                field(Type; Rec.Type) { }
                field(IsSuccess; Rec.IsSuccess) { }
                field(ErrorMessage; Rec.ErrorMessage) { }
                field(SystemCreatedAt; Rec.SystemCreatedAt) { Caption = 'Timestamp'; }
                field(Deployment; Rec.Deployment) { }
            }
        }
    }
}
