enum 70102 AOAIDeployment implements IAOAIDeployment
{
    Extensible = false;

    value(0; gpt35turbo) { Caption = 'GPT 3.5 - Turbo'; Implementation = IAOAIDeployment = gpt35turbo; }
    value(1; gpt432k) { Caption = 'GPT 4 - 32K'; Implementation = IAOAIDeployment = gpt432k; }
    value(2; gpt35turbo16k) { Caption = 'GPT 3.5 - Turbo - 16K'; Implementation = IAOAIDeployment = gpt35turbo16k; }
}