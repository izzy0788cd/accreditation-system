using System.Text;
using backend.Authorization;
using backend.Data;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();
builder.Services.AddControllers();
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("AppDbContext"))
);

builder.Services.AddCors(options =>
{
    options.AddPolicy(
        "AllowFrontendDev",
        policy =>
        {
            policy
                .SetIsOriginAllowed(origin => true)
                .AllowAnyHeader()
                .AllowAnyMethod()
                .AllowCredentials();
        }
    );
});

//add swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.AddSecurityDefinition(
        "Bearer",
        new OpenApiSecurityScheme
        {
            Name = "Authorization",
            Type = SecuritySchemeType.Http,
            Scheme = "bearer",
            BearerFormat = "JWT",
            In = ParameterLocation.Header,
            Description = "Enter your JWT token like this: Bearer {your token}",
        }
    );

    options.AddSecurityRequirement(document => new OpenApiSecurityRequirement
    {
        [new OpenApiSecuritySchemeReference("Bearer", document)] = new List<string>(),
    });
});

var jwtKey = builder.Configuration["Jwt:Key"]!;
var jwtIssuer = builder.Configuration["Jwt:Issuer"]!;
var jwtAudience = builder.Configuration["Jwt:Audience"]!;

builder
    .Services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtIssuer,
            ValidAudience = jwtAudience,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey)),
        };
    });

builder.Services.AddAuthorization(options =>
{
    // Keep role membership here, not spread throughout controller attributes.
    options.AddPolicy(PolicyNames.ReferenceDataRead, policy => policy.RequireAuthenticatedUser());
    options.AddPolicy(PolicyNames.ReferenceDataManage, policy => policy.RequireRole("Admin"));
    options.AddPolicy(PolicyNames.SurveyWork, policy => policy.RequireRole("Admin", "Surveyor", "Team Lead"));
    options.AddPolicy(PolicyNames.SurveyReviewTeam, policy => policy.RequireRole("Admin", "Team Lead"));
    options.AddPolicy(PolicyNames.SurveyAdminister, policy => policy.RequireRole("Admin"));
    options.AddPolicy(PolicyNames.ReportsGenerate, policy => policy.RequireRole("Admin", "Team Lead"));
    options.AddPolicy(PolicyNames.ActionsManage, policy => policy.RequireRole("Admin", "Team Lead"));
    options.AddPolicy(PolicyNames.AccountsManage, policy => policy.RequireRole("Admin"));
});

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();

    app.UseSwagger();
    app.UseSwaggerUI();
}

// app.UseHttpsRedirection();

// CORS must run before auth so 401/403 responses retain the CORS headers that
// let the frontend display a useful access message instead of a browser error.
app.UseCors("AllowFrontendDev");

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
