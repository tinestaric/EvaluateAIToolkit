codeunit 70109 PromptTestBCPT implements "BCPT Test Param. Provider"
{
    Subtype = Test;

    var
        _PromptToTest: Code[20];

    [Test]
    internal procedure TestPrompt()
    var
        PromptTest: Record PromptTest;
        BCPTTestContext: Codeunit "BCPT Test Context";
        Completion: Text;
    begin
        PromptTest.ReadIsolation := IsolationLevel::UpdLock;
        PromptTest.Get(_PromptToTest);

        BCPTTestContext.StartScenario('Testing prompt: ' + _PromptToTest);

        BCPTTestContext.StartScenario('Create a Completion of the prompt');
        Completion := PromptTest.Complete();
        BCPTTestContext.EndScenario('Create a Completion of the prompt');

        BCPTTestContext.StartScenario('Validate the Completion');
        PromptTest.TestCompletionWithSchema(Completion);
        BCPTTestContext.EndScenario('Validate the Completion');

        BCPTTestContext.EndScenario('Testing prompt: ' + _PromptToTest);
    end;

    internal procedure GetDefaultParameters(): Text[1000];
    begin
        //do nothing
    end;

    internal procedure ValidateParameters(Params: Text[1000]);
    begin
        _PromptToTest := CopyStr(Params, 1, MaxStrLen(_PromptToTest));
    end;
}