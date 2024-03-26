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
    private readonly IUsersController _usersController;
    private readonly IUserService _userService;
    private readonly SqlService _sqlService;

    public ChangeUserController(DataContext context)
    {
        _context = context;
        _usersController = new UsersController(context);
        _userService = new UserService();
        _sqlService = new SqlService();
    }

    [HttpPut("name/{userId}")]
    public async Task<ActionResult> ChangeName(int userId, NameRequest request)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");
        
        user.UserName = request.Name;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        var imageParameter = new MySqlParameter("?objectData", MySqlDbType.Blob, user.ProfileImage.Length)
        {
            Value = user.ProfileImage
        };
        var tinyImageParameter = new MySqlParameter("?tinyObjectData", MySqlDbType.TinyBlob, user.TinyProfileImage.Length)
        {
            Value = user.TinyProfileImage
        };
        var nameParameter = new MySqlParameter("?name", MySqlDbType.VarChar, request.Name.Length)
        {
            Value = request.Name
        };
        var groupIdParameter = new MySqlParameter("?userId", MySqlDbType.Int64)
        {
            Value = userId
        };

        const string commandText = "UPDATE Users SET ProfileImage = @objectData, TinyProfileImage = @tinyObjectData, UserName = @name WHERE Id = @userId;";
        var parameters = new List<MySqlParameter>
        {
            nameParameter,
            imageParameter,
            tinyImageParameter,
            groupIdParameter
        };
        _sqlService.UpdateInfo(commandText, parameters);
        
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
        
        var imageParameter = new MySqlParameter("?objectData", MySqlDbType.Blob, user.ProfileImage.Length)
        {
            Value = user.ProfileImage
        };
        var tinyImageParameter = new MySqlParameter("?tinyObjectData", MySqlDbType.TinyBlob, user.TinyProfileImage.Length)
        {
            Value = user.TinyProfileImage
        };
        var emailParameter = new MySqlParameter("?email", MySqlDbType.VarChar, request.Email.Length)
        {
            Value = request.Email
        };
        var groupIdParameter = new MySqlParameter("?userId", MySqlDbType.Int64)
        {
            Value = userId
        };

        const string commandText = "UPDATE Users SET ProfileImage = @objectData, TinyProfileImage = @tinyObjectData, Email = @email WHERE Id = @userId;";
        var parameters = new List<MySqlParameter>
        {
            emailParameter,
            imageParameter,
            tinyImageParameter,
            groupIdParameter
        };
        _sqlService.UpdateInfo(commandText, parameters);
        
        return Ok("Email changed");
    }

    [HttpPut("password/{userId}")]
    public async Task<ActionResult> ChangePassword(int userId, PasswordRequest request)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest("User not found");

        user.Password = request.Password; //_userService.ComputeHash(request.Password);
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        var imageParameter = new MySqlParameter("?objectData", MySqlDbType.Blob, user.ProfileImage.Length)
        {
            Value = user.ProfileImage
        };
        var tinyImageParameter = new MySqlParameter("?tinyObjectData", MySqlDbType.TinyBlob, user.TinyProfileImage.Length)
        {
            Value = user.TinyProfileImage
        };
        var passwordParameter = new MySqlParameter("?password", MySqlDbType.VarChar, request.Password.Length)
        {
            Value = request.Password
        };
        var groupIdParameter = new MySqlParameter("?userId", MySqlDbType.Int64)
        {
            Value = userId
        };

        const string commandText = "UPDATE Users SET ProfileImage = @objectData, TinyProfileImage = @tinyObjectData, Password = @password WHERE Id = @userId;";
        var parameters = new List<MySqlParameter>
        {
            passwordParameter,
            imageParameter,
            tinyImageParameter,
            groupIdParameter
        };
        _sqlService.UpdateInfo(commandText, parameters);
        
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
        
        var imageParameter = new MySqlParameter("?objectData", MySqlDbType.Blob, user.ProfileImage.Length)
        {
            Value = user.ProfileImage
        };
        var tinyImageParameter = new MySqlParameter("?tinyObjectData", MySqlDbType.TinyBlob, user.TinyProfileImage.Length)
        {
            Value = user.TinyProfileImage
        };
        var iconParameter = new MySqlParameter("?icon", MySqlDbType.VarChar, newIcon.Length)
        {
            Value = newIcon
        };
        var groupIdParameter = new MySqlParameter("?userId", MySqlDbType.Int64)
        {
            Value = userId
        };

        const string commandText = "UPDATE Users SET ProfileImage = @objectData, TinyProfileImage = @tinyObjectData, AppIcon = @icon WHERE Id = @userId;";
        var parameters = new List<MySqlParameter>
        {
            iconParameter,
            imageParameter,
            tinyImageParameter,
            groupIdParameter
        };
        _sqlService.UpdateInfo(commandText, parameters);
        
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