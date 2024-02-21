interface ISimplePrompt
{
    procedure IsShowPromptPart(): Boolean
    procedure ExecutePrompt(SystemPrompt: Text; UserPrompt: Text) Completion: Text
}