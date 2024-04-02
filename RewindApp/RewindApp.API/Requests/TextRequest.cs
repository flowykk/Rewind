using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests;

public class TextRequest
{
    [Required] public string Text { get; set; } = string.Empty;
}