using Npgsql;
using System.Text.Json;
var cfg=JsonDocument.Parse(File.ReadAllText("backend/appsettings.json"));
var source="data/imports/standard-4/standard-4.extracted.json";
var data=JsonDocument.Parse(File.ReadAllText(source)).RootElement;
await using var db=new NpgsqlConnection(cfg.RootElement.GetProperty("ConnectionStrings").GetProperty("AppDbContext").GetString());
await db.OpenAsync();
if(args.Contains("--sentence-case")) {
 await using var casingTx=await db.BeginTransactionAsync();
 var sql="UPDATE standards SET \"standardTitle\"=upper(left(\"standardTitle\",1)) || lower(substring(\"standardTitle\" from 2)) WHERE \"standardNumber\"='4'; UPDATE criteria SET \"criterionTitle\"=upper(left(\"criterionTitle\",1)) || lower(substring(\"criterionTitle\" from 2)) WHERE \"standardId\"=(SELECT \"standardId\" FROM standards WHERE \"standardNumber\"='4');";
 await using var update=new NpgsqlCommand(sql,db,casingTx);
 var count=await update.ExecuteNonQueryAsync();
 if(count!=8)throw new Exception("Expected one standard and seven criteria; rolling back");
 await casingTx.CommitAsync();
 await using var read=new NpgsqlCommand("SELECT \"standardTitle\" FROM standards WHERE \"standardNumber\"='4' UNION ALL SELECT \"criterionTitle\" FROM criteria WHERE \"standardId\"=(SELECT \"standardId\" FROM standards WHERE \"standardNumber\"='4')",db);
 await using var reader=await read.ExecuteReaderAsync();
 while(await reader.ReadAsync())Console.WriteLine(reader.GetString(0));
 return;
}
await using var tx=await db.BeginTransactionAsync();
async Task<int> Scalar(string sql,params object[] values){await using var cmd=new NpgsqlCommand(sql,db,tx);foreach(var v in values)cmd.Parameters.AddWithValue(v);return Convert.ToInt32(await cmd.ExecuteScalarAsync());}
var component=await Scalar("SELECT \"componentId\" FROM components WHERE \"componentNumber\"=$1","2");
var function=await Scalar("SELECT \"functionId\" FROM functions WHERE \"functionNumber\"=$1","1");
if(component==0||function==0)throw new Exception("Required parent missing");
if(await Scalar("SELECT count(*) FROM standards WHERE \"standardNumber\"=$1","4")!=0)throw new Exception("Standard 4 already exists; no changes made");
var expected=new List<(string table,string idField,int id,Dictionary<string,object> fields)>();
async Task<int> Insert(string table,string idField,Dictionary<string,object> fields){
 var sql=$"INSERT INTO {table} ({string.Join(",",fields.Keys.Select(k=>$"\"{k}\""))}) VALUES ({string.Join(",",Enumerable.Range(1,fields.Count).Select(i=>$"${i}"))}) RETURNING \"{idField}\"";
 int id=await Scalar(sql,fields.Values.ToArray());expected.Add((table,idField,id,fields));return id;
}
string S(JsonElement e,string k)=>e.GetProperty(k).GetString()!;
var sid=await Insert("standards","standardId",new(){["standardNumber"]="4",["standardTitle"]=S(data,"standardTitle"),["standardSummary"]=S(data,"standardSummary"),["componentId"]=component,["functionId"]=function});
foreach(var c in data.GetProperty("criteria").EnumerateArray()){
 var cid=await Insert("criteria","criterionId",new(){["criterionNumber"]=S(c,"criterionNumber"),["criterionTitle"]=S(c,"criterionTitle"),["standardId"]=sid,["isApplicable"]=true});
 foreach(var co in c.GetProperty("compliances").EnumerateArray()){
  var coid=await Insert("compliances","complianceId",new(){["complianceNumber"]=S(co,"complianceNumber"),["complianceSummary"]=S(co,"complianceSummary"),["criterionId"]=cid,["isApplicable"]=true});
  foreach(var e in co.GetProperty("evidence").EnumerateArray())await Insert("evidence","evidenceId",new(){["evidenceNumber"]=S(e,"evidenceNumber"),["evidenceSummary"]=S(e,"evidenceSummary"),["complianceId"]=coid,["isApplicable"]=true});
 }
}
foreach(var row in expected){
 var filters=row.fields.Select((f,i)=>$"\"{f.Key}\"=${i+2}");
 var count=await Scalar($"SELECT count(*) FROM {row.table} WHERE \"{row.idField}\"=$1 AND {string.Join(" AND ",filters)}",new object[]{row.id}.Concat(row.fields.Values).ToArray());
 if(count!=1)throw new Exception("Verification failed: "+row.table);
}
if(expected.Count!=45)throw new Exception("Unexpected record count");
await tx.CommitAsync();
await using var check=new NpgsqlCommand("SELECT count(*) FROM evidence e JOIN compliances co ON e.\"complianceId\"=co.\"complianceId\" JOIN criteria c ON co.\"criterionId\"=c.\"criterionId\" WHERE c.\"standardId\"=$1",db);
check.Parameters.AddWithValue(sid);
if(Convert.ToInt32(await check.ExecuteScalarAsync())!=26)throw new Exception("Post-commit verification failed");
var receipt=new{standardId=sid,componentId=component,functionId=function,criteria=7,compliances=11,evidence=26,verifiedRecords=expected.Count,importedAt=DateTimeOffset.UtcNow};
File.WriteAllText("data/imports/standard-4/import-receipt.json",JsonSerializer.Serialize(receipt,new JsonSerializerOptions{WriteIndented=true}));
Console.WriteLine(JsonSerializer.Serialize(receipt));

