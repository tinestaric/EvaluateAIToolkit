page 60100 CustomerEmailGeneration
{
    Caption = 'Generate an Email for a Customer';
    DataCaptionExpression = GenerationIdInputText;
    PageType = PromptDialog;
    IsPreview = true;
    Extensible = false;
    PromptMode = Prompt;
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
            }
        }
        area(Content)
        {
            group(GeneratedEmailGroup)
            {
                ShowCaption = false;

                field(GeneratedEmail; GeneratedEmail)
                {
                    Caption = 'Generated Email';
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    trigger OnValidate()
                    begin
                        GeneratedEmailSet.SetContent(GeneratedEmail);
                    end;
                }
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
        if GeneratedEmailSet.Get(Rec.ID) then
            GeneratedEmail := GeneratedEmailSet.GetContent();
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
        GeneratedEmail := GeneratedEmailSet.GetContent();
    end;

    local procedure SendEmail()
    var
        CustEmailGenerationImpl: Codeunit CustEmailGenerationImpl;
    begin
        CustEmailGenerationImpl.SendEmail(GeneratedEmail);
    end;
}