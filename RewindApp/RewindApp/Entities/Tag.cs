using System.ComponentModel.DataAnnotations;
using System.Runtime.Serialization;

namespace RewindApp.Entities;

public class Tag
{
    [Key] public int Id { get; set; }
    [Required, MaxLength(10)] public string Text { get; set; } = string.Empty;
    
    [IgnoreDataMember] public Media Media { get; set; }
}