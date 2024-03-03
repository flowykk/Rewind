using Microsoft.AspNetCore.Mvc;
using RewindApp.Data;
using RewindApp.Requests.ChangeRequests;
using RewindApp.Requests;
using RewindApp.Services;
using MySql.Data.MySqlClient;
using RewindApp.Entities;

namespace RewindApp.Controllers.UserControllers;

[ApiController]
[Route("change-user")]
public class ChangeUserController : ControllerBase
{
    private readonly DataContext _context;
    private readonly ILogger<ChangeUserController> _logger;
    private readonly IUsersController _usersController;
    private readonly IUserService _userService;

    public ChangeUserController(DataContext context, ILogger<ChangeUserController> logger, IUsersController usersController, IUserService userService)
    {
        _context = context;
        _logger = logger;
        _usersController = usersController;
        _userService = userService;
    }

    [HttpPut("name/{userId}")]
    public async Task<ActionResult> ChangeName(int userId, NameRequest request)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");
        
        user.UserName = request.Name;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        return Ok("Name changed");
    }
    
    [HttpPut("email/{userId}")]
    public async Task<ActionResult> ChangeEmail(int userId, EmailRequest request)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");
        
        user.Email = request.Email;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        return Ok("Email changed");
    }

    [HttpPut("password/{userId}")]
    public async Task<ActionResult> ChangePassword(int userId, PasswordRequest request)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");
        
        user.Password = _userService.ComputeHash(request.Password);
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        return Ok($"Password changed");
    }
    
    [HttpPut("image/{userId}")]
    public async Task<ActionResult<User>> EditUserProfileImage(MediaRequest mediaRequest, int userId)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");

        var rawData = Convert.FromBase64String(mediaRequest.Media);
        Console.WriteLine(rawData.Length);
        Console.WriteLine(mediaRequest.Media.Length);

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
            CommandText = "UPDATE Users SET ProfileImage = @rawData WHERE Id = @userId;"
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

        return Ok("Image changed")

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
}