using System.CodeDom.Compiler;
using System.Security.Cryptography;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using RewindApp.Data;
using RewindApp.Models;
using RewindApp.Models.RequestsModels;

namespace RewindApp.Controllers;

[ApiController]
[Route("[controller]")]
public class UsersController : ControllerBase
{
    private readonly DataContext _context;
    private readonly ILogger<UsersController> _logger;
    private readonly IEmailSender _emailSender;

    public UsersController(DataContext context, ILogger<UsersController> logger, IEmailSender emailSender)
    {
        _context = context;
        _logger = logger;
        _emailSender = emailSender;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<User>>> GetUsers()
    {
        return await _context.Users.ToListAsync();
    }

    [HttpGet("check-email/{email}")]
    public async Task<ActionResult<IEnumerable<User>>> CheckEmail(string email)
    {
        int verificationCode = SendVerificationCode(email);
        //int verificationCode = GenerateCode();

        var user = await GetUserByEmail(email);
        if (user != null)
        {
            return BadRequest($"Bad");
        }

        return Ok($"{verificationCode}");
    }

    public int SendVerificationCode(string receiverEmail)
    {
        var receiver = receiverEmail;
        var subject = "verification code";

        int verificationCode = GenerateCode();
        var message = $"your code - {verificationCode}";

        _emailSender.SendEmailAsync(receiver, subject, message);

        return verificationCode;
    }

    public int GenerateCode()
    {
        Random random = new Random();
        return random.Next(1000, 10000);
    }

    [HttpPost("register")]
    public async Task<ActionResult<IEnumerable<User>>> Register(UserRegisterRequest request)
    {
        /*if (_context.Users.Any(user => user.Email == request.Email))
        {
            return BadRequest("User with this email already exists!");
        }*/

        string passwordHash = ComputeHash(request.Password);
        
        var user = new User
        { 
            UserName = request.UserName,
            Email = request.Email,
            Password = passwordHash,
            RegistrationDateTime = DateTime.Now
        };

        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return Ok($"{GetUserByEmail(request.Email).Id}");
    }
    
    [HttpPost("login")]
    public async Task<ActionResult<IEnumerable<User>>> Login(UserLoginRequest request)
    {
        var user = await GetUserByEmail(request.Email);
        
        // maybe dont need this
        if (user == null)
        {
            return BadRequest("User not found.");
        }
        
        string passwordHash = ComputeHash(request.Password);
        if (passwordHash != user.Password)
        {
            return BadRequest("Incorrect password!");
        }

        return Ok($"id - {user.Id}");
    }
    
    
    [HttpDelete("{userId}")]
    public async Task<ActionResult> DeleteUserAccount(int userId)
    {
        var user = await GetUserById(userId);
        if (user != null)
        {
            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
            return Ok($"User with Id {userId} was successfully deleted");
        }
        
        return BadRequest("User not found.");
    }
    
    public async Task<User?> GetUserByEmail(string email)
    {
        var user = await _context.Users.FirstOrDefaultAsync(user => user.Email == email);
        return user;
    }
    
    public async Task<User?> GetUserById(int userId)
    {
        var user = await _context.Users.FirstOrDefaultAsync(user => user.Id == userId);
        return user;
    } 

    [HttpPut("edit-name/{userId}/{newName}")]
    public async Task<ActionResult> EditUserName(int userId, string newName)
    {
        var user = await GetUserById(userId);
        if (user != null)
        {
            user.UserName = newName;
            _context.Users.Update(user);
            
            await _context.SaveChangesAsync();
            return Ok($"name changed id - {user.Id}; name - {user.UserName}");
        }

        return BadRequest($"error");
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
    
    static string ComputeHash(string input)
    {
        byte[] inputBytes = Encoding.UTF8.GetBytes(input);
        using var sha512 = SHA512.Create();
        byte[] hashBytes = sha512.ComputeHash(inputBytes);

        StringBuilder sb = new StringBuilder();
        foreach (byte hashByte in hashBytes)
        {
            sb.Append(hashByte.ToString("x2")); 
        }

        return sb.ToString();
    }
    
    // private void CreatePasswordHash(string password)
    // {
    //     using (var hmac = new HMACSHA512())
    //     {
    //         password = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
    //     }
    // }
    
}