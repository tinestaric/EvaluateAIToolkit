enumextension 60600 AIFeatureExtension extends AIFeature
{
    value(60600; SendEmailToCustomer)
    {
        Implementation = IAIFeature = EmailTestWrapper;
    }
}