using RewindApp.Application.Interfaces.UserInterfaces;
using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests.UserRequests;

namespace RewindApp.Infrastructure.Data.Repositories.UserRepositories;

public class RegisterRepository : IRegisterRepository
{
    private readonly DataContext _context;

    public RegisterRepository(DataContext context)
    {
        _context = context;
    }

    public async Task<User> RegisterUserAsync(UserRegisterRequest request)
    {
        var newUser = new User
        { 
            UserName = request.UserName,
            Email = request.Email,
            Password = request.Password,
            RegistrationDateTime = DateTime.Now,
            ProfileImage = Array.Empty<byte>()
        };

        _context.Users.Add(newUser);
        await _context.SaveChangesAsync();

        return newUser;
    }
}