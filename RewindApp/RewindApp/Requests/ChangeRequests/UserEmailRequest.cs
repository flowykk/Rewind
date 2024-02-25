using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests.ChangeRequests;

public class UserEmailRequest
{
    [Required]
    public string Email { get; set; } = string.Empty;
}