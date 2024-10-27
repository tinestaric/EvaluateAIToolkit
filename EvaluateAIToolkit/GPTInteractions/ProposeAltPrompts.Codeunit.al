codeunit 70118 ProposeAltPrompts
{
    procedure ExecutePrompt(var GenerationId: Record "Name/Value Buffer"; var AltUserPromptGenerated: Record AltUserPrompt temporary; SysPromptToProcess: Text)
    var
        AOAIWrapper: Codeunit AOAIWrapper;
        NonTempRecErr: Label 'This function can only be used with temporary records.';
        SystemPrompt: Text;
        Completion: Text;
    begin
        if not AltUserPromptGenerated.IsTemporary then
            Error(NonTempRecErr);

        SystemPrompt := GetSystemPrompt();

        Completion := AOAIWrapper.GenerateResponse(SystemPrompt, SysPromptToProcess);
        if CheckIfValidCompletion(Completion) then begin
            SaveGenerationHistory(GenerationId);
            CreateAltPrompts(GenerationId, AltUserPromptGenerated, Completion);
        end;
    end;

    local procedure GetSystemPrompt(): Text
    var
        SystemPrompt: TextBuilder;
    begin
        SystemPrompt.AppendLine('You are `generateAltUserPrompts` API');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('Your task: Generate user prompts that can be used for testing.');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('You will receive the System Prompt and you need to suggest 10 user prompts that are used as an addition to the system prompt to personalize the request.');
        SystemPrompt.AppendLine('the user prompts will later be used to validate the behavior of the system prompt.');
        SystemPrompt.AppendLine('Keep the prompts short and simple, and make sure they are relevant to the system prompt.');
        SystemPrompt.AppendLine('Prompts should focus on changing the tone, or emphasizing certain aspects of the system prompt.');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('Example prompt:');
        SystemPrompt.AppendLine('Make the email sound like we really dislike getting late payments.');
        SystemPrompt.AppendLine('Example prompt 2:');
        SystemPrompt.AppendLine('Make the names of new item names start with "NI".');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('IMPORTANT!');
        SystemPrompt.AppendLine('Don''t add comments.');
        SystemPrompt.AppendLine('Fill all fields.');
        SystemPrompt.AppendLine('Always respond in the next JSON format:');
        SystemPrompt.AppendLine('''''''');
        SystemPrompt.AppendLine('[');
        SystemPrompt.AppendLine('    {');
        SystemPrompt.AppendLine('        "prompt": "string",');
        SystemPrompt.AppendLine('    }');
        SystemPrompt.AppendLine(']');
        SystemPrompt.AppendLine('''''''');
        SystemPrompt.AppendLine();
        SystemPrompt.AppendLine('If you can''t answer or don''t know the answer, respond with: []');
        SystemPrompt.AppendLine('Your answer in a JSON format: [');
        exit(SystemPrompt.ToText());
    end;

    [TryFunction]
    local procedure CheckIfValidCompletion(Completion: Text)
    var
        JsonArray: JsonArray;
    begin
        JsonArray.ReadFrom(Completion);
    end;

    local procedure SaveGenerationHistory(var GenerationId: Record "Name/Value Buffer")
    begin
        GenerationId.ID += 1;
        GenerationId.Insert(true);
    end;

    local procedure CreateAltPrompts(var GenerationId: Record "Name/Value Buffer"; var AltUserPromptGenerated: Record AltUserPrompt temporary; Completion: Text)
    var
        JSONManagement: Codeunit "JSON Management";
        PromptObj: Text;
        i: Integer;
    begin
        JSONManagement.InitializeCollection(Completion);

        for i := 0 to JSONManagement.GetCollectionCount() - 1 do begin
            JSONManagement.GetObjectFromCollectionByIndex(PromptObj, i);

            InsertAltUserPromptGenerated(AltUserPromptGenerated, PromptObj, GenerationId.ID, i);
        end;
    end;

    local procedure InsertAltUserPromptGenerated(var AltUserPromptGenerated: Record AltUserPrompt temporary; PromptObj: Text; GenerationId: Integer; LineNo: Integer)
    var
        JSONManagement: Codeunit "JSON Management";
        ValueText: Text;
    begin
        JSONManagement.InitializeObject(PromptObj);

        AltUserPromptGenerated.Init();
        AltUserPromptGenerated.LineNo := GenerationId;
        AltUserPromptGenerated.PromptCode := Format(LineNo);

        JSONManagement.GetStringPropertyValueByName('prompt', ValueText);
        AltUserPromptGenerated.UserPrompt := CopyStr(ValueText, 1, MaxStrLen(AltUserPromptGenerated.UserPrompt));
        AltUserPromptGenerated.Insert(false);
    end;
}