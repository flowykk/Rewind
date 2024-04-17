using Microsoft.EntityFrameworkCore;
using RewindApp.Application.Interfaces.UserInterfaces;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Infrastructure.Data;
using RewindApp.Infrastructure.Data.Repositories.UserRepositories;
using RewindApp.Infrastructure.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddTransient<IEmailSender, EmailSender>();
builder.Services.AddTransient<IUserService, UserService>();

// builder.Services.AddTransient<IGroupRepository, GroupRepository>();
builder.Services.AddTransient<IUserRepository, UserRepository>();
builder.Services.AddTransient<IRegisterRepository, RegisterRepository>();
builder.Services.AddTransient<IChangeUserRepository, ChangeUserRepository>();

builder.Services.AddDbContext<DataContext>(options => options.UseMySQL(
    builder.Configuration.GetConnectionString("default")
) ); //.LogTo(Console.WriteLine));
builder.Services.AddControllers().AddNewtonsoftJson(options =>
    options.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore
);

var app = builder.Build();
app.UseMiddleware<GlobalRoutePrefixMiddleware>("/api");
app.UsePathBase(new PathString("/api"));
app.UseRouting();

if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();