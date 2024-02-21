codeunit 70112 ExecuteValidationPrompt
{
    procedure ExecutePrompt(ValidationPrompt: Text; CompletionToValidate: Text) Completion: Text
    var
        AOAIWrapper: Codeunit AOAIWrapper;
        gpt432k: Codeunit gpt432k;
        SystemPrompt: Text;
    begin
        SystemPrompt := GetSystemPrompt(ValidationPrompt, Completion);

        AOAIWrapper.SetDeploymentInstance(gpt432k);
        Completion := AOAIWrapper.GenerateResponse(SystemPrompt, CompletionToValidate);
    end;

    local procedure GetSystemPrompt(ValidationPrompt: Text; CompletionToValidate: Text): Text
    var
        Regex: Codeunit Regex;
        HtmlRegexTok: Label '<.*?>', Locked = true;
        SystemPrompt: TextBuilder;
    begin
        ValidationPrompt := Regex.Replace(ValidationPrompt, HtmlRegexTok, '');
        CompletionToValidate := Regex.Replace(CompletionToValidate, HtmlRegexTok, '');

        SystemPrompt.AppendLine('You are a `validateCompletion` api.');
        SystemPrompt.AppendLine('You will receive a validation prompt and a completion.');
        SystemPrompt.AppendLine('A validation prompt contains a set of rules that you should check the completion against.');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('Validation Prompt:');
        SystemPrompt.AppendLine('"""');
        SystemPrompt.AppendLine(ValidationPrompt);
        SystemPrompt.AppendLine('"""');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('Completion:');
        SystemPrompt.AppendLine('"""');
        SystemPrompt.AppendLine(CompletionToValidate);
        SystemPrompt.AppendLine('"""');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('If the completion is valid, the result should be true, no nothing should be returned in the error message.');
        SystemPrompt.AppendLine('If the completion is invalid, the result should be false, and the error message should contain a description of the error.');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('IMPORTANT!');
        SystemPrompt.AppendLine('Don''t add comments.');
        SystemPrompt.AppendLine('Fill all fields.');
        SystemPrompt.AppendLine('Always respond in the next JSON format:');
        SystemPrompt.AppendLine('''''''');
        SystemPrompt.AppendLine('{');
        SystemPrompt.AppendLine('    "isValid": "boolean",');
        SystemPrompt.AppendLine('    "errorMessage": "string"');
        SystemPrompt.AppendLine('}');
        SystemPrompt.AppendLine('''''''');
        SystemPrompt.AppendLine('If you can''t answer or don''t know the answer, respond with: []');
        exit(SystemPrompt.ToText());
    end;
}