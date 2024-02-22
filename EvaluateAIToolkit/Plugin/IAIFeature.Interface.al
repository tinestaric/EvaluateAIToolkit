interface IAIFeature
{
    procedure GetSystemPrompt(): Text
    procedure Generate(UserPrompt: Text) Completion: Text
}