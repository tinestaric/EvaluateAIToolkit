namespace EvaluateAIToolkit.PromptingPanel;

using System.Tooling;

table 70100 PromptTest
{
    DataClassification = CustomerContent;
    LookupPageId = PromptTestList;
    DrillDownPageId = PromptTestCard;

    fields
    {
        field(1; PromptCode; Code[10])
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
        field(40; DefaultUserPrompt; Blob)
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
            InitValue = 10;
            Caption = 'No. of Test Runs';
        }
        field(80; VersionNo; Integer)
        {
            InitValue = 1;
            Caption = 'Version';
        }
        field(90; ValidationPrompt; Blob)
        {
            Caption = 'Validation Prompt';
        }
    }

    keys
    {
        key(Key1; PromptCode)
        {
            Clustered = true;
        }
    }

    trigger OnDelete()
    var
        PromptTestResult: Record PromptTestResult;
    begin
        PromptTestResult.SetRange(PromptCode, Rec.PromptCode);
        PromptTestResult.DeleteAll(true);
    end;

    #region Blob I/O
    internal procedure GetSystemPrompt(): Text
    var
        InStr: InStream;
    begin
        Rec.CalcFields(SystemPrompt);
        Rec.SystemPrompt.CreateInStream(InStr);
        exit(ReadBlob(InStr));
    end;

    internal procedure GetDefaultUserPrompt(): Text
    var
        InStr: InStream;
    begin
        Rec.CalcFields(DefaultUserPrompt);
        Rec.DefaultUserPrompt.CreateInStream(InStr);
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

    internal procedure GetValidationPrompt(): Text
    var
        InStr: InStream;
    begin
        Rec.CalcFields(ValidationPrompt);
        Rec.ValidationPrompt.CreateInStream(InStr);
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
        Rec.VersionNo += 1;

        Clear(Rec.SystemPrompt);
        Rec.SystemPrompt.CreateOutStream(OutStr);
        OutStr.WriteText(Value);
        Rec.Modify(true);
    end;

    internal procedure SetExpectedResponseSchema(Value: Text)
    var
        OutStr: OutStream;
    begin
        Clear(Rec.ExpectedResponseSchema);
        Rec.ExpectedResponseSchema.CreateOutStream(OutStr);
        OutStr.WriteText(Value);
        Rec.Modify(true);
    end;

    internal procedure SetValidationPrompt(Value: Text)
    var
        OutStr: OutStream;
    begin
        Clear(Rec.ValidationPrompt);
        Rec.ValidationPrompt.CreateOutStream(OutStr);
        OutStr.WriteText(Value);
        Rec.Modify(true);
    end;
    #endregion

    #region Completion
    internal procedure Complete(UserPrompt: Text): Text
    var
        ExecuteTestPrompt: Codeunit ExecuteTestPrompt;
    begin
        exit(ExecuteTestPrompt.ExecutePrompt(Rec.GetSystemPrompt(), UserPrompt));
    end;

    internal procedure TestCompletion(Completion: Text; UserPromptText: Text) IsSuccess: Boolean
    var
        ResultLogger: Codeunit ResultLogger;
        ErrorMessage: Text;
    begin
        ResultLogger.Initialize(Rec, Completion, UserPromptText);

        if Rec.GetExpectedResponseSchema() <> '' then begin
            IsSuccess := TestCompletionWithSchema(Completion, ErrorMessage);
            ResultLogger.LogSchemaValidationResult(IsSuccess, ErrorMessage);
        end;

        if Rec.GetValidationPrompt() <> '' then begin
            Clear(ErrorMessage);
            IsSuccess := TestCompletionWithValidationPrompt(Completion, ErrorMessage);
            ResultLogger.LogValidationPromptResult(IsSuccess, ErrorMessage);
        end;
    end;

    internal procedure TestCompletionWithSchema(Completion: Text; var ErrorMessage: Text) IsSuccess: Boolean
    var
        ISchemaTester: Interface ISchemaTester;
    begin
        ISchemaTester := Rec.ExpectedResponseType;
        ISchemaTester.LoadSchema(Rec.GetExpectedResponseSchema());
        IsSuccess := ISchemaTester.Test(Completion, ErrorMessage);
    end;

    internal procedure TestCompletionWithValidationPrompt(CompletionToValidate: Text; var ErrorMessage: Text) IsSuccess: Boolean
    var
        ValidationPromptCheck: Codeunit ValidationPromptCheck;
    begin
        IsSuccess := ValidationPromptCheck.ValidateCompletion(CompletionToValidate, Rec.GetValidationPrompt(), ErrorMessage);
    end;
    #endregion

    #region BCPT
    internal procedure PrepareBCPTSuiteForPrompt()
    var
        BCPTTestSuite: Codeunit "BCPT Test Suite";
        LineDescLbl: Label 'Complete a prompt and test it.', MaxLength = 50;
        SuiteDescLbl: Label 'Suite for testing OpenAI Prompts', MaxLength = 50;
    begin
        BCPTTestSuite.CreateUpdateTestSuiteHeader(Rec.PromptCode, SuiteDescLbl, 1, 100, 1000, 10, 'Base');
        if not BCPTTestSuite.TestSuiteLineExists(Rec.PromptCode, Codeunit::PromptTestBCPT) then
            BCPTTestSuite.AddLineToTestSuiteHeader(Rec.PromptCode, Codeunit::PromptTestBCPT, Rec.NoOfTestRuns, LineDescLbl, 100, 1000, 60, false, 'CODE=' + Rec.PromptCode);
    end;
    #endregion
}