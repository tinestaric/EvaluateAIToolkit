namespace EvaluateAIToolkit.PromptingPanel;

page 70100 PromptTestList
{
    Caption = 'Prompts Tester';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = PromptTest;
    ModifyAllowed = false;
    RefreshOnActivate = true;
    CardPageId = PromptTestCard;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(PromptCode; Rec.PromptCode) { }
                field(VersionNo; Rec.VersionNo)
                {
                    trigger OnDrillDown()
                    begin
                        OpenTestResults();
                    end;
                }
                field(PassRate; _PassRate)
                {
                    Caption = 'Pass Rate';
                    StyleExpr = _PassRateStyle;

                    trigger OnDrillDown()
                    begin
                        OpenTestResults();
                    end;
                }
                field(SchemaPassRate; _SchemaPassRate) { Caption = 'Schema Pass Rate'; }
                field(ValidationPassRate; _ValidationPassRate) { Caption = 'Validation Pass Rate'; }
            }
        }
    }

    var
        _PassRate: Decimal;
        _SchemaPassRate: Decimal;
        _ValidationPassRate: Decimal;
        _PassRateStyle: Text;

    trigger OnAfterGetRecord()
    begin
        Rec.CalcPassRates(_PassRate, _SchemaPassRate, _ValidationPassRate);
        _PassRateStyle := GetPassRateStyle();
    end;

    local procedure OpenTestResults()
    var
        PromptTestResult: Record PromptTestResult;
    begin
        PromptTestResult.SetRange(PromptCode, Rec.PromptCode);
        PromptTestResult.SetRange(VersionNo, Rec.VersionNo);
        Page.Run(Page::PromptTestResultList, PromptTestResult);
    end;

    local procedure GetPassRateStyle(): Text
    begin
        exit(Format(_PassRate < Rec.AcceptablePassRate ? PageStyle::Unfavorable : PageStyle::Favorable));
    end;
}