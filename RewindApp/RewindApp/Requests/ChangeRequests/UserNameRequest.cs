using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests.ChangeRequests;

public class UserNameRequest
{
    [Required]
    public string UserName { get; set; } = string.Empty;
}