using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests.ChangeRequests;

public class TextRequest
{
    [Required] public string Text { get; set; } = string.Empty;
}