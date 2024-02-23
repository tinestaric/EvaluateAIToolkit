# Evaluate AI Framework
The Evaluate AI Toolkit is a comprehensive solution designed to address the challenges introduced by the unpredictability of AI features in Business Central. 
It aims to speed up the prototyping of new features by enabling the execution of prompts at scale, shortening the feedback cycle, and helping sure the prompts still produce predictable responses when used by hundreds of users.

Here's a list of features:
1. **Prompt Validation:**
- Validate prompts against expected response schema.
- Utilize validation prompts for unstructured completions.
2. **Automatic Identification:**
- Automatically identify the expected schema for structured completions.
- Propose validation prompts for semantical validation.
3. **User Prompt Simulation:**
- Propose different user prompts used randomly during testing to simulate user interaction.
4. **Extensibility Points:**
- Easily plug existing AI functionality into the test framework.
5. **Parallel Session Execution:**
- Execute hundreds of prompts in parallel sessions for rapid evaluation.
6. **History Tracking:**
- Maintain a full history of prompt execution for effective investigation and adjustments.

## Apps
### EvaluateAIToolkit
This is the main toolkit, it adds the "Prompt Tester" page where the whole logic sits. To get started, navigate to the Prompt Tester page, create a new entry and follow the teaching tips on the Prompt Test Card and Prompt Test Setup. 

### SendEmailToCustomer
This is a straightforward app that adds an AI Feature for the generation of emails based on information from the Posted Sales Invoice. Its purpose is to showcase how easy it is to integrate an existing AI Feature with the Evaluate AI Toolkit.
The email generation actions are added to the posted sales invoice list and card.

### SendEmailToCustomer-Test
This is a test app that showcases how to integrate an existing AI feature into the Evaluate AI Framework so it can be tested at scale and evaluated.

## Important
For obvious reasons, API Keys for OpenAI deployments are not part of the source code. The apps still compile and work, but to experience the functionality you should supply your own OpenAI deployment settings.
For Toolkit, the information is provided on each of the deployment implementation codeunits within the Helpers folder.
For SendEmailToCustomer the deployment information is set directly in the CustEmailGenerationImpl codeunit within the Implementation folder
