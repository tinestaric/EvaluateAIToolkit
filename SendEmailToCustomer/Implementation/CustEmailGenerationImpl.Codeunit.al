codeunit 60100 CustEmailGenerationImpl
{
    procedure Generate(var GenerationId: Record "Name/Value Buffer"; var GeneratedEmail: Record GeneratedEmail; InputText: Text; InvoiceNo: Code[20])
    var
        TokenCountImpl: Codeunit GPTTokensCountImpl;
        CompletePromptTokenCount: Integer;
        Completion: Text;
        SystemPromptTxt: Text;
    begin
        SystemPromptTxt := GetSystemPrompt(InvoiceNo);

        CompletePromptTokenCount := TokenCountImpl.PreciseTokenCount(SystemPromptTxt) + TokenCountImpl.PreciseTokenCount(InputText);
        if CompletePromptTokenCount <= MaxInputTokens() then begin
            Completion := GenerateEmail(SystemPromptTxt, InputText);
            SaveGenerationHistory(GenerationId, InputText);
            InsertGeneratedEmail(GeneratedEmail, Completion, GenerationId.ID);
        end;
    end;

    [NonDebuggable]
    internal procedure GenerateEmail(SystemPromptTxt: Text; InputText: Text): Text
    var
        AzureOpenAI: Codeunit "Azure OpenAi";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        CompletionAnswerTxt: Text;
    begin
        if not AzureOpenAI.IsEnabled("Copilot Capability"::SendEmailToCustomer) then
            exit;

        AzureOpenAI.SetAuthorization("AOAI Model Type"::"Chat Completions", GetEndpoint(), GetDeployment(), GetSecret());
        AzureOpenAI.SetCopilotCapability("Copilot Capability"::SendEmailToCustomer);
        AOAIChatCompletionParams.SetMaxTokens(MaxOutputTokens());
        AOAIChatCompletionParams.SetTemperature(0);
        AOAIChatMessages.AddSystemMessage(SystemPromptTxt);
        AOAIChatMessages.AddUserMessage(InputText);
        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);
        if AOAIOperationResponse.IsSuccess() then
            CompletionAnswerTxt := AOAIChatMessages.GetLastMessage()
        else
            Error(AOAIOperationResponse.GetError());

        exit(CompletionAnswerTxt);
    end;

    internal procedure SendEmail(GeneratedEmail: Text)
    begin
        Message(GeneratedEmail);
    end;

    internal procedure GetSystemPrompt(InvoiceNo: Code[20]): Text
    var
        SystemPrompt: TextBuilder;
    begin
        SystemPrompt.AppendLine('You are `generateCustomerEmail` API');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('Your task: Generate a customized email for a customer, notifying him of his recent purchase. Do not just list the information, but incorporate it into a well-structured email.');
        SystemPrompt.AppendLine('"""');
        ListInvoiceInformation(SystemPrompt, InvoiceNo);
        SystemPrompt.AppendLine('"""');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('User might add additional instructions on how to word the email.');
        SystemPrompt.AppendLine('Try to fullfil them.');
        SystemPrompt.AppendLine();
        exit(SystemPrompt.ToText());
    end;

    local procedure ListInvoiceInformation(var SystemPrompt: TextBuilder; InvoiceNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
    begin
        SalesInvoiceHeader.Get(InvoiceNo);
        SalesInvoiceHeader.CalcFields("Amount Including VAT");
        SystemPrompt.AppendLine('Invoice No: ' + SalesInvoiceHeader."No.");
        SystemPrompt.AppendLine('Date: ' + Format(SalesInvoiceHeader."Posting Date"));
        SystemPrompt.AppendLine('Due Date: ' + Format(SalesInvoiceHeader."Due Date"));
        SystemPrompt.AppendLine('Total Amount: ' + Format(SalesInvoiceHeader."Amount Including VAT"));
        SystemPrompt.AppendLine('Customer No: ' + SalesInvoiceHeader."Sell-to Customer No.");
        SystemPrompt.AppendLine('Customer Name: ' + SalesInvoiceHeader."Sell-to Customer Name");
    end;

    local procedure GetEndpoint(): Text
    begin
        exit('https://bcaihackathon.openai.azure.com/');
    end;

    local procedure GetDeployment(): Text
    begin
        exit('gpt-35-turbo');
    end;

    [NonDebuggable]
    local procedure GetSecret(): Text
    begin
        exit('7c77ad4735014e38b4336e578f78e938');
    end;

    local procedure MaxInputTokens(): Integer
    begin
        exit(MaxModelTokens() - MaxOutputTokens());
    end;

    local procedure MaxOutputTokens(): Integer
    begin
        exit(2500);
    end;

    local procedure MaxModelTokens(): Integer
    begin
        exit(4096); //GPT 3.5 Turbo
    end;

    local procedure SaveGenerationHistory(var GenerationId: Record "Name/Value Buffer"; InputText: Text)
    begin
        GenerationId.ID += 1;
        GenerationId."Value Long" := CopyStr(InputText, 1, MaxStrLen(GenerationId."Value Long"));
        GenerationId.Insert(true);
    end;

    local procedure InsertGeneratedEmail(var GeneratedEmail: Record GeneratedEmail; EmailObj: Text; GenerationId: Integer)
    begin
        GeneratedEmail.Init();
        GeneratedEmail.GenerationId := GenerationId;
        GeneratedEmail.SetContent(EmailObj);
        GeneratedEmail.Insert(true);
    end;
}