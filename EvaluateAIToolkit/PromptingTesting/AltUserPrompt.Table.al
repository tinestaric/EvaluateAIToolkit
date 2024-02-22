table 70103 AltUserPrompt
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; PromptCode; Code[10])
        {
            Caption = 'Prompt Code';
            TableRelation = PromptTest;
        }
        field(2; LineNo; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
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