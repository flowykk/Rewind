using Microsoft.AspNetCore.Mvc;
using RewindApp.Requests.UserRequests;
using RewindApp.Services;

namespace RewindApp.Controllers.UserControllers;

[ApiController]
[Route("[controller]")]
public class LoginController : ControllerBase
{
    private readonly ILogger<LoginController> _logger;
    private readonly IUsersController _usersController;
    private readonly IUserService _userService;

    public LoginController(ILogger<LoginController> logger, IUsersController usersController, IUserService userService)
    {
        _logger = logger;
        _usersController = usersController;
        _userService = userService;
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
        
        var passwordHash = _userService.ComputeHash(request.Password);
        if (passwordHash != user.Password) return BadRequest("Incorrect password");

        return Ok(user);
    }
}