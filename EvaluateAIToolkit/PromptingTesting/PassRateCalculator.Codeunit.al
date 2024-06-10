codeunit 70105 PassRateCalculator
{
    Access = Internal;

    internal procedure CalcPassRates(PromptTest: Record PromptTest; var PassRate: Decimal; var SchemaPassRate: Decimal; var ValidationPassRate: Decimal)
    var
        PromptTestResult: Record PromptTestResult;
        TotalRuns: Integer;
    begin
        PromptTestResult.SetRange(PromptCode, PromptTest.PromptCode);
        PromptTestResult.SetRange(VersionNo, PromptTest.VersionNo);
        TotalRuns := PromptTestResult.Count;

        PromptTestResult.SetRange(IsSuccess, true);
        PassRate := PromptTestResult.Count / TotalRuns * 100;

        PromptTestResult.SetRange(Type, PromptTestResult.Type::SchemaValidation);
        SchemaPassRate := PromptTestResult.Count / TotalRuns * 100;

        PromptTestResult.SetRange(Type, PromptTestResult.Type::ValidationPrompt);
        ValidationPassRate := PromptTestResult.Count / TotalRuns * 100;
    end;
}