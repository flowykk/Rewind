using Microsoft.AspNetCore.Mvc;
using RewindApp.Infrastructure.Data;
using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests.UserRequests;

namespace RewindApp.Controllers.UserControllers;

[ApiController]
[Route("[controller]")]
public class LoginController : ControllerBase
{
    private readonly IUsersController _usersController;

    public LoginController(DataContext context) 
    {
        _usersController = new UsersController(context);
    }

    [HttpGet("check-email/{email}")]
    public async Task<ActionResult> CheckEmail(string email)
    {
        var user = await _usersController.GetUserByEmail(email);
        if (user == null) return BadRequest("User not registered");

        return Ok(user.Id);
    }

    [HttpPost]
    public async Task<ActionResult<User>> Login(UserLoginRequest request)
    {
        var user = await _usersController.GetUserByEmail(request.Email);
        if (user == null) return BadRequest("User not found");
        
        if (request.Password != user.Password) return BadRequest("Incorrect password");

        return Ok(user);
    }
}