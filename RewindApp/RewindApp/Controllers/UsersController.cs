using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Data;
using RewindApp.Models;
using RewindApp.RequestsModels;
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
    
    [HttpGet("groups/{userId}")]
    public async Task<ActionResult<IEnumerable<Groups>>> GetUserGroups(int userId)
    {
        return await _context.Groups.Where(group => group.OwnerId == userId).ToListAsync();
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<User>>> GetUsers()
    {
        return await _context.Users.ToListAsync();
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
    
    [HttpGet("image/{userId}")]
    public async Task<ActionResult<byte[]>> GetUserImage(int userId)
    {
        var user = await GetUserById(userId);
        if (user == null)
        {
            return BadRequest("Something went wrong");
        }
        
        return File(user.ProfileImage, "application/png", "result.png");
    }
    
    [HttpGet("send-code/{receiverEmail}")]
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
        var user = await _context.Users.FirstOrDefaultAsync(user => user.UserId == userId);
        return user;
    }
}