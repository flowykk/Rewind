using Microsoft.AspNetCore.Mvc;
using RewindApp.Entities;

namespace RewindApp.Interfaces.UserInterfaces;

public interface IUserRepository
{
    Task<IEnumerable<User>> GetAllUsersAsync();
    Task<User> DeleteUserAccountAsync(User user, int userId);
    int SendVerificationCode(string receiverEmail);
    Task<User?> GetUserByEmailAsync(string email);
    Task<User?> GetUserByIdAsync(int userId);
}