namespace EvaluateAIToolkit.GPTInteractions;

using System.Text;
using EvaluateAIToolkit.PromptingPanel;
using EvaluateAIToolkit.Helpers;

codeunit 70103 ExtractResponseStructure
{
    procedure Call(SysPromptToProcess: Text; var PromptTest: Record PromptTest)
    var
        AOAIWrapper: Codeunit AOAIWrapper;
        SystemPrompt: Text;
        Completion: Text;
    begin
        SystemPrompt := GetSystemPrompt();

        Completion := AOAIWrapper.GenerateResponse(SystemPrompt, SysPromptToProcess);
        if CheckIfValidCompletion(Completion) then
            SaveExpectedResponse(Completion, PromptTest);
    end;

    local procedure GetSystemPrompt(): Text
    var
        SystemPrompt: TextBuilder;
    begin
        SystemPrompt.AppendLine('You are `extractExpectedResponseStructure` API');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('Your task: Extract the expected response structure from the given system prompt.');
        SystemPrompt.AppendLine('The system prompt may contain instructions on how the response should be structured. If you find a JSON or XML schema capture it.');
        SystemPrompt.AppendLine('Extract the structure as a valid JSON or XML schema');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('IMPORTANT!');
        SystemPrompt.AppendLine('Don''t add comments.');

        SystemPrompt.AppendLine('''''''');
        SystemPrompt.AppendLine('    {');
        SystemPrompt.AppendLine('        "type": "string (XML or JSON)",');
        SystemPrompt.AppendLine('        "schema": "string",');
        SystemPrompt.AppendLine('    }');
        SystemPrompt.AppendLine('''''''');

        SystemPrompt.AppendLine('If you can''t answer or don''t know the answer, respond with: []');
        exit(SystemPrompt.ToText());
    end;

    [TryFunction]
    local procedure CheckIfValidCompletion(Completion: Text)
    var
        JsonObject: JsonObject;
    begin
        JsonObject.ReadFrom(Completion);
    end;

    local procedure SaveExpectedResponse(Completion: Text; var PromptTest: Record PromptTest)
    var
        JSONManagement: Codeunit "JSON Management";
        valueText: Text;
    begin
        JSONManagement.InitializeObject(Completion);

        JSONManagement.GetStringPropertyValueByName('type', valueText);
        PromptTest.ExpectedResponseType := GetResponseType(valueText);

        JSONManagement.GetStringPropertyValueByName('schema', valueText);
        PromptTest.SetExpectedResponseSchema(valueText);

        PromptTest.Modify(true);
    end;

    local procedure GetResponseType(value: Text): Enum ExpectedResponseType
    begin
        case true of
            value.Contains('JSON'):
                exit(Enum::ExpectedResponseType::JSON);
            value.Contains('XML'):
                exit(Enum::ExpectedResponseType::XML);
            else
                exit(Enum::ExpectedResponseType::None);
        end;
    end;


}