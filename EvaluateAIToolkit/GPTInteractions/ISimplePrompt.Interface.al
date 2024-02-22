interface ISimplePrompt
{
    procedure SetDeployment(AOAIDeployment: Interface IAOAIDeployment): Boolean
    procedure ExecutePrompt(SystemPrompt: Text; UserPrompt: Text) Completion: Text
}