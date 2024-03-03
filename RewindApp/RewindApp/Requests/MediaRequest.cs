using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests;

// maybe need to be renamed
public class MediaRequest
{
    [Required]
    //public byte[] Media { get; set; }
    public string Media { get; set; } = string.Empty;
}