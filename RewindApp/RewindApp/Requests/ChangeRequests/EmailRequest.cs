using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests.ChangeRequests;

public class EmailRequest
{
    [Required] public string Email { get; set; } = string.Empty;
}