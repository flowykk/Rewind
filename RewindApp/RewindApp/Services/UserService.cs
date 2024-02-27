using System.Security.Cryptography;
using System.Text;

namespace RewindApp.Services;

public interface IUserService
{
    public string ComputeHash(string input);
    public int GenerateCode();
    public byte[] StringToBytes(string s);
}

public class UserService : IUserService
{
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
        Random random = new Random();
        return random.Next(1000, 10000);
    }

    public byte[] StringToBytes(string message)
    {
        var byteArray = new byte[message.Length];
        for (int i = 0; i < message.Length; i++)
        {
            byteArray[i] = Convert.ToByte(message[i]);
        }
        
        return byteArray;
    }
}