using System.Text;
using System.Text.Json;
using Microsoft.Azure.Cosmos;

var builder = WebApplication.CreateBuilder(args);
var endpoint = builder.Configuration["COSMOS_ENDPOINT"];
var key = builder.Configuration["COSMOS_KEY"];
var app = builder.Build();

using CosmosClient client = new(
    accountEndpoint: endpoint!,
    authKeyOrResourceToken: key!
);

Database database = await client.CreateDatabaseIfNotExistsAsync(
    id: "wordydb"
);

Container container = await database.CreateContainerIfNotExistsAsync(
    id: "dictionary",
    partitionKeyPath: "/dictionaryId",
    throughput: 1000
);

var parameterizedQuery = new QueryDefinition(
    query: "SELECT * FROM dictionary d WHERE d.dictionaryId = @partitionKey"
)
    .WithParameter("@partitionKey", "abc");

List<DictionaryEntry> entries = new List<DictionaryEntry>();

using FeedIterator filteredFeed = container.GetItemQueryStreamIterator(
    queryDefinition: parameterizedQuery
);
string result = "";
while (filteredFeed.HasMoreResults)
{
    var response = await filteredFeed.ReadNextAsync();
    result = Encoding.UTF8.GetString((response.Content as MemoryStream).ToArray());
    // // Iterate query results
    // foreach (DictionaryEntry item in response.RequestMessage)
    // {
    //     entries.Add(item);
    // }
}

app.MapGet("/", () => {

    return result;
});

app.Run();
