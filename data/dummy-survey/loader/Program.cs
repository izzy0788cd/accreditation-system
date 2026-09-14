using Npgsql;
using System.Text.Json;
var cfg=JsonDocument.Parse(File.ReadAllText("backend/appsettings.json"));
var connectionString = Environment.GetEnvironmentVariable("ConnectionStrings__AppDbContext")
    ?? cfg.RootElement.GetProperty("ConnectionStrings").GetProperty("AppDbContext").GetString()
    ?? throw new InvalidOperationException("A database connection string is required.");
await using var db=new NpgsqlConnection(connectionString);await db.OpenAsync();
await using var cmd=new NpgsqlCommand(File.ReadAllText(args[0]),db);await using var r=await cmd.ExecuteReaderAsync();do{while(await r.ReadAsync())Console.WriteLine(string.Join("\t", Enumerable.Range(0, r.FieldCount).Select(r.GetValue)));}while(await r.NextResultAsync());
