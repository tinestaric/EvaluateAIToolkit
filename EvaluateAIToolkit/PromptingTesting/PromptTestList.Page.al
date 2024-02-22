namespace EvaluateAIToolkit.PromptingPanel;

page 70100 PromptTestList
{
    Caption = 'Prompts Tester';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = PromptTest;
    ModifyAllowed = false;
    CardPageId = PromptTestCard;


    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(PromptCode; Rec.PromptCode)
                {
                    ToolTip = 'The code of the prompt';
                }
            }
        }
    }
}