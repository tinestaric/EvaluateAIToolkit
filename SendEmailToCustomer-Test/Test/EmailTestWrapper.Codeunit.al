codeunit 60600 EmailTestWrapper implements IAIFeature
{
    procedure GetSystemPrompt(): Text
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        CustEmailGenerationImpl: Codeunit CustEmailGenerationImpl;
    begin
        SalesInvoiceHeader.FindFirst();

        exit(CustEmailGenerationImpl.GetSystemPrompt(SalesInvoiceHeader."No."));
    end;

    procedure Generate(UserPrompt: Text) Completion: Text
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        TempNameValueBuffer: Record "Name/Value Buffer" temporary;
        GeneratedEmail: Record GeneratedEmail;
        CustEmailGenerationImpl: Codeunit CustEmailGenerationImpl;
    begin
        SalesInvoiceHeader.FindFirst();

        CustEmailGenerationImpl.Generate(TempNameValueBuffer, GeneratedEmail, UserPrompt, SalesInvoiceHeader."No.");

        exit(GeneratedEmail.GetContent());
    end;
}