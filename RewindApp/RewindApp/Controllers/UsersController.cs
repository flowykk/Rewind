using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Data;
using RewindApp.Models;
using RewindApp.Models.RequestsModels;
using RewindApp.Services;

namespace RewindApp.Controllers;

public interface IUsersController
{
    public Task<User?> GetUserByEmail(string email);

    public Task<User?> GetUserById(int userId);
    public int SendVerificationCode(string receiverEmail);
}

[ApiController]
[Route("[controller]")]
public class UsersController : ControllerBase, IUsersController
{
    private readonly DataContext _context;
    private readonly ILogger<UsersController> _logger;
    private readonly IEmailSender _emailSender;
    private readonly IUserService _userService;

    public UsersController(DataContext context, ILogger<UsersController> logger, IEmailSender emailSender, IUserService userService)
    {
        _context = context;
        _logger = logger;
        _emailSender = emailSender;
        _userService = userService;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<User>>> GetUsers()
    {
        return await _context.Users.ToListAsync();
    }

    /*[HttpGet("check-email/{email}")]
    public async Task<ActionResult> CheckEmail(string email)
    {
        //int verificationCode = GenerateCode();

        var user = await GetUserByEmail(email);
        if (user != null)
        {
            return BadRequest($"Bad");
        }

        int verificationCode = SendVerificationCode(email);
        return Ok($"{verificationCode}");
    }

    public int SendVerificationCode(string receiverEmail)
    {
        var verificationCode = _userService.GenerateCode();

        _emailSender.SendEmail(
            receiverEmail, 
            "Rewind verification code",
            $"Your verification code - {verificationCode}"
            );

        return verificationCode;
    }

    [HttpPost("register")]
    public async Task<ActionResult> Register(UserRegisterRequest request)
    {
        // user exists check?
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

        return Ok($"{GetUserByEmail(request.Email).Id}");
    }*/
    
    [HttpPost("login")]
    public async Task<ActionResult> Login(UserLoginRequest request)
    {
        var user = await GetUserByEmail(request.Email);
        
        // maybe dont need this
        if (user == null)
        {
            return BadRequest("User not found.");
        }
        
        string passwordHash = _userService.ComputeHash(request.Password);
        if (passwordHash != user.Password)
        {
            return BadRequest("Incorrect password!");
        }

        return Ok($"id - {user.Id}");
    }
    
    
    [HttpDelete("delete/{userId}")]
    public async Task<ActionResult> DeleteUserAccount(int userId)
    {
        var user = await GetUserById(userId);
        if (user != null)
        {
            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return Ok($"User with Id {userId} was successfully deleted");
        }
        
        return BadRequest("User not found.");
    }
    
    public int SendVerificationCode(string receiverEmail)
    {
        var verificationCode = _userService.GenerateCode();

        _emailSender.SendEmail(
            receiverEmail, 
            "Rewind verification code",
            $"Your verification code - {verificationCode}"
        );

        return verificationCode;
    }
    
    public async Task<User?> GetUserByEmail(string email)
    {
        var user = await _context.Users.FirstOrDefaultAsync(user => user.Email == email);
        return user;
    }

    public async Task<User?> GetUserById(int userId)
    {
        var user = await _context.Users.FirstOrDefaultAsync(user => user.Id == userId);
        return user;
    }
}