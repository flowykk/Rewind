using System.ComponentModel.DataAnnotations;

namespace RewindApp.Views;

public class MediaView
{
    [Key] public int Id { get; set; }
    [Required] public byte[] TinyObject { get; set; } = Array.Empty<byte>();
}