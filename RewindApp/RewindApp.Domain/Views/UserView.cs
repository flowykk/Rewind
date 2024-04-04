namespace RewindApp.Domain.Views;

public class UserView
{
    public int Id { get; set; }
    public string UserName { get; set; } = string.Empty;
    public byte[] TinyProfileImage { get; set; }
}