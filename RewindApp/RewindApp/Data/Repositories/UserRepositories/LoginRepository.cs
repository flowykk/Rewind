/*using RewindApp.Entities;
using RewindApp.Interfaces;
using RewindApp.Requests.UserRequests;
using RewindApp.Services;

namespace RewindApp.Data.Repositories;

public class LoginRepository : ILoginRepository
{
    private readonly DataContext _context;
    private readonly IUserService _userService;
    private readonly IUserRepository _userRepository;

    public LoginController(DataContext context)
    {
        _context = context;
        _userService = new UserService();
        _userRepository = new UserRepository(context);
    }
    
    public int CheckEmail(string email)
    {
        throw new NotImplementedException();
    }

    public Task<User> Login(UserLoginRequest request)
    {
        var passwordHash = _userService.ComputeHash(request.Password);
        if (passwordHash != user.Password) return BadRequest("Incorrect password");

        return Ok(user);
    }
}*/