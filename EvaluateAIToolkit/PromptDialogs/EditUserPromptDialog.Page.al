page 70109 EditUserPromptDialog
{
    Caption = 'Edit a prompt';
    PageType = PromptDialog;
    IsPreview = true;
    Extensible = false;
    PromptMode = Content;
    ApplicationArea = All;
    Editable = true;
    InherentPermissions = X;
    InherentEntitlements = X;

    layout
    {
        area(Content)
        {
            field(_UserPrompt; _UserPrompt)
            {
                ShowCaption = false;
                MultiLine = true;

                trigger OnValidate()
                begin
                end;
            }
        }
    }
    actions
    {
        area(SystemActions)
        {
            systemaction(Cancel)
            {
                ToolTip = 'Discards all suggestions and dismisses the dialog';
            }
            systemaction(Ok)
            {
                Caption = 'Keep it';
                ToolTip = 'Accepts the current suggestion, send the email and dismisses the dialog';
            }
        }
    }

    var
        _UserPrompt: Text;

    internal procedure SetPrompt(UserPrompt: Text)
    begin
        _UserPrompt := UserPrompt;
    end;


    internal procedure GetPrompt(): Text
    begin
        exit(_UserPrompt);
    end;
}