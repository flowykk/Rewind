using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests.ChangeRequests;

public class UserPasswordRequest
{
    [Required]
    public string Password { get; set; } = string.Empty;
}