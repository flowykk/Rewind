using Microsoft.AspNetCore.Mvc;
using RewindApp.Application.Interfaces.UserInterfaces;
using RewindApp.Infrastructure.Data;
using RewindApp.Domain.Requests.ChangeRequests;
using RewindApp.Domain.Requests;
using RewindApp.Infrastructure.Data.Repositories.UserRepositories;

namespace RewindApp.Controllers.UserControllers;

[ApiController]
[Route("change-user")]
public class ChangeUserController : ControllerBase
{
    private readonly IUserRepository _userRepository;
    private readonly IChangeUserRepository _changeUserRepository;

    public ChangeUserController(DataContext context)
    {
        _userRepository = new UserRepository(context);
        _changeUserRepository = new ChangeUserRepository(context);
    }

    [HttpPut("name/{userId}")]
    public async Task<ActionResult> ChangeName(int userId, TextRequest request)
    {
        var user = await _userRepository.GetUserByIdAsync(userId);
        if (user == null) return BadRequest("User not found");

        await _changeUserRepository.ChangeNameAsync(user, request);
        
        return Ok("Text changed");
    }
    
    [HttpPut("email/{userId}")]
    public async Task<ActionResult> ChangeEmail(int userId, EmailRequest request)
    {
        var user = await _userRepository.GetUserByIdAsync(userId);
        if (user == null) return BadRequest("User not found");
        
        await _changeUserRepository.ChangeEmailAsync(user, request);
        
        return Ok("Email changed");
    }

    [HttpPut("password/{userId}")]
    public async Task<ActionResult> ChangePassword(int userId, PasswordRequest request)
    {
        var user = await _userRepository.GetUserByIdAsync(userId);
        if (user == null) return BadRequest("User not found");

        await _changeUserRepository.ChangePasswordAsync(user, request);
        
        return Ok("Password changed");
    }

    [HttpPut("icon/{userId}")]
    public async Task<ActionResult> ChangeAppIcon(int userId, string newIcon)
    {
        var user = await _userRepository.GetUserByIdAsync(userId);
        if (user == null) return BadRequest("User not found");

        await _changeUserRepository.ChangeAppIconAsync(user, newIcon);
        
        return Ok("AppIcon changed");
    }
    
    [HttpPut("image/{userId}")]
    public async Task<ActionResult> ChangeProfileImage(MediaRequest mediaRequest, int userId)
    {
        var user = await _userRepository.GetUserByIdAsync(userId);
        if (user == null) return BadRequest("User not found");

        await _changeUserRepository.ChangeProfileImage(user, mediaRequest);

        return Ok("Image changed");
    }
}