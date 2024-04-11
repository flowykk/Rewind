using RewindApp.Domain.Entities;

namespace RewindApp.Application.Interfaces.UserInterfaces;

public interface IUserRepository
{
    Task<IEnumerable<User>> GetAllUsersAsync();
    Task<User> DeleteUserAccountAsync(User user);
    int SendVerificationCode(string receiverEmail);
    Task<User?> GetUserByEmailAsync(string email);
    Task<User?> GetUserByIdAsync(int userId);
    Task<IEnumerable<Media>> GetLikedMediaByUser(int userId);

}