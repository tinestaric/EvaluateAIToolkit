codeunit 70109 PromptTestBCPT implements "BCPT Test Param. Provider"
{
    Subtype = Test;

    var
        _PromptTestCodeParamTok: Label 'CODE', Locked = true;

    trigger OnRun()
    var
        PromptTest: Record PromptTest;
        BCPTTestContext: Codeunit "BCPT Test Context";
        Completion: Text;
        PromptToTest: Text;
        UserPrompt: Text;
    begin
        PromptToTest := BCPTTestContext.GetParameter(_PromptTestCodeParamTok);
        PromptTest.Get(PromptToTest);

        BCPTTestContext.StartScenario('Testing prompt: ' + PromptToTest);

        BCPTTestContext.StartScenario('Create a Completion of the prompt');
        UserPrompt := PromptTest.GetRandomUserPrompt();
        Completion := PromptTest.Complete(UserPrompt);
        BCPTTestContext.EndScenario('Create a Completion of the prompt');

        BCPTTestContext.StartScenario('Validate the Completion');
        PromptTest.TestCompletion(Completion, UserPrompt);
        BCPTTestContext.EndScenario('Validate the Completion');

        BCPTTestContext.EndScenario('Testing prompt: ' + PromptToTest);
    end;

    internal procedure GetDefaultParameters(): Text[1000];
    begin
    end;

    internal procedure ValidateParameters(Params: Text[1000]);
    var
        PromptToTest: Code[20];
    begin
        Params := DelStr(Params, 1, StrLen(_PromptTestCodeParamTok + '='));
#pragma warning disable AA0206 //Unused variable
        Evaluate(PromptToTest, Params);
#pragma warning restore AA0206
    end;
}