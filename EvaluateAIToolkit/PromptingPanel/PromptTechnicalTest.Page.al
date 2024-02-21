page 70102 PromptTechnicalTest
{
    Caption = 'Test Prompt';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = PromptTest;

    layout
    {
        area(Content)
        {
            group(PromptGeneral)
            {
                Caption = 'Prompt';

                field(PromptCode; Rec.PromptCode) { Editable = false; }
                field(ExpectedResponseType; Rec.ExpectedResponseType) { }
                field(NoOfTestRuns; Rec.NoOfTestRuns) { }
            }
            group(ResponseStructureGroup)
            {
                Caption = 'Expected Response Structure';

                field(ExpectedResponseStructure; _ExpectedResponseSchema)
                {
                    ShowCaption = false;
                    ExtendedDatatype = RichContent;
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        Rec.SetExpectedResponseSchema(_ExpectedResponseSchema);
                    end;
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(GetResponseStructure)
            {
                Caption = 'Get Response Schema';
                ToolTip = 'Uses GPT to extract the expected schema out of the system prompt';
                Image = GetEntries;

                trigger OnAction()
                var
                    ExtractResponseStructure: Codeunit ExtractResponseStructure;
                begin
                    ExtractResponseStructure.Call(Rec.GetSystemPrompt(), Rec);
                    CurrPage.Update(false);
                end;
            }


        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(GetResponseStructure_Promoted; GetResponseStructure) { }
            }
        }
    }

    var
        _ExpectedResponseSchema: Text;

    trigger OnAfterGetCurrRecord()
    begin
        GetTextFromBlobs();
    end;

    local procedure GetTextFromBlobs()
    begin
        _ExpectedResponseSchema := Rec.GetExpectedResponseSchema();
    end;


}