page 70108 AltUserPrompts
{
    ApplicationArea = All;
    Caption = 'Alternative User Prompts';
    PageType = List;
    SourceTable = AltUserPrompt;
    UsageCategory = None;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(UserPrompt; Rec.UserPrompt)
                {
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        EditUserPromptDialog: Page EditUserPromptDialog;
                    begin
                        EditUserPromptDialog.SetPrompt(Rec.UserPrompt);
                        if EditUserPromptDialog.RunModal() = Action::OK then
                            Rec.UserPrompt := CopyStr(EditUserPromptDialog.GetPrompt(), 1, MaxStrLen(Rec.UserPrompt));
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ProposeAltPrompts)
            {
                Caption = 'Propose Alternative Prompts';
                ToolTip = 'Proposes alternative user prompts for the system prompt.';
                Image = SparkleFilled;

                trigger OnAction()
                var
                    ProposeAltPromptsDialog: Page ProposeAltPromptsDialog;
                begin
                    ProposeAltPromptsDialog.SetPromptCode(CopyStr(Rec.GetFilter(PromptCode), 1, 10));
                    ProposeAltPromptsDialog.RunModal();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(ProposeAltPrompts_Promoted; ProposeAltPrompts) { }
            }
        }
    }
}
