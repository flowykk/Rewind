using System.ComponentModel.DataAnnotations;

namespace RewindApp.Domain.Requests;

public class CreateGroupRequest
{
    [Required] public int OwnerId { get; set; }
    [Required] public string GroupName { get; set; } = string.Empty;
}