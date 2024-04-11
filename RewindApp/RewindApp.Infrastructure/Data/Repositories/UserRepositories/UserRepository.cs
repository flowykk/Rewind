using Microsoft.EntityFrameworkCore;
using RewindApp.Application.Interfaces.UserInterfaces;
using RewindApp.Domain.Entities;
using RewindApp.Infrastructure.Services;

namespace RewindApp.Infrastructure.Data.Repositories.UserRepositories;

public class UserRepository : IUserRepository
{
    private readonly DataContext _context;
    
    private readonly IEmailSender _emailSender;
    private readonly IUserService _userService;

    public UserRepository(DataContext context)
    {
        _context = context;
        _emailSender = new EmailSender();
        _userService = new UserService();
    }
    
    public async Task<IEnumerable<User>> GetAllUsersAsync()
    {
        return await _context.Users.ToListAsync();
    }

    public async Task<User> DeleteUserAccountAsync(User user)
    {
        _context.Users.Remove(user);
        await _context.SaveChangesAsync();
        return user;
    }

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

    public async Task<User?> GetUserByEmailAsync(string email)
    {
        return await _context.Users
            .Include(u => u.Groups)
            .Include(u => u.Media)
            .FirstOrDefaultAsync(user => user.Email == email);
    }

    public async Task<User?> GetUserByIdAsync(int userId)
    {
        return await _context.Users
            .Include(u => u.Groups)
            .Include(u => u.Media)
            .FirstOrDefaultAsync(user => user.Id == userId);
    }
    
    public async Task<IEnumerable<Media>> GetLikedMediaByUser(int userId)
    {
        return await _context.Users
            .Include(user => user.Media)
            .Where(user => user.Id == userId)
            .SelectMany(user => user.Media).ToListAsync(); 
    }
}