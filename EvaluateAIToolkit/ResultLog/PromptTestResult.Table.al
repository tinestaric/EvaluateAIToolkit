table 70101 PromptTestResult
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; PromptCode; Code[10])
        {
            Caption = 'Prompt Code';
            TableRelation = PromptTest;
        }
        field(2; VersionNo; Integer)
        {
            Caption = 'Version No.';
        }
        field(3; LineNo; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
        }
        field(20; Completion; Blob)
        {
            Caption = 'Completion';
        }
        field(30; SystemPrompt; Blob)
        {
            Caption = 'System Prompt';
        }
        field(40; UserPrompt; Blob)
        {
            Caption = 'User Prompt';
        }
        field(50; IsSuccess; Boolean)
        {
            Caption = 'Is Success';
        }
        field(60; ErrorMessage; Text[250])
        {
            Caption = 'Error Message';
        }
        field(70; Type; Enum PromptValidationType)
        {
            Caption = 'Validation Type';
        }
        field(80; Deployment; Enum AOAIDeployment)
        {
            Caption = 'Deployment';
        }
    }

    keys
    {
        key(Key1; PromptCode, VersionNo, LineNo)
        {
            Clustered = true;
        }
    }

    #region Blob I/O
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

    internal procedure GetCompletion(): Text
    var
        InStr: InStream;
    begin
        Rec.CalcFields(Completion);
        Rec.Completion.CreateInStream(InStr);
        exit(ReadBlob(InStr));
    end;

    local procedure ReadBlob(InStr: InStream) OutText: Text
    var
        Text: Text;
    begin
        while not InStr.EOS do begin
            InStr.ReadText(Text);
            OutText += Text;
        end;
    end;

    internal procedure SetSystemPrompt(Value: Text)
    var
        OutStr: OutStream;
    begin
        Clear(Rec.SystemPrompt);
        Rec.SystemPrompt.CreateOutStream(OutStr);
        OutStr.WriteText(Value);
    end;

    internal procedure SetUserPrompt(Value: Text)
    var
        OutStr: OutStream;
    begin
        Clear(Rec.UserPrompt);
        Rec.UserPrompt.CreateOutStream(OutStr);
        OutStr.WriteText(Value);
    end;

    internal procedure SetCompletion(Value: Text)
    var
        OutStr: OutStream;
    begin
        Clear(Rec.Completion);
        Rec.Completion.CreateOutStream(OutStr);
        OutStr.WriteText(Value);
    end;
    #endregion
}