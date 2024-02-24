namespace RewindApp.Models;

public class User
{
    public int UserId { get; set; }
    public string UserName { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
    public DateTime RegistrationDateTime { get; set; } = DateTime.Now;
    public byte[] ProfileImage { get; set; } = Array.Empty<byte>();

    public ICollection<Groups> Groups { get; set; }
}