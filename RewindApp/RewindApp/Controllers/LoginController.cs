using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Data;
using RewindApp.Models;
using RewindApp.RequestsModels;
using RewindApp.Services;

namespace RewindApp.Controllers;

[ApiController]
[Route("[controller]")]
public class LoginController : ControllerBase
{
    private readonly DataContext _context;
    private readonly ILogger<LoginController> _logger;
    private readonly IUsersController _usersController;
    private readonly IUserService _userService;

    public LoginController(DataContext context, ILogger<LoginController> logger, IUsersController usersController, IUserService userService)
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
        if (user == null)
        {
            return BadRequest("User not found");
        }

        return Ok("Ok");
    }

    [HttpPost]
    public async Task<ActionResult> Login(UserLoginRequest request)
    {
        var user = await _usersController.GetUserByEmail(request.Email);
        if (user == null)
        {
            return BadRequest("User not found");
        }
        
        string passwordHash = _userService.ComputeHash(request.Password);
        if (passwordHash != user.Password)
        {
            return BadRequest("Incorrect password!");
        }

        return Ok($"{user.UserId}");
    }
}