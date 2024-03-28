using System.ComponentModel.DataAnnotations;

namespace RewindApp.Requests;

public class MediaRequest
{
    [Required] public string Object { get; set; } = string.Empty;
    [Required] public string TinyObject { get; set; } = string.Empty;
    [Required] public int isPhoto { get; set; }
}