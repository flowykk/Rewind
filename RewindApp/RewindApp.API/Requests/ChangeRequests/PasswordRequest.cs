using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests.ChangeRequests;

public class PasswordRequest
{
    [Required] public string Password { get; set; } = string.Empty;
}