namespace RewindApp.Models;

public class Groups
{
    public int Id { get; set; }
    public int OwnerId { get; set; }
    public string GroupName { get; set; } = string.Empty;
    public byte[] GroupImage { get; set; } = Array.Empty<byte>();
    
    public ICollection<User> Members { get; set; }
}
 