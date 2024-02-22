namespace AISample.PromptDialog;

using Microsoft.Sales.History;

pageextension 60100 SalesInvoiceListExt extends "Posted Sales Invoices"
{
    actions
    {
        addafter("Print")
        {
            action(GPTGenerateEmail)
            {
                Caption = 'Generate Email';
                ToolTip = 'Generate Email using Copilot';
                Image = Sparkle;
                ApplicationArea = All;

                trigger OnAction()
                var
                    CustomerEmailGeneration: Page CustomerEmailGeneration;
                begin
                    CustomerEmailGeneration.SetInvoiceNo(Rec."No.");
                    CustomerEmailGeneration.LookupMode := true;
                    if CustomerEmailGeneration.RunModal() = Action::LookupOK then
                        CurrPage.Update();
                end;
            }
        }

        addlast(Category_Category7)
        {
            actionref(GPTGenerateEmail_Promoted; GPTGenerateEmail) { }
        }
    }
}