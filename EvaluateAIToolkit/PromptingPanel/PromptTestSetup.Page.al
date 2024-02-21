page 70102 PromptTestSetup
{
    Caption = 'Prompt Test Setup';
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
            action(GetResponseSchema)
            {
                Caption = 'Get Response Schema';
                ToolTip = 'Uses GPT to extract the expected schema out of the system prompt';
                Image = SparkleFilled;

                trigger OnAction()
                var
                    ExtractSchemaPromptDialog: Page ExtractSchemaPromptDialog;
                begin
                    ExtractSchemaPromptDialog.SetPromptTest(Rec);
                    ExtractSchemaPromptDialog.RunModal();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';

                actionref(GetResponseSchema_Promoted; GetResponseSchema) { }
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