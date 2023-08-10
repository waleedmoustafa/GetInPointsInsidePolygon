using Microsoft.EntityFrameworkCore;
using Points.Api;
using Points.Api.Core;
using Points.Api.Services;
using System.Configuration;

var builder = WebApplication.CreateBuilder(args);


// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddScoped<IPointProvider, PointProvider>();

builder.Configuration.AddJsonFile($"App_Data/appsettings.json", true, true);
builder.Configuration.AddEnvironmentVariables();

builder.Services.AddDbContext<PointsDbConext>(cnn => cnn.UseSqlServer(builder.Configuration.GetConnectionString("ConnectionStrings")));


var startup = new Startup(builder.Configuration);
startup.ConfigureServices(builder.Services); // calling ConfigureServices method

var app = builder.Build();
startup.Configure(app, builder.Environment); // calling Configure method


