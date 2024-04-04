/*using MySql.Data.MySqlClient;
using RewindApp.Entities;
using RewindApp.Interfaces;
using RewindApp.Interfaces.UserInterfaces;
using RewindApp.Requests;
using RewindApp.Requests.ChangeRequests;
using RewindApp.Requests;
using RewindApp.Services;

namespace RewindApp.Data.Repositories.UserRepositories;

public class ChangeUserRepository : IChangeUserRepository
{
    private readonly DataContext _context;
    private readonly IUserService _userService;

    public ChangeUserRepository(DataContext context)
    {
        _context = context;
        _userService = new UserService();
    }
    
    public async Task<User> ChangeNameAsync(User user, int userId, TextRequest request)
    {
        user.UserName = request.Text;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        return user;
    }

    public async Task<User> ChangeEmailAsync(User user, int userId, EmailRequest request)
    {
        user.Email = request.Email;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        return user;
    }

    public async Task<User> ChangePasswordAsync(User user, int userId, PasswordRequest request)
    {
        user.Password = _userService.ComputeHash(request.Password);
        _context.Users.Update(user);
        await _context.SaveChangesAsync();

        return user;
    }

    public async Task<User> ChangeProfileImage(User user, int userId, MediaRequest mediaRequest)
    {
        var rawData = Convert.FromBase64String(mediaRequest.Object);

        var connectionString = DataContext.GetDbConnection();
        var connection = new MySqlConnection(connectionString);
        connection.Open();

        var command = new MySqlCommand()
        {
            Connection = connection,
            CommandText = "UPDATE Users SET ProfileImage = @rawData WHERE Id = @userId;"
        };
        var fileContentParameter = new MySqlParameter("?rawData", MySqlDbType.Blob, rawData.Length)
        {
            Value = rawData
        };
        var userIdParameter = new MySqlParameter("?userId", MySqlDbType.Int64)
        {
            Value = userId
        };
        
        command.Parameters.Add(fileContentParameter);
        command.Parameters.Add(userIdParameter);
        command.ExecuteNonQuery();
        
        user.ProfileImage = rawData;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();

        return user;
    }
}*/