using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests;

public class MediaRequest
{
    [Required] public string Media { get; set; } = string.Empty;
}