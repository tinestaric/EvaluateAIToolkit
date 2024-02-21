namespace EvaluateAIToolkit.Helpers;

using System.AI;

codeunit 70102 AOAIWrapper
{
    [NonDebuggable]
    internal procedure GenerateResponse(SystemPrompt: Text; UserPrompt: Text): Text
    var
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AzureOpenAI: Codeunit "Azure OpenAi";
        CompletionAnswerTxt: Text;
    begin
        if not AzureOpenAI.IsEnabled("Copilot Capability"::EvaluateAIToolkit) then
            exit;

        CheckInputLength(SystemPrompt, UserPrompt);

        AzureOpenAI.SetAuthorization("AOAI Model Type"::"Chat Completions", GetEndpoint(), GetDeployment(), GetSecret());
        AzureOpenAI.SetCopilotCapability("Copilot Capability"::EvaluateAIToolkit);
        AOAIChatCompletionParams.SetMaxTokens(MaxOutputTokens());
        AOAIChatCompletionParams.SetTemperature(0);
        AOAIChatMessages.AddSystemMessage(SystemPrompt);
        AOAIChatMessages.AddUserMessage(UserPrompt);
        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);
        if AOAIOperationResponse.IsSuccess() then
            CompletionAnswerTxt := AOAIChatMessages.GetLastMessage()
        else
            Error(AOAIOperationResponse.GetError());

        exit(CompletionAnswerTxt);
    end;

    internal procedure MaxInputTokens(): Integer
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

    //TODO: Interface and less hardcode
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
    end;

    local procedure CheckInputLength(SystemPrompt: Text; UserPrompt: Text)
    var
        TokenCountImpl: Codeunit GPTTokensCountImpl;
        CompletePromptTokenCount: Integer;
    begin
        CompletePromptTokenCount := TokenCountImpl.PreciseTokenCount(SystemPrompt) + TokenCountImpl.PreciseTokenCount(UserPrompt);
        if CompletePromptTokenCount <= MaxInputTokens() then
            Error('The input token count is too large. Shorten your prompts.');
    end;
}