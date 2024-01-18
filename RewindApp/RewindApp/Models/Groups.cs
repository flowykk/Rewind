namespace RewindApp.Models;

public class Groups
{
    public int Id { get; set; }
    public string GroupOwnerEmail { get; set; } = string.Empty;
    public string GroupName { get; set; } = string.Empty;
    public byte[] GroupImage { get; set; } = Array.Empty<byte>();
}
