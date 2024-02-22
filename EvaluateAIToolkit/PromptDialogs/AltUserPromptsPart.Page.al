page 70111 AltUserPromptsPart
{

    Caption = 'Alternative User Prompts';
    PageType = ListPart;
    SourceTable = AltUserPrompt;
    ApplicationArea = All;
    SourceTableTemporary = true;
    DeleteAllowed = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    InherentPermissions = X;
    InherentEntitlements = X;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(UserPrompt; Rec.UserPrompt) { }
            }
        }
    }

    internal procedure Load(var AltUserPromptGenerated: Record AltUserPrompt temporary)
    begin
        AltUserPromptGenerated.Reset();
        if AltUserPromptGenerated.FindSet() then
            repeat
                Rec := AltUserPromptGenerated;
                Rec.Insert(false);
            until AltUserPromptGenerated.Next() = 0;
    end;

    internal procedure GetTempRecord(GenerationId: Integer; var AltUserPromptGenerated: Record AltUserPrompt temporary)
    begin
        AltUserPromptGenerated.DeleteAll(false);
        Rec.Reset();
        Rec.SetRange(LineNo, GenerationId);
        AltUserPromptGenerated.DeleteAll(false);
        AltUserPromptGenerated.Copy(Rec, true);
    end;
}