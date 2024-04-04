using System.ComponentModel.DataAnnotations;

namespace RewindApp.Domain.Requests.ChangeRequests;

public class PasswordRequest
{
    [Required] public string Password { get; set; } = string.Empty;
}