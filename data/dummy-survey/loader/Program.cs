using Npgsql;
using System.Text.Json;
var cfg=JsonDocument.Parse(File.ReadAllText("backend/appsettings.json"));
await using var db=new NpgsqlConnection(cfg.RootElement.GetProperty("ConnectionStrings").GetProperty("AppDbContext").GetString());await db.OpenAsync();
await using var cmd=new NpgsqlCommand(File.ReadAllText(args[0]),db);await using var r=await cmd.ExecuteReaderAsync();do{while(await r.ReadAsync())Console.WriteLine(r.GetValue(0));}while(await r.NextResultAsync());
