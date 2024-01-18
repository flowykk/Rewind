using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RewindApp.Data;
using RewindApp.Models;
using RewindApp.Models.RequestsModels;

namespace RewindApp.Controllers;

internal interface IUsersController
{
    public Task<ActionResult<IEnumerable<Users>>> GetUsers();
    public Task<ActionResult<IEnumerable<Users>>> Register(UserRegisterRequest request);
    public Task<ActionResult<IEnumerable<Users>>> Login(UserLoginRequest request);
    public Task<ActionResult> DeleteUserAccount(int userId);
    public Task<ActionResult> EditUserName(int userId);
    public Task<ActionResult> EditUserEmail(int userId);
    public Task<ActionResult> EditUserProfileImage(int userId);
    public Task<ActionResult> EditUserPassword(int userId);
    public Task<ActionResult> ForgotPasswordPassword(string userEmail);
}

[ApiController]
[Route("[controller]")]
public class UsersController : ControllerBase, IUsersController
{
    private readonly DataContext _context;
    private readonly ILogger<UsersController> _logger;

    public UsersController(DataContext context, ILogger<UsersController> logger)
    {
        _context = context;
        _logger = logger;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Users>>> GetUsers()   
    {
        return await _context.Users.ToListAsync();
    }

    [HttpPost("register")]
    public async Task<ActionResult<IEnumerable<Users>>> Register(UserRegisterRequest request)
    {
        if (_context.Users.Any(user => user.Email == request.Email))
        {
            return BadRequest("User with this email already exists!");
        }

        ComputeHash(request.Password, out string passwordHash);
        //passwordSalt
        
        var user = new Users
        { 
            FirstName = request.FirstName,
            LastName = request.LastName,
            Email = request.Email,
            Password = passwordHash,
            RegistrationDateTime = DateTime.Now
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return Ok("User created successfully!");
    }
    
    [HttpPost("login")]
    public async Task<ActionResult<IEnumerable<Users>>> Login(UserLoginRequest request)
    {
        var user = await _context.Users.FirstOrDefaultAsync(user => user.Email == request.Email);
        if (user == null)
        {
            return BadRequest("User not found.");
        }
        
        ComputeHash(request.Password, out string passwordHash);
        //Console.WriteLine(passwordHash);
        if (passwordHash != user.Password)
        {
            return BadRequest("Incorrect password!");
        }

        //SendEmail(request.Email);

        return Ok($"Welcome back, {user.FirstName}! Your id is {user.Id} <3");
    }
    
    [HttpDelete("{userId}")]
    public async Task<ActionResult> DeleteUserAccount(int userId)
    {
        var user = await _context.Users.FirstOrDefaultAsync(user => user.Id == userId);
        if (user == null)
        {
            return BadRequest("User not found.");
        }
        
        _context.Users.Remove(user);
        await _context.SaveChangesAsync();

        return Ok($"User with Id {userId} was successfully deleted");
    }

    [HttpPut("edit-name/{userId}")]
    public async Task<ActionResult> EditUserName(int userId)
    {
        throw new NotImplementedException();
    }
    
    [HttpPut("edit-email/{userId}")]
    public async Task<ActionResult> EditUserEmail(int userId)
    {
        throw new NotImplementedException();
    }
    
    [HttpPut("edit-profile-image/{userId}")]
    public async Task<ActionResult> EditUserProfileImage(int userId)
    {
        throw new NotImplementedException();
    }
    
    [HttpPut("edit-password/{userId}")]
    public async Task<ActionResult> EditUserPassword(int userId)
    {
        throw new NotImplementedException();
    }
    
    [HttpPut("forgot-password/{userId}")]
    public async Task<ActionResult> ForgotPasswordPassword(string userEmail)
    {
        var user = await _context.Users.FirstOrDefaultAsync(user => user.Email == userEmail);
        if (user == null)
        {
            return BadRequest("User not found.");
        }
        
        //TODO: Отправка кода верификации на указанный userEmail - SendEmailAsync(email).GetAwaiter() ???;
        //TODO: После проверки введённого кода - запрос на новый пароль
        //TODO: После - обновление пароля
        
        return Ok($"Your password was successfully changed!");
    }
    
    // not working
    // [HttpPost("forgot-password")]
    // public async Task<ActionResult> ForgotPassword(string email)
    // {
    //     var user = await _context.Users.FirstOrDefaultAsync(user => user.Email == email);
    //     if (user == null)
    //     {
    //         return BadRequest("User not found.");
    //     }
    //     
    //     //SendEmailAsync(email).GetAwaiter();
    //
    //     return Ok($"Your password was successfully changed!");
    // }
    
    // private static async Task SendEmail(string email)
    // {
    //     MailAddress from = new MailAddress("noreply@rewindapp.ru", "Rewind");
    //     // кому отправляем
    //     MailAddress to = new MailAddress(email);
    //     // создаем объект сообщения
    //     MailMessage m = new MailMessage(from, to);
    //     // тема письма
    //     m.Subject = "Тест";
    //     // текст письма
    //     m.Body = "<h2>Письмо-тест работы smtp-клиента</h2>";
    //     // письмо представляет код html
    //     m.IsBodyHtml = true;
    //     // адрес smtp-сервера и порт, с которого будем отправлять письмо
    //     SmtpClient smtp = new SmtpClient("smtp.mail.com", 587);
    //     // логин и пароль
    //     smtp.Credentials = new NetworkCredential("noreply@rewindapp.ru", "RvecJZeBURzuZptnzWtW");
    //     smtp.EnableSsl = true;
    //     smtp.Send(m);
    // }
    
    static void ComputeHash(string input, out string hash)
    {
        // Convert the input string to a byte array
        byte[] inputBytes = Encoding.UTF8.GetBytes(input);

        // Create an MD5 hash object
        using var sha512 = SHA512.Create();
        
        // Compute the hash value from the input bytes
        byte[] hashBytes = sha512.ComputeHash(inputBytes);

        // Convert the hash bytes to a hexadecimal string
        StringBuilder sb = new StringBuilder();
        foreach (byte hashByte in hashBytes)
        {
            sb.Append(hashByte.ToString("x2")); // "x2" formats the byte as a two-digit hexadecimal number
        }

        hash = sb.ToString();
    }
    
    // private void CreatePasswordHash(string password)
    // {
    //     using (var hmac = new HMACSHA512())
    //     {
    //         password = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
    //     }
    // }
    
}