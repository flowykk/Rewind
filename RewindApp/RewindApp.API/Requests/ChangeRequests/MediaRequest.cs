using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests.ChangeRequests;

public class MediaRequest
{
    [Required] public string Object { get; set; } = string.Empty;
    [Required] public string TinyObject { get; set; } = string.Empty;
}