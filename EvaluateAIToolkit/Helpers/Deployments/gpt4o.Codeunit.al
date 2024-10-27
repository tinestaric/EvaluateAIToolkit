codeunit 70117 gpt4o implements IAOAIDeployment
{
    procedure GetEndpoint(): Text
    begin
        exit('https://bcaihackathon.openai.azure.com/');
    end;

    procedure GetDeployment(): Text
    begin
        exit('gpt-4o');
    end;

    procedure GetAPIKey(): SecretText
    begin
    end;

    procedure MaxModelTokens(): Integer
    begin
        exit(128000);
    end;
}