using System.ComponentModel.DataAnnotations;

namespace RewindApp.Entities;

public class Media
{
    public int Id { get; set; }
    [Required]
    public DateTime Date { get; set; }
    [Required]
    public byte[] Photo { get; set; } = Array.Empty<byte>();

    public Group Group { get; set; }
}