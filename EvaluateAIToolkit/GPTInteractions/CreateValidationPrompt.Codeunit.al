namespace EvaluateAIToolkit.GPTInteractions;

using System.Utilities;
using EvaluateAIToolkit.PromptingPanel;
using EvaluateAIToolkit.Helpers;

codeunit 70111 CreateValidationPrompt implements ISimplePrompt
{
    procedure SetDeployment(AOAIDeployment: Interface IAOAIDeployment): Boolean
    begin
        // Do nothing
    end;

    internal procedure RunPrompt(PromptTest: Record PromptTest)
    var
        CreateValidationPrompt: Codeunit CreateValidationPrompt;
        RunPromptDialog: Page RunPromptDialog;
    begin
        RunPromptDialog.SetPrompts(PromptTest.GetSystemPrompt(), '');
        RunPromptDialog.SetPromptType(CreateValidationPrompt);
        if RunPromptDialog.RunModal() = Action::OK then
            PromptTest.SetValidationPrompt(RunPromptDialog.GetCompletion());
    end;

    procedure ExecutePrompt(SysPromptToProcess: Text; UserPrompt: Text) Completion: Text
    var
        AOAIWrapper: Codeunit AOAIWrapper;
        SystemPrompt: Text;
    begin
        SystemPrompt := GetSystemPrompt(SysPromptToProcess);

        Completion := AOAIWrapper.GenerateResponse(SystemPrompt, '');
    end;

    local procedure GetSystemPrompt(SystemPromptToProcess: Text): Text
    var
        SystemPrompt: TextBuilder;
    begin
        SystemPrompt.AppendLine('Assume this was your original System Prompt');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('"""');
        SystemPrompt.AppendLine(SystemPromptToProcess);
        SystemPrompt.AppendLine('"""');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('What prompt would you create to validate if the completions has invalidated any of the requests?');
        SystemPrompt.AppendLine('Return a list of prompts that you would use to validate the completion of the SystemPrompt.');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('Example:');
        SystemPrompt.AppendLine('"""');
        SystemPrompt.AppendLine('SystemPrompt:');
        SystemPrompt.AppendLine('Generate a customized email for a customer, notifying him of his recent purchase. Do not just list the information, but incorporate it into a well-structured email.');
        SystemPrompt.AppendLine('Invoice Number: 12345');
        SystemPrompt.AppendLine('Customer Name: John Doe');
        SystemPrompt.AppendLine('Purchase Date: 2022-01-01');
        SystemPrompt.AppendLine('Total Amount: $100.00');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('ValidationPrompt:');
        SystemPrompt.AppendLine('Validate if the completion follows the following rules:');
        SystemPrompt.AppendLine('All the information is included in the email.');
        SystemPrompt.AppendLine('The tone of the email is professional.');
        SystemPrompt.AppendLine('No information that was not provided in the prompt is included in the email.');
        SystemPrompt.AppendLine('"""');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('IMPORTANT!');
        SystemPrompt.AppendLine('Don''t add comments.');
        SystemPrompt.AppendLine('Only reply with lines of the validation prompt.');
        SystemPrompt.AppendLine('If you can''t answer or don''t know the answer, respond with: []');
        exit(SystemPrompt.ToText());
    end;
}