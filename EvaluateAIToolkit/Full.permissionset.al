namespace EvaluateAIToolkit.Permissions;

using EvaluateAIToolkit.PromptingPanel;
using EvaluateAIToolkit.Helpers;
using EvaluateAIToolkit.GPTInteractions;
using EvaluateAIToolkit.Common;

permissionset 70100 Full
{
    Caption = 'Evaluate AI Toolkit', Locked = true;
    Assignable = true;
    Permissions = tabledata AltUserPrompt = RIMD,
        tabledata PromptTest = RIMD,
        tabledata PromptTestResult = RIMD,
        table AltUserPrompt = X,
        table PromptTest = X,
        table PromptTestResult = X,
        codeunit AIFeatureNone = X,
        codeunit AOAIWrapper = X,
        codeunit CreateValidationPrompt = X,
        codeunit ExecuteTestPrompt = X,
        codeunit ExtractResponseSchema = X,
        codeunit gpt35turbo = X,
        codeunit gpt35turbo16k = X,
        codeunit gpt432k = X,
        codeunit PromptTestBCPT = X,
        codeunit ProposeAltPrompts = X,
        codeunit "Register Capability" = X,
        codeunit ResultLogger = X,
        codeunit SchemaTesterJSON = X,
        codeunit SchemaTesterNone = X,
        codeunit SchemaTesterXML = X,
        codeunit ValidateCompletion = X,
        codeunit ValidationPromptCheck = X,
        page AltUserPrompts = X,
        page AltUserPromptsPart = X,
        page EditUserPromptDialog = X,
        page ExtractSchemaPromptDialog = X,
        page PromptTestCard = X,
        page PromptTestList = X,
        page PromptTestResultCard = X,
        page PromptTestResultList = X,
        page PromptTestSetup = X,
        page ProposeAltPromptsDialog = X,
        page RunPromptDialog = X,
        page ValidationPromptDialog = X;
}