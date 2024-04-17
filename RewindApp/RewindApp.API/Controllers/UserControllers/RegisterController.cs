using Microsoft.AspNetCore.Mvc;
using RewindApp.Application.Interfaces.UserInterfaces;
using RewindApp.Infrastructure.Data;
using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests.UserRequests;
using RewindApp.Infrastructure.Data.Repositories.UserRepositories;

namespace RewindApp.Controllers.UserControllers;

[ApiController]
[Route("[controller]")]
public class RegisterController : ControllerBase
{
    private readonly IUserRepository _userRepository;
    private readonly IRegisterRepository _registerRepository;

    public RegisterController(DataContext context) 
    {
        _userRepository = new UserRepository(context);
        _registerRepository = new RegisterRepository(context);
    }

    [HttpGet("check-email/{email}")]
    public async Task<ActionResult> CheckEmail(string email)
    {
        var user = await _userRepository.GetUserByEmailAsync(email);
        if (user != null) return BadRequest("User is registered");

        try
        {
            return Ok(_userRepository.SendVerificationCode(email));
        }
        catch (Exception e)
        {
            return BadRequest(e.Message);
        }
    }

    [HttpPost]
    public async Task<ActionResult<User>> Register(UserRegisterRequest request)
    {
        var user = await _userRepository.GetUserByEmailAsync(request.Email);
        if (user != null) return BadRequest("User with this email already exists!");

        var newUser = await _registerRepository.RegisterUserAsync(request);
        return StatusCode(200, newUser);
    }
}