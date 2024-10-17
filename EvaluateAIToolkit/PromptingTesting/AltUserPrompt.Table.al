table 70103 AltUserPrompt
{
    Caption = 'Alternative User Prompts';
    DataClassification = CustomerContent;
    LookupPageId = AltUserPrompts;
    DrillDownPageId = AltUserPrompts;

    fields
    {
        field(1; PromptCode; Code[10])
        {
            Caption = 'Prompt Code';
            TableRelation = PromptTest;
            AllowInCustomizations = Never;
        }
        field(2; LineNo; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
            AllowInCustomizations = Never;
        }
        field(20; UserPrompt; Text[2048])
        {
            Caption = 'User Prompt';
        }
    }

    keys
    {
        key(Key1; PromptCode, LineNo)
        {
            Clustered = true;
        }
    }
}