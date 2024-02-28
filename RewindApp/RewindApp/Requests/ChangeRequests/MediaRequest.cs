using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests.ChangeRequests;

// maybe need to be renamed
public class MediaRequest
{
    [Required]
    public byte[] Media { get; set; }
}