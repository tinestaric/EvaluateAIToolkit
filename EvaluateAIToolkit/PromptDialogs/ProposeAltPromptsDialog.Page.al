page 70110 ProposeAltPromptsDialog
{
    Caption = 'Propose Alternative Prompts';
    PageType = PromptDialog;
    IsPreview = true;
    Extensible = false;
    ApplicationArea = All;
    PromptMode = Generate;
    Editable = true;
    SourceTable = "Name/Value Buffer";
    SourceTableTemporary = true;
    InherentPermissions = X;
    InherentEntitlements = X;

    layout
    {
        area(Prompt)
        {
            field(InputText; InputText)
            {
                ShowCaption = false;
                MultiLine = true;
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }

        }
        area(Content)
        {
            part(ProposalDetails; AltUserPromptsPart)
            {
                ShowFilter = false;
                ApplicationArea = All;
                Editable = true;
                Enabled = true;
                SubPageLink = LineNo = field(ID);
            }
        }
    }
    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Caption = 'Generate';
                Tooltip = 'Generate Alternative Prompts';
                trigger OnAction()
                begin
                    GenerateAltUserPrompts();
                end;
            }
            systemaction(Regenerate)
            {
                Caption = 'Regenerate';
                Tooltip = 'Regenerate Alternative Prompts';
                trigger OnAction()
                begin
                    GenerateAltUserPrompts();
                end;
            }
            systemaction(Cancel)
            {
                ToolTip = 'Discards all suggestions and dismisses the dialog';
            }
            systemaction(Ok)
            {
                Caption = 'Keep it';
                ToolTip = 'Accepts the current suggestion and dismisses the dialog';
            }
        }
    }

    var
        _PromptTest: Record PromptTest;
        inputtext: text;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
    begin
        if CloseAction = CloseAction::OK then
            ApplyProposedPrompts();
    end;

    internal procedure SetPromptCode(PromptCode: Code[10])
    begin
        _PromptTest.Get(PromptCode);
    end;

    local procedure GenerateAltUserPrompts()
    var
        TempAltUserPromptGenerated: Record AltUserPrompt temporary;
        ProposeAltUserPrompt: Codeunit ProposeAltPrompts;
    begin
        ProposeAltUserPrompt.ExecutePrompt(Rec, TempAltUserPromptGenerated, _PromptTest.GetSystemPrompt());
        CurrPage.ProposalDetails.Page.Load(TempAltUserPromptGenerated);
    end;

    local procedure ApplyProposedPrompts()
    var
        TempAltUserPromptGenerated: Record AltUserPrompt temporary;
        AltUserPrompt: Record AltUserPrompt;
    begin
        CurrPage.ProposalDetails.Page.GetTempRecord(Rec.ID, TempAltUserPromptGenerated);

        if TempAltUserPromptGenerated.FindSet() then
            repeat
                AltUserPrompt.Init();
                AltUserPrompt.PromptCode := _PromptTest.PromptCode;
                AltUserPrompt.LineNo := 0;
                AltUserPrompt.UserPrompt := TempAltUserPromptGenerated.UserPrompt;
                AltUserPrompt.Insert(true);
            until TempAltUserPromptGenerated.Next() = 0;
    end;
}