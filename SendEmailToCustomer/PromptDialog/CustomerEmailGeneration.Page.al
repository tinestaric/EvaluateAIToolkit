page 50100 CustomerEmailGeneration
{
    Caption = 'Generate an Email for a Customer';
    DataCaptionExpression = GenerationIdInputText;
    PageType = PromptDialog;
    IsPreview = true;
    Extensible = false;
    // PromptMode = Content;
    ApplicationArea = All;
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
            field(GeneratedEmail; GeneratedEmail)
            {
                Caption = 'Generated Email';
                ToolTip = 'The generated email';
                ApplicationArea = All;
                Editable = true;
                Enabled = true;
            }
        }
    }
    actions
    {
        area(SystemActions)
        {
            systemaction(Generate)
            {
                Tooltip = 'Generates an Email';
                trigger OnAction()
                begin
                    GenerateEmail();
                end;
            }
            systemaction(Regenerate)
            {
                Caption = 'Regenerate';
                Tooltip = 'Regenerates an Email';
                trigger OnAction()
                begin
                    GenerateEmail();
                end;
            }
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
        GeneratedEmailSet: Record GeneratedEmail;
        InputText: Text;
        GenerationIdInputText: Text;
        GeneratedEmail: Text;
        InvoiceNo: Code[20];

    trigger OnAfterGetCurrRecord()
    begin
        GenerationIdInputText := Rec."Value Long";
        if GeneratedEmailSet.Get(Rec.ID) then;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
    begin
        if CloseAction = CloseAction::OK then
            SendEmail();
    end;

    internal procedure SetInvoiceNo(NewInvoiceNo: Code[20])
    begin
        InvoiceNo := NewInvoiceNo;
    end;

    local procedure GenerateEmail()
    var
        CustEmailGenerationImpl: Codeunit CustEmailGenerationImpl;
    begin
        CustEmailGenerationImpl.Generate(Rec, GeneratedEmailSet, InputText, InvoiceNo);
        GeneratedEmail := GeneratedEmailSet.Content;
    end;

    local procedure SendEmail()
    var
        CustEmailGenerationImpl: Codeunit CustEmailGenerationImpl;
    begin
        CustEmailGenerationImpl.SendEmail(GeneratedEmail);
    end;
}