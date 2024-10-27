namespace EvaluateAIToolkit.Permissions;

using EvaluateAIToolkit.PromptingPanel;
using EvaluateAIToolkit.Helpers;
using EvaluateAIToolkit.GPTInteractions;
using EvaluateAIToolkit.Common;

permissionset 70100 Full
{
    Caption = 'Evaluate AI Toolkit', Locked = true;
    Assignable = true;
    Permissions = table AltUserPrompt = X,
        tabledata AltUserPrompt = RIMD,
        table PromptTest = X,
        tabledata PromptTest = RIMD,
        table PromptTestResult = X,
        tabledata PromptTestResult = RIMD,
        codeunit AIFeatureNone = X,
        codeunit AOAIWrapper = X,
        codeunit CreateValidationPrompt = X,
        codeunit ExecuteTestPrompt = X,
        codeunit ExtractResponseSchema = X,
        codeunit gpt4o = X,
        codeunit gpt4omini = X,
        codeunit gpt35turbo = X,
        codeunit gpt35turbo16k = X,
        codeunit gpt432k = X,
        codeunit o1mini = X,
        codeunit o1preview = X,
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