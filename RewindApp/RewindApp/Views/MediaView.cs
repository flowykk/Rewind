using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;

namespace RewindApp.Views;

public class MediaView
{
    [Key] public int Id { get; set; }
    [Required] public byte[] TinyObject { get; set; } = Array.Empty<byte>();
}