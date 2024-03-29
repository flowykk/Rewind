using Microsoft.AspNetCore.Mvc;
using RewindApp.Data;
using RewindApp.Entities;
using RewindApp.Requests.UserRequests;
using RewindApp.Services;

namespace RewindApp.Controllers.UserControllers;

[ApiController]
[Route("[controller]")]
public class RegisterController : ControllerBase
{
    private readonly DataContext _context;
    //private readonly ILogger<RegisterController> _logger;
    private readonly IUsersController _usersController;
    private readonly IUserService _userService;

    public RegisterController(DataContext context) //ILogger<RegisterController> logger, IUsersController usersController, IUserService userService)
    {
        _context = context;
        _usersController = new UsersController(context);
        _userService = new UserService();
    }

    [HttpGet("check-email/{email}")]
    public async Task<ActionResult> CheckEmail(string email)
    {
        var user = await _usersController.GetUserByEmail(email);
        if (user != null) return BadRequest("User is registered");

        try
        {
            var verificationCode = _usersController.SendVerificationCode(email);
            return Ok(verificationCode);
        }
        catch (Exception e)
        {
            return BadRequest(e.Message);
        }
    }

    [HttpPost]
    public async Task<ActionResult> Register(UserRegisterRequest request)
    {
        var user = await _usersController.GetUserByEmail(request.Email);
        if (user != null) return BadRequest("User with this email already exists!");
        
        var newUser = new User
        { 
            UserName = request.UserName,
            Email = request.Email,
            Password = request.Password,
            RegistrationDateTime = DateTime.Now,
            ProfileImage = Array.Empty<byte>()
        };

        _context.Users.Add(newUser);
        await _context.SaveChangesAsync();

        return StatusCode(200, newUser);  //Ok(newUser);
    }
}