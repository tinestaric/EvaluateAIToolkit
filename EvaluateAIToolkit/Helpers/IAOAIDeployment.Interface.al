interface IAOAIDeployment
{
    procedure GetEndpoint(): Text
    procedure GetDeployment(): Text
    procedure GetAPIKey(): SecretText
    procedure MaxModelTokens(): Integer
}