using System.ComponentModel.DataAnnotations;

namespace RewindApp.Domain.Requests.ChangeRequests;

public class EmailRequest
{
    [Required] public string Email { get; set; } = string.Empty;
}