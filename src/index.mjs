import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import {
  DynamoDBDocumentClient,
  ScanCommand,
  PutCommand,
  GetCommand,
  DeleteCommand,
} from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});

const dynamo = DynamoDBDocumentClient.from(client);
//pass
const tableName = "ToDoList";

export const handler = async (event, context) => {
  let body;
  let statusCode = 200;
  const headers = {
    "Content-Type": "application/json",
  };
  try {
        let requestJSON = JSON.parse(event.Records[0].body);
        console.log(requestJSON);
        await dynamo.send(
          new PutCommand({
            TableName: tableName,
            Item: {
              UserId: requestJSON.id,
              Date: requestJSON.date,
              Text: requestJSON.text,
            },
          })
        );
        body = `Put item ${requestJSON.id}`;
  } catch (err) {
    statusCode = 400;
    body = err.message;
  } finally {
    body = JSON.stringify(body);
    console.log(body);
  }

  return {
    statusCode,
    body,
    headers,
  };
};
