using Microsoft.AspNetCore.Mvc;
using RewindApp.Application.Interfaces.UserInterfaces;
using RewindApp.Infrastructure.Data;
using RewindApp.Domain.Entities;
using RewindApp.Infrastructure.Data.Repositories.UserRepositories;

namespace RewindApp.Controllers.UserControllers;

[ApiController]
[Route("[controller]")]
public class UsersController : ControllerBase
{
    private readonly IUserRepository _userRepository;

    public UsersController(DataContext context)
    {
        _userRepository = new UserRepository(context);
    }

    [HttpGet]
    public async Task<IEnumerable<User>> GetUsers()
    {
        return await _userRepository.GetAllUsersAsync();
    }
    
    [HttpDelete("delete/{userId}")]
    public async Task<ActionResult> DeleteUser(int userId)
    {
        var user = await GetUserById(userId);
        if (user == null) return BadRequest("User not found");

        var deletion = await _userRepository.DeleteUserAccountAsync(user);
        return Ok(deletion.Id);
    }
    
    [HttpGet("send-code/{receiverEmail}")]
    public int SendVerificationCode(string receiverEmail)
    {
        return _userRepository.SendVerificationCode(receiverEmail);
    }
    
    public async Task<User?> GetUserByEmail(string email)
    {
        return await _userRepository.GetUserByEmailAsync(email);
    }

    [HttpGet("{userId}")]
    public async Task<User?> GetUserById(int userId)
    {
        return await _userRepository.GetUserByIdAsync(userId);
    }

    public async Task<IEnumerable<Media>> GetLikedMediaByUser(int userId)
    {
        return await _userRepository.GetLikedMediaByUser(userId);
    }
}