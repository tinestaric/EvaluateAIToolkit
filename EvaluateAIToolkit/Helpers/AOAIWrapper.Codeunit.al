namespace EvaluateAIToolkit.Helpers;

using System.AI;

codeunit 70102 AOAIWrapper
{
    var
        _IAOAIDeployment: Interface IAOAIDeployment;
        _DeploymentSet: Boolean;
        _JsonMode: Boolean;

    [NonDebuggable]
    internal procedure GenerateResponse(SystemPrompt: Text; UserPrompt: Text): Text
    var
        AOAIChatCompletionParams: Codeunit "AOAI Chat Completion Params";
        AOAIChatMessages: Codeunit "AOAI Chat Messages";
        AOAIOperationResponse: Codeunit "AOAI Operation Response";
        AzureOpenAI: Codeunit "Azure OpenAI";
        CompletionAnswerTxt: Text;
    begin
        if not AzureOpenAI.IsEnabled("Copilot Capability"::EvaluateAIToolkit) then
            exit;

        GetDeploymentInstance();
        CheckInputLength(SystemPrompt, UserPrompt);

        AzureOpenAI.SetAuthorization(
            "AOAI Model Type"::"Chat Completions",
            _IAOAIDeployment.GetEndpoint(),
            _IAOAIDeployment.GetDeployment(),
            _IAOAIDeployment.GetAPIKey()
        );
        AzureOpenAI.SetCopilotCapability("Copilot Capability"::EvaluateAIToolkit);
        AOAIChatCompletionParams.SetMaxTokens(MaxOutputTokens());
        AOAIChatCompletionParams.SetTemperature(0);
        AOAIChatCompletionParams.SetJsonMode(_JsonMode);
        AOAIChatMessages.AddSystemMessage(SystemPrompt);
        AOAIChatMessages.AddUserMessage(UserPrompt);
        AzureOpenAI.GenerateChatCompletion(AOAIChatMessages, AOAIChatCompletionParams, AOAIOperationResponse);
        if AOAIOperationResponse.IsSuccess() then
            CompletionAnswerTxt := AOAIChatMessages.GetLastMessage()
        else
            Error(ErrorInfo.Create(AOAIOperationResponse.GetError()));

        exit(CompletionAnswerTxt);
    end;

    local procedure MaxInputTokens(): Integer
    begin
        exit(_IAOAIDeployment.MaxModelTokens() - MaxOutputTokens());
    end;

    local procedure MaxOutputTokens(): Integer
    begin
        exit(2500);
    end;

    local procedure CheckInputLength(SystemPrompt: Text; UserPrompt: Text)
    var
        AOAIToken: Codeunit "AOAI Token";
        InputTooLongErr: Label 'The input token count is too large. Shorten your prompts.';
        CompletePromptTokenCount: Integer;
    begin
        CompletePromptTokenCount := AOAIToken.GetGPT4TokenCount(SystemPrompt) + AOAIToken.GetGPT4TokenCount(UserPrompt);
        if CompletePromptTokenCount > MaxInputTokens() then
            Error(InputTooLongErr);
    end;

    local procedure GetDeploymentInstance()
    var
        gpt4o: Codeunit gpt4o;
    begin
        if _DeploymentSet then
            exit;

        _IAOAIDeployment := gpt4o;
        _DeploymentSet := true;
    end;

    internal procedure SetDeploymentInstance(DeploymentInstance: Interface IAOAIDeployment)
    begin
        _IAOAIDeployment := DeploymentInstance;
        _DeploymentSet := true;
    end;

    internal procedure SetJsonMode(JsonMode: Boolean)
    begin
        _JsonMode := JsonMode;
    end;
}