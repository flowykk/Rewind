using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Infrastructure.Data;
using RewindApp.Domain.Entities;
using RewindApp.Infrastructure.Services;

namespace RewindApp.Controllers.UserControllers;

public interface IUsersController
{
    public Task<IEnumerable<User>> GetUsers();
    public Task<User?> GetUserByEmail(string email);

    public Task<User?> GetUserById(int userId);
    public int SendVerificationCode(string receiverEmail);
    public Task<IEnumerable<Media>> GetLikedMediaByUser(int userId);
}

[ApiController]
[Route("[controller]")]
public class UsersController : ControllerBase, IUsersController
{
    private readonly DataContext _context;
    private readonly IEmailSender _emailSender;
    private readonly IUserService _userService;

    public UsersController(DataContext context)
    {
        _context = context;
        _emailSender = new EmailSender();
        _userService = new UserService();
    }

    [HttpGet]
    public async Task<IEnumerable<User>> GetUsers()
    {
        return await _context.Users.ToListAsync();
    }
    
    [HttpDelete("delete/{userId}")]
    public async Task<ActionResult> DeleteUser(int userId)
    {
        var user = await GetUserById(userId);
        if (user == null) return BadRequest("User not found");
        
        _context.Users.Remove(user);
        await _context.SaveChangesAsync();
        return Ok(userId);
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

    [HttpGet("{userId}")]
    public async Task<User?> GetUserById(int userId)
    {
        var user = await _context.Users
            .Include(u => u.Groups)
            .Include(u => u.Media)
            .FirstOrDefaultAsync(user => user.Id == userId);
        return user;
    }

    public async Task<IEnumerable<Media>> GetLikedMediaByUser(int userId)
    {
        return await _context.Users
            .Include(user => user.Media)
            .Where(user => user.Id == userId)
            .SelectMany(user => user.Media).ToListAsync(); 
    }
}