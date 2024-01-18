namespace RewindApp.Models;

public class Media
{
    public int Id { get; set; }
    public DateTime Date { get; set; }
    public byte[] Photo { get; set; } = Array.Empty<byte>();
}