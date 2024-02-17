#  A REST API Gateway, SQS, Lambda (NodeJS middleware), DynamoDB Integration Sample

## Note: 
you might ask why is SQS included in this architecture?

The short answer is because I wanted to experiment deploying
and integrating an SQS service. This turned out to bite me 
as I am fairly confident it is not possible to pass any other 
http method besides POST through an API -> SQS -> Lambda
integration and if I had just done API -> Lambda, this example
would have had more robust CRUD capabilities.  

The change for this is fairly easy just delete the SQS project,
and add resource integrations directly to Lambda instead, updating
the index.mjs file to include DynamoDB crud methods as well. 

This is a lot of code change though and I want to work on other stuff since 
this proof of concept is fully functional.

Tested using ThunderClient via the public API invokation URI with an example data structure: 

    {
      "id":"1",
      "date":"02162024",
      "text":"test"
    }


Thanks, Folks!
