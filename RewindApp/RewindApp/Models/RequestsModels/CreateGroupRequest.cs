using System.ComponentModel.DataAnnotations;

namespace RewindApp.Models.RequestsModels;

public class CreateGroupRequest
{
    [Required, EmailAddress]
    public string GroupOwnerEmail { get; set; } = string.Empty;
    [Required]
    public string GroupName { get; set; } = string.Empty;

    //[Required] public byte[] GroupImage { get; set; } = Array.Empty<byte>();
}