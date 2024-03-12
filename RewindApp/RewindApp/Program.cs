using Microsoft.EntityFrameworkCore;
using RewindApp.Controllers.GroupControllers;
using RewindApp.Controllers.UserControllers;
using RewindApp.Data;
using RewindApp.Data.Repositories;
using RewindApp.Data.Repositories.UserRepositories;
using RewindApp.Interfaces;
using RewindApp.Interfaces.UserInterfaces;
using RewindApp.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
builder.Services.AddTransient<IEmailSender, EmailSender>();
builder.Services.AddTransient<IUsersController, UsersController>();
builder.Services.AddTransient<IGroupsController, GroupsController>();
builder.Services.AddTransient<IUserService, UserService>();

builder.Services.AddTransient<IUserRepository, UserRepository>();
builder.Services.AddTransient<IRegisterRepository, RegisterRepository>();
builder.Services.AddTransient<IChangeUserRepository, ChangeUserRepository>();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
//builder.Services.AddEndpointsApiExplorer();
//builder.Services.AddSwaggerGen();
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

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
    //app.UseSwagger();
    //app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();