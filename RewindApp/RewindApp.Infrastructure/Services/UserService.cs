using System.Security.Cryptography;
using System.Text;

namespace RewindApp.Infrastructure.Services;

public interface IUserService
{
    public string ComputeHash(string input);
    public int GenerateCode();
}

public class UserService : IUserService
{
    private const int VerificationCodeMinValue = 1000;
    private const int VerificationCodeMaxValue = 10000;
    
    public string ComputeHash(string input)
    {
        var inputBytes = Encoding.UTF8.GetBytes(input);
        using var sha512 = SHA512.Create();
        var hashBytes = sha512.ComputeHash(inputBytes);

        var sb = new StringBuilder();
        foreach (var hashByte in hashBytes)
        {
            sb.Append(hashByte.ToString("x2")); 
        }

        return sb.ToString();
    }
    
    public int GenerateCode()
    {
        var random = new Random();
        return random.Next(VerificationCodeMinValue, VerificationCodeMaxValue);
    }
}