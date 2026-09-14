using Npgsql;
using System.Text.Json;
var cfg=JsonDocument.Parse(File.ReadAllText("backend/appsettings.json"));
var source="data/imports/standard-22/standard-22.extracted.json";
var data=JsonDocument.Parse(File.ReadAllText(source)).RootElement;
await using var db=new NpgsqlConnection(cfg.RootElement.GetProperty("ConnectionStrings").GetProperty("AppDbContext").GetString());
await db.OpenAsync();
await using var tx=await db.BeginTransactionAsync();
async Task<int> Scalar(string sql,params object[] values){await using var cmd=new NpgsqlCommand(sql,db,tx);foreach(var v in values)cmd.Parameters.AddWithValue(v);return Convert.ToInt32(await cmd.ExecuteScalarAsync());}
var sid=await Scalar("SELECT \"standardId\" FROM standards WHERE \"standardNumber\"=$1","22");
if(sid==0)throw new Exception("Standard 22 missing");
if(await Scalar("SELECT count(*) FROM criteria WHERE \"standardId\"=$1 AND \"criterionNumber\" IN ('22.2','22.3','22.4','22.5','22.6')",sid)!=0)throw new Exception("Some target criteria already exist; recheck before import");
var expected=new List<(string table,string idField,int id,Dictionary<string,object> fields)>();
async Task<int> Insert(string table,string idField,Dictionary<string,object> fields){
 var sql=$"INSERT INTO {table} ({string.Join(",",fields.Keys.Select(k=>$"\"{k}\""))}) VALUES ({string.Join(",",Enumerable.Range(1,fields.Count).Select(i=>$"${i}"))}) RETURNING \"{idField}\"";
 int id=await Scalar(sql,fields.Values.ToArray());expected.Add((table,idField,id,fields));return id;
}
string S(JsonElement e,string k)=>e.GetProperty(k).GetString()!;
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
if(expected.Count!=203)throw new Exception("Unexpected record count");
await tx.CommitAsync();
var receipt=new{standardId=sid,criteriaAdded=5,compliancesAdded=40,evidenceAdded=158,verifiedRecords=expected.Count,importedAt=DateTimeOffset.UtcNow};
File.WriteAllText("data/imports/standard-22/import-receipt.json",JsonSerializer.Serialize(receipt,new JsonSerializerOptions{WriteIndented=true}));
Console.WriteLine(JsonSerializer.Serialize(receipt));
