using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Data;
using RewindApp.Models;
using RewindApp.Models.RequestsModels;
using RewindApp.Services;

namespace RewindApp.Controllers;

[ApiController]
[Route("[controller]")]
public class RegisterController : ControllerBase
{
    private readonly DataContext _context;
    private readonly ILogger<RegisterController> _logger;
    private readonly IUsersController _usersController;
    private readonly IUserService _userService;

    public RegisterController(DataContext context, ILogger<RegisterController> logger, IUsersController usersController, IUserService userService)
    {
        _context = context;
        _logger = logger;
        _usersController = usersController;
        _userService = userService;
    }

    [HttpGet("check-email/{email}")]
    public async Task<ActionResult> CheckEmail(string email)
    {
        var user = await _usersController.GetUserByEmail(email);
        if (user != null)
        {
            return BadRequest($"Bad");
        }

        int verificationCode = _usersController.SendVerificationCode(email);
        return Ok($"{verificationCode}");
    }

    [HttpPost]
    public async Task<ActionResult> Register(UserRegisterRequest request)
    {
        if (_context.Users.Any(user => user.Email == request.Email))
        {
             return BadRequest("User with this email already exists!");
        }
        
        string passwordHash = _userService.ComputeHash(request.Password);
        
        var user = new User
        { 
            UserName = request.UserName,
            Email = request.Email,
            Password = passwordHash,
            RegistrationDateTime = DateTime.Now
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return Ok($"{user.Id}");
    }
}