namespace EvaluateAIToolkit.Helpers;

using System.AI;

codeunit 70102 AOAIWrapper
{
    var
        IAOAIDeployment: Interface IAOAIDeployment;
        DeploymentSet: Boolean;

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

        GetDeploymentInstance();
        CheckInputLength(SystemPrompt, UserPrompt);

        AzureOpenAI.SetAuthorization(
            "AOAI Model Type"::"Chat Completions",
            IAOAIDeployment.GetEndpoint(),
            IAOAIDeployment.GetDeployment(),
            IAOAIDeployment.GetAPIKey()
        );
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
        exit(IAOAIDeployment.MaxModelTokens() - MaxOutputTokens());
    end;

    local procedure MaxOutputTokens(): Integer
    begin
        exit(2500);
    end;

    local procedure CheckInputLength(SystemPrompt: Text; UserPrompt: Text)
    var
        TokenCountImpl: Codeunit GPTTokensCountImpl;
        CompletePromptTokenCount: Integer;
    begin
        CompletePromptTokenCount := TokenCountImpl.PreciseTokenCount(SystemPrompt) + TokenCountImpl.PreciseTokenCount(UserPrompt);
        if CompletePromptTokenCount > MaxInputTokens() then
            Error('The input token count is too large. Shorten your prompts.');
    end;

    local procedure GetDeploymentInstance()
    var
        gpt35turbo: Codeunit gpt35turbo16k;
    begin
        if DeploymentSet then
            exit;

        IAOAIDeployment := gpt35turbo;
        DeploymentSet := true;
    end;

    internal procedure SetDeploymentInstance(DeploymentInstance: Interface IAOAIDeployment)
    begin
        IAOAIDeployment := DeploymentInstance;
        DeploymentSet := true;
    end;
}