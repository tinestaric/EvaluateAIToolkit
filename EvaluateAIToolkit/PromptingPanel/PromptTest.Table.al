namespace EvaluateAIToolkit.PromptingPanel;

table 70100 PromptTest
{
    DataClassification = CustomerContent;
    LookupPageId = PromptTestList;
    DrillDownPageId = PromptTestCard;

    fields
    {
        field(1; PromptCode; Code[20])
        {
            Caption = 'Prompt Code';
        }
        field(20; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(30; SystemPrompt; Blob)
        {
            Caption = 'System Prompt';
        }
        field(40; UserPrompt; Blob)
        {
            Caption = 'User Prompt';
        }
        field(50; ExpectedResponseSchema; Blob)
        {
            Caption = 'Expected Response Schema';
        }
        field(60; ExpectedResponseType; Enum ExpectedResponseType)
        {
            Caption = 'Expected Response Type';
        }
        field(70; NoOfTestRuns; Integer)
        {
            Caption = 'No. of Test Runs';
        }
    }

    keys
    {
        key(Key1; PromptCode)
        {
            Clustered = true;
        }
    }

    internal procedure GetSystemPrompt(): Text
    var
        InStr: InStream;
    begin
        Rec.CalcFields(SystemPrompt);
        Rec.SystemPrompt.CreateInStream(InStr);
        exit(ReadBlob(InStr));
    end;

    internal procedure GetUserPrompt(): Text
    var
        InStr: InStream;
    begin
        Rec.CalcFields(UserPrompt);
        Rec.UserPrompt.CreateInStream(InStr);
        exit(ReadBlob(InStr));
    end;

    internal procedure GetExpectedResponseSchema(): Text
    var
        InStr: InStream;
    begin
        Rec.CalcFields(ExpectedResponseSchema);
        Rec.ExpectedResponseSchema.CreateInStream(InStr);
        exit(ReadBlob(InStr));
    end;

    internal procedure SetExpectedResponseSchema(Value: Text)
    var
        OutStr: OutStream;
    begin
        Rec.ExpectedResponseSchema.CreateOutStream(OutStr);
        OutStr.WriteText(Value);
        Rec.Modify(true);
    end;


    local procedure ReadBlob(InStr: InStream) OutText: Text
    var
        Text: Text;
    begin
        while not InStr.EOS do begin
            InStr.ReadText(Text);
            OutText += Text + '<br>';
        end;
    end;
}