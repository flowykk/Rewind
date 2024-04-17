using MySql.Data.MySqlClient;
using RewindApp.Application.Interfaces.UserInterfaces;
using RewindApp.Domain.Entities;
using RewindApp.Domain.Requests;
using RewindApp.Domain.Requests.ChangeRequests;
using RewindApp.Infrastructure.Services;

namespace RewindApp.Infrastructure.Data.Repositories.UserRepositories;

public class ChangeUserRepository : IChangeUserRepository
{
    private readonly DataContext _context;
    private readonly IUserService _userService;
    private readonly SqlService _sqlService;

    public ChangeUserRepository(DataContext context)
    {
        _context = context;
        _userService = new UserService();
        _sqlService = new SqlService();
    }
    
    public async Task ChangeNameAsync(User user, TextRequest request)
    {
        user.UserName = request.Text;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        _sqlService.UpdateUserImage(user);
    }

    public async Task ChangeEmailAsync(User user, EmailRequest request)
    {
        user.Email = request.Email;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        _sqlService.UpdateUserImage(user);
    }

    public async Task ChangePasswordAsync(User user, PasswordRequest request)
    {
        user.Password = request.Password; 
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        _sqlService.UpdateUserImage(user);
    }
    
    public async Task ChangeAppIconAsync(User user, string newIcon)
    {
        user.AppIcon = newIcon;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        _sqlService.UpdateUserImage(user);
    }

    public async Task ChangeProfileImage(User user, MediaRequest mediaRequest)
    {
        var rawData = Convert.FromBase64String(mediaRequest.Object);
        var tinyData = Convert.FromBase64String(mediaRequest.TinyObject);

        var connectionString = DataContext.GetDbConnection();
        var connection = new MySqlConnection(connectionString);
        connection.Open();

        var command = new MySqlCommand()
        {
            Connection = connection,
            CommandText = "UPDATE Users SET ProfileImage = @rawData, TinyProfileImage = @tinyData WHERE Id = @userId;"
        };
        var imageParameter = new MySqlParameter("?rawData", MySqlDbType.Blob, rawData.Length)
        {
            Value = rawData
        };
        var tinyImageParameter = new MySqlParameter("?tinyData", MySqlDbType.TinyBlob, tinyData.Length)
        {
            Value = tinyData
        };
        var userIdParameter = new MySqlParameter("?userId", MySqlDbType.Int64)
        {
            Value = user.Id
        };
        
        user.ProfileImage = rawData;
        _context.Users.Update(user);
        await _context.SaveChangesAsync();
        
        command.Parameters.Add(imageParameter);
        command.Parameters.Add(tinyImageParameter);
        command.Parameters.Add(userIdParameter);
        command.ExecuteNonQuery();
    }
}