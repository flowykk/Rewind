using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Data;
using RewindApp.Models;
using RewindApp.Services;

namespace RewindApp.Controllers;

[ApiController]
[Route("[controller]")]
public class ChangeController : ControllerBase
{
    private readonly DataContext _context;
    private readonly ILogger<ChangeController> _logger;
    private readonly IUsersController _usersController;

    public ChangeController(DataContext context, ILogger<ChangeController> logger, IUsersController usersController)
    {
        _context = context;
        _logger = logger;
        _usersController = usersController;
    }

    [HttpPut("name/{userId}/{newName}")]
    public async Task<ActionResult> EditUserName(int userId, string newName)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest($"error");
        
        user.UserName = newName;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        return Ok($"name changed id - {user.Id}; new name - {user.UserName}");
    }
    
    [HttpPut("email/{userId}/{newEmail}")]
    public async Task<ActionResult> EditUserEmail(int userId, string newEmail)
    {
        var user = await _usersController.GetUserById(userId);
        if (user == null) return BadRequest($"error");
        
        user.Email = newEmail;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        return Ok($"email changed id - {user.Id}; new email - {user.UserName}");
    }
    
    [HttpPut("edit-profile-image/{userId}")]
    public async Task<ActionResult> EditUserProfileImage(int userId)
    {
        throw new NotImplementedException();
    }
    
    [HttpPut("edit-password/{userId}")]
    public async Task<ActionResult> EditUserPassword(int userId)
    {
        throw new NotImplementedException();
    }
    
    [HttpPut("forgot-password/{userId}")]
    public async Task<ActionResult> ForgotPasswordPassword(string userEmail)
    {
        var user = await _context.Users.FirstOrDefaultAsync(user => user.Email == userEmail);
        if (user == null)
        {
            return BadRequest("User not found.");
        }
        
        //TODO: Отправка кода верификации на указанный userEmail - SendEmailAsync(email).GetAwaiter() ???;
        //TODO: После проверки введённого кода - запрос на новый пароль
        //TODO: После - обновление пароля
        
        return Ok($"Your password was successfully changed!");
    }
}