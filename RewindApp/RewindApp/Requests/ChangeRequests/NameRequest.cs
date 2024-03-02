using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests.ChangeRequests;

public class NameRequest
{
    [Required]
    public string Name { get; set; } = string.Empty;
}