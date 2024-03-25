using Microsoft.AspNetCore.Mvc;
using RewindApp.Data;
using RewindApp.Requests.ChangeRequests;
using RewindApp.Requests;
using RewindApp.Services;
using MySql.Data.MySqlClient;


namespace RewindApp.Controllers.UserControllers;

[ApiController]
[Route("change-user")]
public class ChangeUserController : ControllerBase
{
    private readonly DataContext _context;
    //private readonly ILogger<ChangeUserController> _logger;
    private readonly IUsersController _usersController;
    private readonly IUserService _userService;

    public ChangeUserController(DataContext context)
    {
        _context = context;
        _usersController = new UsersController(context);
        _userService = new UserService();
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
        
        return Ok("Password changed");
    }

    [HttpPut("icon/{userId}")]
    public async Task<ActionResult> ChangeAppIcon(int userId, string newIcon)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");

        user.AppIcon = newIcon;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        return Ok("AppIcon changed");
    }
    
    [HttpPut("image/{userId}")]
    public async Task<ActionResult> ChangeProfileImage(MediaRequest mediaRequest, int userId)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");

        var rawData = Convert.FromBase64String(mediaRequest.Object);
        var tinyData = Convert.FromBase64String(mediaRequest.TinyObject);

        var connectionString = DataContext.GetDbConnection();
        var connection = new MySqlConnection(connectionString);
        connection.Open();

        var command = new MySqlCommand()
        {
            Connection = connection,
            CommandText = "UPDATE Users SET ProfileImage = @rawData, TinyProfileImage = @tinyData WHERE Id = @userId;"
        };
        var imageParameter = new MySqlParameter("?rawData", MySqlDbType.Blob, rawData.Length)
        {
            Value = rawData
        };
        var tinyImageParameter = new MySqlParameter("?tinyData", MySqlDbType.TinyBlob, tinyData.Length)
        {
            Value = tinyData
        };
        var userIdParameter = new MySqlParameter("?userId", MySqlDbType.Int64)
        {
            Value = userId
        };
        
        user.ProfileImage = rawData;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        command.Parameters.Add(imageParameter);
        command.Parameters.Add(tinyImageParameter);
        command.Parameters.Add(userIdParameter);
        command.ExecuteNonQuery();

        return Ok("Image changed");
    }
}