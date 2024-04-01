using Microsoft.AspNetCore.Mvc;
using RewindApp.Data;
using RewindApp.Requests.UserRequests;
using RewindApp.Services;

namespace RewindApp.Controllers.UserControllers;

[ApiController]
[Route("[controller]")]
public class LoginController : ControllerBase
{
    //private readonly ILogger<LoginController> _logger;
    private readonly IUsersController _usersController;
    private readonly IUserService _userService;

    public LoginController(DataContext context) 
    {
        _usersController = new UsersController(context);
        _userService = new UserService();
    }

    [HttpGet("check-email/{email}")]
    public async Task<ActionResult> CheckEmail(string email)
    {
        var user = await _usersController.GetUserByEmail(email);
        if (user == null) return BadRequest("User not registered");

        return Ok(user.Id);
    }

    [HttpPost]
    public async Task<ActionResult> Login(UserLoginRequest request)
    {
        var user = await _usersController.GetUserByEmail(request.Email);
        if (user == null) return BadRequest("User not found");
        
        if (request.Password != user.Password) return BadRequest("Incorrect password");

        return Ok(user);
    }
}