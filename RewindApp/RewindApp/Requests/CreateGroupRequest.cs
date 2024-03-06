using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests;

public class CreateGroupRequest
{
    [Required] public int OwnerId { get; set; }
    
    [Required] public string GroupName { get; set; } = string.Empty;

    //[Required] public byte[] GroupImage { get; set; } = Array.Empty<byte>();
}