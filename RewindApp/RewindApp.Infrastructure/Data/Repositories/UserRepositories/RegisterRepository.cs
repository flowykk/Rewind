/*using RewindApp.Entities;
using RewindApp.Interfaces;
using RewindApp.Interfaces.UserInterfaces;
using RewindApp.Requests.UserRequests;
using RewindApp.Services;

namespace RewindApp.Data.Repositories.UserRepositories;

public class RegisterRepository : IRegisterRepository
{
    private readonly DataContext _context;
    private readonly IUserService _userService;
    private readonly IUserRepository _userRepository;

    public RegisterRepository(DataContext context)
    {
        _context = context;
        _userService = new UserService();
        _userRepository = new UserRepository(context);
    }
    
    public int CheckEmailAsync(string email)
    {
        var verificationCode = _userRepository.SendVerificationCode(email);
        return verificationCode;
    }

    public async Task<User> RegisterUserAsync(UserRegisterRequest request)
    {
        var newUser = new User
        { 
            UserName = request.UserName,
            Email = request.Email,
            Password = _userService.ComputeHash(request.Password),
            RegistrationDateTime = DateTime.Now,
            ProfileImage = Array.Empty<byte>()
        };

        _context.Users.Add(newUser);
        await _context.SaveChangesAsync();

        return newUser;
    }
}*/