codeunit 70104 ExecuteTestPrompt implements ISimplePrompt
{
    var
        _IAOAIDeployment: Interface IAOAIDeployment;

    procedure SetDeployment(AOAIDeployment: Interface IAOAIDeployment): Boolean
    begin
        _IAOAIDeployment := AOAIDeployment;
    end;

    procedure ExecutePrompt(SysPrompt: Text; UserPrompt: Text) Completion: Text
    var
        AOAIWrapper: Codeunit AOAIWrapper;
    begin
        AOAIWrapper.SetDeploymentInstance(_IAOAIDeployment);
        Completion := AOAIWrapper.GenerateResponse(SysPrompt, UserPrompt);
    end;

    internal procedure RunDialog(var _Completion: Text; PromptTest: Record PromptTest)
    var
        ExecuteTestPrompt: Codeunit ExecuteTestPrompt;
        RunPromptDialog: Page RunPromptDialog;
    begin
        ExecuteTestPrompt.SetDeployment(PromptTest.Deployment);
        RunPromptDialog.SetPromptType(ExecuteTestPrompt);
        RunPromptDialog.SetPrompts(PromptTest.GetSystemPrompt(), PromptTest.GetDefaultUserPrompt());
        if RunPromptDialog.RunModal() = Action::OK then
            _Completion := RunPromptDialog.GetCompletion();
    end;
}