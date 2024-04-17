using Microsoft.AspNetCore.Mvc;
using RewindApp.Application.Interfaces.UserInterfaces;
using RewindApp.Infrastructure.Data;
using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests.UserRequests;
using RewindApp.Infrastructure.Data.Repositories.UserRepositories;

namespace RewindApp.Controllers.UserControllers;

[ApiController]
[Route("[controller]")]
public class LoginController : ControllerBase
{
    private readonly IUserRepository _userRepository;

    public LoginController(DataContext context) 
    {
        _userRepository = new UserRepository(context);
    }

    [HttpGet("check-email/{email}")]
    public async Task<ActionResult> CheckEmail(string email)
    {
        var user = await _userRepository.GetUserByEmailAsync(email);
        if (user == null) return BadRequest("User not registered");

        return Ok(user.Id);
    }

    [HttpPost]
    public async Task<ActionResult<User>> Login(UserLoginRequest request)
    {
        var user = await _userRepository.GetUserByEmailAsync(request.Email);
        if (user == null) return BadRequest("User not found");
        
        if (request.Password != user.Password) return BadRequest("Incorrect password");

        return Ok(user);
    }
}