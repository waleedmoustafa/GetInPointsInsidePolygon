using Points.Api.Configuration;

namespace Points.Api
{
    public class Startup
    {
        private IConfiguration Configuration { get; }
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        public void ConfigureServices(IServiceCollection services)
        {
            // Read connection string from appsettings.json
            var appSettings = Configuration.GetSection("ConnectionStrings").Get<AppSettings>();
            services.AddSingleton(appSettings);

            services.AddScoped<IJsonFieldsSerializer, JsonFieldsSerializer>();

        }

        public void Configure(WebApplication app, IWebHostEnvironment env)
        {
           

            if (!app.Environment.IsDevelopment())
            {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }


            app.UseHttpsRedirection();
            app.UseStaticFiles();
            app.UseCors();
            app.MapControllers();
            app.UseRouting();
            app.UseAuthorization();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }
            app.Run();
        }

    }
}
