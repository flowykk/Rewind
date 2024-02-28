using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Data;
using RewindApp.Entities;
using RewindApp.Requests.ChangeRequests;
using RewindApp.Services;
using System.IO;
using MySql.Data.MySqlClient;

namespace RewindApp.Controllers;

[ApiController]
[Route("[controller]")]
public class ChangeController : ControllerBase
{
    private readonly DataContext _context;
    private readonly ILogger<ChangeController> _logger;
    private readonly IUsersController _usersController;
    private readonly IUserService _userService;

    public ChangeController(DataContext context, ILogger<ChangeController> logger, IUsersController usersController, IUserService userService)
    {
        _context = context;
        _logger = logger;
        _usersController = usersController;
        _userService = userService;
    }

    [HttpPut("name/{userId}")]
    public async Task<ActionResult> ChangeName(int userId, UserNameRequest request)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest($"error");
        
        user.UserName = request.UserName;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        return Ok($"name changed id - {user.UserName}; new name - {user.UserName}");
    }
    
    [HttpPut("email/{userId}")]
    public async Task<ActionResult> ChangeEmail(int userId, UserEmailRequest request)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest($"error");
        
        user.Email = request.Email;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        return Ok($"email changed id - {user.UsersId}; new email - {user.UserName}");
    }

    [HttpPut("password/{userId}")]
    public async Task<ActionResult> ChangePassword(int userId, UserPasswordRequest request)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest($"error");
        
        user.Password = _userService.ComputeHash(request.Password);
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        return Ok($"password changed id - {user.UsersId}; new password - {user.Password}");
    }
    
    [HttpPut("image/{userId}")]
    public async Task<ActionResult> EditUserProfileImage(MediaRequest mediaRequest, int userId)
    {
        var rawData = mediaRequest.Media;
        //var rawData = await System.IO.File.ReadAllBytesAsync("sample2.png");
        var date = DateTime.Now;
        
        var server = "localhost";
        var databaseName = "rewinddb";
        var userName = "rewinduser";
        var password = "rewindpass";

        var connectionString = $"Server={server}; Port=3306; Database={databaseName}; UID={userName}; Pwd={password}";
        //                       Server=myServerAddress; Port=1234; Database=myDataBase; Uid=myUsername; Pwd=myPassword;
        var connection = new MySqlConnection(connectionString);
        connection.Open();
        
        var command = new MySqlCommand()
        {
            Connection = connection,
            CommandText = "UPDATE Users SET ProfileImage = @rawData WHERE UsersId = @userId;"
        };
        var fileContentParameter = new MySqlParameter("?rawData", MySqlDbType.Blob, rawData.Length)
        {
            Value = rawData
        };
        var userIdParameter = new MySqlParameter("?userId", MySqlDbType.Int64)
        {
            Value = userId
        };
        command.Parameters.Add(fileContentParameter);
        command.Parameters.Add(userIdParameter);

        command.ExecuteNonQuery();
        
        return Ok($"image changed" )
        
        /*var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("Something went wrong");

        var rawData = await System.IO.File.ReadAllBytesAsync("sample.png");
        
        user.ProfileImage = rawData;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();

        var media = new Media()
        {
            Date = DateTime.Now,
            Photo = rawData
        };

        _context.Media.Add(media);
        await _context.SaveChangesAsync();

        //return File(user.Image, "application/png", "users test.png");
        return Ok($"image changed {user.ProfileImage.Length} {media.Photo.Length}" )*/;
    }
    
    [HttpPut("forgot-password/{userId}")]
    public async Task<ActionResult> ForgotPasswordPassword(string userEmail)
    {
        var user = await _context.Users.FirstOrDefaultAsync(user => user.Email == userEmail);
        if (user == null)
        {
            return BadRequest("User not found.");
        }
        
        //TODO: Отправка кода верификации на указанный userEmail - SendEmailAsync(email).GetAwaiter() ???;
        //TODO: После проверки введённого кода - запрос на новый пароль
        //TODO: После - обновление пароля
        
        return Ok($"Your password was successfully changed!");
    }
}