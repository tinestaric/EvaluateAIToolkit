codeunit 70114 gpt35turbo implements IAOAIDeployment
{
    procedure GetEndpoint(): Text
    begin
        exit('https://bcaihackathon.openai.azure.com/');
    end;

    procedure GetDeployment(): Text
    begin
        exit('gpt-35-turbo');
    end;

    procedure GetAPIKey(): SecretText
    begin
    end;

    procedure MaxModelTokens(): Integer
    begin
        exit(4096);
    end;
}